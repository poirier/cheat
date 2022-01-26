Virtualbox
==========
.. contents::

List running VMs::

    VBoxManage list runningvms

Stop a running VM::

    VBoxManage controlvm <UUID|VMNAME> pause|resume|reset|poweroff etc.

Delete a VM::

    VboxManage unregistervm <UUID|VMNAME> [--delete]
