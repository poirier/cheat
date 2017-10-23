Task
====

.. _tasks-file:

Tasks file
----------

Syntax
    YAML FILE
Templating
    Jinja2
Content
    A list of task definitions, task includes, and
    :ref:`blocks`.

.. _task-include:

Task include
-------------

Anywhere there can be a task definition, you
can also use a task include::

    - include: <path to tasks file> [options]

The path is relative to the :ref:`playbook-directory`, or
the file is also searched for in the tasks directory of a role.

``[options]`` is an optional list of additional variable
settings, e.g.::

    - include: tasks/footasks.yml vara=1 varb=2 varc=3

You can use an expanded syntax with a vars setting to set
more complicated values::

      - include: wordpress.yml
        vars:
            wp_user: timmy
            some_list_variable:
              - alpha
              - beta
              - gamma

Or use this more compact but apparently equivalent syntax::

    - { include: wordpress.yml, wp_user: timmy, ssh_keys: [ 'keys/one.txt', 'keys/two.txt' ] }

.. _task:

Task
------

`doc <http://docs.ansible.com/ansible/playbooks_intro.html#tasks-list>`_,
`complete list of possible keywords <http://docs.ansible.com/ansible/latest/playbooks_keywords.html#task>`_

A dictionary::

   name: string      # optional but highly recommended
   module: args      # required; the "action"
   environment: dictionary
   remote_user: username
   sudo: yes|no
   sudo_user: username
   otheroption: othervalue   # depending on module
   tags:
    - <tag1>
    - <tag2>


Required keys:

name
    text
*modulename*
    options

Optional keys that can be used on any task:

environment
    dictionary (in YAML, or variable containing dictionary)
ignore_errors
    if true, continue even if task fails
register <varname>
    store result of task in <varname>.  See also ``when`` for some ways to use.
remote_user
    user to login as remotely
sudo
    yes|no
sudo_user
    user to sudo to remotely
tags
    list of tags to associate with the task
when
    expression controls whether task is executed `doc <https://docs.ansible.com/ansible/playbooks_conditionals.html#the-when-statement>`_::

        when: <varname>
        when: not <varname>

    Special filters for checking result of a prior task::

        when: <varname>|failed
        when: <varname>|skipped
        when: <varname>|success

Additional keys might be required and optional depending on the module being used.

.. _handler:

Handler
-----------

Same syntax as a :ref:`task`, it just gets triggered under different circumstances.

