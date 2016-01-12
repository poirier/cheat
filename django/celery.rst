Celery
======

(Yes, I know Celery isn't Django-specific.)

http://docs.celeryproject.org/en/latest/

Useful settings
---------------

http://docs.celeryproject.org/en/latest/configuration.html

CELERY_ALWAYS_EAGER: If this is True, all tasks will be executed locally by blocking until the task returns. apply_async() and Task.delay() will return an EagerResult instance, which emulates the API and behavior of AsyncResult, except the result is already evaluated.

That is, tasks will be executed locally instead of being sent to the queue.

CELERY_EAGER_PROPAGATES_EXCEPTIONS: If this is True, eagerly executed tasks (applied by task.apply(), or when the CELERY_ALWAYS_EAGER setting is enabled), will propagate exceptions.

It’s the same as always running apply() with throw=True.

`CELERY_IGNORE_RESULT <http://docs.celeryproject.org/en/latest/configuration.html#celery-ignore-result>`_:
Whether to store the task return values or not (tombstones). If you still want to store errors, just not successful return values, you can set CELERY_STORE_ERRORS_EVEN_IF_IGNORED.

*CELERYD_HIJACK_ROOT_LOGGER:* By default any previously configured handlers on the root logger will be removed. If you want to customize your own logging handlers, then you can disable this behavior by setting CELERYD_HIJACK_ROOT_LOGGER = False.

`CELERYBEAT_SCHEDULE <http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html#beat-entries>`_:
In each task, you can add an 'options' dictionary and set
'expires' to a number of seconds. If the task doesn't run within that time,
it'll be discarded rather than run when it finally gets to a worker. This can
help a lot with periodic tasks when workers or the queue gets hung up for a while
and then unjammed - without this, the workers will have to work through a huge
backlog of the same periodic tasks over and over, for no reason.

Example::

    CELERYBEAT_SCHEDULE = {
        'process_new_scans': {
            'task': 'tasks.process_new_scans',
            'schedule': timedelta(minutes=15),
            'options': {
                'expires': 10*60,  # 10 minutes
            }
        },
    }

CELERY_DEFAULT_QUEUE: In the absence of more complicated configuration, celery
will use this queue name for everything. Handy when multiple instances of a site
are sharing a queue manager::

    CELERY_DEFAULT_QUEUE = 'queue_%s' % INSTANCE

