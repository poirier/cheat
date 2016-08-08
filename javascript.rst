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

ES2015 literals, append, extend (`Spread operator <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator>`_
)::

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

This will include enumerable properties of prototype classes (traditional)
(`for...in <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...in>`_)::

    for (var key in object) {
       value = object[key]
       # ... do stuff ...
    }

.. note::

    For objects that you're just using as dictionaries, `for...in` is perfectly
    good. Just be careful not to use it on instances of anything more
    complicated.

For more complicated objects, here's how you get just properties
that are directly on the object (not inherited from a prototype).
Traditional::

    for (var key in object) {
        if (object.hasOwnProperty(key)) {
            value = object[key]
            # ... do stuff ...
        }
    }

Just properties directly on the object, with ES2015+
(`keys <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/keys>`_)::

    var keys = object.keys();
    for (var i = 0; i < keys.length; i++) {
        value = object[keys[i]];
        # ... do stuff ...
    }

Is a key in a dictionary?
-------------------------

    dict.hasOwnProperty(key)

Remove key from dictionary
--------------------------

    delete dict["key"]
    delete dict.key

String operations
-----------------

`String <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String>`_,
`endsWith <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith>`_,
`indexOf <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/indexOf>`_,
`join <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/join>`_,
`replace <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace>`_,
`split <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/split>`_,
`startsWith <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith>`_,
`substr <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substr>`_,
`substring <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substring>`_
::

    arr = str.split(sep=(str|regex)[, limit])
    str = arr.join(sep)
    index = str.indexOf(substr[, startIndex])  # returns -1 if not found
    sub = str.substr(firstIndex[, length])  # firstIndex can be negative to count back from end
    sub = str.substring(firstIndex[, lastIndex+1])
    str2 = str.replace(regexp|substr, newSubStr|function)
    bool = str.endsWith(str2)
    bool = str.startsWith(str2)

Contains:  haystack.indexOf(needle) != -1

Timer
-----

`setTimeout <https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout>`_::

    window.setTimeout(func, delay, param1, param2, ...);

All but func is optional. `delay` defaults to 0.

    timerId = window.setTimeout(func, [delay, param1, param2, ...]);
    window.clearTimeout(timerId);

Meta
----

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
