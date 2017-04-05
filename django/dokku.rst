Dokku
=====

Readying a Django project for deploying to `Dokku <http://dokku.viewdocs.io/dokku/>`_.

Files
.....

requirements.txt
----------------

Add latest versions of::

    dj-database-url==0.4.1
    gunicorn==19.6.0
    whitenoise==3.2

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
        'django.middleware.security.SecurityMiddleware',
        'whitenoise.middleware.WhiteNoiseMiddleware',
        # ... rest of middleware
    ]

    # Update database configuration with $DATABASE_URL.
    db_from_env = dj_database_url.config(conn_max_age=500)
    DATABASES['default'].update(db_from_env)

    # Honor the 'X-Forwarded-Proto' header for request.is_secure()
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

    # Allow all host headers
    ALLOWED_HOSTS = ['*']


    # Simplified static file serving.
    # https://warehouse.python.org/project/whitenoise/
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

wsgi.py
-------

Add::

    from whitenoise.django import DjangoWhiteNoise
    application = DjangoWhiteNoise(application)

Procfile
--------

Something like::

    web: gunicorn {{ project_name }}.wsgi

runtime.txt
-----------

One line::

    python-3.6.1

Postgresql
..........

To use the `postgresql plugin <https://github.com/dokku/dokku-postgres>`_,
inside your server run:

.. code-block:: bash

    $ sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git

Now you need to create a database, and link the database to the app:

.. code-block:: bash

    $ ssh dokku postgres:create example-database
    $ ssh dokku postgres:link example-database django-tutorial

Letsencrypt
...........

To add SSL with the `Let's Encrypt plugin <https://github.com/dokku/dokku-letsencrypt>`_
(`more <https://blog.semicolonsoftware.de/securing-dokku-with-lets-encrypt-tls-certificates/>`_),
on the dokku server:

.. code-block:: bash

    $ sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

On your system:

.. code-block:: bash
    $ ssh dokku config:set --no-restart myapp DOKKU_LETSENCRYPT_EMAIL=your@email.tld DOKKU_LETSENCRYPT_EMAIL=your@email.tld
    $ ssh dokku letsencrypt myapp
