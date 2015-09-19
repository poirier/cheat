Invoking
========

Ad-hoc
------

To run an ad-hoc command, use `ansible`. Examples::

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

To run a playbook, use ansible-playbook::

    Usage: ansible-playbook playbook.yml [options]

    Options:
      -k, --ask-pass        ask for SSH password
      --ask-su-pass         ask for su password
      -K, --ask-sudo-pass   ask for sudo password
      --ask-vault-pass      ask for vault password
      -C, --check           don't make any changes; instead, try to predict some
                            of the changes that may occur
      -c CONNECTION, --connection=CONNECTION
                            connection type to use (default=smart)
      -D, --diff            when changing (small) files and templates, show the
                            differences in those files; works great with --check
      -e EXTRA_VARS, --extra-vars=EXTRA_VARS
                            set additional variables as key=value or YAML/JSON
      --force-handlers      run handlers even if a task fails
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
      --list-tasks          list all tasks that would be executed
      -M MODULE_PATH, --module-path=MODULE_PATH
                            specify path(s) to module library
                            (default=/usr/share/ansible/)
      --private-key=PRIVATE_KEY_FILE
                            use this file to authenticate the connection
      --skip-tags=SKIP_TAGS
                            only run plays and tasks whose tags do not match these
                            values
      --start-at-task=START_AT
                            start the playbook at the task matching this name
      --step                one-step-at-a-time: confirm each task before running
      -S, --su              run operations with su
      -R SU_USER, --su-user=SU_USER
                            run operations with su as this user (default=root)
      -s, --sudo            run operations with sudo (nopasswd)
      -U SUDO_USER, --sudo-user=SUDO_USER
                            desired sudo user (default=root)
      --syntax-check        perform a syntax check on the playbook, but do not
                            execute it
      -t TAGS, --tags=TAGS  only run plays and tasks tagged with these values
      -T TIMEOUT, --timeout=TIMEOUT
                            override the SSH timeout in seconds (default=10)
      -u REMOTE_USER, --user=REMOTE_USER
                            connect as this user (default=poirier)
      --vault-password-file=VAULT_PASSWORD_FILE
                            vault password file
      -v, --verbose         verbose mode (-vvv for more, -vvvv to enable
                            connection debugging)
      --version             show program's version number and exit


Hosts pulling config
--------------------

Ansible-pull is a small script that will checkout a repo of configuration instructions from git, and then run ansible-playbook against that content.

Assuming you load balance your checkout location, ansible-pull scales essentially infinitely.

Help::

    Usage: ansible-pull [options] [playbook.yml]

    Options:
      -K, --ask-sudo-pass   ask for sudo password
      -C CHECKOUT, --checkout=CHECKOUT
                            branch/tag/commit to checkout.  Defaults to behavior
                            of repository module.
      -d DEST, --directory=DEST
                            directory to checkout repository to
      -e EXTRA_VARS, --extra-vars=EXTRA_VARS
                            set additional variables as key=value or YAML/JSON
      -f, --force           run the playbook even if the repository could not be
                            updated
      -h, --help            show this help message and exit
      -i INVENTORY, --inventory-file=INVENTORY
                            location of the inventory host file
      -m MODULE_NAME, --module-name=MODULE_NAME
                            Module name used to check out repository.  Default is
                            git.
      -o, --only-if-changed
                            only run the playbook if the repository has been
                            updated
      --purge               purge checkout after playbook run
      -s SLEEP, --sleep=SLEEP
                            sleep for random interval (between 0 and n number of
                            seconds) before starting. this is a useful way to
                            disperse git requests
      -U URL, --url=URL     URL of the playbook repository
      --vault-password-file=VAULT_PASSWORD_FILE
                            vault password file
      -v, --verbose         Pass -vvvv to ansible-playbook

