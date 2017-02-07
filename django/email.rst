Email
=====

https://docs.djangoproject.com/en/stable/topics/email/

API
---

Send one email::

    send_mail(subject, message, from_email, recipient_list, fail_silently=False, auth_user=None, auth_password=None, connection=None)

Attachments
-----------

    msg = EmailMessage(...)
    msg.attach(
        filename="any string",
        content=b"the contents",
        mimetype="application/sunshine"
    )

or

    msg.attach(instance of MIMEBase)


Email backends/handlers
-----------------------

https://docs.djangoproject.com/en/stable/topics/email/#email-backends

For development::

    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

For real::

    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

In-memory backend - The 'locmem' backend stores messages in a special attribute of the django.core.mail module. The outbox attribute is created when the first message is sent. It’s a list with an EmailMessage instance for each message that would be sent::

    EMAIL_BACKEND = 'django.core.mail.backends.locmem.EmailBackend'

This backend is not intended for use in production – it is provided as a convenience that can be used during development and testing.

Settings for email addresses
----------------------------

`ADMINS <https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-ADMINS>`_
A tuple that lists people who get code error notifications::

    (('John', 'john@example.com'), ('Mary', 'mary@example.com'))

`MANAGERS <https://docs.djangoproject.com/en/stable/ref/settings/#managers>`_ Not needed

`DEFAULT_FROM_EMAIL <https://docs.djangoproject.com/en/stable/ref/settings/#default-from-email>`_
Default email address to use for various automated correspondence from the site manager(s).
This doesn’t include error messages sent to ADMINS and MANAGERS; for that, see SERVER_EMAIL.

`SERVER_EMAIL <https://docs.djangoproject.com/en/stable/ref/settings/#server-email>`_
The email address that error messages come from, such as those sent to ADMINS and MANAGERS.
