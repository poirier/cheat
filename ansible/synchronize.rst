synchronize
===========

The Ansible synchronize module gets its own page because it is a bitch.

(Update: apparently some of these bad behaviors were bugs in Ansible
2.0.0.x, but I'm keeping this page around for history.)

Let me count the ways:

* By default, it tries to become *locally* the user you've specified
  using the ``become_user`` variable that you have said you
  want to become *remotely*. [Apparently that was a bug in 2.0.0.x and
  works correctly in 1.9.x and 2.0.1+.]

* Then it does *not* try to *remotely* become the user you've specified;
  you have to hack it by setting ``rsync_path: "sudo rsync"``.
  [I have not tried this again with 2.0.1+.]

* Unlike every other Ansible module, the ``owner`` and ``group`` options
  are *booleans*, not the names or numbers of users and groups.
  If true, it'll try to copy the owner of the local files, but
  if you want to specify the ownership of the target files yourself,
  you'll have to fix it afterward.

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

NOTE: Ansible 2.0.1 fixed numerous bugs in synchronize:

* Fixes a major compatibility break in the synchronize module shipped with 2.0.0.x. That version of synchronize ran sudo on the controller prior to running rsync. In 1.9.x and previous, sudo was run on the host that rsync connected to. 2.0.1 restores the 1.9.x behaviour.
* Additionally, several other problems with where synchronize chose to run when combined with delegate_to were fixed. In particular, if a playbook targetted localhost and then delegated_to a remote host the prior behavior (in 1.9.x and 2.0.0.x) was to copy files between the src and destination directories on the delegated host. This has now been fixed to copy between localhost and the delegated host.
* Fix a regression where synchronize was unable to deal with unicode paths.
* Fix a regression where synchronize deals with inventory hosts that use localhost but with an alternate port.
