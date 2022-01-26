Elixir
======
.. contents::

Basic types
-----------

Examples::

    iex> 1          # integer
    iex> 0x1F       # integer (31)
    iex> 0x1010     # integer (10)
    iex> 0o777      # integer (511)
    iex> 1.0        # float
    iex> 1.0e-10    # float
    iex> true       # boolean
    iex> false      # boolean
    iex> :atom      # atom / symbol
    iex> "elixir"   # string
    iex> [1, 2, 3]  # list
    iex> {1, 2, 3}  # tuple
    iex> is_atom(false)     # true
    iex> is_atom(:false)     # true
    iex> is_boolean(true)   # true
    iex> is_boolean(:true)   # true
    iex> is_integer(1.0)    # false
    iex> is_float("foo")
    iex> is_number(1.0)     # true

Arithmetic
----------

Infix: ``40 + 2`` is 42.  ``/`` on integers returns a float,
e.g. ``10 / 2`` is 5.0::

    10 / 2         5.0
    div(10, 2)     5
    div 10, 2      5
    rem 10, 3      1
    round(3.58)    4
    trunc(3.58)    3

Boolean expressions
-------------------

``true == false`` is ``false``.

``true != false`` is ``true``.

You can also use ``or``, ``and``, and ``not``.
``or`` and ``and`` are short-circuiting operators.
All three of these require Boolean arguments.

Elixir also has ``||``, ``&&``, and ``!``, which
accept values of any type, and where any value except
``false`` and ``nil`` are truthy.

For comparison: ``==``, ``!=``, ``===``, ``!==``,
``<=``, ``>=``, ``<``, and ``>``. The only difference
between ``==`` and ``===`` is that ``1 == 1.0`` is true
but ``1 === 1.0`` is not true.

Elixir allows applying the comparison operators to values
of any type or combination of types, for simplicity when
doing things like sorting. There is an ordering among
types, e.g. ``<number> < <atom>``.

Strings
-------

Double quoted literals are strings (single quoted
literals are char lists, not strings).

Use ``<>`` to concatenate,
e.g. ``"hello" <> " world"``

You can interpolate::

    iex> "hellö #{:world}"
    "hellö world"

The typical ``\x`` char codes work, e.g.
``"hello\nworld"``

Internally strings are binary, sequences of bytes
(UTF-8)::

    iex> String.length("hellö")
    5
    iex> is_binary("hellö")
    true
    iex> byte_size("hellö")
    6

The `String <http://elixir-lang.org/docs/stable/elixir/String.html>`_
module has lots of useful methods like ``upcase``.

You can print a string using ``IO.puts/1``::

    iex> IO.puts "hello\nworld"
    hello
    world
    :ok

Note that the return value of ``IO.puts`` is ``:ok``.

Functions
---------

Note: Functions in Elixir are identified by name and by number
of arguments (i.e. arity). Therefore, is_boolean/1 identifies
a function named is_boolean that takes 1 argument.
is_boolean/2 identifies a different (nonexistent) function
with the same name but different arity.::

    iex> is_boolean(true)
    true
    iex> is_boolean(1)
    false

You can get help on a function with ``h`` and its name/arity::

    iex> h is_boolean
    iex> h is_boolean/1
    iex> h ==/2

*BUT* you can't call a function using its full name and arity,
you have to leave off the arity::

    iex> is_boolean/1(1)
    ** (SyntaxError) iex:2: syntax error before: '('

Anonymous functions
-------------------

Define anonymous functions with ``fn``, ``->``, and ``end``::

    iex> add = fn a, b -> a + b end
    ...
    iex> is_function(add)
    true
    iex> is_function(add, 2)
    true
    iex> is_function(add, 1)
    false

Anonymous functions require a dot ``.`` to invoke::

    iex> add.(1, 2)
    3

Anonymous functions are closures and can access variables
that were in scope when they were defined.

Variables assigned inside a function do *not* affect the
surrounding environment, though::

  iex> x = 42
  42
  iex> (fn -> x = 0 end).()
  0
  iex> x
  42

Lists
-----

Literal lists are written with square brackets.
Values can be a mix of any types::

   iex> length [1, 2, true, 3]
   4

Lists are concatenated using ``++/2`` and can
be "subtracted" using ``--/2``::

      iex> [1, 2, 3] ++ [4, 5, 6]
      [1, 2, 3, 4, 5, 6]
      iex> [1, true, 2, false, 3, true] -- [true, false]
      [1, 2, 3, true]

The "head" of a list is like Lisp's ``car`` but
is accessed using the ``hd/1`` function. Similarly,
the "tail" is the ``cdr`` and you get it with ``tl/1``::

  iex> list = [1,2,3]
  iex> hd(list)
  1
  iex> tl(list)
  [2, 3]

You can add a new head to a list with ``|``::

  iex> [1 | [2, 3]]
  [1, 2, 3]

Getting the head or the tail of an empty list is an error::

  iex> hd []
  ** (ArgumentError) argument error

A list of small integers is printed by Elixir as
a single-quoted "string" - but it's not a string, it's
a list of chars::

  iex> [11, 12, 13]
  '\v\f\r'
  iex> [104, 101, 108, 108, 111]
  'hello'

Introspection
-------------

Use ``i/1`` to get information about a value::

    iex(2)> i 'hello'
    Term
      'hello'
    Data type
      List
    Description
      This is a list of integers that is printed as a sequence of characters
      delimited by single quotes because all the integers in it represent valid
      ASCII characters. Conventionally, such lists of integers are referred to as
      "char lists" (more precisely, a char list is a list of Unicode codepoints,
      and ASCII is a subset of Unicode).
    Raw representation
      [104, 101, 108, 108, 111]
    Reference modules
      List
    iex(3)> i "hello"
    Term
      "hello"
    Data type
      BitString
    Byte size
      5
    Description
      This is a string: a UTF-8 encoded binary. It's printed surrounded by
      "double quotes" because all UTF-8 encoded codepoints in it are printable.
    Raw representation
      <<104, 101, 108, 108, 111>>
    Reference modules
      String, :binary

Tuples
------

Literal tuples are written with curly brackets ``{1, :ok, true}``.
Access any element with ``elem/2`` using 0-indexing, get the length
with ``tuple_size/1``, and return a new tuple with an element
changed using ``put_elem/3``::

    iex> elem({:ok, "hello"})
    "hello"
    iex> tuple_size({:ok, "hello"})
    2
    iex> put_elem({:ok, "hello"}, 1, "world"})
    {:ok, "world"}
