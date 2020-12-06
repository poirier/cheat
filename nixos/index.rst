NixOS
=====

https://nixos.org

* Update channel: ``nix-channel --update nixos; nixos-rebuild switch``
* Update system: sudo nixos-rebuild switch


Contents:

.. toctree::
   :maxdepth: 2

   nix_lang
   zfs_install


Find a package
--------------

https://nixos.org/manual/nix/stable/#chap-package-management

Query (-q) available (-a) packages::

    nix-env -qa [regex]

E.g.::

    nix-env -qa "firefox.*"

Add -s to show status of matching packages::

    $ nix-env -qas
    …
    -PS bash-3.0
    --S binutils-2.15
    IPS bison-1.875d
    …

    I = installed in current environment,
    P = present on system (so very fast to add to environment),
    S = there's a binary available so you won't have to compile it.

Query just installed packages::

    nix-env -q [pattern]

Create a Python virtualenv
--------------------------

https://github.com/DavHau/mach-nix is a good start.


Declarative package management
------------------------------

https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
