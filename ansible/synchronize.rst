synchronize
===========

The Ansible synchronize module gets its own page because it is a bitch.

Let me count the ways:

* By default, it tries to become *locally* the user you've specified
  using the ``become_user`` variable that you have said you
  want to become *remotely*.
* Then it does *not* try to *remotely* become the user you've specified;
  you have to hack it by setting ``rsync_path: "sudo rsync"``.
* Unlike every other Ansible module, the ``owner`` and ``group`` options
  are *booleans*, not the names or numbers of users and groups.
  If true, it'll try to copy the owner of the local files, but
  if you want to specify the ownership of the target files yourself,
  you'll have to fix it afterward.
* And it's hardly worth mentioning after those, but it copies the weird
  rsync behavior where a trailing ``/`` on the source path is significant.

Here's a working example::

    - name: sync source from local directory
      synchronize:
        dest: "{{ source_dir }}"
        src: "{{ local_project_dir }}/"
        delete: yes
        rsync_path: "sudo rsync"  # Use sudo on the remote system
        recursive: true
        rsync_opts:
          - "--exclude=.git"
          - "--exclude=*.pyc"
      become: no  # stops synchronize trying to sudo locally
