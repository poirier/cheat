Tox
===
.. contents::


Command line
------------

Some useful options:

* ``tox -l`` - list environments
* ``tox -e envname[,envname...]`` - run tests for just those environments

Configuration
-------------

Links:

* `Configuration <http://tox.readthedocs.io/en/latest/config.html>`_


Substitutions
-------------

E.g. ``{toxinidir}}`` expands to the directory where ``tox.ini`` is, and
``{{env:ENV_NAME}}`` expands to the value of ``ENV_NAME`` from the environment:

* `Substitutions <http://tox.readthedocs.io/en/latest/config.html#globally-available-substitutions>`_

Environment variables
---------------------

Set env vars for the test::

    [testenv]
    setenv =
        VAR1 = value1
        VAR2 = value2

.. warning:: By default tox strips most values from the environment.

You can override with `passenv <http://tox.readthedocs.io/en/latest/config.html#confval-passenv=SPACE-SEPARATED-GLOBNAMES>`_.
I generally just put::

    passenv = *

in every ``tox.ini`` file.

* `passing in environment variables <http://tox.readthedocs.io/en/latest/example/basic.html#passing-down-environment-variables>`_
* `setting environment variables <http://tox.readthedocs.io/en/latest/example/basic.html#setting-environment-variables>`_
