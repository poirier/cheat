Roles
=====

.. _role:

Role
----

A role is a directory with specified contents. The role directory
must be in one of the directories on the :ref:`roles-path` and its
name is used to refer to the role elsewhere.

Inside the role's top-level directory, you might see a tree like
this (most of this is optional).

defaults/main.yml
    variables within will be defined at the
    lowest priority (can be overridden by variables declared anywhere else, even
    inventory variables)
files/
    Any copy tasks can reference files in roles/x/files/ without having to path them relatively or absolutely

    Any script tasks can reference scripts in roles/x/files/ without having to path them relatively or absolutely
handlers/main.yml
    handlers listed therein will be added to the play
library/
    modules here (directories) will be available in the role, and any
    roles called after this role
meta/main.yml
    :ref:`role-dependencies-file`
tasks/main.yml
    :ref:`tasks-file`

    Any include tasks can reference files in roles/x/tasks/ without having to path them relatively or absolutely
templates/
    Any template tasks can reference files in roles/x/templates/ without having to path them relatively or absolutely
vars/main.yml
    variables listed therein will be added to the play. These override
    almost any other variables except those on the command line, so this
    is really better for the role's "constants" than variables :-)

.. _role-dependencies-file:

Role dependencies file
----------------------

Syntax
    YAML file
Templating
    Jinja2
Contents
    A dictionary

The role dependencies file defines what other roles
this role depends on.

Keys:

dependencies
    A list of :ref:`dependency-dictionary` s

allow-duplicates
    yes|no

    Defaults to no, preventing the same role from being listed
    as a dependency more than once. Set to yes if you want
    to list the same role with different variables.

Example::

    ---
    dependencies:
      - role: role1
      - role: role2
        varname: value

.. _dependency-dictionary:

Dependency dictionary
---------------------

Required keys:

role
   name of role, or quoted path to role file, or quoted
   repo URL:

       role: postgres

       role: '/path/to/common/roles/foo'

       role: 'git+http://git.example.com/repos/role-foo,v1.1,foo'

       role: '/path/to/tar/file.tgz,,friendly-name'

 Optional keys: any parameters for the role - these define
 :ref:`variables`

.. _role-modules:

Embedding modules in roles
--------------------------

