django-compressor
=================

`django-compressor docs <https://django-compressor.readthedocs.io/en/latest/>`_

FIRST read the `usage <https://django-compressor.readthedocs.io/en/latest/usage/>`_
page in the docs, down to the paragraph starting "Which would be rendered something like:",
to understand at a high-level what compressor does.

For now, don't read anything else; it can be confusing.

Much of the following information is based on the code, not the current docs,
and hopefully will be more accurate.

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

Offline
-------

If ``COMPRESS_OFFLINE`` is True, compressor expects all uses of ``{% compress ... %}``
in templates to have been pre-processed by running ``manage.py compress`` ahead of time,
which puts the results in compressor's *offline* cache. If anything it needs at run-time is not
found there, things break/throw errors/render wrong etc.

The offline cache manifest is a json file, stored using COMPRESS_STORAGE,
in the subdirectory ``COMPRESS_OUTPUT_DIR`` (default: ``CACHE``),
using the filename ``COMPRESS_OFFLINE_MANIFEST`` (default: ``manifest.json``).

The keys in the offline cache manifest are generated from *the template content inside each compress tag*,
*not* the contents of the compressed files. So, you must arrange to re-run the offline
compression anytime your content files might have changed, or it'll be serving up compressed
files generated from the old file contents.

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
processed results, but if not found, will create them on the fly.

Important Advice
----------------

When using django-compressor,

1. Set COMPRESS_STORAGE=STATICFILES_STORAGE,
COMPRESS_URL=STATIC_URL, and COMPRESS_ROOT=STATIC_ROOT.

2. If STATICFILES_STORAGE is a remote storage class, use a subclass modeled on
`this documentation <https://django-compressor.readthedocs.io/en/latest/remote-storages/#using-staticfiles>`_.

Trying anything more complicated will just cause you headaches, as compressor
doesn't really use these separate settings the way you would probably expect.

.. note::

   If you follow the above advice, you can probably skip reading the rest of this.

Storage
-------

Compressor uses a `Django storage class <https://docs.djangoproject.com/en/stable/howto/custom-file-storage/>`_
for some of its operations, controlled by
the setting ``COMPRESS_STORAGE``.

The default storage is ``compressor.storage.CompressorFileStorage``, which is a subclass
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
  using a different code path, though that appears to end up again going to
  COMPRESS_STORAGE.
* If it still can't get a local filepath, throws an error:
  "'%s' could not be found in the COMPRESS_ROOT '%s'%s"
  which is very misleading if you're not using a storage class that looks at COMPRESS_ROOT.


collectstatic and compressor
----------------------------

When we start thinking about how collectstatic and compressor interact,
things get really hinky, and the documentation especially misleading.

Two problems:

1. Compressor looks at COMPRESS_STORAGE to find the source files to compress,
   when logically you'd expect it to look at STATICFILES_STORAGE. But
   ``collectstatic`` uses STATICFILES_STORAGE to gather and store the source
   files.

2. Compressor tries to hack access to the storage class to find the local path
   to the files, rather than just asking the storage class to open the file
   wherever it is.

This means for all practical purposes, if you want this to work, you have
to:

1. Set COMPRESS_STORAGE the same as STATICFILES_STORAGE, COMPRESS_URL the same as STATIC_URL,
   and COMPRESS_ROOT the same as STATIC_ROOT. (So why does django-compressor
   even have these settings?)

2. Hack whatever storage class STATICFILES_STORAGE is using, if it normally just
   stores files remotely, to save a local copy and make it accessible via ``.path()``.
   `There's an example in the docs
   <https://django-compressor.readthedocs.io/en/latest/remote-storages/#using-staticfiles>`_.
