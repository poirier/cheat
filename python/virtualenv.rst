Virtualenv
==========

Using Python virtual environments

Assumes virtualenv and `virtualenvwrapper <http://www.doughellmann.com/docs/virtualenvwrapper/>`_ is installed

pip install into site.USER_BASE (kind of a special virtualenv)::

   PIP_REQUIRE_VIRTUALENV= pip install --user ...

http://www.doughellmann.com/docs/virtualenvwrapper::

    sudo /usr/bin/easy_install pip
    sudo /usr/local/bin/pip install virtualenvwrapper

Then add to .bashrc::

    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh

creates and activates a new env, //envname//::

    mkvirtualenv //envname//

switch to //envname2//::

    workon //envname2//

no longer working with a virtual env::

    deactivate

List all of the environments::

    lsvirtualenv

Show the details for a single virtualenv::

    showvirtualenv

delete a virtual env (must deactivate first)::

    rmvirtualenv
