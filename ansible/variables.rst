Variables
=========

.. _variables:

Pre-defined variables
---------------------

`Ansible defines some variables for you <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#magic-variables-and-how-to-access-information-about-other-hosts>`_

These are not mentioned when you list Facts (see below) - go figure.

``inventory_hostname`` is the name of the current host as you've configured it in your Ansible inventory file, regardless of the system's actual hostname.

If you have a long FQDN, ``inventory_hostname_short`` also contains the part up to the first period, without the rest of the domain.

Variables
---------

Some variables alter the behavior of ansible (see http://docs.ansible.com/intro_inventory.html#list-of-behavioral-inventory-parameters for a list).
You can set some of these using environment variables
(`ansible variables doc <http://docs.ansible.com/ansible/intro_configuration.html#environmental-configuration>`_).

CORRECTION: Use ``ansible_ssh_user``, not ``ansible_user``.

Any of them can be used anywhere Jinja2 templating is in effect.

Places to define variables:

* inventory
* playbook
* included files and roles
* local facts
* ansible command line (``--extra-vars "foo=1 bar=2"`` or ``--extra-vars @filepath.json`` or ``--extra-vars @filepath.yml``)

See also "Variable Precedence", a little farther down...


.. _variables-file:

Variables file
--------------

A variables file (`doc <http://docs.ansible.com/ansible/playbooks_variables.html#variable-file-separation>`_)
is a file that defines values of :ref:`variables`.

Syntax
    YAML defining a single dictionary
Templating
    The file does not appear to undergo template expansion, but the values of variables do??

.. _variables-files:

Variables files
-------------------

Ansible will look in :ref:`inventory-directory` and
:ref:`playbook-directory`
for directories named ``host_vars`` or ``group_vars``.  Inside
those directories, you can put a single :ref:`variables-file` with the same
name as a host or group (respectively) and Ansible will use those
:ref:`variables` definitions.

Or a file named ``all`` that will be used for all hosts or groups.

Or you can create a directory with the same name as a host or group
and Ansible will use all the files in that directory as
:ref:`variables-file` s.

You can also include vars files from a :ref:`play`
(`ansible variable files doc <http://docs.ansible.com/ansible/playbooks_variables.html#variable-file-separation>`_).

.. _precedence:

Variable precedence
-------------------

`docs <http://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_

From 2.0 on, from lowest priority to highest - in other words, if a variable is defined in two places, the place that's farther down in this list takes precedence.

* role defaults [1]
* inventory file or script group vars [2]
* inventory group_vars/all [3]
* playbook group_vars/all [3]
* inventory group_vars/* [3]
* playbook group_vars/* [3]
* inventory file or script host vars [2]
* inventory host_vars/*
* playbook host_vars/*
* host facts / cached set_facts [4]
* inventory host_vars/* [3]
* playbook host_vars/* [3]
* host facts
* play vars
* play vars_prompt
* play vars_files
* role vars (defined in role/vars/main.yml)
* block vars (only for tasks in block)
* task vars (only for the task)
* include_vars
* set_facts / registered vars
* role (and include_role) params
* include params
* extra vars (defined on command line with ``-e``, always win precedence)

[1]	Tasks in each role will see their own role’s defaults. Tasks defined outside of a role will see the last role’s defaults.
[2]	(1, 2) Variables defined in inventory file or provided by dynamic inventory.
[3]	(1, 2, 3, 4, 5, 6) Includes vars added by ‘vars plugins’ as well as host_vars and group_vars which are added by the default vars plugin shipped with Ansible.
[4]	When created with set_facts’s cacheable option, variables will have the high precedence in the play, but will be the same as a host facts precedence when they come from the cache.


.. _facts:

Facts
-----

Ansible automatically defines a whole bunch of variables with
information about the system that it's running on (the system
the plays and tasks are running on, not the system you're
controlling ansible from).

You can add to the facts with config files called local facts
(`ansible local facts doc <http://docs.ansible.com/playbooks_variables.html#local-facts-facts-d>`_)
though I don't know how that's any better than putting
variables in all the other places you can set them...

To see a list of all of the facts that are available about a machine,
you can run the “setup” module as an ad-hoc action::

    ansible -m setup hostname

This will print out a dictionary of all of the facts that are
available for that particular host.

:ref:`facts_example`  is an example from one of my machines.

The Ansible docs used to show an example of this output, but
apparently they've removed or moved that.
And here's
`an example <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variables-discovered-from-systems-facts>`_.

The top of the output will look like::

    staging-web2 | SUCCESS => {
        "ansible_facts": {
            "ansible_all_ipv4_addresses": [
                "10.132.77.14",
                "138.197.111.207",
                "10.17.0.12"
            ],
            "ansible_all_ipv6_addresses": [

Ignore the ``"ansible_facts"`` part of that. To reference any of these variable, start with
the next level.  E.g. ``{{ ansible_all_ipv4_addresses[1] }}``.

*ALTERNATIVELY*, you can access the same variables as items in the ``ansible_facts``
dictionary, only without the individual keys prefixed by ``ansible_`` (or so
the docs say https://docs.ansible.com/ansible/latest/reference_appendices/config.html#inject-facts-as-vars)
and this should work even if INJECT_FACTS_AS_VARS has been set False).
