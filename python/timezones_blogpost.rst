Time zones and Daylight Saving Time - Oh, the Horror
====================================================

Or, why I hate Daylight Saving Time (DST).

Time zones
-----------

Let's start with some problems with time zones, because they're bad
enough even before we consider DST, but they'll help us ease into it.

Historical Time Zones
......................

Time zones are a human invention, and humans tend to change their
minds, so time zones can change over time.

For example, look at the Pacific/Apia time zone, which is the time
zone of the independent country of Samoa. It's +13 hours from
UTC, but it used to be -11 hours from UTC, up through
December 29, 2011. From December 31, 2011 on, Pacific/Apia became
+13 hours from UTC.

What happened to December 30, 2011? It never
happened in Samoa, because Dec. 29, 23:59:59-11:00 is followed
immediately by Dec. 31, 0:00:00+13:00.

========== ======== ====== ==========  ======== ====
Date       Time     Zone   Date        Time     Zone
========== ======== ====== ==========  ======== ====
2011-12-29 23:59:59 UTC-11 2011-12-30  10:59:59 UTC
2018-12-31 00:00:00 UTC+13 2011-12-30  11:00:00 UTC
========== ======== ====== ==========  ======== ====


That's an extreme example, but time zones change more often than
we might think, often due to changes in government or boundaries.

The bottom line here is that even knowing the time *and* time zone, it's
meaningless unless you also know the date.

Always convert to UTC?
.......................

As programmers, we're encouraged to avoid issues with time zones by
"converting" times to UTC (Coordinated
Universal Time) as early as possible, and convert to the local time
zone only when necessary to display times to humans. But over time,
I've realized there's a problem with that.

If all you care about is the exact moment in the lifetime of the
universe when an event happened (or is going to happen), then that
advice is fine.

But for humans, the time zone they expressed a time in can be important too.

For example, suppose I'm sitting here in North Carolina, in the
Eastern time zone, but planning an event in Memphis for some
reason. Memphis is in the Central time zone. I go to my calendar
program and carefully enter the date and "3:00 pm CST". Whoever wrote
the calendar program follows the usual advice and converts that to UTC
by adding 6 hours, so they store the time as 9:00 PM UTC, or 21:00
UTC.  If they were using Django, there's not even any extra code
needed, because Django does that automatically.

The next day I look at my calendar to continue working on my
event. The programmer converts the event time to my local time zone,
or Eastern time, so the calendar shows the event happening at "4:00
pm". Which is not useful for me, the user. I'm trying to
plan something around other events in the location where the event is
happening, which is using CST, and my local time zone is irrelevant.

The bottom line is that following the advice to always convert
times to UTC loses information.
We'd sometimes be better off storing times with their non-UTC time zones.

Which is why it's kind of annoying that Django always
"converts" local times to UTC before saving
to the database, or even before returning them from a form.
That means the original timezone is lost unless you go to the
trouble of saving it separately and then converting the time from the
database back to that time zone after you get it from the
database. I've `written about this before
<https://www.caktusgroup.com/blog/2014/01/09/managing-events-explicit-time-zones/>`_.

By the way, I've been putting "convert" in scare quotes because talking
about converting times from one time zone to another carries
an implicit assumption that such converting is simple and loses
no information, but as we see, that's not really true.

Daylight Saving Time
----------------------

That brings us to Daylight Saving Time (DST), which is even more
a human invention than time zones.

Time zones are a fairly obvious adaptation to the conflict between how
our bodies prefer to be active during the hours when the sun is up,
and how we communicate time with people in other parts of the world.
Historical changes in time zones across the years are annoying, but as
time zones are a human invention it's not surprising that we'd tweak
them every now and then.

DST, on the other hand, amounts to changing entire time zones twice
every year. What does US/Eastern time zone mean? I don't know,
unless you tell me the date. From Jan 1, 2018 to March 10, 2018, it
meant UTC-5. From March 11, 2018 to November 3, 2018, it meant UTC-4.
And from November 4, 2018 to December 31, 2018 it's UTC-5 again.

But it gets worse. From
`Wikipedia <https://en.wikipedia.org/wiki/Eastern_Time_Zone>`_:

    The Uniform Time Act of 1966 ruled that daylight saving time
    would run from the last Sunday of April until the last Sunday
    in October in the United States. The act was amended to make
    the first Sunday in April the beginning of daylight saving
    time as of 1987. The Energy Policy Act of 2005 extended
    daylight saving time in the United States beginning in 2007.
    So local times change at 2:00 a.m. EST to 3:00 a.m. EDT on
    the second Sunday in March and return at 2:00 a.m. EDT to
    1:00 a.m. EST on the first Sunday in November.

So in a little over 50 years, the rules changed 3 times.

But at least the US gave a couple years of notice.
In October 2013, with just a few *days* notice, the
government of Libya decided to cancel the scheduled switch from
daylight saving time back to what had been their standard time.
While I applaud their apparent
decision that daylight saving time was an unnecessary complication to
timekeeping, they should have given the world adequate notice first.

Even if you have complete and accurate information about the rules,
daylight saving time complicates things in surprising ways. For
example, you can't convert 2:30 am March 11, 2018 in US/Eastern
time zone to UTC, because that time never happened — our clocks had to
jump directly from 1:59:00 am to 3:00:00 am:

========== ======= ==== ==========  ======= ====
Date       Time    Zone Date        Time    Zone
========== ======= ==== ==========  ======= ====
2018-03-11 1:59:59 EST  2018-03-11  6:59:59 UTC
2018-03-11 3:00:00 EDT  2018-03-11  7:00:00 UTC
========== ======= ==== ==========  ======= ====

You can't convert 1:30 am November 4, 2018 in US/Eastern time
zone to UTC either, because that time happened *twice*. You would have
to specify whether it was 1:30 am November 4, 2018 EDT or 1:30 am
November 4, 2018 EST:

========== ======= ==== ==========  ======= ====
Date       Time    Zone Date        Time    Zone
========== ======= ==== ==========  ======= ====
2018-11-04 1:00:00 EDT  2018-11-04  5:00:00 UTC
2018-11-04 1:30:00 EDT  2018-11-04  5:30:00 UTC
2018-11-04 1:59:59 EDT  2018-11-04  5:59:59 UTC
2018-11-04 1:00:00 EST  2018-11-04  6:00:00 UTC
2018-11-04 1:30:00 EST  2018-11-04  6:30:00 UTC
2018-11-04 1:59:59 EST  2018-11-04  6:59:59 UTC
========== ======= ==== ==========  ======= ====

Practical advice
----------------

Here are some rules I try to follow.

When working in Python, *never* use naive datetimes. (Those are
datetime objects without timezone information, which unfortunately are
the default in Python, even in Python 3.)

Use the `pytz library <http://pytz.sourceforge.net/>`_ when
constructing datetimes, and *review the documentation
frequently*. Properly managing datetimes is not always intuitive, and
using pytz doesn't prevent me from using it wrong and
doing things that will give wrong results *only sometimes*, making it
really hard to spot. I have to triple-check that I'm following the
docs when I write the code and not rely on testing to find problems.

Let me strengthen that even further. *It is* **not possible** *to
correctly construct datetimes with timezone information using
only Python's own libraries when dealing with timezones that
use DST*. I *must* use pytz or something equivalent.

If I'm tempted to use ``datetime.replace``, I need to stop, think
hard, and find another way to do it. ``datetime.replace`` is almost
always the wrong approach, because changing one part of a datetime without
consideration of the other parts is almost guaranteed to not do what I expect
for some datetimes.

When using Django, be sure `USE_TZ = True
<https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-USE_TZ>`_.

If Django emits warnings about naive datetimes being saved in the
database, treat them as if they were fatal errors, track them down,
and fix them.  If I want to, I can even turn them into actual fatal
errors; see `this Django documentation
<https://docs.djangoproject.com/en/stable/topics/i18n/timezones/#code>`_.

When processing user input, consider whether a datetime's original
timezone needs to be preserved, or it's okay to just store the
datetime as UTC. If the original timezone is important, `I've written
before about how to get and store it
<https://www.caktusgroup.com/blog/2014/01/09/managing-events-explicit-time-zones/>`_.

Conclusion
----------

Working with human times correctly is complicated, unintuitive,
and needs a *lot* of careful attention to detail to get right.
