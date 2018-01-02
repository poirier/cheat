Dokku server administration
===========================

This page has information for those who have to set up and maintain
a Dokku server. If you're just using one, you can ignore this.

Initial install
---------------

The Dokku docs recommend setting up a new OS install of a supported
operating system, then running the Dokku install script.

Experience suggests that that approach is more likely to work than trying
to install Dokku on a system that has already had some configuration
done for other things.

Simple hostnames
----------------

The simple way to set up hostnames is:

* Pick a hostname you can control, e.g. ``dokku.me``.
* During initial setup of Dokku, configure that as the server's name.
* Create a DNS A record pointing ``dokku.me`` at the server's IP
  address.
* Add a wildcard entry for ``*.dokku.me`` at the same address.
* For each app you put on that server, give the app the same name
  you want to use for its subdomain.  For example, an app named
  ``foo`` would be accessible on the internet at ``foo.dokku.me``,
  without having to make any more changes to your DNS settings.


Managing users
--------------

In other words, who can mess with the apps on a dokku server?

`The way this currently works <http://dokku.viewdocs.io/dokku/deployment/user-management/>`_
is that everybody ends up sshing to the server
as the ``dokku`` user to do things. To let them do that, we want to add a
public key for them to the dokku config, by doing this (from any system):

.. code-block:: bash

    $ cat /path/to/ssh_keyfile.pub | ssh dokku ssh-keys:add <KEYNAME>

The <KEYNAME> is just to identify the different keys. I suggest using the
person's typical username. Just remember there will not be a user of that
name on the dokku server.

When it's time to revoke someone's access:

.. code-block:: bash

    $ ssh dokku ssh_keys:remove <KEYNAME>

and now you see why the <KEYNAME> is useful.

For now, there's not a simple way to limit particular users to particular
apps or commands.
