Ansible
=======

Things I'm always wanting to look up about
`Ansible <http://docs.ansible.com/>`_.

.. toctree::

  conditionals
  configuration
  inventory
  invoking
  loops
  playbook
  role
  secrets
  synchronize
  task
  variables

Misc. stuff I need to file somewhere:

.. _ad-hoc-command:

Ad-hoc command
-------------------------

    ansible :ref:`host-pattern` -m <module> [options]

e.g.

    $ ansible all -m ping --ask-pass

Shortcut to run a command:

    $ ansible all -a "/bin/echo hello"

options:  see output of "ansible --help" for now

See `doc <http://docs.ansible.com/intro_adhoc.html>`_ for ad-hoc commands.

.. _host-pattern:

Host pattern
------------------

See `doc <http://docs.ansible.com/intro_patterns.html#patterns>`_ for host patterns.

<hosts>:

    "all" = all hosts in inventory file
