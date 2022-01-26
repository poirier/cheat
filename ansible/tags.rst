.. _tags:

Tags
====
.. contents::

When you apply tags to things, you can then control whether
they're executed by adding command line options.

How to tag things
-----------------

Plays and tasks have optional ``tags`` attributes where you can
specify a list of tags.  Here are some tagged :ref:`task` s::

    tasks:
        - module: parm1=a parm2=b
          tags:
             - packages

        - module2: parm1=x parm2=y
          tags:
             - configuration

And here's a playbook with some tagged :ref:`play` s::

    - hosts: all
      tags:
        - foo
        - bar
      roles:
        - role1
        - role2

You can also apply tags when invoking a role from a playbook::

    roles:
      - { role: webserver, port: 5000, tags: [ 'web', 'foo' ] }

and when including tasks::

    - include: foo.yml
      tags: [web,foo]

.. _warning:
    In these cases, the tags are applied to everything within the included
    role or tasks file, *replacing* any tags that might have been specified
    in the role or tasks file already.

What tags do
------------

Adding a tag to a play or task says that *if* ansible is invoked
with ``--tags=x,y,z``, that the tagged play or task will only
be executed if at least one of its tags is included in the list
of tags from the command line.

Specifying ``--tags=all`` is equivalent to the default behavior,
where all playbooks and tasks are run regardless of their tags.

Specifying ``--tags=tagged`` runs only things that have *some*
tag, while ``--tags=untagged`` runs only things that have *no*
tag.

You could alternatively invoke ansible with ``--skip-tags=a,b,c``
and it will execute all plays and tasks that are *not* tagged
with a, b, or c.

Presumably ``--skip-tags=tagged`` does the opposite of ``--tags=tagged``,
and ``--skip-tags=untagged`` does the opposite of ``--tags=untagged``.

If a play or task is tagged ``always``, then it will be executed
*unless* ansible is invoked with ``skip-tags=always``.
