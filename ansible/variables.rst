Variables
=========

.. _variables:

Variables
---------

Some variables alter the behavior of ansible (see http://docs.ansible.com/intro_inventory.html#list-of-behavioral-inventory-parameters for a list).

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

.. _variables-file:

Variables file
--------------

A file that defines values of :ref:`variables`.

Syntax
    YAML defining a single dictionary
Templating
    Jinja2  (?)

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

.. _facts:

Facts
-----

Ansible automatically defines a whole bunch of variables with
information about the system that it's running on (the system
the plays and tasks are running on, not the system you're
controlling ansible from).

You can add to the facts with config files called
`local facts <http://docs.ansible.com/playbooks_variables.html#local-facts-facts-d>`_
though I don't know how that's any better than putting
variables in all the other places you can set them...

To see a list of all of the facts that are available about a machine,
you can run the “setup” module as an ad-hoc action::

    ansible -m setup hostname

This will print out a dictionary of all of the facts that are
available for that particular host.
