Javascript Syntax
=================



Spread Operator
---------------

`Spread operator <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator>`_

Given function and args::

    function myFunction(x, y, z) { }
    var args = [0, 1, 2];

Traditional::

    myFunction.apply(null, args);

ES2015::

    myFunction(...args);
    myFunction(1, ...[2, 3]);

.. caution::

    The ES2016 `...` operator is NOT the same as `*` in a
    Python function call. `...` basically splices the array it's applied
    to into the list at the place where it's used. It can be
    used repeatedly, and in any combination with other unnamed arguments.
    Python's `*` can only be used to extend the list of unnamed arguments
    at the end.
