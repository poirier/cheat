Ansible Galaxy
==============
.. contents::

Links
-----

* `Galaxy doc <https://galaxy.ansible.com/intro>`_
* `popular galaxy roles and recent activity <https://galaxy.ansible.com/explore#/>`_
* `search galaxy <https://galaxy.ansible.com/list#/roles>`_

Role specification
------------------

Format when installing roles from galaxy:

* ``username.rolename[,version]``
* ``scm+repo_url[,version]``
* ``tarball_url``

Versions represent tags in the role's source repository.

E.g.::

    user2.role2
    user1.role1,v1.0.0
    user1.role2,master
    git+http://bitbucket.org/willthames/git-ansible-galaxy
    https://some.webserver.example.com/files/master.tar.gz

Ways of installing
------------------

Command-line
~~~~~~~~~~~~

List roles on the command line::

    ansible-galaxy install user2.role2 user1.role1,v1.0.9

Simple file
~~~~~~~~~~~

List roles in a file, one per line.  Example file::

    # file: roles.txt
    user2.role2
    user1.role1,v1.0.0

And install with ``-r``::

    ansible-galaxy install -r roles.txt

YAML file
~~~~~~~~~

Use a YAML file to provide more control.  The YAML file should contain
a list of dictionaries. Each dictionary specifies a role to install.
Keys can include:

src
    (*required*) a role specification as above. (Since there's a separate dictionary
    key for ``version``, I don't know whether you can include version
    here, or if you're required to list it separately as ``version``.)

path
    Where to install (directory, can be relative)

version
    version to install. e.g. ``master`` or ``v1.4``.

name
    install as a different name

scm
    default ``git`` but could say ``hg`` and then in ``src``
    provide a URL to a mercurial repository.

Example::

    # install_roles.yml

    # from galaxy
    - src: yatesr.timezone

    # from github
    - src: https://github.com/bennojoy/nginx

    # from github installing to a relative path
    - src: https://github.com/bennojoy/nginx
      path: vagrant/roles/

    # from github, overriding the name and specifying a specific tag
    - src: https://github.com/bennojoy/nginx
      version: master
      name: nginx_role

    # from a webserver, where the role is packaged in a tar.gz
    - src: https://some.webserver.example.com/files/master.tar.gz
      name: http-role

    # from bitbucket, if bitbucket happens to be operational right now :)
    - src: git+http://bitbucket.org/willthames/git-ansible-galaxy
      version: v1.4

    # from bitbucket, alternative syntax and caveats
    - src: http://bitbucket.org/willthames/hg-ansible-galaxy
      scm: hg

And again install with ``-r``::

    ansible-galaxy install -r install_roles.yml
