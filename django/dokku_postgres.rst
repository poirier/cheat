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

There are built-in commands making it easy to backup and restore databases:

.. code-block:: bash

    $ ssh dokku postgres:export [db_name] > [db_name].dump
    $ ssh dokku postgres:import [db_name] < [db_name].dump
