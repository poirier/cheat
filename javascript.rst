Javascript
==========

Arrays
------

Traditional literals, append, extend::

    >> a = [1, 2, 3]                        # literal
    >> console.log(a)
    [1, 2, 3]
    >> b = [4, 5]
    >> Array.prototype.push.apply(a, b);    # 'extend'
    >> console.log(a)
    [1, 2, 3, 4, 5]
    >> a.push(6)                            # 'append'
    >> console.log(a)
    [1, 2, 3, 4, 5, 6]

 ES2015 literals, append, extend::

    >> a = [1, 2, 3]
    >> b = [0, ...a]                        # literal incorporating another array
    >> console.log(b)
    [0, 1, 2, 3]
    >> a.push(4)                            # append
    >> console.log(a)
    [1, 2, 3, 4]
    >> console.log(b)
    [0, 1, 2, 3]
    >> a.push(...b)                        # extend
    >> console.log(a)
    [1, 2, 3, 4, 0, 1, 2, 3]

Iterate over an array
---------------------

Run code for each element (ES5+)
(`forEach <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach>`_)::

    arr.forEach(function(value, index, arr){}[, thisArg])

See if none, some, or all elements pass a test (ES5+)
(`every <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every>`_,
`some <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some>`_)::

    all_passed = arr.every(function(value, index, arr){ return bool;}[, thisArg])
    some_passed = arr.some(function(value, index, arr){ return bool;}[, thisArg])
    none_passed = !arr.some(...)

Create a new array by applying a function to each element of an existing array (ES5+)
(`map <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map>`_)::

    arr2 = arr1.map(function(value, index, arr){}[, thisArg])

Create a new array only including elements that pass a test (ES5+
(`MDN <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter>`_)::

    arr2 = arr1.filter(function(value, index, arr){}[, thisArg])

Iterate over a "dictionary" (JS object)
---------------------------------------

This will include properties of prototype classes (traditional)
(`for...in <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...in>`_)::

    for (var key in object) {
       value = object[key]
       # ... do stuff ...
    }

This is just properties directly on the object (ES2015+)
(`keys <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/keys>`_)::

    var keys = object.keys();
    for (var i = 0; i < keys.length; i++) {
        value = object[keys[i]];
        # ... do stuff ...
    }

String operations
-----------------

`MDN <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String>`_::

    arr = str.split(sep=(str|regex)[, limit])
    str = arr.join(sep)

Timer
-----

`MDN <https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout>`_::

    window.setTimeout(func, [delay, param1, param2, ...]);

Meta
----

`MDN <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator>`_

Given function and args::

    function myFunction(x, y, z) { }
    var args = [0, 1, 2];

Traditional::

    myFunction.apply(null, args);

ES2015::

    myFunction(...args);
    myFunction(1, ...[2, 3]);

..note::

    The ES2016 `...` operator is NOT the same as `*` in a
    Python function call. `...` basically splices the array it's applied
    to into the list at the place where it's used. It can be
    used repeatedly, and in any combination with other unnamed arguments.
    Python's `*` can only be used to extend the list of unnamed arguments
    at the end.
