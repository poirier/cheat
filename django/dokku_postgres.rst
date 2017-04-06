Postgres with Dokku
===================

There's nothing Django-specific about this, but I'm including it just
because we probably want to do it on every single Django deploy.

To install the `postgresql plugin <https://github.com/dokku/dokku-postgres>`_,
inside your server run:

.. code-block:: bash

    $ sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git

Now you need to create a database, and link the database to the app:

.. code-block:: bash

    $ ssh dokku postgres:create example-database
    $ ssh dokku postgres:link example-database django-tutorial
