Microk8s
========

* `Quick Start <https://microk8s.io/docs/>`_
* `Add-ons <https://microk8s.io/docs/addons>`_
* `Built-in registry <https://microk8s.io/docs/registry-built-in>`_
* `Command reference <https://microk8s.io/docs/commands>`_

Notes
-----

* The only way to install MicroK8S on Linux is via a snap.
  (Possibly inside a multipass VM.)::

    sudo apt install snapd -y
    sudo snap install microk8s --classic --channel=1.17/stable

* Add your user to the group to get auth to admin microk8s::

    sudo usermod -a -G microk8s $USER

  Since group changes only take effect on login, either logout and
  back in now, or you can get the same effect in a terminal with::

    su - $USER

* Wait for the install to finally complete - it continues in the background
  after "snap install" completes, apparently::

    microk8s.status --wait-ready
