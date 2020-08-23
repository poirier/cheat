Development Environment
=======================

This is how to set up the One True Development Environment for Python.

Ha ha, just kidding, there is no such thing. Here's one way to do it, and
an attempt to explain the benefits of doing it this way.

Different developers working on the same project can choose different ways of doing
these things. In other words, projects should not assume things are being done this way.
These are just intended as a set of approaches to setting up to develop on a python
project that work pretty well in a variety of settings for a variety of developers.

Common requirements
-------------------

* Python 2 is dead. This assumes a recent Python 3 version.  (Say, 3.6 and later?)
* Works for both Linux and Mac
* As far as possible, works the same on Mac and on different Linux distributions.
* No dependency on any particular IDE or editor.

.. warning:: My experience is primarily on Ubuntu. Please let me know if anything here doesn't work on other Linuxes or on Mac.

Installing Python
-----------------

Assumptions:

* We need different versions of Python for different projects
* We don't want to be bothered with the changes our operating system might have made to how Python is installed.

Therefore, we will *not* use the operating system installed copy of Python, even if it happens to be
the version we want.

On Macs, we can choose between downloading an installer from `python.org <https://www.python.org/downloads/mac-osx/>`_,
or using `brew <brew.sh>`_. As far as I know, either will work fine.

On Linux, you can `download the source <https://www.python.org/downloads/source/>`_ and build and install each
version you want, but it's simpler to use a tool like `pythonz <https://github.com/saghul/pythonz>`_
or `pyenv <https://github.com/pyenv/pyenv>`_. I'm not ready to recommend a tool right now.

In any case, be sure you know how to invoke a specific version of Python from the command line before continuing.

Creating a virtualenv
---------------------

Python has had built-in support for creating virtual environments since version 3.3, and it works fine,
so we'll use that to create our virtualenv.

Where should we put our virtualenv, though?

as follows::

    <path-to-our-desired-python> -m venv <path-where-we-want-our-venv>



...

References and further reading
------------------------------

* `Jacob Kaplan-Moss, *My Python Development Environment, 2020 Edition* <https://jacobian.org/2019/nov/11/python-environment-2020/#atom-entries>`_
