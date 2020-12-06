Nix language
============

The Nix expression language is used all over in Nix and the Nix OS.

https://nixos.wiki/wiki/Nix_Expression_Language

Sets
----

*Confusingly* Nix has a data type called *sets* that are similar to
Python dictionaries or JavaScript objects: a collection of named values,
called "attributes".

Use ``.key`` to access a value from the set.::

    var1 = { key1="value1";  key2="value2"; }
    { hello="world"; }.hello
    > "world"

You can access an attribute and provide a default in case the set doesn't
have that attribute::

    val = set.a or 13

Paths
-----

Nix has a special type for file names and paths, called *paths*. You
don't need to put quotes around them::

    filename = ./a/b/foo.txt

but note that paths are automatically resolved to absolute paths, so after
the above, the actual path stored in `filename` might be ``/var/www/a/b/foo.txt``.

You can also write ``<nixpkgs/stuff>`` and it'll resolve to the ``stuff`` directory
under your ``NIX_PATH``.

If you have a string like ``"/foo/bar"`` that you want to use as a path, you
have to convert it by writing::

    mypath = /. + builtins.toPath "/foo/bar"

(https://nixos.wiki/wiki/Nix_Expression_Language#Convert_a_string_to_an_.28import-able.29_path)

Functions
---------

Functions are all unnamed lambda functions, though they can be assigned to variables.
They have the form::

    funca = argument: nixExpression

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

If the set has additional keys, the call will fail unless you say to allow that
by adding ``...``.  You can also access any extra keys by supplying a name with ``@``::

    add_a_b = args@{ a, b, ... }: a + b + args.c
    add_a_b { a=5; b=2; c=10; }
    17

Import
------

The ``import`` keyword loads a Nix expression from a file, evaluates it, and
returns the result::

    x = import <nixpkgs/myfile.nix> {};

I *think* the ``{}`` there indicates you can pass arguments to the expression? But
that would mean the expression was really a lambda? Confused...
