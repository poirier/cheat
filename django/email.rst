Email
=====

https://docs.djangoproject.com/en/dev/topics/email/

API
---

Send one email::

    send_mail(subject, message, from_email, recipient_list, fail_silently=False, auth_user=None, auth_password=None, connection=None)¶


Email backends/handlers
-----------------------

https://docs.djangoproject.com/en/dev/topics/email/#email-backends

For development::

    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

For real::

    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

In-memory backend - The 'locmem' backend stores messages in a special attribute of the django.core.mail module. The outbox attribute is created when the first message is sent. It’s a list with an EmailMessage instance for each message that would be sent::

    EMAIL_BACKEND = 'django.core.mail.backends.locmem.EmailBackend'

This backend is not intended for use in production – it is provided as a convenience that can be used during development and testing.
