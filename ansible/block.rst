.. _blocks:

Blocks
======

* `Blocks doc <http://docs.ansible.com/ansible/playbooks_blocks.html>`_
* `A blog post about blocks <http://www.jeffgeerling.com/blog/new-features-ansible-20-blocks>`_
* `Blog post with examples <https://www.pandastrike.com/posts/20160308-ansible-blocks-examples>`_
* `Complete list of possible keywords <http://docs.ansible.com/ansible/latest/playbooks_keywords.html#block>`_

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

