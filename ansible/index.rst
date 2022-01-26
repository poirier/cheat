Ansible
=======

This is growing into a minimal Ansible reference of sorts,
since Ansible's own docs have nothing like a reference.

.. contents::

* `Ansible <http://docs.ansible.com/>`_.
* `list of keys that common playbook objects can take <http://docs.ansible.com/ansible/playbooks_directives.html>`_.
* `Release tarballs <http://releases.ansible.com/ansible/>`_
* `Ansible documentation for older releases <http://jeremie.huchet.nom.fr/ansible-documentation/>`_

Quickies:

To check the ubuntu version, ``ansible_distribution_version|float < 18``  (ansible_distribution_version is e.g. "16.04")::

    "ansible_distribution_release": "bionic"
    "ansible_distribution_version": "18.04"

Better error formatting from https://www.jeffgeerling.com/blog/2018/use-ansibles-yaml-callback-plugin-better-cli-experience
Put this in ansible.cfg::

    [defaults]
    # FROM https://www.jeffgeerling.com/blog/2018/use-ansibles-yaml-callback-plugin-better-cli-experience
    # Use the YAML callback plugin.
    stdout_callback = yaml
    # Use the stdout_callback when running ad-hoc commands.
    bin_ansible_callbacks = True

Just note that this can break output from 'command' or 'ansible -m setup', and you might need to
disable it if you need that. Open issue: https://github.com/ansible/ansible/issues/39122

.. toctree::

  background
  block
  cheatsheet
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
  vault_yaml

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
