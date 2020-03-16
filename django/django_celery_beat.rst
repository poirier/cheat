Draft Blog Post: Using the django-celery-beat scheduler with Django and Celery
==============================================================================

The `django-celery-beat` scheduler for Celery stores the
schedules for your periodic tasks in a Django database
table, instead of a local file. This is a good idea when
running our services in ephemeral containers where local
files could be discarded at any time. However, getting it
working was a little harder than I had anticipated.

The premise
-----------

One of Celery's many useful features is the ability
to configure it to run tasks periodically. It's like
cron, only not tied to a particular server. So when
we scale our site by running the Django service on
multiple servers, we don't end up running our periodic
tasks repeatedly, once on each server.

A Celery utility daemon called `beat` implements this
by submitting your tasks to run as configured
in your task schedule. E.g. if you configure a task
to run every morning at 5am, then every morning at
5am the beat daemon will submit the task to a queue to be
run by Celery's workers.

In addition to being able to run tasks at certain
days and times, beat can also run them at specified
intervals, e.g. every 5 minutes.

In order to do the latter, beat needs to keep track
of when each task last ran. By default, it
just creates a local file and stashes the information
there. It's simple, requires little or no additional
configuration, and works fine in many cases.

But if we're running our daemons in
ephemeral containers, where file system changes can
be thrown away at any time, that's not good enough.
At any time, beat might lose its memory, and that
could result in the task that was only supposed to run
once a week running too often, or not often enough.

`django-celery-beat` is an alternative scheduler
for beat that instead keeps this information in
your Django database, where it's safe.

Complications
-------------

It `sounds pretty simple <http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html#using-custom-scheduler-classes>`_
to install and configure django-celery-beat. You just add it to your virtual environment and
the list of apps in your Django settings,
and change a Celery setting to tell beat to use the new scheduler instead of the default one.

I assumed, since there was nothing in the documentation saying otherwise, that no
changes would be needed in the rest of my application. That turned out to be
incorrect.

Here's the important missing piece of information: the majority of Celery's documentation
for `how to set up periodic tasks <http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html>`_
does *NOT* apply if you're using an alternative scheduler.
I assumed that was all still valid, and just stored the information in a different
way behind the scenes.  In fact, you have to ignore all that,
and convert all your application's current scheduling configuration to a completely
different approach when using django-beat-scheduler.

This only affects how to tell Celery when to run your tasks. Your code doesn't need
to change otherwise.

Scheduling tasks with django-beat-scheduler
-------------------------------------------

If you are using django-celery-beat, you must set up your schedule by creating records in your database, as described
`in django-celery-beat's documentation <https://django-celery-beat.readthedocs.io/en/latest/>`_.
It's not difficult to do, and it's a perfectly reasonable way to
set up your schedule.  I just assumed that using Celery's documented way to set up scheduled tasks would create those records for me, and that turns out not to be the case.

Here's an example of how you might set up a task to run periodically::

    from django_celery_beat.models import IntervalSchedule, PeriodicTask

    every_2_minutes, _ = IntervalSchedule.objects.get_or_create(
        every=2, period=IntervalSchedule.MINUTES,
    )
    PeriodicTask.objects.update_or_create(
        task="invoices.tasks.update_invoices_task",
        name="update invoices",
        defaults=dict(
            interval=every_2_minutes,
            expire_seconds=60,  # If not run within 60 seconds, forget it; another one will be scheduled soon.
        ),
    )


And here's a task to be run every morning::

    at_5_am, _ = CrontabSchedule.objects.get_or_create(
        minute="0", hour="5", day_of_week="*", day_of_month="*", month_of_year="*",
    )
    PeriodicTask.objects.update_or_create(
        task="reports.tasks.generate_large_report",
        defaults=dict(
            crontab=at_5_am,
            expire_seconds=7200,
        ),
    )

When and where to create the schedule records
---------------------------------------------

If you're going to be setting up some of the same tasks in all environments - like a nightly cleanup task - then you can view that task data as a fixture: data that needs to get added to your database once. `I've found <https://www.caktusgroup.com/blog/2015/11/10/initial-data-django/>`_ that all things considered, using migrations works better for that than trying to do it during application startup.

Tasks that aren't so much like fixtures can be added at the appropriate place and time in your application code.

Time zones
----------

The other problem area I ran into was with time zones `(my nemesis) <https://www.caktusgroup.com/blog/2019/03/21/coding-time-zones-and-daylight-saving-time/>`_.
django-celery-beat has to be set up with the same time zone settings as Django.  I assumed, since it has "django" in its name,
that it would just follow the Django settings, but instead it follows the Celery settings.

In my case, my Django application was using local time while django-celery-beat was using UTC. As a result, django-celery-beat seemed to always think my every 30 seconds task didn't need to run for another 5 hours plus 30 seconds, or something like that.

The simplest solution in my case was to make sure my Django settings
looked like this::

    USE_TZ = True
    TIME_ZONE = "UTC"

django-celery-beat defaults to UTC, so it and Django started getting along after that.

If I had really needed Django's TIME_ZONE to be something other than UTC, I think I could have gotten things to work by setting CELERY_TIMEZONE to the same value. But I haven't tried that.

Without time zones
------------------

If you're working on an old project that has never enabled Django's time zone support, you'll want something like this in your Django settings::

USE_TZ = False
# Configure Celery to match, or things will get confused.
CELERY_ENABLE_UTC = False
# Undocumented but necessary setting for django-celery-beat:
DJANGO_CELERY_BEAT_TZ_AWARE = False
# Just in case anything looks at these anyway (probably not necessary):
TIME_ZONE = "UTC"
CELERY_TIMEZONE = "UTC"

As noted in the comment, DJANGO_CELERY_BEAT_TZ_AWARE is not documented, but I found it in the source when trying to figure out why django-celery-beat was trying to store timezone-aware datetimes in the database, triggering Django exceptions.  Explicitly setting it False makes django-celery-beat use naive datetimes.

Django admin
------------

Another helpful feature of django-celery-beat is that its models will show up automatically in the Django admin, no extra configuration needed. Then you can easily view or edit the schedule there.

Summary
-------

django-celery-beat is a very helpful aid to larger deployments, where storing Celery's schedule data in a local file isn't appropriate anymore. With these tips, I hope you'll find it helpful too.


