.. index:: django; security

.. _security:

Security
========

Protect internal services
-------------------------

Vse a VPN, or check out `oauth2_proxy <https://github.com/bitly/oauth2_proxy>`_ or similar services.

Django
------

(django-secure appears to be abandoned. Last change was in 2014, and
it doesn't load under Django 1.11/Python 3.6.)

-Best practice: install ``django-secure`` and run ``manage.py checksecure``
to make sure all the right settings are enabled.-

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
`Django docs on SSL and https <https://docs.djangoproject.com/en/stable/topics/security/#ssl-https>`_.

Basically, make sure nginx is setting X-Forwarded-Proto, then add to settings::

    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

Django security

djangocon 2011 Paul McMillan

http://subversivecode.com/talks/djangocon-us-2011

HSTS

django needs better password hash (SHA1 not broken but very fast)

OpenID much more secure against password cracking (because cracker won't have passwords)

password reset strings can be eventually worked out with a timing attack (if you have a long time and a fast connection)

same for which userids exist on the site

you should do rate limiting:

  mod_evasive (apache)
  HttpLimitReqModule (nginx)

do NOT use random.Random() for security functions, not cryptographically secure;
use random.SystemRandom() instead
e.g.::

    from random import SystemRandom as random
    xxxx random.choice(yyyy)...

Be very careful with pickle, it'll execute anything in the pickled data when you unpickle it

BOOK: The web application hacker's handbook
(new version coming out soon (as of 9/8/2011))

SITE: lost.org?  (not sure I heard that right)(no I didn't)
