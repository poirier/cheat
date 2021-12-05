Nix language
============

The Nix expression language is used all over in Nix and the Nix OS.

https://nixos.wiki/wiki/Nix_Expression_Language

Expressions
-----------

In Nix, *everything* is an expression. There are no statements.

The nix repl
------------

You can experiment with the Nix language using the ``nix repl``,
e.g.::

    $ nix repl
    nix-repl> _

Immutable
---------

In Nix, all values are immutable.

Types
-----

While Nix is not statically typed, it is strongly typed. To do
an operation between values of different types, for example,
you have to explicitly convert one value to the other type.

Identifiers
-----------

Unlike most other languages, identifiers in Nix can include
the "-" character.  (If you want to subtract, add in some
whitespace to make things unambiguous.)

Attribute sets
--------------

*Confusingly* Nix has a data type formally called attribute sets,
but usually just called *sets*, that are similar to
Python dictionaries or JavaScript objects: a collection of named values,
called "attributes".

Literal sets are written as a sequence of assignments,  each one
terminated by a semicolon, all wrapped in curly braces.

Use ``.key`` to access a value from the set, similar to using [key] in Python.::

    var1 = { key1="value1";  key2="value2"; }
    var1.key2
    > "value2"

You can access an attribute and provide a default in case the set doesn't
have that attribute::

    val = set.a or 13

If you need to refer to another element in the set while writing
the set, you can use *recursive* sets::

    val2 = rec { a=1; b=2; c=a + 4; }

If expressions
--------------

The expression ``if A then val1 else val2`` has the value val1
if A is true and otherwise val2. Since all expressions must have
a value, if expressions must always have an else.

Let expressions
---------------

Like lisp, you can use let to temporarily define local variables
for use inside an expression::

    let a = 3; b = 4; in a + b
    > 7

You can refer to variables in the let expression when assigning
variables, like with recursive attribute sets, or ``let*`` in
Lisp.

With expressions
----------------

This is just a syntactic shortcut::

    nix-repl> longName = { a = 3; b = 4; }
    nix-repl> longName.a + longName.b
    7
    nix-repl> with longName; a + b
    7

Warning: if there's already a variable with the same name as
the attribute set used in the ``with``, the outer variable is
**not** shadowed and continues to refer to that outer variable.

It seems safer to me to write something like::

    let l=LongName; in l.a + l.b

Strings
-------

Literal strings are written either with double quotes, or two single quotes
at each end::

    val1 = "Hello, world."
    val2 = ''And hello to you.''

You can use one kind of quotes inside a string written using
the other kind.

In strings, you can interpolate string values using ${}::

    val3 = "Hello, ${username}"

Escaping ${...} within double quoted strings is done with the
backslash. Within two single quotes, it's done with '' (!)::

    nix-repl> "\${foo}"
    "${foo}"
    nix-repl> ''test ''${foo} test''
    "test ${foo} test"

Paths
-----

Nix has a special type for file names and paths, called *paths*. You
don't need to put quotes around them::

    filename = ./a/b/foo.txt

but note that paths are automatically resolved to absolute paths, so after
the above, the actual path stored in `filename` might be ``/var/www/a/b/foo.txt``.

You can also write literally ``<nixpkgs/stuff>`` and it'll resolve to the ``stuff`` directory
under your ``NIX_PATH``.

If you have a string like ``"/foo/bar"`` that you want to use as a path, you
have to convert it by writing::

    mypath = /. + builtins.toPath "/foo/bar"

(https://nixos.wiki/wiki/Nix_Expression_Language#Convert_a_string_to_an_.28import-able.29_path)

Lists
-----

Lists are written as a series of expressions separated by space (NOT COMMA)
and with square brackets around them::

    [ 2 "foo" true (2+3) ]

Lists are immutable, so adding or removing elements returns a new list.

Functions
---------

Functions are all unnamed lambda functions, sometimes assigned to variables, and all have a single argument.
They have the form::

    argument: nixExpression

so for example::

    funca = argument: argument * argument

Call a function by writing the name of the function (well, the
name of the variable the function was assigned to), a space,
then the expression to pass as the functions argument. No
parentheses or commas.

e.g. ``funca 12`` would square its input and have the value ``144``.

For multiple arguments::

    funcb = arg1: arg2: nixExpression
    funcb 1 34

You can create partials::

   funcc = funcb 1

would be a new function that takes one argument and returns the value of ``funcb 1 <new argument>``.

Destructuring
-------------

You can pass a set into a function and declare the keys the set should have::

    funcd = {a, b}: a + b
    funcd {a=12; b=13;}
    > 25

You can declare default values for some or all the keys::

    add_a_b = { a ? 1, b ? 2 }: a + b
    add_a_b {}
    3
    add_a_b {a=5;}
    7

.. note:: This looks like Python named arguments - cool!

If the set passed in the call has additional keys, the call will fail unless you say to allow that
by adding ``...``.  You can access any extra keys by supplying a name with ``@``::

    add_a_b = args@{ a, b, ... }: a + b + args.c
    add_a_b { a=5; b=2; c=10; }
    17

Import
------

The ``import`` keyword loads a Nix expression from a file, evaluates it, and
returns the result::

    a = import a/b/path

If the result is a function, you can of course
call it immediately::

    x = import <nixpkgs/myfile.nix> {a=1; b=12;}

Derivations and .drv files
--------------------------

There's a built-in function named ``derivation``. It takes
an argument set with at least three elements:

* name: a name for the derivation
* system: is the name of the system in which the derivation can be built. For example, x86_64-linux.
* builder: it is the binary program that builds the derivation.

Aside: the currently running system is available
as ``builtins.currentSystem``::

    builtins.currentSystem
    > x86_64-linux

In ``nix repl``, calling derivation with a derivation expression
will not build the derivation (e.g. compile the package), but
it will create the ``.drv`` file.

(The ``.drv`` file is kind of like a compiled .c file - it's
a more compact representation of the derivation, but it doesn't
do anything by itself.)

In the nix repl, the value returned by calling ``derivation``
is an attribute set.  It will be printed something like::

    nix-repl> d = derivation { name = "myname"; builder = "mybuilder"; system = "mysystem"; }
    nix-repl> d
    «derivation /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv»

because Nix does something special if an attribute set has
an attribute named "type", and this one has ``type = "derivation"``,
but it's really just an attribute set.

We can refer elsewhere to a derivation by its outPath string, which
we can easily extract using ``builtins.toString``::

    nix-repl> builtins.toString d
    "/nix/store/40s0qmrfb45vlh6610rk29ym318dswdr-myname"

(builtins.toString just returns the ``outPath`` attribute after
converting it to a string.)

You can pretty-print the .drv file::

    $ nix show-derivation /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv
    {
      "/nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv": {
        "outputs": {
          "out": {
            "path": "/nix/store/40s0qmrfb45vlh6610rk29ym318dswdr-myname"
          }
        },
        "inputSrcs": [],
        "inputDrvs": {},
        "platform": "mysystem",
        "builder": "mybuilder",
        "args": [],
        "env": {
          "builder": "mybuilder",
          "name": "myname",
          "out": "/nix/store/40s0qmrfb45vlh6610rk29ym318dswdr-myname",
          "system": "mysystem"
        }
      }
    }

There's an "out" path that tells us *where* Nix would put
the build output if we were to build it.

If you really want to build a derivation in ``nix repl``,
use the nix repl command ``:b``.

.. code-block::

    nix-repl> d = derivation { name = "myname"; builder = "mybuilder"; system = "mysystem"; }
    nix-repl> :b d
    [...]
    these derivations will be built:
      /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv
    building path(s) `/nix/store/40s0qmrfb45vlh6610rk29ym318dswdr-myname'
    error: a `mysystem' is required to build `/nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv', but I am a `x86_64-linux'

Outside ``nix repl``, you can "realize" (build) a derivation with ``nix-store -r``, e.g.::

    $ nix-store -r /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv

