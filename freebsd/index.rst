FreeBSD
=======


Contents:

.. toctree::
   :maxdepth: 2

  packages
  jails

.. contents::

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
