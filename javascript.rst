Javascript
==========

Iterate over a "dictionary" (JS object)
---------------------------------------

    for (var key in object) {
       value = object[key]
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

`MDN <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String>`_

Split: str.split(sep)

Contains:  haystack.indexOf(needle) != -1

Timer
-----

    window.setTimeout(func, delay, param1, param2, ...);

All but func is optional. `delay` defaults to 0.

`MDN <https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout>`_

