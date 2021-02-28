Celery
======

(Yes, I know Celery isn't Django-specific.)

http://docs.celeryproject.org/en/latest/

RELIABLY setting up a Django project with Celery
------------------------------------------------

The Celery docs are woefully insufficient.

* Unlike many Django packages, you do not need to add Celery to ``INSTALLED_APPS``
  in settings.

* To configure Celery in our Django settings, use the (new as of 4.0) settings names as documented
  `here <http://docs.celeryq.org/en/latest/userguide/configuration.html#configuration>`_
  *BUT* prefix each one with ``CELERY_`` and change it to all uppercase.
  E.g. the docs say to set ``broker_url``, but instead we will set ``CELERY_BROKER_URL``
  in our Django settings.

* Decide on what name to use for your Celery application.  Here I'm going to call it "example_celeryapp".

* Somewhere add code to create the Celery application::

    from celery import Celery

    # Don't try to guess which django settings we should be using.
    if "DJANGO_SETTINGS_MODULE" not in os.environ:
        raise Exception(
            "DJANGO_SETTINGS_MODULE must be set in the environment before running celery."
        )

    # The app name is "example_celeryapp" to match "-A example_celeryapp" that we pass to
    # beat and the workers.
    app = Celery("example_celeryapp")
    # - namespace='CELERY' means all celery-related configuration keys
    #   should have a `CELERY_` prefix.
    app.config_from_object("django.conf:settings", namespace="CELERY")

It doesn't really matter where we put this, because we'll import it from all
our tasks files and it'll get loaded when we need it to.

Note that we're not using ``app.autodiscover_tasks()`` - it would need to run after
all the Django apps were configured in order to reliably work, and thus far, Django doesn't
offer any way to run things then.  Instead, we're going to have to register each Django
app's tasks as it is ready.

* In each Django app that needs tasks, create a tasks.py. Import our celery app
  from whereever we put it previously, and use ``@app.tasks(options)`` as a decorator
  on each task::

    from somewhere import app

    @app.task(ignore_result=True)
    def some_task(arg1, arg2):
        ...

* `Set up a ready method <https://docs.djangoproject.com/en/stable/ref/applications/#django.apps.AppConfig.ready>`_
  for the Django app. In the ready method (and not before), import its tasks file::

    from django.apps import AppConfig

    class MyApplicationConfig(AppConfig):
      name = 'myapplication'
      verbose_name = 'myapplication'

      def ready():
        # Register celery tasks
        import myapplication.tasks

* Your servers will need some directories for Celery to use at run-time. If you're using Ansible, you might do something like::

    - name: create dirs for celery to use
      file:
          state: directory
          owner: "{{ run_as_user }}"
          group: "{{ run_as_group }}"
          path: "{{ item }}"
          mode: 0755
      loop:
          - /var/log/celery
          - "{{ pidfiles_dir }}"


* When starting workers, pass ``-A`` with your celery app name. E.g., if you're creating a systemd service,
  ``{{ venv_dir }}`` is your virtualenv, etc, your command might be::

    {{ venv_dir }}/bin/celery worker -A example_celeryapp --loglevel INFO --concurrency 2 --logfile /var/log/celery/%%n%%I.log --pidfile {{ pidfiles_dir }}/celery-%%n%%I.pid

* Similarly when starting beat::

    {{ venv_dir }}/bin/celery beat -A example_celeryapp --loglevel INFO --logfile /var/log/celery/beat.log --pidfile {{ pidfiles_dir }}/celery-beat.pid

Useful settings
---------------

http://docs.celeryproject.org/en/latest/configuration.html

CELERY_TASK_ALWAYS_EAGER: If this is True, all tasks will be executed locally by blocking until the task returns. apply_async() and Task.delay() will return an EagerResult instance, which emulates the API and behavior of AsyncResult, except the result is already evaluated.

That is, tasks will be executed locally instead of being sent to the queue.

This is useful mainly when running tests, or running locally without Celery
workers.

CELERY_TASK_EAGER_PROPAGATES: If this is True, eagerly executed tasks (applied by task.apply(), or when the CELERY_TASK_ALWAYS_EAGER setting is enabled), will propagate exceptions.

It’s the same as always running apply() with throw=True.

`CELERY_TASK_IGNORE_RESULT <https://docs.celeryproject.org/en/stable/userguide/configuration.html#std:setting-task_ignore_result>`_:
Whether to store the task return values or not (tombstones). If you still want to store errors, just not successful return values, you can set CELERY_STORE_ERRORS_EVEN_IF_IGNORED.

*CELERYD_HIJACK_ROOT_LOGGER:* By default any previously configured handlers on the root logger will be removed. If you want to customize your own logging handlers, then you can disable this behavior by setting CELERYD_HIJACK_ROOT_LOGGER = False.

`CELERY_BEAT_SCHEDULE <https://docs.celeryproject.org/en/stable/userguide/configuration.html#std:setting-beat_schedule>`_:
In each task, you can add an 'options' dictionary and set
'expires' to a number of seconds. If the task doesn't run within that time,
it'll be discarded rather than run when it finally gets to a worker. This can
help a lot with periodic tasks when workers or the queue gets hung up for a while
and then unjammed - without this, the workers will have to work through a huge
backlog of the same periodic tasks over and over, for no reason.

Example::

    CELERY_BEAT_SCHEDULE = {
        'process_new_scans': {
            'task': 'tasks.process_new_scans',
            'schedule': timedelta(minutes=15),
            'options': {
                'expires': 10*60,  # 10 minutes
            }
        },
    }

`CELERY_TASK_DEFAULT_QUEUE <https://docs.celeryproject.org/en/stable/userguide/configuration.html#std:setting-task_default_queue>`_:
In the absence of more complicated configuration, celery
will use this queue name for everything. Handy when multiple instances of a site
are sharing a queue manager::

    CELERY_TASK_DEFAULT_QUEUE = 'queue_%s' % INSTANCE

