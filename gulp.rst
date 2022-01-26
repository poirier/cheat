Gulp Tasks
==========
.. contents::

Because gulp tasks are actually from another package,
`orchestrator <https://github.com/robrich/orchestrator>`_,
the gulp people don't feel the need to document how gulp tasks
work very much. So...

Asynchronous
------------

Gulp tasks are asynchronous. Here are some patterns to use.

Just exit
.........

*THIS IS ALMOST ALWAYS WRONG*

Gulp calls the task function, which returns when it's done.

Even if everything your task is doing is synchronous, this is
*still wrong* because Gulp is allowed to kick it off in the
background and then immediately assume it's done and start
running other tasks that depend on it, which might or might
not work. A real bear to debug. But here's how it looks::

    # DO NOT DO THIS:
    gulp.task('sync_task', function() {
       stuff that runs immediately;
    })

Callback
........

Gulp passes a callback. The tasks calls it when done::

    gulp.task('foo', function(cb) {
        stuff...;
        cb();
    })

Return a promise or an event stream
...................................

Gulp pipes, and lots of gulp plugins, return a promise or even stream. We can just return the
thing they gave us, and gulp will use that to tell when the work is done::

    gulp.task('make_promise', function() {
        return some_gulp_plugin.pipe(stuff).pipe(more_stuff);
    })

Watching
--------

Call a task whenever any of a group of files changes::

    gulp.watch('filepattern', ['task1', 'task2'])

After calling this, anytime a file that existed when this was called
and matched the filepattern changes, task1 and task2 will be called.

This *will result* in the gulp command not exiting, because it's hanging
around to watch for changes!

(But the watch() function itself does return, no worries there.)

TBD: What does gulp.watch return? Anything?
