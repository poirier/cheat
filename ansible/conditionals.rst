Conditionals, return values, and registered variables
=====================================================

`Ansible conditionals doc <http://docs.ansible.com/playbooks_conditionals.html>`_

Conditional tasks
-----------------

See :ref:`task`.


Return Values and registered variables
======================================

To create a variable with results from a task, use ``register``::

    - name: any task
      command: whatever
      register: varname

Then in later tasks, you can use varname in conditionals like ``when``.

The variable is actually an object with lots of useful items in it.  Some of them:

* ``.changed`` - boolean, whether the task changed anything
* ``.failed`` - boolean, true if the task failed
* ``.skipped`` - boolean, true if the task was skipped
* ``.result`` - ? (depends on the task?)
* ``.results`` - If this key exists, it indicates that a loop was present for the task and that it contains a list of the normal module ‘result’ per item.

`more on common return values <https://docs.ansible.com/ansible/latest/common_return_values.html>`_.

There are also useful filters:

* ``|succeeded`` - boolean, true if task succeeded
* ``|failed`` - boolean, true if task failed
* ``|skipped`` = boolean, true if the task was skipped

``succeeded`` is probably the most useful here - the others just duplicate attributes.