Promises
========

`MDN docs <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise>`_

quoting from there:

    A Promise is in one of these states:

    * pending: initial state, not fulfilled or rejected.
    * fulfilled: meaning that the operation completed successfully.
    * rejected: meaning that the operation failed.

A promise that is not pending is "settled".

You can create a Promise with new, passing it an executor function::

    let p = new Promise((resolve, reject) => {
         if (things go well) {
           resolve(resulting_value)
         } else {
            reject(error)
         }
    })

At any time after the promise is created, you can call ``then`` on it
and pass in a success handler, a failure handler, or both:

    p.then(on_success)
    p.then(undefined, on_failure)
    p.then(on_success, on_failure)

If the promise is still pending, the appropriate handler will be called
once it is settled. If it's settled already, the handler will be calleed
immediately (or ASAP, anyway).

The ``on_success`` handler is called with the resolved value from the promise,
while the ``on_failure`` handler is called with the error value from the promise.

``then()`` returns a *new* promise, so you can chain calls::

   p.then(on_success).then(another_on_success).then(a_third_on_success)

If the on_success handler returns a new promise, *that* promise will be
the return value from ``then()`` (or an equivalent promise, anyway).

The handlers will be called in order. If one fails, then the promise
returned by that then() call will be rejected.   "Fail" can mean raises
an exception.

Many async functions nowadays return promises.

Pausing
-------

Here's a way of doing something after a delay::

    let p = new Promise((resolve) => {
        setTimeout(resolve, 100)
    }).then(()=>{
        do stuff
    })

Some notes I made a while ago
-----------------------------

Here are some examples::

    // Return a new promise.
    return new Promise(function(resolve, reject) {
       // do stuff.  if it works:
       resolve(result);
       // but if it fails:
       reject(Error(error text));
    });

    // USE a promise
    promise.then(function(result) {
       // use result here
    }, function(error) {
       // do something with error here
    });

    // CHAINING
    // Note that 'then' returns a new promise

    promise.then(function(val1) {
       return val1 + 2;
    }).then(function(val2) {
       val2 is here val1 + 2!!!
    });

    // MORE CHAINING
    promise.then(function(result){
      // do something, then return a new promise
      return promise2;
    }).then(function(result2) {
      // this isn't invoked until promise2 resolves, and it gets promise2's result.
      ...
    }
