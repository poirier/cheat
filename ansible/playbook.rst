Playbook
========

.. _playbook-directory:

Playbook directory
--------------------------

Default
    current dir

.. _playbook:

Playbook
-------------

Syntax
    A YAML file defining a list of :ref:`play` s and :ref:`playbook-include` s::

    - <play>
    - <play>
    - include: <path to playbook>
    - include: <path to playbook>

Templating
    A playbook is rendered as a Jinja2 template before processing it,
    but playbooks should not use loops and conditionals.

.. _playbook-include:

Playbook include
----------------

A playbook can include other playbooks::

    - include: <path to playbook>

Note that, unlike :ref:`task-include` s, playbook includes cannot
set variables.

.. _play:

Play
------

A dictionary::

  hosts:  hosta:pattern1:pattern2   # required
  vars:
    var1: value1
    var2: value2
  roles:
    - <rolename1>
    - <rolename2>
  remote_user: username
  sudo: yes|no
  sudo_user: username
  tasks:
    - <task>
    - include: <taskfile>
    - <task>
  handlers:
    - <task>
    - include: <taskfile>
    - <task>
  notify:
    - <handler name>
    - <handler name>
  vars_files:
    - <path to external variables file>
    - [<path1>, <path2>, ...]   (ansible loads the first one found)
    - <path to external variables file>


Required keys:

hosts
    A string, containing one or more :ref:`host-pattern` s separated by colons

Optional keys:

handlers
    list of :ref:`handler` s and :ref:`task-include` s.
pre_tasks
    list of :ref:`task` s and :ref:`task-include` s.  These are
    executed before roles.
roles
    list of names of :ref:`role` s to include in the play.  You can
    add parameters, tags, and conditionals::

      roles:
        - common
        - { role: foo_app_instance, dir: '/opt/a', tags: ["bar", "baz"] }
        - { role: foo_app_instance, dir: '/opt/b', when: "ansible_os_family == 'RedHat'" }

tasks
    list of :ref:`task` s and :ref:`task-include` s.  These are
    executed after the `roles`.
post_tasks
    list of :ref:`task` s and :ref:`task-include` s.  These are
    executed after the `tasks`.
notify
    list of names of :ref:`handler` s to trigger when done, but
    only if something changed
vars
    A dictionary defining additional :ref:`variables`
remote_user
    user to login as remotely
sudo
    yes|no
sudo_user
    user to sudo to remotely

.. _running-a-playbook:

Running a playbook
------------------

ansible-playbook <filepath of playbook> [options]

ansible-playbook playbook.yml --start-at="install packages"
    The above will start executing your playbook at a task named “install packages”.
ansible-playbook playbook.yml --step
    This will cause ansible to stop on each task, and ask if it should execute that task.
