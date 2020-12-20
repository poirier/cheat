Virtual environments
====================

Using Python virtual environments
---------------------------------

To create a virtual environment that uses a particular Python executable,
assuming that Python executable is /usr/bin/python, run::

    /usr/bin/python -m venv /path/for/new/venv

To start using it, run::

    . /path/for/new/venv/bin/activate

Virtualenv and virtualenvwrapper
--------------------------------

Virtualenvwrapper adds some helpful shell aliases, but some of them do assume
all your venvs are under one directory, which is ``~/.virtualenvs`` by default.
Still, a few of the aliases work anytime a venv has been activated.

* `virtualenv <https://virtualenv.pypa.io/en/latest/>`_
* `virtualenvwrapper <https://virtualenvwrapper.readthedocs.io/en/latest/>`_ is installed

Virtualenvwrapper needs virtualenv installed. It's probably simplest to install
both of them using your system packages, e.g. for ubuntu::

    sudo apt-get install python3-virtualenv virtualenvwrapper

That puts the files on your system, but there's one more step to make it work - you
need to activate it in your ~/.bashrc::

    . /usr/share/virtualenvwrapper/virtualenvwrapper.sh

If when you open a new shell, you get an error like::

    /home/dpoirier/.pythonz/pythons/CPython-3.9.0/bin/python: Error while finding module specification for 'virtualenvwrapper.hook_loader'
    (ModuleNotFoundError: No module named 'virtualenvwrapper')
    virtualenvwrapper.sh: There was a problem running the initialization hooks.

    If Python could not import the module virtualenvwrapper.hook_loader,
    check that virtualenvwrapper has been installed for
    VIRTUALENVWRAPPER_PYTHON=/home/dpoirier/.pythonz/pythons/CPython-3.9.0/bin/python and that PATH is
    set properly.

then before loading virtualenvwrapper.sh, set an env var VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3:

    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    . /usr/share/virtualenvwrapper/virtualenvwrapper.sh

Aliases that only work for venvs under ~/.virtualenvs
.....................................................

Now if you want to create and activates a new env
under ``~/.virtualenvs``::

    mkvirtualenv envname

switch to ``~/.virtualenvs/envname2``::

    workon envname2

List all of the environments::

    lsvirtualenv

Show the details for a single virtualenv::

    showvirtualenv

delete a virtual env (must deactivate first)::

    rmvirtualenv

Aliases that work anytime a venv is active
..........................................

no longer work with a virtual env::

    deactivate

uninstall all the packages from the current venv::

    wipeenv
