SSL for Dokku (Letsencrypt etc.)
================================

Letsencrypt
...........

*Note:* Get the site up and running, and accessible from the Internet,
first. Let's Encrypt will not be able to get you a certificate until then.

To add SSL with the `Let's Encrypt plugin <https://github.com/dokku/dokku-letsencrypt>`_
(`more <https://blog.semicolonsoftware.de/securing-dokku-with-lets-encrypt-tls-certificates/>`_),
first install the plugin by running on the dokku server (plugins must
be installed as root):

.. code-block:: bash

    $ sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

Then on your system, to configure your app and tell letsencrypt to manage
its certs and renew them periodically:

.. code-block:: bash

    $ ssh dokku config:set --no-restart <appname> DOKKU_LETSENCRYPT_EMAIL=your@email.tld
    $ ssh dokku letsencrypt myapp
    $ ssh dokku letsencrypt:cron-job --add <appname>

Forcing SSL from Django
.......................

If we don't want to figure out how to override the default nginx config
to redirect non-SSL requests to SSL, we can have Django do it with
a few settings.

First, set
`SECURE_SSL_REDIRECT <https://docs.djangoproject.com/en/stable/ref/settings/#secure-ssl-redirect>`_ to True. This will tell Django
to do the redirect.

.. code-block:: python

    SECURE_SSL_REDIRECT = True

Commit, deploy, and make sure the site still works.

Second, set
`SECURE_HSTS_SECONDS <https://docs.djangoproject.com/en/stable/ref/settings/#secure-hsts-seconds>`_
to a relatively small number of seconds.

.. code-block:: python

    SECURE_HSTS_SECONDS = 1800

This adds a header to all responses, telling any browser that receives it
that this site should only be accessed via SSL, for that many seconds.

Commit, deploy, and make sure the site still works.

If everything still seems good, bite the bullet, increase SECURE_HSTS_SECONDS
to a large number (e.g. 31536000 seconds, or 1 year),
commit, deploy, and test again.
