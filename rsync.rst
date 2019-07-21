Rsync
=====

The one thing I can never remember: what it means for source and/or target
to have trailing slashes.

Target - makes no difference
----------------------------

As long as the target specifies a directory, it makes no
difference whether you write it with a trailing slash or not.
I'll write a trailing slash from here on, just to emphasize
that I'm copying things into a directory.

Source no slash
---------------

With *no* trailing slash on the source, the tail part of any name in the
source gets created on the target. E.g.::

    rsync path/to/file.ext remote:target/

creates file `remote:target/file.ext`

    rsync -a path/of/dir remote:target/

creates directory `remote:target/dir` containing whatever
files were in `path/of/dir`.

Source with slash
-----------------

If the source is a directory and is written with a trailing slash,
then no part of the directory path is copied to the target, only
the contents of the specified directory.
