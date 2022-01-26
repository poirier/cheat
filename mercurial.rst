Mercurial
=========
.. contents::

`Quick start <https://www.mercurial-scm.org/quickstart>`_.

And `here <https://onhate.pulpo.space/SfxPvsysCSQi6neBQ/documents/67be940c-a411-4510-a82d-5ac8a7ac7bb4>`_
is an extensive table showing equivalent commands in hg and git. The
only problem is that it's from the viewpoint of someone used to git
who needs to use mercurial.

Terminology
-----------

git branches
    hg heads
git commit
    hg changeset
git repository
    hg repository
git status
    hg status

Clone remote repo
-----------------

.. code-block:: bash

    $ hg clone https://selenic.com/repo/hello
    $ cd hello

Add files
---------

.. code-block:: bash

    $ hg add file <file2...> <filepattern>

Commit changes

.. code-block:: bash

    $ hg commit -m "Message"
