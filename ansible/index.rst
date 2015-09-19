Ansible Cheatsheet
==================

Things I'm always wanting to look up about
`Ansible <http://docs.ansible.com/>`_.

.. toctree::

  configuration
  inventory
  invoking
  playbook
  role
  task
  variables
  conditionals
  loops


.. Indices and tables
.. ==================

.. (no index entries yet) * :ref:`genindex`
.. (no modules) * :ref:`modindex`
.. (not needed) * :ref:`search`

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

See `ad-hoc commands <http://docs.ansible.com/intro_adhoc.html>`_.

.. _host-pattern:

Host pattern
------------------

See `patterns <http://docs.ansible.com/intro_patterns.html#patterns>`_ for now

<hosts>:

    "all" = all hosts in inventory file
