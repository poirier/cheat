Python
======

Contents:

.. toctree::
   :maxdepth: 2

   packaging
   pip
   virtualenv

Quick 'n' easy static web server
--------------------------------

* Change to the top level directory of the static files
* Run ``python -m http.server``

Python snippet copy logging to stdout
-------------------------------------

add to top::

   import logging

   handler = logging.StreamHandler()
   root_logger = logging.getLogger('')
   root_logger.setLevel(logging.DEBUG)
   root_logger.addHandler(handler)

Warnings
--------

Hiding python warnings. e.g. Deprecations::

   python -Wignore::DeprecationWarning ...

Pylint
------

Running it::

   python /usr/bin/pylint --rcfile=.pylintrc -f colorized aremind.apps.patients | less -r

Disabling a warning in code::

   # pylint: disable-msg=E1101


