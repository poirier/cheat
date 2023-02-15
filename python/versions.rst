Python Versions
===============
.. contents::

Important (to me) changes by version:

3.11
----

* SPEED!
* tomllib (read-only)
* PEP 657: Fine-grained error locations in tracebacks
* PEP 594: Many legacy standard library modules have been deprecated and will be removed in Python 3.13

3.10
----

* ``match`` pattern matching (which I have not yet looked at)
* parenthesized context managers (for formatting ease, no semantic difference)
* Deprecate distutils module.

3.9
---

* dict union operator
* string methods to remove prefixes and suffixes.
* ``zoneinfo`` module

3.8
---

* `walrus operator <https://docs.python.org/3/whatsnew/3.8.html#assignment-expressions>`_ (":=")
* `f-strings add "=" support <https://docs.python.org/3/whatsnew/3.8.html#f-strings-support-for-self-documenting-expressions-and-debugging>`_
* `Positional-only parameters <http://localdocs.localhost/python-3.11.0-docs-html/whatsnew/3.8.html#positional-only-parameters>`_: "new function parameter syntax / to indicate that some function parameters must be specified positionally and cannot be used as keyword arguments. " - ``def f(a, b, /, c, d, *, e, f):`` means that ``a`` and ``b`` can **only** be passed by position and not by keyword.
* `asyncio.run <https://docs.python.org/3/whatsnew/3.8.html#asyncio>`_

3.7
---

* `context vars <https://docs.python.org/3/whatsnew/3.7.html#contextvars>`_ Context variables are conceptually similar to thread-local variables. Unlike TLS, context variables support asynchronous code correctly.
* `Data classes <https://docs.python.org/3.7/library/dataclasses.html#module-dataclasses>`_

3.6
---

* ``asyncio`` module is no longer provisional
* `f-strings <https://docs.python.org/3/whatsnew/3.6.html#pep-498-formatted-string-literals>`_
* `underscores in numeric literals <https://docs.python.org/3/whatsnew/3.6.html#pep-515-underscores-in-numeric-literals>`_
* `secrets module <https://docs.python.org/3/whatsnew/3.6.html#secrets>`_ provide an obvious way to reliably generate cryptographically strong pseudo-random values suitable for managing secrets, such as account authentication, tokens, and similar.

3.5
---

* `can use multiple "*" and "**" unpacking operators <https://docs.python.org/3/whatsnew/3.5.html#pep-448-additional-unpacking-generalizations>`_
* new ``typing`` module
* new `os.scandir() <https://docs.python.org/3/library/os.html#os.scandir>`_ function
* new `subprocess.run() <https://docs.python.org/3/library/subprocess.html#subprocess.run>`_ function

3.4
---

* new `enum module <https://docs.python.org/3/library/enum.html#module-enum>`_
* new `pathlib module <https://docs.python.org/3/library/pathlib.html#module-pathlib>`_ (provisional)
* new `ensurepip  module <https://docs.python.org/3/whatsnew/3.4.html#pep-453-explicit-bootstrapping-of-pip-in-python-installations>`_
* provisional asyncio module

3.3
---

* `yield from expression <https://docs.python.org/3/whatsnew/3.3.html#pep-380-syntax-for-delegating-to-a-subgenerator>`_
* The u'unicode' syntax is accepted again for str objects.
* new `unittest.mock module <https://docs.python.org/3/library/unittest.mock.html#module-unittest.mock>`_
* new `venv module <https://docs.python.org/3/library/venv.html#module-venv>`_ and pyvenv script
* `implicit namespace packages <https://docs.python.org/3/whatsnew/3.3.html#pep-420-implicit-namespace-packages>`_

3.2
---

* new `argparse <https://docs.python.org/3/library/argparse.html#module-argparse>`_ module
* `logging.config.dictConfig() <https://docs.python.org/3/library/logging.config.html#logging.config.dictConfig>`_
* major redesign of `how bytecode is cached in files <https://docs.python.org/3/whatsnew/3.2.html#pep-3147-pyc-repository-directories>`_
* `PYTHONWARNINGS <https://docs.python.org/3/using/cmdline.html#envvar-PYTHONWARNINGS>` env var
* `functools.lru_cache() <https://docs.python.org/3/library/functools.html#functools.lru_cache>`_
