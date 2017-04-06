SSL for Dokku (Letsencrypt)
===========================


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
