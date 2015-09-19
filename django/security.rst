.. _security:

Security
========

Protect internal services
-------------------------

Vse a VPN, or check out `oauth2_proxy <https://github.com/bitly/oauth2_proxy>`_ or similar services.

Django
------

Best practice: install ``django-secure`` and run ``manage.py checksecure``
to make sure all the right settings are enabled.

See also `OWASP <https://www.owasp.org>`_.

Admin
-----

Don't leave it externally accessible, even with a password.

SSH
---

Two important settings in ``/etc/sshd_config``:

* Disable root login::

    PermitRootLogin no

* Disable password auth::

    PasswordAuthentication no

Also consider changing to some port other than 22.

SSL
---

SEE ALSO :ref:`nginx` and
`Django docs on SSL and https <https://docs.djangoproject.com/en/1.7/topics/security/#ssl-https>`_.

Basically, make sure nginx is setting X-Forwarded-Proto, then add to settings::

    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
