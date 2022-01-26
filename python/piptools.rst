Better Python dependency management with pip-tools
==================================================
.. contents::

I recently looked into whether I could use `pip-tools <https://github.com/jazzband/pip-tools>`_ to improve my workflow around projects' Python dependencies.My conclusion was that pip-tools would help on some projects, but it wouldn't do everything I wanted, and I couldn't use it everywhere.(I tried pip-tools version 2.0.2 in August 2018. If there are newer versions, they might fix some of the things I ran into when trying pip-tools.)

My problems
-------------

What were the problems I wanted to find solutions for, that just pip wasn't handling?
Software engineer Kenneth Reitz explains them pretty well
`in his post <https://www.kennethreitz.org/essays/a-better-pip-workflow>`_, but I'll summarize here.

Let me start by briefly describing the environments I'm concerned with. First is my development environment, where I want to manage the dependencies. Second is the test environment, where I want to know exactly what packages and versions we test with, because then we come to the deployed environment, where I want to use exactly the same Python packages and versions as I've used in development and testing, to be sure no problems are introduced by an unexpected package upgrade.

The way we often handle that is to have a requirements file with every package and its version specified. We might start by installing the packages we know that we need, then saving the output of `pip freeze` to record all the dependencies that also got installed and their versions.   Installing into an empty virtual environment using that requirements file gets us the same packages and versions.

But there are several problems with that approach.

First, we no longer know which packages in that file we originally wanted, and which were pulled in as dependencies. For example, maybe we needed ``Celery``, but installing it pulled in a half-dozen other packages. Later we might decide we don't need Celery anymore and remove it from the requirements file, but we don't know which other packages we can also safely also remove.

Second, it gets very complicated if we want to upgrade some of the packages, for the same reasons.

Third, having to do a complete install of all the packages into an empty virtual environment can be slow, which is especially aggravating when we know little or nothing has changed, but that's the only way to be sure we have exactly what we want.

Requirements
-------------

To list my requirements more concisely:

- Distinguish direct dependencies and versions from incidental
- Freeze a set of exact packages and versions that we know work
- Have one command to efficiently update a virtual environment to have exactly the frozen packages at the frozen versions and no other packages
- Make it reasonably easy to update packages
- Work with both installing from PyPI, and installing from Git repositories
- Take advantage of pip's hash checking to give a little more confidence that packages haven't been modified
- Support multiple sets of dependencies (e.g. dev vs. prod, where prod is not necessarily a subset of dev)
- Perform reasonably well
- Be stable

That's a lot of requirements. It turned out that I could meet more of them with pip-tools than just pip, but not all of them, and not for all projects.

Here's what I tried, using
`pip <https://pip.pypa.io/en/stable/>`_,
`virtualenv <http://www.virtualenv.org/en/latest/index.html>`_,
and `pip-tools <https://github.com/jazzband/pip-tools>`_.

How to set it up
-----------------

1. I put the top-level requirements in ``requirements.in/*.txt``.

   To manage multiple sets of dependencies, we can include "-r file.txt",
   where "file.txt" is another file in requirements.in, as many times as we want.
   So we might have a ``base.txt``, a ``dev.txt`` that starts with ``-r base.txt``
   and then adds django-debug-toolbar etc,
   and a ``deploy.txt`` that starts with ``-r base.txt`` and then adds gunicorn.

   There's one annoyance that seems minor at this point, but turns out to be a bigger problem: pip-tools only supports URLs in these requirements files if they're marked editable with `-e`.

.. code-block:: text

    # base.txt
    Django<2.0
    -e git+https://github.com/caktus/django-scribbler@v0.8.0#egg=django-scribbler

    # dev.txt
    -r base.txt
    django-debug-toolbar

    # deploy.txt
    -r base.txt
    gunicorn

2. Install pip-tools in the relevant virtual environment:

.. code-block:: bash

    $ <venv>/bin/pip install pip-tools

3. Compile the requirements as follows:

.. code-block:: bash

    $ <venv>/bin/pip-compile --output-file requirements/def.txt requirements.in/dev.txt

This looks only at the requirements file(s) we tell it to look at, and *not*
at what's currently installed in the virtual environment. So one unexpected
benefit is that pip-compile is faster and simpler than installing everything
and then running ``pip freeze``.

The output is a new requirements file at ``requirements/dev.txt``.

pip-compile nicely puts a comment at the top of the output file to tell
developers exactly how the file was generated and how to make a newer version of it.

.. code-block:: text

    #
    # This file is autogenerated by pip-compile
    # To update, run:
    #
    #    pip-compile --output-file requirements/dev.txt requirements.in/dev.txt
    #
    -e git+https://github.com/caktus/django-scribbler@v0.8.0#egg=django-scribbler
    django-debug-toolbar==1.9.1
    django==1.11.15
    pytz==2018.5
    sqlparse==0.2.4           # via django-debug-toolbar
    ```

4. Be sure ``requirements``, ``requirements.in``, and their contents are in version control.

How to make the current virtual environment have the same packages and versions
------------------------------------------------------------------------------------

To update your virtual environment to match your requirements file,
ensure pip-tools is installed in the desired virtual environment, then:

.. code-block:: bash

    $ <venv>/bin/pip-sync requirements/dev.txt

And that's all. There's no need to create a new empty virtual environment to
make sure only the listed requirements end up installed. If everything is already as we want it, no packages need to be installed at all. Otherwise only the necessary changes are made. And if there's anything installed that's no longer mentioned in our requirements, it gets removed.

Except ...

pip-sync doesn't seem to know how to uninstall the packages that we installed using `-e <URL>`. I get errors like this::

    Can't uninstall 'pkgname1'. No files were found to uninstall.
    Can't uninstall 'pkgname2'. No files were found to uninstall.

I don't really know, then, whether pip-sync is keeping those packages up to date. Maybe before running pip-sync, I could just

.. code-block:: bash

    rm -rf $VIRTUAL_ENV/src

to delete any packages that were installed with ``-e``? But that's ugly and would be easy to forget, so I don't want to do that.

How to update versions
-----------------------

1. Edit ``requirements.in/dev.txt`` if needed.
2. Run pip-compile again, exactly as before:

.. code-block:: bash

    $ <venv>/bin/pip-compile--output-file requirements/dev.txt requirements.in/dev.txt

3. Update the requirements files in version control.

Hash checking
-------------

I'd like to use hash checking, but I can't yet. pip-compile can generate hashes for packages we will install from PyPI, but not for ones we install with `-e <URL>`. Also, pip-sync doesn't check hashes. `pip install` will check hashes, but if there are any hashes, then it will fail unless *all* packages have hashes. So if we have any `-e <URL>` packages, we have to turn off hash generation or we won't be able to `pip install` with the compiled requirements file. We could still use pip-sync with the requirements file, but since pip-sync doesn't check hashes, there's not much point in having them, even if we don't have any `-e` packages.

What about pipenv?
--------------------

`pipenv <https://docs.pipenv.org/>`_ promises to solve many of these same problems. Unfortunately, it imposes other constraints on my workflow that I don't want. It's also changing too fast at the moment to rely on in production.

Pipenv solves several of the requirements I listed above, but fails on these:
It only supports two sets of requirements: base, and base plus dev, not arbitrary sets as I'd like.
It can be very slow.
It's not (yet?) stable: the interface and behavior is changing constantly, sometimes
`multiple times in the same day <https://chriswarrick.com/blog/2018/07/17/pipenv-promises-a-lot-delivers-very-little/#the-break-neck-pace-of-pipenv>`_.

It also introduces some new constraints on my workflow. Primarily, it wants to control where the virtual environment is in the filesystem. That both prevents me from putting my virtual environment where I'd like it to be, and prevents me from using different virtual environments with the same working tree.

Shortcomings
-------------

pip-tools still has some shortcomings, in addition to the problems with checking hashes I've already mentioned.

Most concerning are the errors from pip-sync when packages have previously been
installed using ``-e <URL>``. I feel this is an unresolved issue that needs to be fixed.

Also, I'd prefer not to have to use ``-e`` at all when installing from a URL.

This workflow is more complicated than the one we're used to, though no more complicated than we'd have with pipenv, I don't think.

The number and age of open issues in the pip-tools git repository worry me. True, it's orders of magnitude fewer than some projects, but it still suggests to me that pip-tools isn't as well maintained as I might like if I'm going to rely on it in production.

Conclusions
------------

I don't feel that I can trust pip-tools when I need to install packages from Git URLs.

But many projects don't need to install packages from Git URLs, and for those, I think adding pip-tools to my workflow might be a win. I'm going to try it with some real projects and see how that goes for a while.
