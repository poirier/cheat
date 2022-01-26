Pyenv
=====
.. contents::

`Pyenv <https://github.com/pyenv/pyenv>`_

`Pyenv commands reference <https://github.com/pyenv/pyenv/blob/master/COMMANDS.md>`_

cd $(pyenv root) && git pull
  Update pyenv's list of available versions

pyenv versions
  Lists the Python versions that pyenv currently has installed

pyenv local <version> [<version>...]
  Sets a local application-specific Python version by writing the version name to a .python-version file in the current directory.

pyenv global <version> [<version>...]
  Sets the global version of Python to be used in all shells by writing the version name to the ~/.pyenv/version file. This version can be overridden by an application-specific .python-version file, or by setting the PYENV_VERSION environment variable.

pyenv shell <version> [<version>...]
  Sets a shell-specific Python version by setting the PYENV_VERSION environment variable in your shell. This version overrides application-specific versions and the global version.

pyenv install <version>
  Install a Python version

pyenv install --list
  list the all available versions of Python, including Anaconda, Jython, pypy, and stackless

pyenv uninstall
  Uninstall a specific Python version.

pyenv which <command>
  Displays the full path to the executable that pyenv will invoke when you run the given command.  E.g. ``pyenv which python3``.
