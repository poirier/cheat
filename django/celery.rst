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

CELERY_IGNORE_RESULT: Whether to store the task return values or not (tombstones). If you still want to store errors, just not successful return values, you can set CELERY_STORE_ERRORS_EVEN_IF_IGNORED.
