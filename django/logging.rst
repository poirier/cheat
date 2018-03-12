Logging
=======

Some best practices for Django logging.

https://docs.djangoproject.com/en/stable/topics/logging/
https://docs.djangoproject.com/en/stable/topics/logging/#configuring-logging

https://docs.python.org/2/howto/logging.html

https://docs.python.org/2/library/logging.handlers.html#rotatingfilehandler
https://docs.python.org/2/library/logging.handlers.html#timedrotatingfilehandler


INFO level logging for celery is very verbose

If you have DEBUG on, Django logs all SQL queries


Default
-------

Here's what Django uses (around 1.7, anyway) if you don't configure logging:

.. code-block:: python

    # Default logging for Django. This sends an email to the site admins on every
    # HTTP 500 error. Depending on DEBUG, all other log records are either sent to
    # the console (DEBUG=True) or discarded by mean of the NullHandler (DEBUG=False).
    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'filters': {
            'require_debug_false': {
                '()': 'django.utils.log.RequireDebugFalse',
            },
            'require_debug_true': {
                '()': 'django.utils.log.RequireDebugTrue',
            },
        },
        'handlers': {
            'console': {
                'level': 'INFO',
                'filters': ['require_debug_true'],
                'class': 'logging.StreamHandler',
            },
            'null': {
                'class': 'logging.NullHandler',
            },
            'mail_admins': {
                'level': 'ERROR',
                'filters': ['require_debug_false'],
                'class': 'django.utils.log.AdminEmailHandler'
            }
        },
        'loggers': {
            'django': {
                'handlers': ['console'],
            },
            'django.request': {
                'handlers': ['mail_admins'],
                'level': 'ERROR',
                'propagate': False,
            },
            'django.security': {
                'handlers': ['mail_admins'],
                'level': 'ERROR',
                'propagate': False,
            },
            'py.warnings': {
                'handlers': ['console'],
            },
        }
    }

Console
-------

Log errors to console in local.py:

.. code-block:: python

    LOGGING.setdefault('formatters', {})
    LOGGING['formatters']['verbose'] = {
        'format': '[%(name)s] Message "%(message)s" from %(pathname)s:%(lineno)d in %(funcName)s'
    }
    LOGGING['handlers']['console'] = {
        'class': 'logging.StreamHandler',
        'formatter': 'verbose',
        'level': 'ERROR',
    }
    LOGGING['loggers']['django'] = {
                'handlers': ['console'],
                'level': 'ERROR',
                'propagate': True,
    }


Development
-----------

For local development, we want lots of output saved to a log file in case
we need to look back at a problem, but no emailing of
exceptions and such.


In settings:

.. code-block:: python


    LOG_DIR = os.path.join(PROJECT_ROOT, '..', 'log')

    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'handlers': {
            'console': {  # Log to stdout
                'level': 'INFO',
                'class': 'logging.StreamHandler',
            },
            'file': {
                'level': 'DEBUG',
                'class': 'logging.FileHandler',
                'filename': os.path.join(LOG_DIR, 'django_debug.log',
            }
        },
        'root': {  # For dev, show errors + some info in the console
            'handlers': ['console'],
            'level': 'INFO',
        },
        'loggers': {
            'django.request': {  # debug logging of things that break requests
                'handlers': ['file'],
                'level': 'DEBUG',
                'propagate': True,
            },
        },
    }

Or how about:

.. code-block:: python

    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'formatters': {
            'simple': {
                'format': '%(name)-20s %(levelname)-8s %(message)s',
            },
        },
        'handlers': {
            'console': {  # Log to stdout
                'level': 'INFO',
                'class': 'logging.StreamHandler',
                'formatter': 'simple',
            },
        },
        'root': {  # For dev, show errors + some info in the console
            'handlers': ['console'],
            'level': 'INFO',
        },
    }



Staging
-------

FIXME: Add celery exceptions

@tobiasmcnulty also mentioned: "re: celery error emails, this is a good setting to have enabled: http://celery.readthedocs.org/en/latest/configuration.html#celery-send-task-error-emails"

On staging, we still want lots of info logged semi-permanently (to files),
but we also want to be emailed about exceptions to make sure
we find out about problems before we deploy them to production.

Emails should go to the devs, not the client or production site admins.

Like so:

.. code-block:: python


    ADMINS = (
        ('XXX DevTeam', 'xxx-dev-team@example.com'),
    )

    LOG_DIR = os.path.join(PROJECT_ROOT, '..', 'log')

    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'handlers': {
            'file': {  # Rotate log file daily, only keep 1 backup
                'level': 'DEBUG',
                'class': 'logging.handlers.TimedRotatingFileHandler',
                'filename': os.path.join(LOG_DIR, 'django_debug.log',
                'when': 'd',
                'interval': 1,
                'backupCount': 1,
            },
            'mail_admins': {
                'level': 'ERROR',
                'class': 'django.utils.log.AdminEmailHandler'
            },
        },
        # EMAIL all errors (might not want this, but let's try it)
        'root': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
        },
        'loggers': {
            'django.request': {
                'handlers': ['file'],
                'level': 'INFO',
                'propagate': True,
            },
        },
    }


Production
----------

Mark says: for production I like to log to syslog which can then be shipped elsewhere without changing the application

(https://docs.python.org/2/library/logging.handlers.html#logging.handlers.SysLogHandler ?)

@Scottm and I have been talking about making that more common: log to syslog, ship to Logstash, monitor via Kibana http://www.elasticsearch.org/overview/kibana/

getting Nginx to log to syslog is kind of a pain
you basically have to get syslog to monitor the file and ship it
Logstash + Kibana looks much easier to manage/configure than Graylog2

the plan was to add it to Ona but that isn't done yet (as of Aug 28, 2014)
CCSR was/is using Graylog2
Minidam does syslog --> Loggly
libya is using logstash -> graylog (in addition to sentry)


Example
-------

Here's what we've got set up for Django logging on one project.  This sends everything
level INFO and higher to a local log file and a Graylog instance. Anything ERROR and
higher is emailed to admins and sent to a Sentry instance, which can send more notifications.

In environment::

    SENTRY_DSN: http://long_hex_string:long_hex_string@hostname:9000/3

Requirements::

    raven==3.6.1

Settings:

.. code-block:: python


    INSTALLED_APPS = (
        ...
        'raven.contrib.django.raven_compat',  # Sentry logging client
        ...
    }

    CELERY_SEND_TASK_ERROR_EMAILS = True

    # Send ERRORS to email and sentry.
    # Send a fair bit of info to graylog and a local log file
    # (but not debug level messages, ordinarily).
    LOGGING = {
        'version': 1,
        'disable_existing_loggers': True,
        'filters': {
            # This filter strips out request information from the message record
            # so it can be sent to Graylog (the request object is not picklable).
            'django_exc': {
                '()': 'our_filters.RequestFilter',
            },
            'require_debug_false': {
                '()': 'django.utils.log.RequireDebugFalse'
            },
            # This filter adds some identifying information to each message, to make
            # it easier to filter them further, e.g. in Graylog.
            'static_fields': {
                '()': 'our_filters.StaticFieldFilter',
                'fields': {
                    'deployment': 'project_name',
                    'environment': 'staging'   # can be overridden, e.g. 'staging' or 'production'
                },
            },
        },
        'formatters': {
            'basic': {
                'format': '%(asctime)s %(name)-20s %(levelname)-8s %(message)s',
            },
        },
        'handlers': {
            'file': {
                'level': 'DEBUG',  # Nothing here logs DEBUG level messages ordinarily
                'class': 'logging.handlers.RotatingFileHandler',
                'formatter': 'basic',
                'filename': os.path.join(LOG_ROOT, 'django.log'),
                'maxBytes': 10 * 1024 * 1024,  # 10 MB
                'backupCount': 10,
            },
            'graylog': {
                'level': 'INFO',
                'class': 'graypy.GELFHandler',
                'host': env_or_default('GRAYLOG_HOST', 'monitor.caktusgroup.com'),
                'port': 12201,
                'filters': ['static_fields', 'django_exc'],
            },
            'mail_admins': {
                'level': 'ERROR',
                'class': 'django.utils.log.AdminEmailHandler',
                'include_html': False,
                'filters': ['require_debug_false'],
            },
            'sentry': {
                'level': 'ERROR',
                'class': 'raven.contrib.django.raven_compat.handlers.SentryHandler',
            },
        },
        'root': {
            # graylog (or any handler using the 'django_exc' filter ) should be last
            # because it will alter the LogRecord by removing the `request` field
            'handlers': ['file', 'mail_admins', 'sentry', 'graylog'],
            'level': 'WARNING',
        },
        'loggers': {
            # These 2 loggers must be specified, otherwise they get disabled
            # because they are specified by django's DEFAULT_LOGGING and then
            # disabled by our 'disable_existing_loggers' setting above.
            # BEGIN required loggers #
            'django': {
                'handlers': [],
                'propagate': True,
            },
            'py.warnings': {
                'handlers': [],
                'propagate': True,
            },
            # END required loggers #
            # The root logger will log anything WARNING and higher, so there's
            # no reason to add loggers here except to add logging of lower-level information.
            'libya_elections': {
                'handlers': ['file', 'graylog'],
                'level': 'INFO',
            },
            'nlid': {
                'handlers': ['file', 'graylog'],
                'level': 'INFO',
            },
            'register': {
                'handlers': ['file', 'graylog'],
                'level': 'INFO',
            },
            'bulk_sms': {
                'handlers': ['file', 'graylog'],
                'level': 'INFO',
            },
        }
    }

    #
    # our_filters.py
    #
    import logging


    class QuotelessStr(str):
        """
        Return the repr() of this string *without* quotes.  This is a
        temporary fix until https://github.com/severb/graypy/pull/34 is resolved.
        """
        def __repr__(self):
            return self


    class StaticFieldFilter(logging.Filter):
        """
        Python logging filter that adds the given static contextual information
        in the ``fields`` dictionary to all logging records.
        """
        def __init__(self, fields):
            self.static_fields = fields

        def filter(self, record):
            for k, v in self.static_fields.items():
                setattr(record, k, QuotelessStr(v))
            return True


    class RequestFilter(logging.Filter):
        """
        Python logging filter that removes the (non-pickable) Django ``request``
        object from the logging record.
        """
        def filter(self, record):
            if hasattr(record, 'request'):
                del record.request
            return True


Including info like the emailed errors do
-----------------------------------------

.. code-block:: python

    from django.views.debug import TECHNICAL_500_TEXT_TEMPLATE, get_safe_settings, \
        get_exception_reporter_filter
    from django.views.decorators.debug import sensitive_post_parameters

    t = Template(TECHNICAL_500_TEXT_TEMPLATE)
    filter = get_exception_reporter_filter(request)
    r = t.render(Context({
        'request': request,
        'is_email': True,
        'filtered_POST': filter.get_post_parameters(request),
        'settings': get_safe_settings(),
        'server_time': timezone.now(),
        'django_version_info': get_version(),
    }, autoescape=False))
    logger.error(
        "Got CSRF failure, reason=%s. %s", reason, r,
    )
