Timezones in Python
===================

Key points
-----------

* Install the pytz package to provide actual time zones. Python doesn't come with them.

* There are two kinds of datetime objects in Python, and you need to always know which you're working with:

  * naive - has no timezone info.  (datetime.tzinfo is None)
  * aware - has timezone info (datetime.tzinfo is not None)

* There will always be some things you want to do with datetimes that are just inherently ambiguous. Get used to it.

Some use cases
--------------

Start by importing useful modules::

    import datetime, time, pytz

Given a formatted time string with timezone, end up with a datetime object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose we have RFC 2822 format::

    s = "Tue, 3 July 2012 14:11:03 -0400"

It would be nice if strptime could just parse this and give you an aware datetime
object, but no such luck::

    >>> fmt = "%a, %d %B %Y %H:%M:%S %Z"
    >>> datetime.datetime.strptime(s, fmt)
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
      File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/_strptime.py", line 325, in _strptime
        (data_string, format))
    ValueError: time data 'Tue, 3 July 2012 14:11:03 -0400' does not match format '%a, %d %B %Y %H:%M:%S %Z'
    >>> fmt = "%a, %d %B %Y %H:%M:%S %z"
    >>> datetime.datetime.strptime(s, fmt)
    Traceback (most recent call last):
      File "<console>", line 1, in <module>
      File "/System/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6/_strptime.py", line 317, in _strptime
        (bad_directive, format))
    ValueError: 'z' is a bad directive in format '%a, %d %B %Y %H:%M:%S %z'

So, we have to parse it without the time zone::

    >>> fmt = "%a, %d %B %Y %H:%M:%S"
    >>> dt = datetime.datetime.strptime(s[:-6], fmt)
    >>> dt
    datetime.datetime(2012, 7, 3, 14, 11, 3)

That is assuming we know exactly how long the timezone string was, but we might not. Try again::

    >>> last_space = s.rindex(' ')
    >>> last_space
    25
    >>> datetime.datetime.strptime(s[:last_space], fmt)

Now, we need to figure out what that timezone string means.  Pick it out::

    >>> tzs = s[last_space+1:]
    >>> tzs
    '-0400'

We could have a timezone name or offset, but let's assume the offset for now.
RFC 2282 says this is in the format [+-]HHMM::

    >>> sign = 1
    >>> if tzs.startswith("-"):
    ...     sign = -1
    ...     tzs = tzs[1:]
    ... elif tzs.startswith("+"):
    ...     tzs = tzs[1:]
    ...
    >>> tzs
    '0400'
    >>> sign
    -1

Now compute the offset::

    >>> minutes = int(tzs[0:2])*60 + int(tzs[2:4])
    >>> minutes *= sign
    >>> minutes
    -240

Unfortunately, we can't just plug that offset into our datetime. To
create an aware object, Python wants a tzinfo object that has more
information about the timezone than just the offset from UTC at this
particular moment.

So here's one of the problems - we don't KNOW what timezone this
date/time is from, we only know the current offset from UTC.

So, the best we can do is to figure out the corresponding time in
UTC, then create an aware object in UTC. We know this time is 240 minutes
less than the corresponding UTC time, so::

    >>> import time
    >>> time_seconds = time.mktime(dt.timetuple())
    >>> time_seconds -= 60*minutes
    >>> utc_time = datetime.datetime.fromtimestamp(time_seconds, pytz.utc)
    >>> utc_time
    datetime.datetime(2012, 7, 3, 22, 11, 3, tzinfo=<UTC>)

And there we have it, an aware datetime object for that moment in time.
