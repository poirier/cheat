Postgres with Dokku
===================

There's nothing Django-specific about this, but I'm including it just
because we probably want to do it on every single Django deploy.

To install the `postgresql plugin <https://github.com/dokku/dokku-postgres>`_,
inside your server run (because plugins must be installed as root):

.. code-block:: bash

    $ sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git

Now you need to create a database, and link the database to the app.
You can do this from your own system:

.. code-block:: bash

    $ ssh dokku postgres:create example-database
    $ ssh dokku postgres:link example-database django-tutorial

Now when dokku runs your app, it’ll set an env var to tell it where its DB is, e.g.::

    DATABASE_URL=postgres://user:pass@host:port/db

For Django, install the tiny ``dj_database_url`` package, then in settings.py::

    import dj_database_url
    db_from_env = dj_database_url.config(conn_max_age=500)
    DATABASES['default'].update(db_from_env)

There are built-in commands making it easy to backup and restore databases:

.. code-block:: bash

    $ ssh dokku postgres:export [db_name] > [db_name].dump
    $ ssh dokku postgres:import [db_name] < [db_name].dump
