.. index:: django; sentry

Sentry on a Django site
=======================

Requirements::

    raven==6.6.0   # or whatever

Settings::

    INSTALLED_APPS += ('raven.contrib.django.raven_compat',)

    LOGGING[handlers]['sentry'] = {
        'level':  'ERROR', # To capture more than ERROR, change to WARNING, INFO, etc.
        'class': 'raven.contrib.django.raven_compat.handlers.SentryHandler',
         # 'tags': {'custom-tag': 'x'},
    }

    LOGGING['root']['handlers'].append('sentry')
    # OR
    LOGGING['root'] = {
        'level': 'WARNING',
        'handlers': ['sentry'],
    }

    RAVEN_CONFIG = {
        'dsn': '{{ RAVEN_DSN }}',
        'release': '{{ commit }}',
        'site': 'TypeCoach',
        'environment': '{{ env }}',
        'processors': [
            'raven.processors.SanitizePasswordsProcessor',
        ]
    }

Base template::

    {% load raven %}
    <!doctype html>
    <head>
        ...
        <script src="https://cdn.ravenjs.com/3.23.2/raven.min.js" crossorigin="anonymous"></script>
        <script>Raven.config('{% sentry_public_dsn %}').install()</script>

wsgi.py::

    from raven.contrib.django.raven_compat.middleware.wsgi import Sentry
    from django.core.wsgi import get_wsgi_application

    application = Sentry(get_wsgi_application())
