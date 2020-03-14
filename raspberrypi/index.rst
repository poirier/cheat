Raspberry Pi
============

.. toctree::
   :maxdepth: 1

   usbdrive

Basic setup
-----------

This assumes a headless install on a RPi.

* Download and install `raspberry imager <https://www.raspberrypi.org/downloads/>`_
* Run ``rpi-imager``
* Follow the instructions to put an OS image on your SD card. I installed Raspbian lite (no desktop).
* Since I'm setting it up headless, there are a few more steps.
  `headless instructions <https://www.raspberrypi.org/documentation/configuration/wireless/headless.md>`_

    * Now mount the boot partition from the SD card (the smaller one).  (e.g. insert SD card, run ``thunar`` or other file browser)
    * Create an empty file named ``ssh`` in the root of the boot partition.
    * If you need to connect now using wireless, create a ``wpa_supplicant.conf`` file in the root of the boot partition::

        ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
        update_config=1
        country=<Insert country code here>

        network={
         ssid="<Name of your WiFi>"
         psk="<Password for your WiFi>"
        }

    * Unmount

* Put the SD card into the RPi.
* If using wired ethernet, hook up the ethernet cable. If using a wifi dongle, insert it.
* Plug in the power.
* Wait a bit. Check your router admin to see what address it ended up at.
  On mine it came up as ``raspberrypi.mynet`` (.mynet is my local network domain).
* ``ssh pi@raspberrypi.mynet``. Password is ``raspberry``.
* Create a new user::

    sudo adduser poirier

* Set a password::

    sudo passwd poirier

* To enable sudo for the user, edit the ``sudoers`` file by running ``sudo visudo``
  and add a line like ``poirier ALL=(ALL:ALL) NOPASSWD:ALL``
* Log out
* ``ssh poirier@raspberrypi.mynet``
* Delete the old ``pi`` user::

    sudo deluser --remove-all-files pi

fd81:910:aeeb:0:f607:3571:987b:4cda

│ Configure your devices to use the Pi-hole as their DNS server      │
                                                          │ using:                                                             │
                                                          │                                                                    │
                                                          │ IPv4:        192.168.4.132                                         │
                                                          │ IPv6:        fd81:910:aeeb:0:f607:3571:987b:4cda                   │
                                                          │                                                                    │
                                                          │ If you set a new IP address, you should restart the Pi.            │
                                                          │                                                                    │
                                                          │ The install log is in /etc/pihole.                                 │
                                                          │                                                                    │
                                                          │ View the web interface at http://pi.hole/admin or                  │
                                                          │ http://192.168.4.132/admin                                         │
                                                          │                                                                    │
                                                          │ Your Admin Webpage login password is CdQc6cBY
