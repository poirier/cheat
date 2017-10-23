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
    A playbook is rendered as a Jinja2 template
    (`doc <http://docs.ansible.com/ansible/playbooks_variables.html#using-variables-about-jinja2>`_)
    before processing it, but playbooks should not use loops and conditionals.

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

`Complete list of possible keys <http://docs.ansible.com/ansible/latest/playbooks_keywords.html#play>`_

A dictionary::

  hosts:  hosta:pattern1:pattern2   # required
  vars:
    var1: value1
    var2: value2
  roles:
    - <rolename1>
    - {role: <rolename2>, var1: value1, tags: ['tag1', 'tag2']}
  tags:
    - <tag1>
    - <tag2>
  remote_user: username
  sudo: yes|no
  sudo_user: username
  tasks:
    - <task>
    - include: <taskfile>
    - include: <taskfile2>
      tags: [tag1, tag2]
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
  strategy: linear|free
  serial: <number>|"<number>%"

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

serial
    Set how many hosts at a time to run at a time. The
    default is to run tasks on all of a play's machines
    at once.  See also `strategy`.
strategy
    How plays are run on multiple hosts.  The default is
    "linear", where each task is run on up to `serial`
    hosts in parallel, and then Ansible waits for them all to
    complete before starting the next task on all the hosts.

    "free" lets each host run independently, starting its
    next task as soon as it finishes the previous one, regardless
    of how far other hosts have gotten.
tags
    see :ref:`tags`.
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
