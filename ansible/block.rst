.. _blocks:

Blocks
======

`Blocks doc <http://docs.ansible.com/ansible/playbooks_blocks.html>`_

Blocks can be used anywhere a task can (mostly?).
They allow applying task keys to a group of tasks
without having to repeat them over and over.
They also provide a form of error handling.

Syntax::

    block:
      - <task1>
      - <task2>
    when: <condition>
    become: true
    become_user: <username>
    ....
    [rescue:
      - debug: msg="This task runs if there's an error in the block"
      - <task2>
      ...
    always:
      - debug: msg="I always run"
      ... more tasks ..
    ]

