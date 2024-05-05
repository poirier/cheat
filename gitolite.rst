Gitolite
========

`Gitolite <https://gitolite.com/gitolite/index.html>`_ is a program that manages
hosting Git repositories
on your own server. It's lightweight, especially compared to
do-everything applications like `Gitlab <https://about.gitlab.com>`_.

It is still not a trivial undertaking to host git repositories for multiple
users, though, and (IMHO) gitolite doesn't help with the complexity by
defaulting to doing some of the admin by having to clone, update, and push
an "admin" git repo for some of the routine admin, and having to run arcane
commands after making some changes outside of that.

`This article <https://opensource.com/article/19/4/server-administration-git>`_ (`archive <https://web.archive.org/web/20240408114155/https://opensource.com/article/19/4/server-administration-git>`_) looks like it does a pretty good job of stepping through the important setup and daily operations, without getting into the weeds.

Some things you might also want to do:

* `Add existing repos to gitolite <https://gitolite.com/gitolite/basic-admin.html#appendix-1-bringing-existing-repos-into-gitolite>`_ (I guess assuming you don't want to just have the user push.)

* `Move an existing gitolite install to another server <https://gitolite.com/gitolite/install.html#moving-servers>`_

* If you really want to: `administer gitolite directly instead of using a gitolite-admin git repository <https://gitolite.com/gitolite/odds-and-ends.html#administering-gitolite-directly-on-the-server>`_.
