Pipenv
======

`Pipenv docs <https://pipenv.pypa.io/en/latest/>`_

.. warning:: Pipenv was changing rapidly when I originally wrote this, so don't trust it too much today.

From the docs:

    It automatically creates and manages a virtualenv for your projects, as well as adds/removes packages from your Pipfile as you install/uninstall packages. It also generates the ever-important Pipfile.lock, which is used to produce deterministic builds.

Pipenv documentation
--------------------

There's a lot of information on the pipenv web site. Unfortunately, as I remarked to a friend once, it's as if
someone wrote all the thoughts they had about pipenv on note cards, threw them up in the air, and added them to
the site in the order they fell. In other words, it's difficult to navigate or find the information you want.

Here's an attempt at a useful table of contents/index to the useful information in a useful order.

* Installation and configuration

  * `Installation  <https://pipenv.pypa.io/en/latest/install/#installing-pipenv>`_
  * `Shell configuration <https://pipenv.pypa.io/en/latest/basics/#about-shell-configuration>`_
  * `Configuration with environment variables <https://pipenv.pypa.io/en/latest/advanced/#configuration-with-environment-variables>`_
  * `Configuring where virtualenvs are created <https://pipenv.pypa.io/en/latest/advanced/#custom-virtual-environment-location>`_
  * `Shell completion <https://pipenv.pypa.io/en/latest/advanced/#shell-completion>`_
  * `Changing cache location <https://pipenv.pypa.io/en/latest/advanced/#changing-pipenv-s-cache-location>`_
  * `Changing default Python versions <https://pipenv.pypa.io/en/latest/advanced/#changing-default-python-versions>`_
  * `Show venv name in shell prompt <https://pipenv.pypa.io/en/latest/diagnose/#shell-does-not-show-the-virtualenvs-name-in-prompt>`_

* Converting an existing project

  * `Importing from requirements.txt <https://pipenv.pypa.io/en/latest/basics/#importing-from-requirements-txt>`_

* General day-to-day usage

  * `Install, uninstall, and lock <https://pipenv.pypa.io/en/latest/basics/#environment-management-with-pipenv>`_
  * `What to keep in version control <https://pipenv.pypa.io/en/latest/basics/#importing-from-requirements-txt>`_
  * `Deployment <https://pipenv.pypa.io/en/latest/advanced/#using-pipenv-for-deployments>`_
  * `Pipfile v. setup.py <https://pipenv.pypa.io/en/latest/advanced/#pipfile-vs-setup-py>`_


* Reference

  * `Pipenv command reference <https://pipenv.pypa.io/en/latest/cli/>`_

    * `check - Checks for PyUp Safety security vulnerabilities and against PEP 508 markers provided in Pipfile.<https://pipenv.pypa.io/en/latest/cli/#pipenv-check>`_
    * `clean - Uninstalls all packages not specified in Pipfile.lock. <https://pipenv.pypa.io/en/latest/cli/#pipenv-clean>`_
    * `graph - Displays currently-installed dependency graph information. <https://pipenv.pypa.io/en/latest/cli/#pipenv-graph>`_
    * `install - Installs provided packages and adds them to Pipfile, or (if no packages are given), installs all packages from Pipfile. <https://pipenv.pypa.io/en/latest/cli/#pipenv-install>`_
    * `lock - Generates Pipfile.lock <https://pipenv.pypa.io/en/latest/cli/#pipenv-lock>`_
    * `open - View a given module in your editor. <https://pipenv.pypa.io/en/latest/cli/#pipenv-open>`_
    * `run - Spawns a command installed into the virtualenv. <https://pipenv.pypa.io/en/latest/cli/#pipenv-run>`_
    * `scripts - Lists scripts in current environment config. <https://pipenv.pypa.io/en/latest/cli/#pipenv-scripts>`_
    * `shell - Spawns a shell within the virtualenv. <https://pipenv.pypa.io/en/latest/cli/#pipenv-shell>`
    * `sync - Installs all packages specified in Pipfile.lock. <https://pipenv.pypa.io/en/latest/cli/#pipenv-sync>`_
    * `uninstall - Uninstalls a provided package and removes it from Pipfile. <https://pipenv.pypa.io/en/latest/cli/#pipenv-uninstall>`_
    * `update - Runs lock, then sync. <https://pipenv.pypa.io/en/latest/cli/#pipenv-update>`_

  * `Specifying package versions <https://pipenv.pypa.io/en/latest/basics/#specifying-versions-of-a-package>`_
  * `Specifying python versions <https://pipenv.pypa.io/en/latest/basics/#specifying-versions-of-python>`_
  * `Specifying exactly which python to use <https://pipenv.pypa.io/en/latest/advanced/#pipenv-and-other-python-distributions>`_
  * `Making system-installed packages accessible in virtualenv <https://pipenv.pypa.io/en/latest/advanced/#working-with-platform-provided-python-components>`_
  * `Fine-tune which systems packages are installed on <https://pipenv.pypa.io/en/latest/advanced/#specifying-basically-anything>`_
  * `Editable dependencies <https://pipenv.pypa.io/en/latest/basics/#editable-dependencies-e-g-e>`_
  * `VCS dependencies <https://pipenv.pypa.io/en/latest/basics/#a-note-about-vcs-dependencies>`_
  * Package sources

    * `Specifying package indexes <https://pipenv.pypa.io/en/latest/advanced/#specifying-package-indexes>`_
    * `Mirrors <https://pipenv.pypa.io/en/latest/advanced/#using-a-pypi-mirror>`_
    * `Credentials <https://pipenv.pypa.io/en/latest/advanced/#injecting-credentials-into-pipfiles-via-environment-variables`_

  * `Integrations with IDEs and editors <https://pipenv.pypa.io/en/latest/advanced/#community-integrations>`_
  * `Custom script shortcuts in Pipfile <https://pipenv.pypa.io/en/latest/advanced/#custom-script-shortcuts>`_

* `Troubleshooting <https://pipenv.pypa.io/en/latest/diagnose/>`_

* Examples

  * `Example Pipfile and Pipfile.lock <https://pipenv.pypa.io/en/latest/basics/#importing-from-requirements-txt>`_
  * `Example workflow <https://pipenv.pypa.io/en/latest/basics/#importing-from-requirements-txt>`_
  * `Example upgrade workflow <https://pipenv.pypa.io/en/latest/basics/#importing-from-requirements-txt>`_
  * `Example generating requirements.txt <https://pipenv.pypa.io/en/latest/advanced/#generating-a-requirements-txt>`_
  * `Detecting security vulnerabilities <https://pipenv.pypa.io/en/latest/advanced/#detection-of-security-vulnerabilities>`_
  * `Automatically installing Python versions with pyenv <https://pipenv.pypa.io/en/latest/advanced/#automatic-python-installation>`_
  * `Automatic loading of .env files <https://pipenv.pypa.io/en/latest/advanced/#automatic-loading-of-env>`_
  * `Testing projects <https://pipenv.pypa.io/en/latest/advanced/#testing-projects>`_
  * `Using pipenv to run programs under supervisor <https://pipenv.pypa.io/en/latest/diagnose/#using-pipenv-run-in-supervisor-program>`_

Installing pipenv
-----------------

You need to install pipenv OUTSIDE your project's virtual environment *AND* if at all possible,
not as part of your system packages.

I like to use
`pipx <https://pipxproject.github.io/pipx/>`_.

`More instructions for installing pipenv <https://pipenv.pypa.io/en/latest/install/#installing-pipenv>`_.

Virtualenvs
-----------

There's no command to create a virtualenv. Pipenv just creates one as soon as one is needed.

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
