Python
======

Contents:

.. toctree::
   :maxdepth: 2

   async
   asyncio
   beautifulsoup
   devenv
   fixing_style
   gitpython
   mock
   packaging
   pip
   pipenv
   piptools
   six
   timezones
   tox
   versions
   virtualenv
   xml

Most minimal logging
--------------------

Python doesn't provide any logging handlers by default, resulting
in not seeing anything but an error from the logging package itself...
Add a handler to the root logger so we can see the actual errors.::

   import logging
   logging.getLogger('').addHandler(logging.StreamHandler())


Binary data to file-like object (readable)
------------------------------------------

    f = io.BytesIO(binary_data)   # Python 2.7 and 3

Join list items that are not None
---------------------------------

Special case use of `filter`::

    join(', ', filter(None, the_list))

Declare file encoding
---------------------

Top of .py file::

    # -*- coding: UTF-8 -*-
    # vim:fileencoding=UTF-8

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


