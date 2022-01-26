Packages
--------

.. note:: Unlike Debian's ``apt``, FreeBSD's pkg system automatically updates itself with the latest information.

Find packages starting with "git" using `pkg search <https://www.freebsd.org/cgi/man.cgi?query=pkg-search&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg search ^git

Install a package with `pkg install <https://www.freebsd.org/cgi/man.cgi?query=pkg-install&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg install --yes <pkgname>

List all non-automatically installed packages with `pkg query <https://www.freebsd.org/cgi/man.cgi?query=pkg-query&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg query -e '%a=0' %o

Mark packages as automatically installed::

    pkg set --automatic 1 <pkgname>

List files for a package::

    pkg query '%Fp' python39-3.9.7

List a package's dependencies::

    # pkg query '%do %dv' emby-server
    x11/libX11 1.7.2,1
    x11-fonts/fontconfig 2.13.94_1,1
    security/gnutls 3.6.16
    ...

List a package's reverse dependencies::

    # pkg query '%ro %rv' python39
    databases/py-sqlite3 3.9.9_7
    devel/py-setuptools 57.0.0

Find the package that installed a file (see if there's a more efficient way? Actually this is quite fast anyway)::

    # pkg query '%o: %Fp' | grep /usr/local/bin/rsync
    net/rsync: /usr/local/bin/rsync
    net/rsync: /usr/local/bin/rsync-ssl

Upgrade a package, or all packages, with
`pkg-upgrade <https://www.freebsd.org/cgi/man.cgi?query=pkg-upgrade&apropos=0&sektion=0&manpath=FreeBSD+13.0-RELEASE+and+Ports&arch=default&format=html>`_::

    pkg upgrade <pkgname>
    pkg upgrade    # upgrade all possible

Show message that a package would have printed after installation::

    pkg query '%M' pkgname

Succeed if package is installed with `pkg info <https://www.freebsd.org/cgi/man.cgi?query=pkg-info&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg info --exists pkgname

Uninstall package with `pkg delete <https://www.freebsd.org/cgi/man.cgi?query=pkg-check&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg delete [--yes] pkgname

Remove packages that were installed by other packages that are no longer installed
with `pkg autoremove <https://www.freebsd.org/cgi/man.cgi?query=pkg-autoremove&sektion=8&apropos=0&manpath=FreeBSD+13.0-RELEASE+and+Ports>`_::

    pkg autoremove [--yes]
