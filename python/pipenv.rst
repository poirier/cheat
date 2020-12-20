Pipenv
======

`Pipenv docs <https://pipenv.pypa.io/en/latest/>`_

.. warning:: Pipenv was changing rapidly when I originally wrote this, so don't trust it too much today.

From the docs:

    It automatically creates and manages a virtualenv for your projects, as well as adds/removes packages from your Pipfile as you install/uninstall packages. It also generates the ever-important Pipfile.lock, which is used to produce deterministic builds.

Installing pipenv
-----------------

You need to install pipenv OUTSIDE your project's virtual environment. I like to use
`pipx <https://pipxproject.github.io/pipx/>`_,
but using a distribution's packaged pipenv is probably a good option too.

Virtualenvs
-----------

There's no command to create a virtualenv; Pipenv just creates one as soon as one is needed.

By default (as of Dec 2020), pipenv creates all virtualenvs in some global location (I need to
find out where that is), with a name/path automatically generated from the project directory path.
So if you move your project, pipenv will no longer find that virtualenv and will have to create a
new one.

You can set ``PIPENV_VENV_IN_PROJECT=1`` in your environment to tell pipenv to create your
virtualenv under your project directory.

.. note:: is there a way to tell pipenv to use some other algorithm to generate the path to the virtualenv?

Useful commands
---------------

pipenv install <pkg> [<pkg>...]
...............................



Converting from a requirements file
-----------------------------------

Just run "pipenv install [-r requirementsfile]" and it'll see that there's
no Pipfile but a requirements file, and will generate a new Pipfile and .lock
file for you. Then edit the Pipfile to clean it up.

Starting a new project
----------------------

Just change to the project directory and start using ``pipenv install <packagespec> [<packagespec>...]``
to install packages. Pipenv will create a Pipfile and Pipfile.lock the first time, and update it as you
install more packages.

Pinning a Python version
------------------------

If your project requires a particular Python version, then edit the ``Pipfile``
and put that in::

    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Creating a requirements file
----------------------------

Do this::

    pipenv lock --requirements >non-dev-requirements.txt
    pipenv lock --requirements --dev >only-dev-requirements.txt

Keeping dev-only packages out of production
-------------------------------------------

1) Add dev-only packages using ``pipenv install --dev <packages>``
2) For development, install using ``pipenv install --dev``
3) In production, leave off the ``--dev``
