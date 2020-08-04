Logitech Harmony
================

Harmony Hub
...........

To change which button invokes which activity on the remote, do:

* MENU
* Harmony Setup
* Add/Edit Devices
* REMOTE & HUB
* BUTTON CUSTOMIZATION
* ACTIVITY CONTROL BUTTONS

Programming it using Linux
..........................

I have the Harmony One model (no longer produced).

Some of this information comes from
`http://ubuntuforums.org/showthread.php?t=781059 <http://ubuntuforums.org/showthread.php?t=781059>`_,
but I'm not using the GUI tool (congruity), just command line.

Help :ref:`harmony_devices` for finding devices.

.. toctree::
   :maxdepth: 1

   devices

Install Concordance
-------------------

Install the `concordance <http://www.phildev.net/concordance/>`_ tool.

I'm using v1.0 on Ubuntu 15.10 64-bit.

Briefly::

    sudo apt-get install libusb-dev libzzip-dev
    wget http://downloads.sourceforge.net/project/concordance/concordance/1.0/concordance-1.0.tar.bz2
    tar xjf concordance-1.0.tar.bz2
    cd concordance-1.0/libconcord
    ./configure
    make
    sudo make install
    sudo ldconfig
    cd ../concordance
    ./configure
    make
    sudo make install


Arrange to run without needing sudo
-----------------------------------

* Run 'lsusb' to see what devices are already attached to your computer.
* Plug in your remote
* Run 'lsusb', looking for the device that wasn't there before.  E.g. my Harmony One produced this::

    Bus 001 Device 021: ID 046d:c121 Logitech, Inc.

* Unplug the remote
* Now (using sudo as needed) create a new file, /etc/udev/rules.d/custom-concordance.rules, substituting in the values for your own remote::

    ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c121", MODE="666"

* Test

  * Plug the remote in
  * Run "concordance -i".  It should print out information about the attached remote

Programming the remote
----------------------

* Make a directory to hold firmware and config backups, e.g. ~/Documents/LogitechHarmonyOne.
* `cd ~/Documents/LogitechHarmonyOne`
* Backup firmware if you haven't previously::

    concordance --dump-firmware <filename> (default: firmware.EZUp)

* Backup config if you haven't previously::

    concordance --dump-config <filename>  (default: config.EZHex)

* Go to `http://members.harmonyremote.com/EasyZapper/ <http://members.harmonyremote.com/EasyZapper/>`_ and log in  (ignore the message  about upgrading your software).  If you don't already have an account, create one.
* Update your remote's configuration using the web site.
* When ready to update your remote:

  * Click "Update your remote". It'll prompt to connect your remote.
  * Connect the remote to the computer via USB.
  * Click "Next" on the web page.
  * Your browser will download a file named "Connectivity.EZHex".  Save it to your LogitechHarmonyOne directory.
  * Go to your shell.
  * Run::

        concordance Connectivity.EZHex

  * Go back to your browser.
  * Click "Next".
  * Wait... could be several minutes.
  * Eventually your browser will download a file named "Update.EZHex". Save it to your LogitechHarmonyOne directory.
  * Go to your shell.
  * Run this command.  This will take quite a while (5 minutes?), but it will print progress status as it goes::

        concordance Update.EZHex

  * When that's done, disconnect your remote and try it out.
