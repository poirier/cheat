Async Python
============
.. contents::

It took me a while to understand JavaScript's approach to asynchronous execution.
At some point, though, it started to make sense, and I was able to do what I
wanted to do with it.

I'm still trying to understand Python's approach, and it still makes very
little sense to me. Hopefully by the time I finish writing this, that will
have changed. At least it should help.

(Written Sept. 2020, Python 3.7-3.8, hopefully things won't be changing much after this.
But I tried this once with Python 3.5, and things did change quite a bit
after that, so we'll see.)

Event loops and threads
-----------------------

The differences from JavaScript start showing up almost immediately.

One big one is that while JavaScript's scheduling of asynchronous tasks
is built into the language and happens almost invisibly and automatically,
Python has no built-in support and the program is responsible for
running something to schedule the tasks.

Python calls the thing that schedules the tasks an
`event loop <https://docs.python.org/3/library/asyncio-eventloop.html>`_, which I
find confusing. (Just the first of many things I think badly named in
this part of Python.) I'd have called the scheduling mechanism a *scheduler*.

For now, assume that has been set up for you.  Given that, you can use methods like
`asyncio.create_task() <https://docs.python.org/3/library/asyncio-task.html#asyncio.create_task>`_
to schedule things without ever having to deal directly with the event loop.
``asyncio.create_task()`` doesn't just *create* a task, it also *schedules* it.
We'll see shortly other methods that prepare tasks but don't schedule them.

If needed, you can get a reference to the event loop (scheduler)
`easily <https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.get_running_loop>`_::

    import asyncio

    loop = asyncio.get_running_loop()

A second big difference is that JavaScript only has one thread, while
Python can be multithreaded.  But you might not need multiple threads,
so I'll postpone that until later.

Coroutines functions and objects
--------------------------------

A `coroutine function <https://docs.python.org/3/library/asyncio-task.html#coroutines>`_:

* is a function
* declared with ``async def``
* allowed to use ``await``
* when called, does not execute; instead, returns a *coroutine object*
* A *coroutine object* can be scheduled for execution by passing to ``asyncio.create_task()``
* or by using ``await`` on it, which blocks and returns the return value.

::

    async def a_coroutine(*args, **kwargs):
        print("This won't run when the coroutine is called")
        print("but later, when the return value from the call is scheduled somehow.")
        return 3

    coroutine_object = a_coroutine(1, 2, foo="bar")
    # no output yet
    result = await coroutine_object
    # the print statements in the coroutine function have now run

That's a lousy example though, because all it really does is rearrange the
order of execution you might naively expect.

WRITE MORE HERE

Awaitables
----------

Anything you can use with ``await`` is called an
`awaitable <https://docs.python.org/3/library/asyncio-task.html#awaitables>`_.
Many APIs accept awaitables.

Where do we get awaitables?

* Coroutine objects are awaitables. They come from calling a coroutine function.
* Tasks are awaitables. They come from wrapping coroutine objects using some functions.
* Futures are awaitables. They're returned by some low-level APIs.

Waiting for multiple things
---------------------------

WRITE THIS

Doing things asynchronously but in order
----------------------------------------

Suppose I have:

* a coroutine to turn on my tv
* a coroutine to set the channel on my tv

and I'm in an event handler that should not block, but can add tasks to the event
loop.

If we add both coroutines, they could run in the wrong order, or even roughly simultaneously.

So we write another coroutine::

    async def do_both():
        await turn_on_tv()
        await set_tv_channel()

and submit that, and we're good.

That looks like this::

    asyncio.create_task(do_both())

Note as always that we first have to call the coroutine, then we can use the return value,
the coroutine object, to schedule it to run.

Partials
--------

(mentioned `here <https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.call_soon>`_)

Note Most asyncio scheduling functions don’t allow passing keyword arguments. To do that, use functools.partial():
::

    # will schedule "print("Hello", flush=True)"
    loop.call_soon(
        functools.partial(print, "Hello", flush=True))

Using partial objects is usually more convenient than using lambdas, as asyncio can render partial objects better in debug and error messages.

How I might have designed this interface
----------------------------------------

I think I'd have focused more on the scheduler and do things with it, and not had
special magical methods that don't run when you call them.

E.g., where in Python today you would write::

    import asyncio

    async def run_this_later(*args, **kwargs):
        # do stuff

    asyncio.create_task(run_this_later(*args, **kwargs))

or::

    await func1(*args, **kwargs)
    await func2(...)

I might have written::

    from dans_coroutines import scheduler

    def run_this_later(*args, **kwargs):
        # do stuff

    scheduler.queue_to_run(run_this_later, *args, **kwargs)

or::

    scheduler.run_until_finished(func1, *args, **kwargs)
    scheduler.run_until_finished(func2, ...)

It is at calls to scheduler that we might pause execution of the current coroutine
and let another one run for a while.

Schedule normal code to run later
---------------------------------

IS THIS NEEDED ANYMORE?

One thing I did surprisingly frequently in JavaScript was to arrange
for a bit of code to run later, so it didn't hold up what I was doing
at the moment.

The Python async event loop lets you do that using
`loop.call_soon <https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.call_soon>`_::

    import asyncio

    def thing_to_do_later(1, 2):
        doing this...

    asyncio.get_running_loop().call_soon(thing_to_do_later, 1, 2)

To call with with kwargs, you have to use partial as mentioned above::

    from functools import partial

    loop.call_soon(partial(thing_to_do_later, 1, 2, foo="Bar", thing=27))


Multiple threads
----------------

Some things to keep in mind:

* A Python thread can have at most one active event loop.
* Multiple threads can each have their own event loop.
* ``asyncio.get_running_loop()`` returns the loop of *the current thread*.
* It is not safe to access a loop belonging to another thread than the
  current thread, with a few exceptions.

None of this will be a problem until your program becomes multi-threaded,
of course, and with all this async stuff, you may never need multiple
threads.
