.. index:: ! ubuntu

Ubuntu notes
============
.. contents::

Verbose boot
------------

.. index:: ubuntu;; grub
.. index:: ubuntu;; plymouth

1. Edit ``/etc/default/grub``, find "splash" and remove from the boot command line.
2. Run ``sudo update-grub``.

See `https://wiki.ubuntu.com/Plymouth <https://wiki.ubuntu.com/Plymouth>`_.
