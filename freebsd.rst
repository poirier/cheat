FreeBSD
=======



Useful commands.

Ones I'm still looking for:

* ...

Big hint! See ``/etc/defaults/rc.conf`` for all (?) the default
values of things that can be set in ``/etc/rc.conf``.

.. contents::

Resources
---------

My favorite source is Michael W. Lucas's
`Absolute FreeBSD, 3rd edition <https://nostarch.com/absfreebsd3>`_.
Even more so than other of Lucas's books I've read,
this is comprehensive, full of real-world advice, and
written in a snarky sysadmin style that I really enjoy.

FreeBSD also has excellent `online documentation <https://docs.freebsd.org/en/>`_. The `Handbook <https://docs.freebsd.org/en/books/handbook>`_ is the complete
users' and administrators' guide that you always wished Linux
had. And you can read all of the
`man pages online <https://www.freebsd.org/cgi/man.cgi>`_.

Packages
--------

.. note:: Unlike Debian's ``apt``, FreeBSD's pkg system automatically updates itself with the latest information.

Find packages starting with "git" using `pkg search <https://www.freebsd.org/cgi/man.cgi?query=pkg-search&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg search ^git

Install a package with `pkg install <https://www.freebsd.org/cgi/man.cgi?query=pkg-install&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg install --yes <pkgname>

List all non-automatically installed packages with `pkg query <https://www.freebsd.org/cgi/man.cgi?query=pkg-query&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg query -e '%a=0' %o

List files for a package::

    pkg query '%Fp' python39-3.9.7

Find the package that installed a file (see if there's a more efficient way? Actually this is quite fast anyway)::

    # pkg query '%o: %Fp' | grep /usr/local/bin/rsync
    net/rsync: /usr/local/bin/rsync
    net/rsync: /usr/local/bin/rsync-ssl


Show message that a package would have printed after installation::

    pkg query '%M' pkgname

Succeed if package is installed with `pkg info <https://www.freebsd.org/cgi/man.cgi?query=pkg-info&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg info --exists pkgname

Uninstall package with `pkg delete <https://www.freebsd.org/cgi/man.cgi?query=pkg-check&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg delete [--yes] pkgname

Remove packages that were installed by other packages that are no longer installed
with `pkg autoremove <https://www.freebsd.org/cgi/man.cgi?query=pkg-autoremove&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg autoremove [--yes]

Users and groups
----------------

Remove a user with `rmuser <https://www.freebsd.org/cgi/man.cgi?query=rmuser&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

     rmuser username

Create, remove groups by just editing the group file with `vigr <https://www.freebsd.org/cgi/man.cgi?query=vigr&apropos=0&sektion=8&manpath=FreeBSD+13.0-RELEASE+and+Ports&arch=default&format=html>`_.

Services
--------

You can control services using the
`service <https://www.freebsd.org/cgi/man.cgi?query=service&apropos=0&sektion=8&manpath=FreeBSD+13.0-RELEASE+and+Ports&arch=default&format=html>`_
command very much like the service command on Linux. e.g.

Print a service's status::

    service named status

Commands include status, start, stop, restart, reload, rcvar, onestart, and onestop.

List enabled services::

    service -e
