Loops
=====
.. contents::

See http://docs.ansible.com/playbooks_loops.html

Iterating with nested loops
---------------------------

Write a task::

    - module: args
      with_subelements:
        - thelist
        - fieldname

Then Ansible will essentially do this::

   for thing in thelist:
      item.0 = thing
      for fieldvalue in get(thing, fieldname):
         item.1 = fieldvalue
         EXECUTE (module, args)

In other words, it'll iterate over the first value as a list,
call it item.0,
then get the list from that value's field named 'fieldname', and
iterate over that as well, calling it item.1.

Presumably you could nest this deeper.

Example from the docs. With variables::

    ---
    users:
      - name: alice
        authorized:
          - /tmp/alice/onekey.pub
          - /tmp/alice/twokey.pub
      - name: bob
        authorized:
          - /tmp/bob/id_rsa.pub


You can write tasks::

    - user: name={{ item.name }} state=present generate_ssh_key=yes
      with_items: "{{users}}"

    - authorized_key: "user={{ item.0.name }} key='{{ lookup('file', item.1) }}'"
      with_subelements:
         - users
         - authorized
