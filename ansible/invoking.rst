Invoking
========

Ad-hoc
------

To run an ad-hoc command, use `ansible`.  (But you almost
always will want to run a playbook; see below.)

Examples of ad-hoc commands::

    $ ansible all -m ping
    # as bruce
    $ ansible all -m ping -u bruce
    # as bruce, sudoing to root
    $ ansible all -m ping -u bruce --sudo
    # as bruce, sudoing to batman
    $ ansible all -m ping -u bruce --sdo --sudo-user batman
    $ ansible all -a "/bin/echo hello"

Help::

    Usage: ansible <host-pattern> [options]

    Options:
      -a MODULE_ARGS, --args=MODULE_ARGS
                            module arguments
      -k, --ask-pass        ask for SSH password
      --ask-su-pass         ask for su password
      -K, --ask-sudo-pass   ask for sudo password
      --ask-vault-pass      ask for vault password
      -B SECONDS, --background=SECONDS
                            run asynchronously, failing after X seconds
                            (default=N/A)
      -C, --check           don't make any changes; instead, try to predict some
                            of the changes that may occur
      -c CONNECTION, --connection=CONNECTION
                            connection type to use (default=smart)
      -f FORKS, --forks=FORKS
                            specify number of parallel processes to use
                            (default=5)
      -h, --help            show this help message and exit
      -i INVENTORY, --inventory-file=INVENTORY
                            specify inventory host file
                            (default=/etc/ansible/hosts)
      -l SUBSET, --limit=SUBSET
                            further limit selected hosts to an additional pattern
      --list-hosts          outputs a list of matching hosts; does not execute
                            anything else
      -m MODULE_NAME, --module-name=MODULE_NAME
                            module name to execute (default=command)
      -M MODULE_PATH, --module-path=MODULE_PATH
                            specify path(s) to module library
                            (default=/usr/share/ansible/)
      -o, --one-line        condense output
      -P POLL_INTERVAL, --poll=POLL_INTERVAL
                            set the poll interval if using -B (default=15)
      --private-key=PRIVATE_KEY_FILE
                            use this file to authenticate the connection
      -S, --su              run operations with su
      -R SU_USER, --su-user=SU_USER
                            run operations with su as this user (default=root)
      -s, --sudo            run operations with sudo (nopasswd)
      -U SUDO_USER, --sudo-user=SUDO_USER
                            desired sudo user (default=root)
      -T TIMEOUT, --timeout=TIMEOUT
                            override the SSH timeout in seconds (default=10)
      -t TREE, --tree=TREE  log output to this directory
      -u REMOTE_USER, --user=REMOTE_USER
                            connect as this user (default=poirier)
      --vault-password-file=VAULT_PASSWORD_FILE
                            vault password file
      -v, --verbose         verbose mode (-vvv for more, -vvvv to enable
                            connection debugging)
      --version             show program's version number and exit



Playbooks
---------

To run a playbook, use ansible-playbook. Here's the help from 2.0.1.0::

    Usage: ansible-playbook playbook.yml

    Options:
      --ask-become-pass     ask for privilege escalation password
      -k, --ask-pass        ask for connection password
      --ask-su-pass         ask for su password (deprecated, use become)
      -K, --ask-sudo-pass   ask for sudo password (deprecated, use become)
      --ask-vault-pass      ask for vault password
      -b, --become          run operations with become (nopasswd implied)
      --become-method=BECOME_METHOD
                            privilege escalation method to use (default=sudo),
                            valid choices: [ sudo | su | pbrun | pfexec | runas |
                            doas ]
      --become-user=BECOME_USER
                            run operations as this user (default=root)
      -C, --check           don't make any changes; instead, try to predict some
                            of the changes that may occur
      -c CONNECTION, --connection=CONNECTION
                            connection type to use (default=smart)
      -D, --diff            when changing (small) files and templates, show the
                            differences in those files; works great with --check
      -e EXTRA_VARS, --extra-vars=EXTRA_VARS
                            set additional variables as key=value or YAML/JSON
      --flush-cache         clear the fact cache
      --force-handlers      run handlers even if a task fails
      -f FORKS, --forks=FORKS
                            specify number of parallel processes to use
                            (default=5)
      -h, --help            show this help message and exit
      -i INVENTORY, --inventory-file=INVENTORY
                            specify inventory host path
                            (default=/etc/ansible/hosts) or comma separated host
                            list.
      -l SUBSET, --limit=SUBSET
                            further limit selected hosts to an additional pattern
      --list-hosts          outputs a list of matching hosts; does not execute
                            anything else
      --list-tags           list all available tags
      --list-tasks          list all tasks that would be executed
      -M MODULE_PATH, --module-path=MODULE_PATH
                            specify path(s) to module library (default=None)
      --new-vault-password-file=NEW_VAULT_PASSWORD_FILE
                            new vault password file for rekey
      --output=OUTPUT_FILE  output file name for encrypt or decrypt; use - for
                            stdout
      --private-key=PRIVATE_KEY_FILE, --key-file=PRIVATE_KEY_FILE
                            use this file to authenticate the connection
      --scp-extra-args=SCP_EXTRA_ARGS
                            specify extra arguments to pass to scp only (e.g. -l)
      --sftp-extra-args=SFTP_EXTRA_ARGS
                            specify extra arguments to pass to sftp only (e.g. -f,
                            -l)
      --skip-tags=SKIP_TAGS
                            only run plays and tasks whose tags do not match these
                            values
      --ssh-common-args=SSH_COMMON_ARGS
                            specify common arguments to pass to sftp/scp/ssh (e.g.
                            ProxyCommand)
      --ssh-extra-args=SSH_EXTRA_ARGS
                            specify extra arguments to pass to ssh only (e.g. -R)
      --start-at-task=START_AT_TASK
                            start the playbook at the task matching this name
      --step                one-step-at-a-time: confirm each task before running
      -S, --su              run operations with su (deprecated, use become)
      -R SU_USER, --su-user=SU_USER
                            run operations with su as this user (default=root)
                            (deprecated, use become)
      -s, --sudo            run operations with sudo (nopasswd) (deprecated, use
                            become)
      -U SUDO_USER, --sudo-user=SUDO_USER
                            desired sudo user (default=root) (deprecated, use
                            become)
      --syntax-check        perform a syntax check on the playbook, but do not
                            execute it
      -t TAGS, --tags=TAGS  only run plays and tasks tagged with these values
      -T TIMEOUT, --timeout=TIMEOUT
                            override the connection timeout in seconds
                            (default=10)
      -u REMOTE_USER, --user=REMOTE_USER
                            connect as this user (default=None)
      --vault-password-file=VAULT_PASSWORD_FILE
                            vault password file
      -v, --verbose         verbose mode (-vvv for more, -vvvv to enable
                            connection debugging)
      --version             show program's version number and exit


Hosts pulling config
--------------------

Ansible-pull
(`doc <http://docs.ansible.com/ansible/playbooks_intro.html#ansible-pull>`_)
is a small script that will checkout a repo of configuration instructions from
git, and then run ansible-playbook against that content.

Assuming you load balance your checkout location, ansible-pull scales essentially infinitely.

Help from ansible-pull 2.0.1.0::

    Usage: ansible-pull -U <repository> [options]

    Options:
      --accept-host-key     adds the hostkey for the repo url if not already added
      --ask-become-pass     ask for privilege escalation password
      -k, --ask-pass        ask for connection password
      --ask-su-pass         ask for su password (deprecated, use become)
      -K, --ask-sudo-pass   ask for sudo password (deprecated, use become)
      --ask-vault-pass      ask for vault password
      -C CHECKOUT, --checkout=CHECKOUT
                            branch/tag/commit to checkout.  Defaults to behavior
                            of repository module.
      -c CONNECTION, --connection=CONNECTION
                            connection type to use (default=smart)
      -d DEST, --directory=DEST
                            directory to checkout repository to
      -e EXTRA_VARS, --extra-vars=EXTRA_VARS
                            set additional variables as key=value or YAML/JSON
      -f, --force           run the playbook even if the repository could not be
                            updated
      --full                Do a full clone, instead of a shallow one.
      -h, --help            show this help message and exit
      -i INVENTORY, --inventory-file=INVENTORY
                            specify inventory host path
                            (default=/etc/ansible/hosts) or comma separated host
                            list.
      -l SUBSET, --limit=SUBSET
                            further limit selected hosts to an additional pattern
      --list-hosts          outputs a list of matching hosts; does not execute
                            anything else
      -m MODULE_NAME, --module-name=MODULE_NAME
                            Repository module name, which ansible will use to
                            check out the repo. Default is git.
      -M MODULE_PATH, --module-path=MODULE_PATH
                            specify path(s) to module library (default=None)
      --new-vault-password-file=NEW_VAULT_PASSWORD_FILE
                            new vault password file for rekey
      -o, --only-if-changed
                            only run the playbook if the repository has been
                            updated
      --output=OUTPUT_FILE  output file name for encrypt or decrypt; use - for
                            stdout
      --private-key=PRIVATE_KEY_FILE, --key-file=PRIVATE_KEY_FILE
                            use this file to authenticate the connection
      --purge               purge checkout after playbook run
      --scp-extra-args=SCP_EXTRA_ARGS
                            specify extra arguments to pass to scp only (e.g. -l)
      --sftp-extra-args=SFTP_EXTRA_ARGS
                            specify extra arguments to pass to sftp only (e.g. -f,
                            -l)
      --skip-tags=SKIP_TAGS
                            only run plays and tasks whose tags do not match these
                            values
      -s SLEEP, --sleep=SLEEP
                            sleep for random interval (between 0 and n number of
                            seconds) before starting. This is a useful way to
                            disperse git requests
      --ssh-common-args=SSH_COMMON_ARGS
                            specify common arguments to pass to sftp/scp/ssh (e.g.
                            ProxyCommand)
      --ssh-extra-args=SSH_EXTRA_ARGS
                            specify extra arguments to pass to ssh only (e.g. -R)
      -t TAGS, --tags=TAGS  only run plays and tasks tagged with these values
      -T TIMEOUT, --timeout=TIMEOUT
                            override the connection timeout in seconds
                            (default=10)
      -U URL, --url=URL     URL of the playbook repository
      -u REMOTE_USER, --user=REMOTE_USER
                            connect as this user (default=None)
      --vault-password-file=VAULT_PASSWORD_FILE
                            vault password file
      -v, --verbose         verbose mode (-vvv for more, -vvvv to enable
                            connection debugging)
      --verify-commit       verify GPG signature of checked out commit, if it
                            fails abort running the playbook. This needs the
                            corresponding VCS module to support such an operation
      --version             show program's version number and exit
