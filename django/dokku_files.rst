Files
=====

Setting up files in a Django project for deploying it to Dokku

requirements.txt
----------------

There needs to be a ``requirements.txt`` file at the top level. If
you prefer to keep your requirements somewhere else, the top-level one
can just look like::

    -r path/to/real/requirements.txt

Wherever your requirements are, add the latest versions of::

    dj-database-url
    gunicorn
    whitenoise

settings
--------

Add a ``.../deploy.py`` settings file, e.g. ``<appname>/settings/deploy.py``.

It can start out looking like this (edit the top line if your main settings
file isn't base.py)::

    # Settings when deployed to Dokku
    from .base import *  # noqa
    import dj_database_url

    # Disable Django's own staticfiles handling in favour of WhiteNoise, for
    # greater consistency between gunicorn and `./manage.py runserver`. See:
    # http://whitenoise.evans.io/en/stable/django.html#using-whitenoise-in-development
    INSTALLED_APPS.remove('django.contrib.staticfiles')
    INSTALLED_APPS.extend([
        'whitenoise.runserver_nostatic',
        'django.contrib.staticfiles',
    ])

    MIDDLEWARE.remove('django.middleware.security.SecurityMiddleware')
    MIDDLEWARE = [
        'django.middleware.security.SecurityMiddleware',
        'whitenoise.middleware.WhiteNoiseMiddleware',
    ] + MIDDLEWARE

    # Update database configuration with $DATABASE_URL.
    db_from_env = dj_database_url.config(conn_max_age=500)
    DATABASES['default'].update(db_from_env)

    # Honor the 'X-Forwarded-Proto' header for request.is_secure()
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

    # Allow all host headers (feel free to make this more specific)
    ALLOWED_HOSTS = ['*']

    # Simplified static file serving.
    # https://warehouse.python.org/project/whitenoise/
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

wsgi.py
-------

Find your ``wsgi.py`` file.

1. Edit to change the default settings module to ``<appname>.settings.deploy``
   (the path to the new settings file you created above).

2. Add to the end:

.. code-block:: python

    from whitenoise.django import DjangoWhiteNoise
    application = DjangoWhiteNoise(application)

Procfile
--------

Create `Procfile <https://devcenter.heroku.com/articles/procfile>`_
(`more on dokku Procfile <http://dokku.viewdocs.io/dokku~v0.9.2/deployment/methods/buildpacks/#specifying-commands-via-procfile>`_)
in the top directory. For our simple case, it can just contain one
line, starting with ``web: `` and containing the command to start
gunicorn for our site::

    web: gunicorn {{ project_name }}.wsgi

See also the section on running Celery and other processes.

runtime.txt
-----------

Create ``runtime.txt`` in the top directory. It only needs one line, e.g.::

    python-3.6.1

This *has* to be specific. E.g. ``python-3.5.2`` or ``python-3.6.1`` might work
if the dokku server supports it,
but ``python-3.5`` or ``python-3.6`` probably won't.

app.json
--------

Create `app.json <http://dokku.viewdocs.io/dokku/advanced-usage/deployment-tasks/>`_
in the top-level project directory. You might
see examples on the Interwebs with lots of things in app.json (because Heroku uses app.json
for lots of things), but as of this writing,
dokku ignores everything but ``scripts.dokku.predeploy`` and
``scripts.dokku.postdeploy``.  Example:

.. code-block:: json

    {
      "scripts": {
        "dokku": {
          "predeploy": "python manage.py migrate --noinput"
        }
      }
    }

.. note::

    Dokku automatically runs ``collectstatic`` for you, so you don't need to
    do that from ``app.json``. 

buildpacks
----------

If your app is not pure Python - e.g. if it uses node - you'll need to
`override <http://dokku.viewdocs.io/dokku/deployment/methods/buildpacks/#using-multiple-buildpacks>`_
the automatic buildpack detection, because it only works for a single application type.

Do this by adding a top-level ``.buildpacks`` file, containing links to the
buildpacks to use::

    https://github.com/heroku/heroku-buildpack-nodejs.git
    https://github.com/heroku/heroku-buildpack-python.git
    https://github.com/heroku/heroku-buildpack-apt

Heroku maintains a `list of buildpacks <https://devcenter.heroku.com/articles/buildpacks>`_.
