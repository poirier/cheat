Beancount
=========

Beancount is a plain text accounting program.

Importing data from ledger
--------------------------

`Docs <https://ledger2beancount.readthedocs.io>`_.

https://github.com/beancount/ledger2beancount

For Debian/Ubuntu, install ledger2beancount.

Emacs mode
----------

Documentation is a README at
https://github.com/beancount/beancount-mode. It does not
appear to be in ELPA/MELPA.

Download https://raw.githubusercontent.com/beancount/beancount-mode/main/beancount.el.

Add to init.el::

  (use-package beancount
    :mode ("\\.beancount\\'" . beancount-mode))
