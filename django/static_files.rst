Static Files in Django
======================

The static template tag
-----------------------


What happens when Django is rendering a template containing something
like this?::

    {% load static %}
    {% static "some string" %}

It renders to a URL, but where does that URL come from?

"If the django.contrib.staticfiles app is installed, the tag will serve files using url() method of the storage specified by STATICFILES_STORAGE."

And otherwise? The tag will just stick the value
of the STATIC_URL settings in front.::

        if apps.is_installed('django.contrib.staticfiles'):
            from django.contrib.staticfiles.storage import staticfiles_storage
            return staticfiles_storage.url(path)
        else:
            return urljoin(PrefixNode.handle_simple("STATIC_URL"), quote(path))

* `static tag <https://docs.djangoproject.com/en/stable/ref/templates/builtins/#std:templatetag-static>`_
* `Managing static files <https://docs.djangoproject.com/en/stable/howto/static-files/>`_
* `The staticfiles app <https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/>`_
* `Deploying static files <https://docs.djangoproject.com/en/stable/howto/static-files/deployment/>`_

Fixing a ValueError
-------------------

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

.. _manifest_strict: https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/#django.contrib.staticfiles.storage.ManifestStaticFilesStorage.manifest_strict


Storage systems
---------------

Django uses storage systems to abstract the concept of storing files and being able to list
and retrieve them again.

The default storage systems work with the local file system, but you can use alternatives to
store files on network file services, for example.

Static files are managed using the storage system from the ``STATICFILES_STORAGE`` setting.
By *default*, this is ``django.contrib.staticfiles.storage.StaticFilesStorage``, which
stores files under the directory specified by the ``STATIC_ROOT`` setting.

(Other storage systems might ignore STATIC_ROOT and have their own settings.)

Storage systems can override the ``post_process()`` method so that after ``collectstatic``
has copied a bunch of files into the storage system, it can do further processing on them.
For example, ``ManifestStaticFilesStorage``, which appends hashes to filenames when
saving them, "automatically replaces the paths found in the saved files matching other
saved files with the path of the cached copy".

Storage system also provide a ``url()`` method that just returns a URL that the
user's browser could use to fetch the file itself. That's what the ``static``
template tag uses to know which URL to insert into pages.

* `Writing a custom storage system <https://docs.djangoproject.com/en/stable/howto/custom-file-storage/>`_
* `STATICFILES_STORAGE <https://docs.djangoproject.com/en/stable/ref/settings/#staticfiles-storage>`_

Settings
--------

* `Staticfiles settings <https://docs.djangoproject.com/en/stable/ref/settings/#settings-staticfiles>`_
* `STATIC_URL <https://docs.djangoproject.com/en/stable/ref/settings/#static-url>`_
* `STATIC_ROOT <https://docs.djangoproject.com/en/stable/ref/settings/#static-root>`_

Collectstatic
-------------

`Collectstatic <https://docs.djangoproject.com/en/stable/ref/contrib/staticfiles/#collectstatic>`_

The ``collectstatic`` command finds all the static files, from possibly many places, and copies
them all to one place.

Finding the static files
........................

To debug finding static files, you can use the
`findstatic <https://docs.djangoproject.com/en/3.0/ref/contrib/staticfiles/#findstatic>`_
command.

The finding of the files is controlled first by the
`STATICFILES_FINDERS <https://docs.djangoproject.com/en/stable/ref/settings/#staticfiles-finders>`_
setting, which is a list of names of classes that represent different ways of looking for
static files.

The default list is:

* FileSystemFinder: Looks in each directory in the `STATICFILES_DIRS <https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-STATICFILES_DIRS>`_ setting.
* AppDirectoriesFinder: Looks in the ``static`` directory of each app listed in the ``INSTALLED_APPS`` setting.

There's a third one that can be added:

* DefaultStorageFinder: looks in the files contained by the storage system specified by the
  `DEFAULT_FILE_STORAGE <https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-DEFAULT_FILE_STORAGE>`_ setting.

.. note::
   DEFAULT_FILE_STORAGE is where the *media* files are stored (user-uploaded files). I can't
   imagine why you'd want to copy those using ``collectstatic``, or if you did, why you couldn't
   just add ``MEDIA_ROOT`` to STATICFILES_DIRS.

Copying the static files
........................

``collectstatic`` writes the files into the storage system from ``settings.STATICFILES_STORAGE``.

The doc for collectstatic says it writes the files to ``settings.STATIC_ROOT``, but that is only correct
when STATICFILES_STORAGE is set to its default storage system. The storage system can store them
anywhere it wants.

Post-processing
...............

After ``collectstatic`` has copied the files, it calls ``post_process()`` on the storage system
class and passes the list of files. This lets the storage system do additional processing.
For example, it could compress the files, make a manifest of them, compile style files, etc.

The whitenoise app
------------------

`Whitenoise app <http://whitenoise.evans.io/en/stable/>`_
