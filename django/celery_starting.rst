.. _celery_scheduling:
.. _why_celery:

=================================================
Getting Started Using Celery for Scheduling Tasks
=================================================

Many Django applications can make good use of being able to schedule work, either periodically or just not blocking the request thread.

There are multiple ways to schedule tasks in your Django app, but there are some advantages to using Celery. It’s supported, scales well, and works well with Django. Given its wide use, there are lots of resources to help learn and use it. And once learned, that knowledge is likely to be useful on other projects.

Celery versions 5.0.x
=====================

This documentation applies to Celery 5.0.x.  Earlier or later versions of Celery
might behave differently. Also, links to Celery documentation might stop working if newer versions of Celery re-organize the documentation, which does happen.

Introduction to Celery
======================

The purpose of Celery is to allow you to run some code later, or regularly
according to a schedule.

Why might this be useful? Here are a couple of common cases.

First, suppose a web request has come in from a user, who is waiting
for the request to complete so a new page can load in their browser.
Based on their request, you have some code to run that's going to take
a while (longer than the person might want to wait for a web page), but
you don't really need to run that code before responding to the web
request. You can use Celery to have your long-running code
called later, and go ahead and respond immediately to the web request.

This is common if you need to access a remote server to handle the request.
Your app has no control over how long the remote server will take to respond,
or the remote server might be down.

Another common situation is wanting to run some code regularly. For
example, maybe every hour you want to look up the latest weather
report and store the data. You can write a task to do that work, then
ask Celery to run it every hour. The task runs and puts the data
in the database, and then your Web application has access to the
latest weather report.

A `task`_
is just a Python function.  You can think of scheduling a task as
a time-delayed call to the function. For example, you might ask Celery
to call your function ``task1`` with arguments ``(1, 3, 3)`` after five
minutes.  Or you could have your function ``batchjob`` called every
night at midnight.

When a task is ready to be run, Celery puts it on a
`queue`_,
a list of
tasks that are ready to be run. You can have many queues, but we'll assume
a single queue here for simplicity.

Putting a task on a queue just adds it to a to-do list, so to speak.
In order for the task to be executed, some other process, called a `worker`,
has to be watching that queue for tasks. When it sees tasks on the queue,
it'll pull off the first and execute it, then go back to wait for more.
You can have many workers, possibly on many different servers, but we'll
assume a single worker for now.

We'll talk more later about the queue, the workers, and another important
process that we haven't mentioned yet, but that's enough for now, let's
do some work.

The tricky part
===============

For all this to work, both the Django and Celery processes have to
agree on much of their configuration, and the Celery processes have
to have run enough of Django's setup so that our tasks can access
the database and so forth. This is a little complicated because
Django and Celery have completely different startup code.

(Aside: This was much simpler a few major releases of Celery ago,
when we could just run Celery applications as Django
management commands. Ah, those were the days...)

Here are some key points:

* DJANGO_SETTINGS_MODULE *must* be set in the environment before starting
  a Celery process. Its presence in the environment triggers internal magic
  in Celery to run the Django setup at the right time.

* The Celery "application" must be created and configured during startup of
  both Django and Celery.

* All the Celery tasks need to get imported during startup of both Django
  and Celery.

Installing celery locally
=========================

We're going to be using Redis with Celery.

You'll need to have Redis installed.
I'll point to the `Redis install documentation <https://redis.io/topics/quickstart>`_
rather than reproducing that here.

Then we can install Celery and all
the dependencies it needs to use Redis with one command,
run in our virtual environment:

.. code-block:: bash

    $ pip install celery[redis]

.. raw:: html

    <div style="margin-bottom:2em;"><span style="display:none;">.</span></div>


Configuring Django for Celery
=============================

To get started, we'll just get Celery configured to use with ``runserver``.
For the Celery `broker`_, which lets Django and the Celery workers
communicate, we'll use Redis. Redis is nice because it's both easy to set up
and suitable for many production environments.

.. warning:: Before using Redis beyond just playing on your local system, read about `Redis security <https://redis.io/topics/security>`_ and plan to protect your Redis server. It is *not* designed to be secure out-of-the-box.

In your Django settings file, add:

.. code-block:: python

    CELERY_BROKER_URL = "redis://localhost:6379/0"

.. note:: The broker is the single most important configuration value, since it tells Django and Celery how to communicate. If they don't have the same value for this setting, no tasks will run.

Creating the Celery Application
===============================

We need a small Python file that will initialize Celery the way we want it,
whether running in a Django or Celery process.

It's tempting to just create a file ``celery.py`` at the top level of
our project, but that's exactly the name we cannot use, because Celery
owns the ``celery`` package namespace.

Instead, I'll create a ``celery.py`` inside one of my existing
packages, e.g. ``appname/celery.py``.

Here's the code that you need to add:

.. code-block:: python

    from celery import Celery

    # Create default Celery app
    app = Celery()

    # namespace='CELERY' means all celery-related configuration keys
    # should be uppercased and have a `CELERY_` prefix in Django settings.
    # https://docs.celeryproject.org/en/stable/userguide/configuration.html
    app.config_from_object("django.conf:settings", namespace="CELERY")

    # When we use the following in Django, it loads all the <appname>.tasks
    # files and registers any tasks it finds in them. We can import the
    # tasks files some other way if we prefer.
    app.autodiscover_tasks()

It doesn't really matter what variable you assign the Celery() object to.
Celery will find it as long as it's at the top level of the module.

The ``config_from_object`` is important so we can put ``CELERY_*`` settings
in our Django settings and have Celery use those values. Anything we want to
configure about Celery, we just find the right
`configuration setting <https://docs.celeryproject.org/en/stable/userguide/configuration.html>`_,
change it to all capital letters, put ``CELERY_`` in front, and set it
in our Django settings.

For example, there's a Celery setting
`timezone <https://docs.celeryproject.org/en/stable/userguide/configuration.html#timezone>`_.
If we wanted to set that, we'd put something like this in our Django settings:

.. code-block:: Python

    CELERY_TIMEZONE = "America/New_York"

It is critical that this file is imported late in Django setup, after all your Django apps have
been registered and models loaded. I recommend
importing it inside any Django app's
`ready() method <https://docs.djangoproject.com/en/stable/ref/applications/#django.apps.AppConfig.ready>`_.

We'll see below that we'll tell Celery's processes to load this using a command-line option.

Writing a task
==============

As mentioned before, a task can just be a Python function.  However, Celery
does need to know about it. That's pretty easy when using Celery with Django.
Just add a ``tasks.py`` file to an application, put your tasks in that file,
and decorate them using ``@shared_task()``.  Here's a trivial ``tasks.py``:

.. code-block:: python

    from celery import shared_task

    @shared_task()
    def add(x, y):
        return x + y

Marking a function as a task doesn't prevent calling it normally. You
can still call it: ``z = add(1, 2)`` and it will work exactly as before. Marking
it as a task just gives you additional ways to call it.

When this is imported, Celery will register this method as a task for our application.
Or calling ``app.autodiscover_tasks()`` will load the tasks in all your
``<appname>/tasks.py`` files.

All tasks *must* be imported during Django and Celery startup so that Celery
knows about them. If we put them in ``<appname>/tasks.py`` files and call
``app.autodiscover_tasks()``, that will do it. Or we could put our tasks
in our models files, or import them from there, or import them from
application ``ready`` methods.

Queueing a task
===============

Let's start with the simple case we mentioned above. We want to run our task
soon. We just don't want it to hold up our current thread. We can do that by
just adding ``.delay`` to the name of our task:

.. code-block:: python

    from myapp.tasks import add

    add.delay(2, 2)

Celery will add the task to its queue (`"worker, please call myapp.tasks.add(2, 2)"`) and return
immediately. As soon as an idle worker sees it at the head of the queue, the
worker will remove it from the queue, then execute it, something like this:

.. code-block:: python

    import myapp.tasks.add

    myapp.tasks.add(2, 2)

.. raw:: html

    <div style="margin-bottom:2em;"><span style="display:none;">.</span></div>


A warning about import names
----------------------------

It's important that your task is always imported and referred to using the
`same package name`_.
For example, depending on how your Python path is set up,
it might be possible to refer to it as either
``myproject.myapp.tasks.add`` or ``myapp.tasks.add``.  Or from
``myapp.views``, you might import it as ``.tasks.add``. But Celery has no
way of knowing those are all the same task.

Testing it
==========

Start a worker
--------------

As we've already mentioned, a separate process, the `worker`_, has to be running
to actually execute your Celery tasks.  Here's how we can start a worker for
our development needs.

First, open a new shell or window. In that shell, set up the same Django
development environment - activate your virtual environment, or add
things to your Python path, whatever you do so that you `could` use
``runserver`` to run your project.

Also, even if you otherwise wouldn't, you must set
``DJANGO_SETTINGS_MODULE`` in your environment, or Celery won't recognize
that it's running with Django.

Now you can `start a worker`_ in that shell:

.. code-block:: console

    $ celery -A appname.celery worker --loglevel=info

The worker will run in that window, and send output there.

The ``-A`` command line "option" isn't really optional. Celery will
import that module and look for our Celery application object there.

By the way, we can be more specific here, e.g. ``-A appname.celery:app``
to tell Celery that the application we want it to use is in the ``app``
top-level variable in the module.  But you wouldn't have to do that unless
you had multiple Celery applications in the module, and there's no
reason I know of to do that for most Django projects.

Run your task
-------------

Back in your first window, start a Django shell and run your task:

.. code-block:: console

    $ python manage.py shell
    >>> from myapp.tasks import add
    >>> add.delay(2, 2)

You should see output in the worker window indicating that the worker has
run the task:

.. code-block:: console

    [2013-01-21 08:47:08,076: INFO/MainProcess] Got task from broker: myapp.tasks.add[e080e047-b2a2-43a7-af74-d7d9d98b02fc]
    [2013-01-21 08:47:08,299: INFO/MainProcess] Task myapp.tasks.add[e080e047-b2a2-43a7-af74-d7d9d98b02fc] succeeded in 0.183349132538s: 4

.. raw:: html

    <div style="margin-bottom:2em;"><span style="display:none;">.</span></div>

An Example
==========

Earlier we mentioned using Celery to avoid delaying responding to a web
request. Here's a simplified Django view that uses that technique:

.. code-block:: python

    # views.py

    def view(request):
        form = SomeForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            # Schedule a task to process the data later
            do_something_with_form_data.delay(data)
        return render_to_response(...)

    # tasks.py

    @shared_task
    def do_something_with_form_data(data):
        call_slow_web_service(data['user'], data['text'], ...)

.. raw:: html

    <div style="margin-bottom:2em;"><span style="display:none;">.</span></div>

Troubleshooting
===============

It can be frustrating trying to get Celery tasks working, because multiple parts
have to be present and communicating with each other. Many of the usual tips
still apply:

- Get the simplest possible configuration working first.
- Use the python debugger and print statements to see what's going on.
- Turn up logging levels (e.g. ``--loglevel debug`` on the worker) to get more insight.

There are also some tools that are unique to Celery.

Eager scheduling
----------------

In your Django settings, you can add:

.. code-block:: python

    CELERY_ALWAYS_EAGER = True

and Celery will `bypass the entire scheduling mechanism`_ and call your code
directly.

In other words, with ``CELERY_ALWAYS_EAGER = True``, these two statements run
just the same:

.. code-block:: python

    add.delay(2, 2)
    add(2, 2)

You can use this to get your core logic working before introducing the
complication of Celery scheduling.

Check the results
-----------------

Anytime you schedule a task, Celery returns an `AsyncResult`_ object. You can
save that object, and then use it later to see if the task
has been executed, whether it was successful, and what the result was.

.. code-block:: python

    result = add.delay(2, 2)
    ...
    if result.ready():
        print("Task has run")
        if result.successful():
            print("Result was: %s" % result.result)
        else:
            if isinstance(result.result, Exception):
                print("Task failed due to raising an exception")
                raise result.result
            else:
                print("Task failed without raising exception"
     else:
         print("Task has not yet run")

.. raw:: html

    <div style="margin-bottom:2em;"><span style="display:none;">.</span></div>

Periodic Scheduling
===================

Another common case is running a task on a regular schedule.  Celery implements
this using another process, `celery beat`_. Celery beat runs continually, and
whenever it's time for a scheduled task to run, celery beat queues it for
execution.

For obvious reasons, only one celery beat process should be running (unlike
workers, where you can run as many as you want and need).

Starting celery beat is similar to starting a worker. Start another window,
set up your Django environment, then:

.. code-block:: bash

    $ celery -A appname.celery beat

.. note::
    If you are running celery beat somewhere that it won't have a
    persistent file system across invocations, like in a container, then
    ignore the following instructions and see my other blog post,
    `How to Schedule Tasks Using Celery Beat in a Container
    <https://www.caktusgroup.com/blog/2020/05/14/how-schedule-tasks-using-celery-beat-container/>`_

To arrange for the "add" task in the "myapp.tasks" package to run every 30 seconds with
arguments ``(16, 16)``, add this to your Django settings:

.. code-block:: python

    CELERY_BEAT_SCHEDULE = {
    	  'add-every-30-seconds': {
            'task': 'myapp.tasks.add',
            'schedule': 30.0,
            'args': (16, 16),
            'options': {
                'expires': 15.0,
            },
        },
    }

For safety's sake, the ``expires`` option tells Celery that if it's not able
to run this task within 15 seconds, to just cancel it. We know we'll queue
another one every 30 seconds anyway.

Hints and Tips
==============

Don't pass model objects to tasks
---------------------------------

Since tasks don't run immediately, by the time a task runs and looks at
a model object that was passed to it, the corresponding record in the
database might have changed. If the task then does something to the model
object and saves it, those changes in the database are overwritten by
older data.

It's almost always safer to save the object, pass the record's key, and look
up the object again in the task:

.. code-block:: python

    myobject.save()
    mytask.delay(myobject.pk)

    ...


    @task
    def mytask(pk):
        myobject = MyModel.objects.get(pk=pk)
        ...

.. raw:: html

    <div style="margin-bottom:2em;"><span style="display:none;">.</span></div>

Schedule tasks in other tasks
-----------------------------

It's perfectly all right to schedule one task while executing another.
This is a good way to make sure the second task doesn't run until the
first task has done some necessary work first.

Don't wait for one task in another
----------------------------------

If a task waits for another task, the first task's worker is blocked
and cannot do any more work until the wait finishes. This is likely
to lead to a deadlock, sooner or later.

If you're in Task A and want to schedule Task B, and after Task B
completes, do some more work, it's better to create a Task C to
do that work, and have Task B schedule Task C when it's done.

Next Steps
==========

Once you understand the basics, parts of the Celery User's Guide are
good reading.  I recommend these chapters to start with; the others are
either not relevant to Django users or more advanced:

* `Tasks <http://docs.celeryproject.org/en/latest/userguide/tasks.html>`_
* `Periodic Tasks <http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html>`_

Using Celery in production
==========================

See my followup post,
`Celery in Production <https://www.caktusgroup.com/blog/2014/09/29/celery-production/>`_.

.. _Celery: http://celeryproject.org/
.. _task: http://docs.celeryproject.org/en/latest/userguide/tasks.html
.. _queue: http://docs.celeryproject.org/en/latest/getting-started/introduction.html#what-is-a-task-queue
.. _local use with Django: http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html
.. _django-celery: http://pypi.python.org/pypi/django-celery
.. _broker: http://docs.celeryproject.org/en/latest/getting-started/first-steps-with-celery.html#choosing-a-broker
.. _Django database broker implementation: http://docs.celeryproject.org/en/latest/getting-started/brokers/django.html
.. _South: http://south.readthedocs.org/en/latest/
.. _look through: http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html#defining-and-calling-tasks
.. _same package name: http://docs.celeryproject.org/en/latest/userguide/tasks.html#task-naming-relative-imports
.. _worker: http://docs.celeryproject.org/en/latest/userguide/workers.html
.. _start a worker: http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html#starting-the-worker-process
.. _bypass the entire scheduling mechanism: https://docs.celeryproject.org/en/stable/userguide/configuration.html#task-always-eager
.. _AsyncResult: http://docs.celeryproject.org/en/latest/reference/celery.result.html#celery.result.AsyncResult
.. _celery beat: http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html
.. _storing the schedules in a Django database table: http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html#using-custom-scheduler-classes
.. _/admin/djcelery/periodictask/: /admin/djcelery/periodictask/
.. _crontab: http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html#crontab-schedules
.. _initial data: https://docs.djangoproject.com/en/1.3/howto/initial-data/#providing-initial-data-with-fixtures
.. _RabbitMQ: http://www.rabbitmq.com

