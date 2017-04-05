Dokku
=====

Readying a Django project for deploying to `Dokku <http://dokku.viewdocs.io/dokku/>`_.

Introduction
............

This lists the things to add or change to easily deploy a Django application
to Dokku.  It doesn't try to cover all of setting up a site on Dokku, only
the parts relevant to a Django project. You should read the Dokku getting
started docs, then use this as a cheatsheet to quickly enable existing
Django projects to deploy on Dokku.

We use `whitenoise <http://whitenoise.evans.io/en/stable/>`_
to serve static files from Django.
If the site gets incredible amounts of traffic, throw a CDN in front,
but honestly, very very few sites actually need that.
(If you have a philosophical objection to serving static files
from Django, you can customize the nginx config through Dokku
and probably manage to get nginx to do the static file serving,
but I haven't bothered figuring it out myself.)

Files
.....

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
in the top directory. For our simple case, it can just contain one
line, starting with ``web: `` and containing the command to start
gunicorn for our site::

    web: gunicorn {{ project_name }}.wsgi

runtime.txt
-----------

Create ``runtime.txt`` in the top directory. It only needs one line, e.g.::

    python-3.6.1

app.json
--------

Create `app.json <http://dokku.viewdocs.io/dokku/advanced-usage/deployment-tasks/>`_
in the top-level project directory. You might
see examples with lots of things in app.json (because Heroku uses app.json
for lots of things), but as of this writing,
dokku ignores everything but ``scripts.dokku.predeploy`` and
``scripts.dokku.postdeploy``.  Example:

.. code-block:: json

    {
      "scripts": {
        "dokku": {
          "predeploy": "python manage.py migrate --noinput; python manage.py collectstatic --noinput"
        }
      }
    }



Postgresql
..........

There's nothing Django-specific about this, but I'm including it just
because we probably want to do it on every single Django deploy.

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

There's nothing Django-specific about this, but I'm including it just
because we probably want to do it on every single Django deploy.

To add SSL with the `Let's Encrypt plugin <https://github.com/dokku/dokku-letsencrypt>`_
(`more <https://blog.semicolonsoftware.de/securing-dokku-with-lets-encrypt-tls-certificates/>`_),
first install the plugin by running on the dokku server:

.. code-block:: bash

    $ sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

Then on your system, to configure your app and tell letsencrypt to manage
its certs:

.. code-block:: bash

    $ ssh dokku config:set --no-restart myapp DOKKU_LETSENCRYPT_EMAIL=your@email.tld
    $ ssh dokku letsencrypt myapp

FIXME: I don't *think* this arranges to renew the certs periodically,
so figure out a simple way to get that to happen too.
