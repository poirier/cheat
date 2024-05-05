.. index:: restic; backup

Restic
======

Links:

* `Restic home <https://restic.net>`_
* `Restic documentation <https://restic.readthedocs.io/en/stable/index.html>`_

.. contents::


Restic is a backup system with the following features that I find useful:

* Deduplicating, even across hosts (if you back them up into the same restic respository)
* Compressing
* Efficiently back up to repositories on other hosts
* Can clone and efficiently push changes from one repository to another, rather than having to make the same backups to multiple places.  (Kind of like git.)
* Every backup is self-complete, but only changes are updated in the repository. Kind of like git commits, again.
* You can prune some older backups selectively.

Backup plan
-----------

I have the following components in my backup plan:

* Systems that need backing up
* A local backup server
* Some external drives
* An internet storage service

I assign my files to three categories:

* Must back up: keep 2 home backups plus one internet
* Best effort backup: Keep 2 home backups
* Not worth backing up

(Best effort files are primarily ripped from music and
video discs. I could rip them again, but it'd be a lot of work.
The files are very large relative to everything else I
have to back up, so keeping off-site backups would cost
a lot more than not doing so.)

The "must back up" files are backed up in 3 steps:

* Back up from all hosts to a single restic repository on my backup server
* Clone/sync that repository to an external drive
* Clone/sync that repository to an internet site

The "best effort backup" files are backed up in 2 steps:

* Backup from all hosts to a different restic repository on my backup server
* Clone/sync that repository to an external drive

I rotate the external drives. At present, I have two, keeping
one in the house attached to the backup server, and the
second in the car where it's hopefully save if something
happens to the server or the whole house. I swap the drives
once a month, and at the next sync, the one just moved into
the house gets updated with the last month's backups.

Setting up restic
-----------------

Installing restic
.................

Install restic on all the computers, both backup server
and to be backed up computers.

To get the latest restic, go to
`https://github.com/restic/restic/releases <https://github.com/restic/restic/releases>`_ and just download the latest
binary for each architecture you need.  (For most of my
systems, the filename looks like
``restic_0.16.0_linux_amd64.bz2``.)

I install it into
/usr/local/bin.

If you want man pages, just run

.. block:: console

    $ restic generate --man /usr/share/man/man1

If you want bash completion, just run

.. block:: console

    $ restic generate --bash-completion /etc/bash_completion.d/restic

Setup the backup server
.......................

* create a ``restic`` user (could be named anything).
* create an ssh key pair for the restic user
* copy the restic private key to the systems that will
  be doing backups (e.g. ``~root/.ssh/id_ed25519_restic``),
  being sure to set the permissions restrictively.
* add a host entry to /etc/ssh/ssh_config or ~root/.ssh/config
  on each file to be backed up, something like:

.. codeblock ::

    Host restic_backup
    Hostname backupserver.example.com
    User restic
    # Okay to use key in ~root/.ssh because only root should be using this entry for backup.
    IdentityFile ~root/.ssh/id_ed25519_restic
    IdentitiesOnly Yes

* Create a directory, owned by restic, where the backup
  repositories will live.  I'll use ``/backups`` in my
  examples.

Create a repository
...................

Like git, before you can start backing up files with restic,
you need to `initialize a repository <https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html>`_
for the backed-up files.

Repositories are encrypted, so hen you initialize a repository,
you have to specify one or more passwords that can be used
to access it.  You can change these later as needed.

.. note ::
    I find it simplest to put the password in my
    RESTIC_PASSWORD environment variable so I don't
    have to worry about it. I'll assume, in the rest of
    this, that the password is there.

Initializing a repository stored locally is pretty simple.

.. block:: console

    # login as "restic"
    $ restic init --repo /backups/restic-repo
    enter password for new repository:
    enter password again:
    created restic repository 085b3c76b9 at /backups/restic-repo
    Please note that knowledge of your password is required to access the repository.
    Losing your password means that your data is irrecoverably lost.

There are many, many ways to access remote repositories.
`See the documentation <https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html>`_.

Create a repository to sync to
..............................

Copying backups from repository A to repository B works **MUCH**
better if both repositories are using the same set of internal
parameters. To arrange this, you can tell restic when creating
repository B to use the parameters from repository A. That
looks like this:

.. block:: console

    $ restic -r /backups/restic-repo-B init --from-repo /backups/restic-repo-A --copy-chunker-params

Backup to remote repository
---------------------------

This assumes the setup described above.  Then to back up
to our backup server from another system, we'd use a command
something like this:

.. block:: console

    $ restic backup --repo=sftp:restic_backup:/backups/restic-repo /path1 /path2

I usually add some additional options:

* ``--exclude-caches``: do not backup directories with the
  special `CACHEDIR.TAG file <https://bford.info/cachedir/>`_. See
  `https://restic.readthedocs.io/en/stable/040_backup.html#excluding-files <https://restic.readthedocs.io/en/stable/040_backup.html#excluding-files>`_.
* ``--exclude-file=path``: do not back up other files listed
  in the file at path. My excludes include patterns like
  ``Downloads``, ``.cache``, and ``*.pyc``, among others.

.. note ::

    Note to myself: LOOK INTO using the `restic server <https://github.com/restic/rest-server>`_ on the backup server instead of sftp.
