.. index:: ! rsync

Rsync
=====

Trailing Slashes
++++++++++++++++

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

    $ rsync path/to/file.ext remote:target/
    $ ssh remote ls target
    file.ext

creates file `remote:target/file.ext`

::

    $ ls path/of/dir
    a b c
    $ rsync -a path/of/dir remote:target/
    $ ssh remote ls target
    dir
    $ ssh remote ls target/dir
    a b c

creates directory `remote:target/dir` containing whatever
files were in `path/of/dir`.

Source with slash
-----------------

If the source is a directory and is written with a trailing slash,
then no part of the directory path is copied to the target, only
the contents of the specified directory.::

    $ ls path/of/dir
    a b c
    $ rsync -a path/of/dir/ remote:target/
    $ ssh remote ls target
    a b c

Rsync to remote systems using ssh
+++++++++++++++++++++++++++++++++

Example::

    rsync -Hlrtz --delete-during -M--fake-super /etc/ hostname:path/etc/

* -H --hard-links: preserve hard links
* -l --links: copy symlinks as symlinks
* -M --remote-option=XXX: send OPTION to the remote side only
* -r --recursive: recurse into directories
* -t --times: preserve modtimes
* -z --compress: compress during transfer
* --delete-during: receiver deletes during the transfer
* --fake-super: store/recover privileged attrs using xattrs

Assuming `ssh hostname` works...
