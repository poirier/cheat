Ansible
=======

This is growing into a minimal Ansible reference of sorts,
since Ansible's own docs have nothing like a reference.

* `Ansible <http://docs.ansible.com/>`_.
* `list of keys that common playbook objects can take <http://docs.ansible.com/ansible/playbooks_directives.html>`_.
* `Release tarballs <http://releases.ansible.com/ansible/>`_
* `Ansible documentation for older releases <http://jeremie.huchet.nom.fr/ansible-documentation/>`_

Quickies:

To check the ubuntu version, ``ansible_distribution_version|float < 18``  (ansible_distribution_version is e.g. "16.04")::

    "ansible_distribution_release": "bionic"
    "ansible_distribution_version": "18.04"

.. toctree::

  background
  block
  conditionals
  configuration
  hostpatterns
  inventory
  invoking
  loops
  playbook
  role
  secrets
  synchronize
  tags
  task
  variables
  galaxy
  facts

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

See `ansible ad-hoc commands doc <http://docs.ansible.com/intro_adhoc.html>`_ for ad-hoc commands.
