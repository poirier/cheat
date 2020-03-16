django-compressor
=================

`django-compressor docs <https://django-compressor.readthedocs.io/en/latest/>`_

Warning: much of the documentation is casual about saying things that are
only true in some scenarios, without making clear that that's the case.

ACTUALLY USING
~~~~~~~~~~~~~~

Here are some practical scenarios for using django-compressor.

For what to put in your templates, you can go by the django-compressor documentation,
and be sure to use {% static %} and not STATIC_URL.

For what to put in your settings... it's a lot more complicated.
Set the compressor filters and precompilers however you want. For
the rest, keep reading.


Scenario: Development using runserver, DEBUG, not offline
---------------------------------------------------------

If DEBUG is True, then compressor won't even do anything and so everything
should just work.

Scenario: Running using local files, not offline
------------------------------------------------

This is the typical small server situation.  You unpack your project on
the server, run collectstatic, point nginx or some other server at STATIC_ROOT
and go.

Example settings:

.. code-block:: python

    # Django settings
    DEBUG = False
    STATIC_ROOT = '/var/www/static/'
    STATIC_URL = '/static/'
    # set compressor filters and precompilers as desired.
    # leave other compressor settings at defaults.

.. code-block:: nginx

    # nginx settings
    location /static {
       alias /var/www/static;
    }

Scenario: running using local files, with offline
-------------------------------------------------

Like the previous scenario, but you want compressor to do all its work at
deploy time so the results are cached and ready to go immediately when you
start your server.

.. code-block:: python

    # Django settings like before, plus:
    COMPRESS_OFFLINE = True

Now at deploy time you have more steps:

.. code-block:: bash

    $ python manage.py collectstatic
    $ python manage.py compress

Run ``compress`` *after* collectstatic so that compressor can find its
input files. It'll write its output files under ``{STATIC_ROOT}/CACHE``,
and get them from there at runtime.

Scenario: running with storage on the network, with offline
-----------------------------------------------------------

In this scenario, you're putting your static files somewhere off of the
server where you're running Django. For example, S3. Or just your own
static file server somewhere. Whatever.

Let's start with how this would be setup without django-compressor,
then we can modify it to add django-compressor.

.. code-block:: python

    # settings/no_compressor.py
    STATIC_ROOT = None  # Unused
    STATIC_URL = None  # Unused
    STATIC_FILE_STORAGE = 'package.of.FileStorageClass'

At deploy time you can just run collectstatic, and all your static
files will be pushed to the network:

.. code-block:: bash

    $ python manage.py collectstatic

And at runtime, ``{% static %}`` will ask your file storage class to
come up with a URL for each file, which will turn out to be on your
other server, or S3, or whatever.

Now, suppose we want to add compressor with offline processing
(not using offline makes no sense with network storage). Here are
the settings you can use at runtime for that, assuming things have
been prepared correctly:

.. code-block:: python

    # settings/deployed.py
    # Django settings we'll use in production
    STATIC_ROOT = None  # Unused
    STATIC_URL = None  # Unused
    STATIC_FILE_STORAGE = 'path.to.network.filestorage'
    COMPRESS_ENABLED = True
    COMPRESS_OFFLINE = True

The preparation is the tricky part. It turns out that for the ``compress`` command to work,
a copy of the static files must be gathered in a local directory first.
Most of the tools we might use to compile, compress, etc. are going to
read local files and write local output.

To gather the static files into a local directory,
we might, for example, use a different settings file that uses the default file storage
class, and run collectstatic. E.g.:

.. code-block:: python

    # settings/gather.py
    # Django settings when first running collectstatic
    from .deployed import *

    # Override a few settings to make storage local
    STATIC_ROOT = '/path/to/tmp/dir'
    STATIC_URL = None  # Unused
    STATIC_FILE_STORAGE = 'django.core.files.storage.FileSystemStorage'

.. code-block:: bash

    $ python manage.py collectstatic --settings=settings.gather

After running ``collectstatic`` with these settings, all your source
static files will be gathered under '/path/to/tmp/dir'.

Now you could run ``compress``, and the resulting files would be added
under `/path/to/tmp/dir`.  There's an important *gotcha* that will
cause problems, though - for compressor to match up the output it
makes now with what it'll be looking for later, the contents of each
``{% compress %}`` tag must be identical now to what it'll be then,
which means the URLs must point at the production file server.
We can accomplish this by setting STATIC_URL before running the
compress:

.. code-block:: python

    # settings/compress.py
    # Django settings when running compress command
    from .deployed import *

    # Override a few settings to make storage local, but URLs look remote
    STATIC_ROOT = '/path/to/tmp/dir'
    STATIC_URL = 'https://something.s3.somewhere/static/'  # URL prefix for runtime
    STATIC_FILE_STORAGE = 'django.core.files.storage.FileSystemStorage'

.. code-block:: bash

    $ python manage.py compress --settings=settings.compress

The problem now is to get all these files onto the remote server.
You could just use ``rsync`` or ``s3cmd`` or something, which will
work fine. But for maximum flexibility, let's figure out a way to do
it using Django. Our approach will be to tell Django that our SOURCE
static files are in '/path/to/tmp/dir', and we want them collected
using our production file storage class, which will put them where we
want them.

.. code-block:: python

    # Django settings when running collectstatic again after compress,
    # to copy the resulting files to the network
    # settings/copy_upstream.py
    from .deployed import *  # Set up for network file storage
    # Tell collectstatic to use the files we collected and compressed
    STATICFILES_FINDERS = ['django.contrib.staticfiles.finders.FileSystemFinder']
    STATICFILES_DIRS = ['/path/to/tmp/dir']

.. code-block:: bash

    $ python manage.py collectstatic --settings=settings.copy_upstream

That should copy things to the network. Then if you run using the 'deployed'
settings, things should work!

TODO: TEST THAT!!!!!!!!!!!!!!!!!!!!

Other approaches
----------------

The compressor docs suggest a different approach -- hack the storage class you're
using so when you run collectstatic, it saves a copy of each file into a local
directory in addition to pushing it upstream.  Then you can use the same storage
class for collectstatic, compress, and runtime.

More detailed notes
~~~~~~~~~~~~~~~~~~~

Cache
-----

For some things, compressor uses the cache named by ``COMPRESS_CACHE_BACKEND``,
which defaults to ``None``, which gives us the default Django cache.

Principles of compression
-------------------------

Whether compressor is processing templates offline ahead of time or at runtime,
there are some common principles.

First, if ``COMPRESS_ENABLED`` is False, the ``{% compress %}`` tag will simply
render as its contents; compressor won't change anything.

Otherwise, compressor will

1. parse the contents of the tag and figure out which css and javascript files
   would be included
2. fetch those files (See "accessing the files to be compressed")
3. run those files through any configured preprocessors
4. concatenate the result and save it using COMPRESS_STORAGE
5. at rendering, the tag and contents will be replaced with one or two HTML elements
   that will load the compressed file instead of the original ones.

Offline
-------

If ``COMPRESS_OFFLINE`` is True, compressor expects all uses of ``{% compress ... %}``
in templates to have been pre-processed by running ``manage.py compress`` ahead of time,
which puts the results in compressor's *offline* cache. If anything it needs at run-time is not
found there, things break/throw errors/render wrong etc.

.. note::

    If COMPRESS_OFFLINE is True and files have not been pre-compressed,
    compressor will *not* compress them at runtime. Things will break.

The offline cache manifest is a json file, stored using COMPRESS_STORAGE,
in the subdirectory ``COMPRESS_OUTPUT_DIR`` (default: ``CACHE``),
using the filename ``COMPRESS_OFFLINE_MANIFEST`` (default: ``manifest.json``).

The keys in the offline cache manifest are generated from *the template content inside each compress tag*,
*not* the contents of the compressed files. So, you must arrange to re-run the offline
compression anytime your content files might have changed, or it'll be serving up compressed
files generated from the old file contents.

.. note::

    It sounds like you must *also* be *sure* the contents of the compress tags
    don't change between precompressing and runtime, for example by changing the
    URL prefix!

The values in the offline cache manifest are paths of the compressed files
in COMPRESS_STORAGE.

.. note::

    RECOMMENDATION FROM DOCS: make ``COMPRESS_OFFLINE_MANIFEST`` change depending on the
    current code revision, so that during deploys, servers running different versions of
    the code will each use the manifest appropriate for the version of the code they're
    running. Otherwise, servers might use the wrong manifest and strange things could
    happen.

Not offline
-----------

If ``COMPRESS_OFFLINE`` is False, compressor will look in COMPRESS_STORAGE for previously
processed results, but if not found, will create them on the fly and save them to use again.

Storage
-------

Compressor uses a
`Django storage class <https://docs.djangoproject.com/en/stable/howto/custom-file-storage/>`_
for some of its operations, controlled by
the setting ``COMPRESS_STORAGE``.

The default storage class is ``compressor.storage.CompressorFileStorage``, which is a subclass
of the standard filesystem storage class. It uses ``COMPRESS_ROOT`` as the base directory
in the local filesystem to store files in, and builds URLs by prefixing file paths within
the storage with ``COMPRESS_URL``.

If you change ``COMPRESS_STORAGE``, then *ignore* anything in the docs about
``COMPRESS_ROOT`` and ``COMPRESS_URL`` as they won't apply anymore (except in
a few cases... see exceptions noted as they come up, below).

Accessing the files to be compressed
------------------------------------

For each file to be compressed, compressor starts with the URL from the rendered
original content inside the compress tag.  For example, if part of the content
is ``<script src="http://example.com/foo.js"></script>``, then it extracts
``"http://example.com/foo.js"`` as the URL.

It checks that the URL starts with
COMPRESS_STORAGE's ``base_url``, or if accessing that fails (quite possible since
``base_url`` is not a standard part of the file storage class API), uses ``COMPRESS_URL``.

.. note::

    This is a place where compressor can use COMPRESS_URL even if it's not using
    its default storage.

If the URL doesn't start with that string, compressor throws a possibly misleading
error, "'%s' isn't accessible via COMPRESS_URL ('%s') and can't be compressed".

Otherwise, compressor tries to come up with a local filepath to access the file, as
follows:

* Try to get a local filepath from COMPRESS_STORAGE using ``.path()``.
* If that's not implemented (for example, for remote storages), it tries again
  using ``compressor.storage.CompressorFileStorage`` (regardless of what COMPRESS_STORAGE
  is set to), so basically it's going to look for it under COMPRESS_ROOT.
* If it still can't get a local filepath, throws an error:
  "'%s' could not be found in the COMPRESS_ROOT '%s'%s"
  which is very misleading if you're not using a storage class that looks at COMPRESS_ROOT.
