DOM operations with JavaScript
==============================

Finding elements by selector
----------------------------

https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll

.. code-block:: javascript

    items = document.querySelectorAll('a.class-name')

Returns a `NodeList <https://developer.mozilla.org/en-US/docs/Web/API/NodeList>`_.

https://developer.mozilla.org/en-US/docs/Web/API/Document/getElementById

.. code-block:: javascript

    element = document.getElementById('the-id')

Returns a `Element <https://developer.mozilla.org/en-US/docs/Web/API/Element>`_.

Iterating over elements
-----------------------

https://developer.mozilla.org/en-US/docs/Web/API/NodeList

.. note::

    Although NodeList is not an Array, it is possible to iterate on it using
    `forEach() <https://developer.mozilla.org/en-US/docs/Web/API/NodeList/forEach>`_.
    Several older browsers have not implemented this method yet.

.. code-block:: javascript

    // Newer browsers
    items.forEach(function(item){ do something with item })

    // Old (how old?) browsers
    Array.prototype.forEach.call(items, function(item) { do something with item })

Here's a polyfill for ES5+ browsers from that NodeList.forEach page linked above:

.. code-block:: javascript

    if (window.NodeList && !NodeList.prototype.forEach) {
        NodeList.prototype.forEach = function (callback, thisArg) {
            thisArg = thisArg || window;
            for (var i = 0; i < this.length; i++) {
                callback.call(thisArg, this[i], i, this);
            }
        };
    }
