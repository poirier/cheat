Configuration
=============

.. _configuration-file:

Configuration file
------------------------

Syntax
    .ini file

See `The Ansible Configuration File doc <http://docs.ansible.com/intro_configuration.html>`_.

Ansible uses the first config file it finds on this list:
    * ANSIBLE_CONFIG (an environment variable)
    * ansible.cfg (in the current directory)
    * .ansible.cfg (in the home directory)
    * /etc/ansible/ansible.cfg

Some useful vars in the ``[defaults]`` section:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.. _any_errors_fatal:

any_errors_fatal
................

    If true, stop immediately if any task fails.  Default value of False only stops for the host that failed.
    The playbook invocation will eventually report failure, but the error itself might be thousands of lines
    back in the output. Recommend changing this to True.

.. _display_args_to_stdout:

display_args_to_stdout
......................

    If true, more information displayed as tasks execute.  Default: False.

.. _error_on_undefined_vars:

error_on_undefined_vars
.......................

    If true, task fails if any undefined vars are encountered, which seems like it ought to be the
    default behavior, but it's not.

.. _hostfile:

hostfile
........

    This is the default location of the inventory file, script, or directory that Ansible will use to determine what hosts it has available to talk to:

    hostfile = /etc/ansible/hosts

.. _use_persistent_connections:

use_persistent_connections
..........................

Default False. Whether to use persistent connections. (Yes, this is in the *defaults* section.)

.. _private_role_vars:

private_role_vars
.................

Makes role variables inaccessible from other roles. This was introduced as a way to reset role variables to default values if a role is used more than once in a playbook.
Default: False

.. _retry_files_enabled:

retry_files_enabled
...................

Default true. If True, create .retry files on failure. These are generally useless so I change this to False
to not clutter up my file system with them.

.. _roles-path:

roles_path
..........
    The roles path indicate additional directories beyond the ‘roles/’ subdirectory of a playbook project to search to find Ansible roles. For instance, if there was a source control repository of common roles and a different repository of playbooks, you might choose to establish a convention to checkout roles in /opt/mysite/roles like so:

        roles_path = /opt/mysite/roles

    Additional paths can be provided separated by colon characters, in the same way as other pathstrings:

        roles_path = /opt/mysite/roles:/opt/othersite/roles

    Roles will be first searched for in the playbook directory. Should a role not be found, it will indicate all the possible paths that were searched.


Some useful vars in the ``[inventory]`` section:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.. _any_unparsed_is_failed:

any_unparsed_is_failed
......................

Default false. If ‘true’, it is a fatal error when any given inventory source cannot be successfully parsed by any available inventory plugin; otherwise, this situation only attracts a warning.

Some useful vars in the ``[ssh_connection]`` section:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.. _pipelining:

pipelining
----------

Pipelining, if supported by the connection plugin, reduces the number of network operations required to execute a module on the remote server, by executing many Ansible modules without actual file transfer. This can result in a very significant performance improvement when enabled. However this conflicts with privilege escalation (become). For example, when using ‘sudo:’ operations you must first disable ‘requiretty’ in /etc/sudoers on all managed hosts, which is why it is disabled by default.

.. _scp_if_ssh:

scp_if_ssh
..........

Preferred method to use when transferring files over ssh. When set to smart, Ansible will try them until one succeeds or they all fail. If set to True, it will force ‘scp’, if False it will use ‘sftp’.

.. _ssh_args:

ssh_args
........

If set, this will override the Ansible default ssh arguments.In particular,
users may wish to raise the ControlPersist time to encourage performance.
A value of 30 minutes may be appropriate.Be aware that if -o ControlPath is
set in ssh_args, the control path setting is not used.

.. warning:: If you set this, the default setting is completely overridden, so you should include it (possibly edited): ``-C -o ControlMaster=auto -o ControlPersist=60s``

Example::

    ssh_args = -C -o ControlMaster=auto -o ControlPersist=300s -o ForwardAgent=yes -o ControlPath=./ansible_ssh_conn_%h

