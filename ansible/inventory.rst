Inventory
=========

.. _inventory-directory:

Inventory directory
--------------------------

Whatever directory the :ref:`inventory-file` is in.

.. _inventory-file:

Inventory file
------------------

Default
    ``/etc/ansible/hosts``

Change
    set ``ANSIBLE_HOSTS`` in environment

    ``ansible-playbook -i <inventoryfile> ...``

    set :ref:`hostfile` in configuration

Syntax
    .ini file, except initial lines don't need to be in a section

The inventory file is basically a list of hostnames or IP addresses,
one per line. Can include port with ``hostname:port`` or ``address:port``.

Ranges: Including ``[m:n]`` in a line will repeat the line for every
value from ``m`` through ``n``.  ``m`` and ``n`` can be numbers or letters::

    [mygroup]
    host[1:25]

Host :ref:`variables`: Can specify per-host options after hostname on the
same line.  E.g.::

    jumper ansible_ssh_port=5555 ansible_ssh_host=192.168.1.50

See also :ref:`variables-files`.

Group :ref:`variables`: add ``[groupname:vars]`` section and put var definitions in it, one per line.
Example::

    [all:vars]
    project_name="PeterPan"
    environment_name=staging

See also :ref:`variables-files`.

Groups of groups: add ``[newgroupname:children]`` and put other group names in it, one per line::

    [group3]
    host13
    host14

    [group3:children]
    group1
    group2

    [group3:vars]
    group3_var1=27
    group3_var2="Hello, World"
