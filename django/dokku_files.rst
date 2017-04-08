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

Edit or add to end::

    import dj_database_url

    INSTALLED_APPS = [
        ...
        # Disable Django's own staticfiles handling in favour of WhiteNoise, for
        # greater consistency between gunicorn and `./manage.py runserver`. See:
        # http://whitenoise.evans.io/en/stable/django.html#using-whitenoise-in-development
        'whitenoise.runserver_nostatic',
        'django.contrib.staticfiles',
    ]

    MIDDLEWARE = [
        # At beginning of middleware:
        'django.middleware.security.SecurityMiddleware',
        'whitenoise.middleware.WhiteNoiseMiddleware',
        # ... rest of middleware
    ]

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

Whereever your wsgi.py file is, add to the end:

.. code-block:: python

    from whitenoise.django import DjangoWhiteNoise
    application = DjangoWhiteNoise(application)

Procfile
--------

Create `Procfile <https://devcenter.heroku.com/articles/procfile>`_
(`more <http://dokku.viewdocs.io/dokku~v0.9.2/deployment/methods/buildpacks/#specifying-commands-via-procfile>`_)
in the top directory. For our simple case, it can just contain one
line, starting with ``web: `` and containing the command to start
gunicorn for our site::

    web: gunicorn {{ project_name }}.wsgi

See also the section on running Celery and other processes.

runtime.txt
-----------

Create ``runtime.txt`` in the top directory. It only needs one line, e.g.::

    python-3.6.1

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
