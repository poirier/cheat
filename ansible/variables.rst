Variables
=========

.. _variables:

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

And here's the precedence order:

* extra vars (-e in the command line) always win
* then comes connection variables defined in inventory (ansible_ssh_user, etc)
   * Do NOT put things like ansible_sudo=[yes|no] here because it'll override the values
     set in plays, tasks, etc. which need to be able to control it themselves
* then comes "most everything else" (command line switches, vars in play, included vars, role vars, etc)
* then comes the rest of the variables defined in inventory
* then comes facts discovered about a system
* then "role defaults", which are the most "defaulty" and lose in priority to everything.

There are also three scopes
(`ansible variable scopes doc <http://docs.ansible.com/ansible/playbooks_variables.html#variable-scopes>`_)
but I don't know how these relate to precedence:

* Global: this is set by config, environment variables and the command line
* Play: each play and contained structures, vars entries, include_vars, role defaults and vars.
* Host: variables directly associated to a host, like inventory, facts or registered task outputs

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

The Ansible docs used to show an example of this output, but
apparently they've removed or moved that.
And here's
`an example <http://docs.ansible.com/ansible/playbooks_variables.html#information-discovered-from-systems-facts>`_.

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
