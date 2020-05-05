Static Files in Django
======================

Managing static files in Django seems to be one of the most
confusing areas for me - it seems like it should be simple!
But so often, it's not.

.. contents::

Example scenarios
-----------------

The default case during development
........................................

Suppose you haven't changed any settings related to static files, and you're running your site
locally using `runserver`_ - how does that work?

You do *not* need to run `collectstatic`_ in this case.  `STATIC_URL`_ and `STATICFILES_FINDERS`_
are important, but `STATIC_ROOT`_ is *not used at all*.

`runserver`_ intercepts any request starting with the value of
`STATIC_URL`_ so it will be handled by a special development-only file server.
`STATIC_URL`_ is probably set to ``"/static/"``, so requests starting with
``/static/`` will go to that development file server. It in turn looks up the rest of
the path the same way as `collectstatic`_ and `findstatic`_ do, and serves whatever
file it finds as the response.

.. _runserver: https://docs.djangoproject.com/en/stable/ref/django-admin/#runserver

The most common case when deployed to production
.................................................

In the typical simple production case, you'll put a web server program like nginx listening on
ports 80/443 as needed. You'll configure it so if a request starts with `STATIC_URL`_, then
the web server will serve the file from some directory on your server machine, and otherwise,
it'll forward the request to Django for processing.

To get the static files to the directory where your web server will look for them, you'll
set `STATIC_ROOT`_ to that directory path, then run `collectstatic`_.

At runtime, requests for static files shouldn't ever get to Django, so is the STATIC_URL_
setting now irrelevant?  No! The browser will only know where to get those static files
based on URLs that Django puts into the web responses.  And in the default case, the
information used to generate those URLs comes from STATIC_URL_.

Another common case for production
.................................................

Another common case in production is serving the static files using a
completely different kind of server. It could be a storage system like
Amazon S3, or a content distribution network, but whatever it is, we need
Django to copy the static files to it when we deploy, and we need Django
to know how to build the URLs that browsers will use to fetch those files.

To do this, the most important setting is
STATICFILES_STORAGE_, which will be the package and classname of an
alternative storage system class
that is likely specific to the kind of static file service you are using.

As an example, the django_storages_ package provides a variety of storage systems
that let you use Amazon S3, Azure Storage, Dropbox, FTP, Google Cloud Storage,
Apache Libcloud, or SFTP.

Whatever storage system you're using will require other settings to know where
to put the files, how to authenticate to get access to write them, and so forth.

Building URLs for static files
------------------------------

What happens when Django is rendering a template containing something
like this?::

    {% load static %}
    {% static "some string" %}

It renders to a URL, but where does that URL come from?

"If the django.contrib.staticfiles app is installed, the tag will
serve files using url() method of the storage specified by `STATICFILES_STORAGE`_."

And *otherwise* (if staticfiles is not in INSTALLED_APPS)? The tag will just stick the value
of the `STATIC_URL`_ setting in front.::

        if apps.is_installed('django.contrib.staticfiles'):
            from django.contrib.staticfiles.storage import staticfiles_storage
            return staticfiles_storage.url(path)
        else:
            return urljoin(PrefixNode.handle_simple("STATIC_URL"), quote(path))

* `static tag <https://docs.djangoproject.com/en/stable/ref/templates/builtins/#std:templatetag-static>`_
* `Managing static files <https://docs.djangoproject.com/en/stable/howto/static-files/>`_
* `The staticfiles app <https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/>`_
* `Deploying static files <https://docs.djangoproject.com/en/stable/howto/static-files/deployment/>`_

collectstatic
-------------

`Doc for collectstatic <https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/#collectstatic>`_

The ``collectstatic`` command finds all the static files, from possibly many places, and copies
them all to one place.

Finding the static files
........................

To debug finding static files, you can use the findstatic_ command.

For collectstatic_ and findstatic_,
the finding of the files is controlled by the STATICFILES_FINDERS_ setting, which is a
list of names of classes that represent different ways of looking for static files.

The default list is:

* FileSystemFinder: Looks in each directory in the `STATICFILES_DIRS`_ setting.
* AppDirectoriesFinder: Looks in the ``static`` directory of each app listed in the ``INSTALLED_APPS`` setting.

You might occasionally need to add to that - for example, if you're using
`django-compressor`_ - but most of the time, the default list is fine.

Copying the static files
........................

`collectstatic`_ writes the files into the storage system specified by STATICFILES_STORAGE_.

The doc for collectstatic says it writes the files to `STATIC_ROOT`_, but that is only correct
when STATICFILES_STORAGE_ is set to its default storage system and some others.
The storage system can store them anywhere it wants.

Post-processing
...............

After `collectstatic`_ has copied the files, it calls ``post_process()`` on the storage system
class and passes the list of files. This lets the storage system do additional processing.
For example, it could compress the files, make a manifest of them, compile style files, etc.


Integrating collectstatic with a CSS/JavaScript build step
............................................................

The whitenoise_ docs suggest what seems like a reasonable approach if you need
to build some of your static files before deploying or serving them.

* Put your source files in one directory, e.g. ``static_src``
* Have your build step put its output in a second directory, e.g. ``static_build``
* Add ``"static_build"`` to STATICFILES_DIRS_

Now just run your build step before collectstatic_, and the built files will be
collected along with the other static files.

Storage systems
---------------

Django uses `storage systems`_ to abstract the concept of storing files and being able to list
and retrieve them again.

The default storage systems work with the local file system, but you can use alternatives to
store files on network file services, or do additional processing on the files, for example.

Static files are managed using the storage system from the `STATICFILES_STORAGE`_ setting.

By *default*, this is ``django.contrib.staticfiles.storage.StaticFilesStorage``, which
stores files under the directory specified by the `STATIC_ROOT`_ setting.
Other storage systems might ignore STATIC_ROOT and have their own settings.

Storage systems can override the ``post_process()`` method so that after `collectstatic`_
has copied a bunch of files into the storage system, it can do further processing on them.
For example, ManifestStaticFilesStorage_, which appends hashes to filenames when
saving them, "automatically replaces the paths found in the saved files matching other
saved files with the path of the cached copy".

Storage system also provide a ``url()`` method that just returns a URL that the
user's browser could use to fetch the file itself. That's what the ``static``
template tag uses to know which URL to insert into pages.


The whitenoise app
------------------

whitenoise_ lets Django itself
serve static files in production, kind of like runserver_ does in development.

To install whitenoise_ for Django, just add ``"whitenoise.middleware.WhiteNoiseMiddleware"``
to your MIDDLEWARE immediately after SecurityMiddleware and before anything else.
STATIC_URL_ needs to be set, as always.

You don't have to use StaticFilesStorage for your file storage system, but you have
to use something that stores the files locally at STATIC_ROOT_.

It's not a bad idea to use whitenoise_ in development if you're using it in production,
just to make sure things are working the same way. The way to make runserver_ not serve
the static files itself - so that whitenoise_ will get to serve them - is to put
``"whitenoise.runserver_nostatic"`` at the *top* of ``INSTALLED_APPS``.

Then just make sure DEBUG_ is on when using runserver_, because that'll result in
WHITENOISE_AUTOREFRESH and WHITENOISE_USE_FINDERS both defaulting to ``True``, which
means you won't have to run collectstatic_ in order for whitenoise_ to find your static files.

whitenoise_ provides a couple of `alternative storage systems`_ that optionally add compression
and forever caching features.

.. _alternative storage systems: http://whitenoise.evans.io/en/stable/django.html#add-compression-and-caching-support

django-pipeline
---------------



django-compressor
-----------------

`django-compressor docs <https://django-compressor.readthedocs.io/en/latest/>`_

``django-compressor`` lets you compile, combine, and compress javascript and css files
(or any files that compile to js and css files).

It works fairly smoothly if your static files are all on a local filesystem,
including your Javascript and CSS.

.. warning::
    ``django-compressor`` can be used with remote static files, but it's a royal pain, and I'd recommend
    looking at something else in that case, if you have the option.

If ``settings.COMPRESS_ENABLED`` is ``False``, then it will just compile the files.

If ``settings.COMPRESS_ENABLED`` is ``True``, then it will also combine and compress
the files.

Basic installation
..................

* ``pip install django_compressor``
* Add ``"compressor"`` to ``settings.INSTALLED_APPS``
* Add ``"compressor.finders.CompressorFinder"`` to ``settings.STATICFILES_FINDERS``.

Invoking compress
.................

When your site is running, ``django-compressor`` gets invoked during template
rendering, anywhere that you've used the ``compress`` tag::

    {% load compress %}

    {% compress js %}
        <script type="text/javascript" src="/static/js/site-base.js"/>
        <script type="text/coffeescript" charset="utf-8" src="/static/js/awesome.coffee" />
    {% endcompress %}

If ``COMPRESS_ENABLED`` is ``False``, then it just does compilation, and that would render
to something like::

    <script type="text/javascript" src="/static/js/site-base.js"></script>
    <script type="text/javascript" src="/static/CACHE/js/awesome.8dd1a2872443.js" charset="utf-8"></script>

If ``COMPRESS_ENABLED`` is ``True``, then it also combines and maybe even compresses, and
you'd get something like::

    <script type="text/javascript" src="/static/CACHE/js/sadfiasdoifasdf.js" charset="utf-8"></script>

This can be a big improvement if you had a dozen .js files.

Offline compression
...................

You can use `offline compression`_ to do most of the work of compilation, compression, etc
at deploy time rather than on every request.  You run the `compress`_ command and
it looks through all the templates it can find based on TEMPLATE_LOADERS_ to find uses of
``{% compress ... %}...{% endcompress %}`` and computes
and caches how it would render each occurrence.

This won't work very well if there's dynamic content inside ``{% compress ...%}...{% endcompress %}``.
You can try to work around it using COMPRESS_OFFLINE_CONTEXT_, but it's a hack. But most
applications won't have any dynamic content inside compress tags.

The compress_ command looks in COMPRESS_ROOT (defaults to STATIC_ROOT_) for the files
referred to in the templates, so you'll need to run collectstatic_ before compress_.

compress_ will write its output into the ``CACHE`` subdirectory of STATIC_ROOT_.
(You can change that by setting COMPRESS_OUTPUT_DIR.)

Use caching
...........

In production with django-compressor, be sure Django is configured with a real cache backend
or compressor can really slow things down.

Scenarios
.........

The compressor docs contain tips for the most common `compressor scenarios`_.


Miscellaneous notes
-------------------

Fixing a ValueError
...................

What if you get the error
"ValueError: Missing staticfiles manifest entry for ..."?

The next bit is copied direct from:

http://whitenoise.evans.io/en/stable/django.html#why-do-i-get-valueerror-missing-staticfiles-manifest-entry-for

If you are seeing this error that you means you are referencing a static file in your
templates (using something like ``{% static "foo" %}``) which doesn't exist, or
at least isn't where Django expects it to be. If you don't understand why Django can't
find the file you can use

.. code-block:: sh

   python manage.py findstatic --verbosity 2 foo

which will show you all the paths which Django searches for the file "foo".

If, for some reason, you want Django to silently ignore such errors you can subclass
the storage backend and set the manifest_strict_ attribute to ``False``.

.. _compress: https://django-compressor.readthedocs.io/en/latest/usage/#offline-compression
.. _compressor scenarios: https://django-compressor.readthedocs.io/en/latest/scenarios/
.. _COMPRESS_OFFLINE_CONTEXT: https://django-compressor.readthedocs.io/en/latest/settings/#django.conf.settings.COMPRESS_OFFLINE_CONTEXT
.. _django_storages: https://django-storages.readthedocs.io/en/latest/
.. _findstatic: https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/#findstatic
.. _manifest_strict: https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/#django.contrib.staticfiles.storage.ManifestStaticFilesStorage.manifest_strict
.. _offline compression: https://django-compressor.readthedocs.io/en/latest/usage/#offline-compression
.. _DEBUG: https://docs.djangoproject.com/en/stable/ref/settings/#debug
.. _STATIC_ROOT: https://docs.djangoproject.com/en/stable/ref/settings/#static-root
.. _STATIC_URL: https://docs.djangoproject.com/en/stable/ref/settings/#static-url
.. _STATICFILES_DIRS: https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-STATICFILES_DIRS
.. _STATICFILES_FINDERS: https://docs.djangoproject.com/en/stable/ref/settings/#staticfiles-finders
.. _STATICFILES_STORAGE: https://docs.djangoproject.com/en/stable/ref/settings/#staticfiles-storage
.. _TEMPLATE_LOADERS: https://docs.djangoproject.com/en/stable/ref/settings/#template-loaders
.. _whitenoise: http://whitenoise.evans.io/en/stable/
.. _storage systems: https://docs.djangoproject.com/en/stable/howto/custom-file-storage/
.. _ManifestStaticFilesStorage: https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/#manifeststaticfilesstorage
