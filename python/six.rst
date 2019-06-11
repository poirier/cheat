Six
===

Writing Python code that works the same in Python 2 & 3, using six as necessary.

+-------------------------------+-----------------------------------+---------------------------------------------+
| Python 2                      | Python 3                          | Both                                        |
+-------------------------------+-----------------------------------+---------------------------------------------+
| from urlparse import urlparse | from urllib.parse import urlparse | from six.moves.urllib.parse import urlparse |
+-------------------------------+-----------------------------------+---------------------------------------------+
| dict.iteritems()              | dict.items()                      | six.iteritems(dict)                         |
+-------------------------------+-----------------------------------+---------------------------------------------+
| dict.iterkeys()               | dict.keys()                       | six.iterkeys(dict)                          |
+-------------------------------+-----------------------------------+---------------------------------------------+
| dict.keys()                   | list(dict.keys())                 | list(dict.keys())                           |
+-------------------------------+-----------------------------------+---------------------------------------------+
| Exception.message             | Exception.args[0]                 | Exception.args[0]                           |
+-------------------------------+-----------------------------------+---------------------------------------------+
| isinstance(x, str)            | isinstance(x, bytes)              | isinstance(x, six.binary_type)              |
+-------------------------------+-----------------------------------+---------------------------------------------+
| filter(condition, iterable)   | [x for x in iterable              | [x for x in iterable                        |
|                               |  if condition(x)]                 |  if condition(x)]                           |
+-------------------------------+-----------------------------------+---------------------------------------------+
| map(function, iterable)       | [function(x)                      | [function(x)                                |
|                               |  for x in iterable]               |  for x in iterable]                         |
+-------------------------------+-----------------------------------+---------------------------------------------+
| reduce()                      | from functools import reduce      | from functools import reduce                |
+-------------------------------+-----------------------------------+---------------------------------------------+
| self.assertItemsEqual(        | self.assertCountEqual(            | six.assertCountEqual(                       |
|    random_order(items),       |   random_order(items),            |    self,                                    |
|    random_order(more_items))  |   random_order(more_items))       |    random_order(items),                     |
|                               |                                   |    random_order(other_items)                |
+-------------------------------+-----------------------------------+---------------------------------------------+
| string.lowercase              | string.ascii_lowercase            | string.ascii_lowercase                      |
+-------------------------------+-----------------------------------+---------------------------------------------+
| class Foo(BaseClass):         | class Foo(BaseClass,              | @six.add_metaclass(MetaClass)               |
|    __metaclass__ = MetaClass  |           metaclass=MetaClass):   | class Foo(BaseClass)                        |
+-------------------------------+-----------------------------------+---------------------------------------------+
| str                           | bytes                             | six.binary_type                             |
+-------------------------------+-----------------------------------+---------------------------------------------+
| unicode                       | str                               | six.text_type                               |
+-------------------------------+-----------------------------------+---------------------------------------------+
| [int, long]                   | [int]                             | six.integer_types                           |
+-------------------------------+-----------------------------------+---------------------------------------------+
| iterator.next()               | next(iterator)                    | six.next(iterator)                          |
+-------------------------------+-----------------------------------+---------------------------------------------+
| zip(a, b).__iter__()          | zip(a, b)                         | ???????????                                 |
+-------------------------------+-----------------------------------+---------------------------------------------+
| zip(a, b)                     | list(zip(a, b))                   | list(zip(a, b))                             |
+-------------------------------+-----------------------------------+---------------------------------------------+
| from urllib import quote      | from urllib.parse import quote    | from six.moves.urllib.parse import quote    |
+-------------------------------+-----------------------------------+---------------------------------------------+
| xmlrpclib                     | xmlrpc.client                     | six.moves.xmlrpc_client                     |
+-------------------------------+-----------------------------------+---------------------------------------------+
| from StringIO import StringIO | from io import BytesIO            | from six import BytesIO                     |
+-------------------------------+-----------------------------------+---------------------------------------------+
| from StringIO import StringIO | from io import StringIO           | from six import StringIO                    |
+-------------------------------+-----------------------------------+---------------------------------------------+

six.moves.range

range	xrange()	range


``six.reraise(exc_type, exc_value, exc_traceback=None)``
Reraise an exception, possibly with a different traceback. In the simple case,
``reraise(*sys.exc_info())``
with an active exception (in an except block) reraises the current exception with the last traceback.
A different traceback can be specified with the exc_traceback parameter. Note that since the exception
reraising is done within the ``reraise()`` function, Python will attach the call frame of reraise() to whatever
traceback is raised.

2to3 does raise E, V, T to raise E(V).with_traceback(T)
