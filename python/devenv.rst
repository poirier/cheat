My Python Development Environment
=================================
.. contents::

This is how to set up the One True Development Environment for Python.

Ha ha, just kidding, there is no such thing. Here's one way to do it that
works for me, and
an attempt to explain the benefits of doing it this way.

Different developers working on the same project can choose different ways of doing
these things. In other words, projects should not assume things are being done this way.
These are just one set of approaches to setting up to develop on a python
project that work pretty well in a variety of settings for me.

This is inspired by Jacob Kaplan-Moss's post
`My Python Development Environment, 2020 Edition <https://jacobian.org/2019/nov/11/python-environment-2020/>`_.

Common requirements
-------------------

* Projects use different Python versions.
* Python 2 is dead. This assumes a recent Python 3 version. (Say, 3.6 and later?)
* As far as possible, works the same on Mac and on different Linux distributions
  (though I only do Python development on Ubuntu).
* No dependency on any particular IDE or editor.

.. warning:: My experience is primarily on Ubuntu. Please let me know if anything here doesn't work on other Linuxes, or on Mac.

Installing Python
-----------------

Assumptions:

* We need different versions of Python for different projects
* We don't want to be bothered with the changes our operating system might have made to how Python is installed,
  or to risk breaking our operating system by messing with the system Python.

Therefore, we will *not* use the operating system installed copy of Python, even if it happens to be
the version we want.

Compile it myself?
..................

For a while, I was using an Ansible role to download source, compile, and install each version of Python
that I needed (on Linux), and using
`stow <https://www.gnu.org/software/stow/>`_ to put them all under ``/usr/local``. Then if I wanted Python 3.8, I
could just run ``python3.8`` and it would run the right one.

Except that if I had one project that wanted Python 3.8.1, and another that wanted Python 3.8.2, I was
out of luck. When I build and install Python vX.Y.Z, the installer creates executables pythonX and
pythonX.Y, but not pythonX.Y.Z. If I had multiple Python 3.8's installed, I didn't know which 3.8.x
version I'd get by running python3.8.

To create the right virtualenv, I would have to type something like::

    $ /usr/local/stow/python3.8.6/bin/python -m venv ...

Pythonz?
........

So, I switched to using `pythonz <https://github.com/saghul/pythonz>`_. It automates the install — and
uninstall — of any version x.y.z of python I want (just run ``pythonz install 3.7.7``).

Pythonz doesn't put all those Python versions on the path. Instead, I can find a particular
executable by running::

    $ pythonz locate 3.7.7
    /home/dpoirier/.pythonz/pythons/CPython-3.7.7/bin/python3

So I can run a specific version using something like this::

    $ $(pythonz locate 3.7.7)

where ``pythonz locate 3.7.7`` prints the complete path to the Python 3.7.7 executable,
and the ``$( )`` captures the output and executes it.

I could use that when creating a virtualenv for a project, and not have to deal with
pythonz afterward. Still, it always seemed inelegant.

Pyenv
.....

Now I'm trying `pyenv <https://github.com/pyenv/pyenv>`_. Like pythonz, I can easily
install multiple Python versions (``pyenv install 3.7.7``). But it takes a completely
different approach to selecting which version to run. You put pyenv's *shims* directory
first on your path, so that when you run any python command, you are running pyenv's
shim executable for that command. That shim executable figures out the right actual
python executable to run, and invokes it for you.

You can tell the shim which version you want at any given time in several ways.

* You can set PYENV_VERSION in your shell.
* You can put the version in a ``.python-version`` file in your current directory.
* You can have a ``.python-version`` file in any parent directory and it'll use
  the first one it finds, working its way up.
* Finally, you can configure a default version to use as a fallback.

This looks like it'll fit into my existing workflow pretty well. I already use
`direnv <https://direnv.net/>`_, so I can just set PYENV_VERSION in my ``.envrc`` file and get the
version I want without changing anything in the project's files in source control.
Or, I could create a .python-version file in the project, which shouldn't affect
any user not using pyenv, but whose meaning should be pretty obvious.

Creating a virtualenv
---------------------

Python has had built-in support for creating virtual environments since version 3.3,
so we'll use that to create our virtualenv.

Where should we put our virtualenv, though? I used
`virtualenvwrapper <https://virtualenvwrapper.readthedocs.io/en/latest/>`_
for a long time, which puts all of your virtual environments
in one directory (``$HOME/.virtualenvs`` by default).

But virtual environments tended to accumulate in my virtualenvs directory from
projects I hadn't touched in years, and it bugged me.

More recently, if I'm working on a project in ``.../projectname``
(my top-level directory where I cloned the project from git), then I create the
virtualenv at ``.../projectname.venv``. Anytime I'm cleaning up an old project,
I'll see the virtualenv next to it and remember to clean that up too.

That does mean I can't use virtualenvwrapper's ``workon`` command to switch
virtualenvs, but that's okay. I use direnv already, so I just have a little
script that creates a virtualenv at ``../projectname.venv`` and also adds
a line like ``. '../project.venv/bin/activate'`` to my .envrc file. Then
anytime I change to that directory, my virtual environment is already activated.

(I'm aware of pyenv-virtualenv and pyenv-virtualenvwrapper, but these look like
they also hide away the virtual environment directories somewhere I'll forget about
them, so for now, I'm not using them.)

Installing packages into the virtualenv
---------------------------------------

I've played with `pip-tools <https://github.com/jazzband/pip-tools>`_
for installing Python packages into virtual environments,
but somehow, most of my projects still just use
`pip` to install requirements::

    $ pip install -r requirements.txt

What about "tox"?
-----------------

`tox <https://tox.readthedocs.io/en/latest/>`_ needs to be able to find each
version of Python mentioned in
``tox.ini``, and it doesn't know to ask pyenv for them. But you can expose
as many python versions as you want using ``pyenv local``.  So I should
be able to, for example, set .python-version to::

    3.7.5
    3.8.6

and have tox work for test environments ``py37`` and ``py38``.

I haven't tested that, though. Most of my projects are standalone and
don't need to use tox.

References and further reading
------------------------------

* `Jacob Kaplan-Moss, *My Python Development Environment, 2020 Edition* <https://jacobian.org/2019/nov/11/python-environment-2020/#atom-entries>`_
