How Mock Can Improve Your Unit Tests
====================================

Mocking is a little tricky to learn to use, but it's really handy to have in
your testing toolbox.

The purpose of mocking is to focus each unit test by faking execution of all code other than the
small piece that unit test is trying to verify.

Let's start with a small example. Suppose you have a utility function that calls
an API with some parameters, does a little manipulation of the return value,
and returns part of it. You don't want to call the API every time you run the
test of this function — it might be expensive to run, or slow, or difficult
to set up.

Instead, you mock the call to the API, and make it look to the
function being tested as if the API had returned whatever value you want.
You can verify both that the function returns the value it should, and that the
function passed the expected parameters to the API call, without ever calling
the API.

You can also make the API appear to fail, even raise an exception, something
you could not test by actually calling the API.

This post will teach you how to use Python's
`unittest.mock <https://docs.python.org/3/library/unittest.mock.html>`_
module to add mocking to your unit tests.

The mock methods and mock objects
---------------------------------

There are usually two different aspects of mocking going on at the same time, and
it's helpful to understand the difference.

First, we can temporarily change the value of something using
`mock.patch <https://docs.python.org/3/library/unittest.mock.html#patch>`_
or
`mock.patch.object <https://docs.python.org/3/library/unittest.mock.html#patch-object>`_,
then restore its original value.

Second, we can use mock objects, which are Python objects that can be used to simulate another object,
and control the behavior of the simulated object.

Often when we use mocking, we're using the mock methods to temporarily replace
something with a mock object. But sometimes we can use the methods or a mock
object independently.

Mock a function being called in another module
----------------------------------------------

It's common to test a function that is calling another function that it has
imported. Example::

    # package1/code.py
    from package2.subpackage import foobar

    def function_to_test(a, b):
        return foobar(a, b + 2) + "xyz"

Here's the pattern we use to test ``function_to_test``, while mocking
the call to ``foobar``:

.. code-block:: python
   :linenos:
   :emphasize-lines: 7,9,11

    from django.test import TestCase
    from unittest import mock
    from package1.code import function_to_test

    class TestClass(TestCase):
        def test_normal_call(self):
            with mock.patch("package1.code.foobar") as mock_foobar:
                mock_foobar.return_value = "something"
                retval = function_to_test(1, 2)

            self.assertEqual("somethingxyz", retval)
            mock_foobar.assert_called_with(1, 4)

Let's break this down.

On line 9, we call the function with some arguments, and save the
return value. Then on line 11, we check that we got back the
return value we expected.

On line 7, ``mock.patch("package1.code.foobar")`` indicates
that we want to mock the symbol ``foobar`` in the module
``package1.code``. In other words, while this mock is in effect, we're
going to change the value of ``foobar`` within ``package1.code``, and
afterward we will restore its original value.

.. important::

    Notice that while ``foobar`` is in ``package2.subpackage``,
    we do the mock on ``package1.code.foobar``, which is the reference
    that is being called by our function under test! It wouldn't do
    any good to change things in ``package2.subpackage`` anyway,
    since ``package1.code`` got a reference to the original ``foobar``
    when it was imported, and that's what will be called unless we
    change that reference.

By default, ``mock.patch()`` will create a new mock object and use
that as the replacement value. You can pass a different object using
``mock.patch(new=other_object)`` if want it to be used in place of
a newly created mock object.

By using the mock as a context manager, we limit its scope to the
short time we need it to be in effect. ``as mock_foobar`` saves the
mock object itself to the ``mock_foobar`` variable so we can manipulate
it. We're going to want to do two things with that mock object.

First, we control the return value when the mock object is called by
assigning to its ``return_value`` attribute. While this mock is in
effect, any call to ``foobar`` from within ``package1.code`` will
immediately return the value ``"something"``.

Second, we're going to verify that ``foobar`` was called with the
arguments we expect — in this case, ``(1, 4)``. ``mock_object.assert_called_with(*args, **kwargs)``
asserts that the last call to the mock object was passed ``(*args, **kwargs)``.

Mock an attribute
-----------------

Another common case is mocking an attribute of an object or class.
We can use ``mock.patch.object`` for this.

Suppose we have a function that will try to read from a file handle
it has been passed, and we want to test what it does if the read
fails.

.. code-block:: python

    def read_from_handle(fh):
        try:
            return len(fh.read())
        except IOError:
            return None

.. code-block:: python
   :linenos:
   :emphasize-lines: 8

    from django.test import TestCase
    from unittest import mock
    from ... import read_from_handle

    class TestClass(TestCase):
        def test_read_error(self):
            fh = open("testfile", "r")
            with mock.patch.object(fh, "read") as mock_read:
                mock_read.side_effect = IOError("fake error for test")
                retval = read_from_handle(fh)

            self.assertIsNone(retval)

On line 8, ``mock.patch.object(fh, "read")`` means that while the mock is in
effect, we're going to replace the value of the ``read`` attribute of the
object ``fh`` with our mock object. Again, by default, ``mock.patch.object``
just creates a new mock object to use.

On line 9, by assigning an exception to the
``side_effect`` attribute of the mock object, we indicate that when
called, instead of returning a value, the exception should be raised.
Our function is supposed to catch the exception and return ``None``, so we
check in the usual way that its return value is ``None``.

.. note::

    I try to use ``mock.object.patch`` instead of ``mock.object`` when I can,
    because it makes more sense to me when I try to figure out where to apply
    the mock. But both methods have their uses.

Mock something on a class
-------------------------

If we don't have access to an object to mock something on it, perhaps
because it doesn't exist yet,
we may instead apply a mock to the *class* that will be used to create the object.
We just need to be sure the mock is in effect when the object
is created.

.. code-block:: python

    class SomeClass:
        def some_function(self):
            return 1

    def function_to_test():
        obj = SomeClass()
        return obj.some_function()

.. code-block:: python
    :linenos:

    from django.test import TestCase
    from unittest import mock
    from ... import function_to_test, SomeClass

    class TestClass(TestCase):
        def test_object_all(self):
            with mock.object.patch(SomeClass, "some_function") as mock_function:
                mock_function.return_value = 3
                self.assertEqual(3, function_to_test())

By mocking ``some_function`` on the class object, we arrange that
the instance created from it will also have ``some_function`` be our
mock object.

Where to mock
-------------

It can be confusing figuring out what to pass to ``mock.patch`` to get
the mocking behavior we need.

In the most common case, we have a module that imports some object
and then calls or otherwise accesses it, and we want the code in the
module to see a mocked version of that object instead of the real
one. This is the module containing the code that we are testing.

In that case, we want to identify the module with its full package
name, e.g. "ourpackage.ourmodule", and combine it with the name of the object
to be mocked *as it appears in that module*.

So if the module has ``from urllib.urlparse import urlparse as parse_method``,
then we need to pass ``ourpackage.ourmodule.parse_method`` to ``mock.patch``.

If instead of importing an object, we define a function or variable in
the same module, we can mock it the same way as if it was imported into
our module.

When we can't mock
------------------

There are some common cases where we can't use mocking. It's okay to rewrite
the code being tested a little bit in order to make it possible to use mocking
when testing it. I'll usually add a comment to explain why the code is maybe
a little less straightforward than a reader might expect.

In the first case, something is being imported from a C module and we can't
mock that. For example, if we have ``from datetime import timedelta``,
we can't mock ``timedelta`` in that module because ``datetime`` is a C
module, not a Python module.

If we need to, we can wrap that in a Python function and mock our function.
E.g.:

.. code-block:: python

    from datetime import timedelta

    def daydelta(days):
        return timedelta(days=days)

then we can mock ``daydelta``.

In the second case, the thing we want to mock isn't at the top level of the
module, maybe because we're importing it inside a function or class.
``mock.patch`` can only mock objects at the top level of modules.

Again, we might write a little Python function that uses the thing we'd
otherwise mock, and mock the Python function instead.

I recently ran into another case. A mocked object method was supposed to
be called from a Django template, but the Django template code didn't
recognize the mock object as callable and tried to just use the mock object
directly.

How mock.patch and mock.patch.object work
-----------------------------------------

I have a mental model of how ``mock.patch`` works that is useful
for me. I'm sure in reality it's a lot more complicated, but I
imagine it does something like this:

.. code-block:: python

    with mock.patch('pkg.module.name') as xyz:
        run code

    # which is implemented something like
    import sys.modules

    module = sys.modules["pkg"]["module"]
    saved_value = module["name"]
    mock_object = mock.MagicMock()
    module["name"] = mock_object
    xyz = mock_object
    [ run code ]
    module["name"] = saved_value

It finds the reference by name in the appropriate module, saves its
value, changes it to the mock object, and when done, restores the
value.

And I imagine something similar for ``mock.patch.object``:

.. code-block:: python

    with mock.patch.object(some_object, "attrname") as xyz:
        run code

    # does

    saved_value = getattr(some_object, "attrname")
    mock_object = mock.MagicMock()
    setattr(some_object, "attrname", mock_object)
    xyz = mock_object
    [ run code ]
    setattr(some_object, "attrname", saved_value)

This is even simpler.

Controlling the mock object's behavior
--------------------------------------

We've already seen that we can assign to ``.return_value`` on a mock
object and whenever the mock object is called, the value we set will
be returned.

For more complex behaviors, we can assign to ``.side_effect``:

* Assign a list of values, and each time the mock object is called, the
  next value in the list will be returned.
* Assign an exception instance or class, and calling the mock object will raise that
  exception.
* Assign a callable, and anytime the mock object is called, the arguments
  will be passed to the callable, and the callable's return value will
  be returned from the mock object.

Most of the arguments that can be passed when contructing a mock object
can also be assigned as attributes later, so reading the
`documentation for the mock class <https://docs.python.org/3/library/unittest.mock.html#the-mock-class>`_
should give you more ideas.

Determining what was done with a mock object
--------------------------------------------

You can assert that a mock object has been called with
``mock_object.assert_called()``. It's more useful to assert that
its last call had the arguments you expect by using
``mock_object.assert_called_with(*args, **kwargs)``. Or that the mock
was *not* called, using ``mock_object.assert_not_called()``.

If you don't care about some of the arguments, you can pass ``mock.ANY`` to
``assert_called...`` methods in place of those arguments, and the assertion
will pass regardless of what value that argument had::

    mock_object.assert_called_with(1, 2, mock.ANY, x=3, y=mock.ANY)

See the mock class documentation for more variations on the same
theme.

And if you want to check something that there's no built-in method to check,
you can always access ``mock_object.call_args_list``, which is a list of
``(args, kwargs)`` pairs, one for each time the mock object was called.

For more information
--------------------

I've never found the mock documentation particularly clear, but once you know
some of the basics from this post, I hope you'll be able to approach them
more usefully. They're at https://docs.python.org/3/library/unittest.mock.html.
