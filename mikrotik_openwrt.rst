Installing OpenWRT on Mikrotik hAP |ac2|
========================================

.. contents::

Useful links
------------

* `Mikrotik hAP ac2 product page <https://mikrotik.com/product/hap_ac2>`_
* `OpenWRT Mikrotik hAP ac2 page <https://openwrt.org/toh/mikrotik/mikrotik_hap_ac2>`_
* `OpenWRT common Mikrotik page <https://openwrt.org/toh/mikrotik/common>`_

State of OpenWRT support
------------------------

Right now the stable release of OpenWRT is `19.07.7 <https://openwrt.org/releases/19.07/notes-19.07.7>`_,
which does not include support for Mikrotik hAP |ac2|. The latest dev snapshot does support it, but the
latest dev snapshot is not built with Luci, the OpenWRT web admin tool.  So for now, we have to do some
OpenWRT things by ssh'ing to the router and using the command line.  It'll get simpler whenever a new
OpenWRT release is made that includes support for this device.

Difficulties using a Snapshot Openwrt build
-------------------------------------------

The biggest difficulty with using a snapshot build is that it tends to get
rebuilt as often as daily with the latest code, along with its packages, and
the previous builds are not kept. So within a day or so of installing a
snapshot build, you might find that none of the packages available are compatible
with your now old snapshot build. At that point if you really need to install a
new package you have to install the latest snapshot.

It's simplest after installing a snapshot build to go ahead and immediately
install all the packages you think you might want.

Overview of the process
-----------------------

This is for installing OpenWRT on a "new" router that doesn't have OpenWRT
on it already. Once this has been done, you can use the normal OpenWRT
upgrade process.

1. Download the OpenWRT files for the router and prepare a script for TFTP/DHCP.

2. Save the RouterOS key file from the router

3. Temporarily boot OpenWRT on the router using TFTP/DHCP

4. Transfer the OpenWRT upgrade file to the router

5. Install OpenWRT onto the router

6. Install the Luci web interface.

Requirements
------------

I'm assuming your computer is a Linux computer using an Ethernet cable to connect to the Internet.

Your computer must have ``dnsmasq`` and a browser installed.

Steps
-----

Download the files
..................

Go to the `OpenWRT Mikrotik hAP ac2 page <https://openwrt.org/toh/mikrotik/mikrotik_hap_ac2>`_,
scroll down to "Installation",
and download both the "Firmware OpenWrt snapshot Install"
and "Firmware OpenWrt snapshot Upgrade" files. The filenames will look like
openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-initramfs-kernel.bin
and openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-squashfs-sysupgrade.bin

In the same directory, create a file ``loader.sh`` starting with the following::

    #!/bin/bash
    USER=root
    IFNAME=eth0
    FILENAME=openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-initramfs-kernel.bin
    sudo /sbin/ip addr replace 192.168.1.10/24 dev $IFNAME
    sudo /sbin/ip link set dev $IFNAME up
    sudo /usr/sbin/dnsmasq --user=$USER \
    --no-daemon \
    --listen-address 192.168.1.10 \
    --bind-interfaces \
    -p0 \
    --dhcp-authoritative \
    --dhcp-range=192.168.1.100,192.168.1.200 \
    --bootp-dynamic \
         --dhcp-boot=$FILENAME \
         --log-dhcp \
    --enable-tftp \
    --tftp-root=$(pwd)

Change the ``IFNAME`` to the interface name of the Ethernet interface on
your computer.  (Run ``ip a`` to see your interface names.)

Change the ``FILENAME`` to the name of the ``initramfs`` file you downloaded.

Make the script executable::

    $ chmod +x loader.sh


Save the RouterOS key file
..........................

The router comes with RouterOS installed and a valid key for it. We want to save that key
before we install OpenWRT, so that if we ever want to go back to RouterOS, we don't have
to buy another license for it.

These instructions are adapted from
`https://openwrt.org/toh/mikrotik/common#saving_mikrotik_routerboard_license_key_without_using_winbox <https://openwrt.org/toh/mikrotik/common#saving_mikrotik_routerboard_license_key_without_using_winbox>`_.

1. With no network cables connected to the router, connect the router to power and wait for it to finish starting.
2. Connect your computer's ethernet to the router's *ethernet port 2 (a LAN port)*.
3. Visit `http://192.168.88.1 <http://192.168.88.1>`_. You should see RouterOS. If this is the
   first time, you might need to let it apply the default configuration and restart. Then
   continue.
4. In the top right, click the "Terminal" button.  You should get a page that looks like a terminal
   with a command prompt like ``[admin@MikroTik] >``.
5. At the prompt, copy the key to a file by typing::

    /system license output

6. Now visit `http://192.168.88.1/webfig/#Files <http://192.168.88.1/webfig/#Files>`_
   and you should see a list of files.

7. Next to the ``.key`` file, click the "Download" button and download the file.

8. Save the key file someplace safe.

Temporarily boot OpenWRT
........................

1. Visit `http://192.168.88.1 <http://192.168.88.1>`_. You should see RouterOS.

2. In the top right, click the "WebFig" button. You should see a page with a long column of links
   on the left side.

3. In the left-hand column, click "System", then "RouterBOARD".

4. At the top of the right side, click the "Settings" button.

5. Change the following settings:

    Boot Device: "try-ethernet-once-then-nand"

    Boot Protocol: "dhcp"

    Force Backup Booter: Checked

6. Click the "OK" button at the top.

Now the next time the router boots, it'll look on the network for a boot image. If it
fails, it'll boot RouterOS again. In any case, unless the settings are changed again,
it'll go back to booting RouterOS by default.

7. Under "System" on the left, click "Shutdown", and confirm. Wait a little, then unplug power from
   the router, just to be sure.

8. Unplug the network cable from the router, then plug it in to the *WAN port (port #1)*.

9. On your computer, run your loader script to provide a TFTP/DHCP service::

    $ ./loader.sh

10. Connect the router power cable. Shortly you should see output from your loader
    script indicating that the router has downloaded the openwrt file.  Keep
    watching until you see "client provides name: OpenWRT" and a DHCPACK indicating
    that OpenWRT has accepted an IP address from your DHCP server.

11. Kill the script using Control-C.

12. Disconnect the network cable from the router, then plug it into a *LAN port* again.

13. Shortly, you should be able to ping 192.168.1.1 from your computer.

Unfortunately, if you're running a snapshot version of OpenWRT, there's no web
interface to make things simpler from here on.

Transfer the upgrade file to the router
.......................................

On your computer, run::

    $ scp openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-squashfs-sysupgrade.bin root@192.168.1.1:/tmp

Use whatever "sysupgrade" file you had downloaded earlier.

(If you get asked if you're sure you want to continue, answer "yes".
If you get a warning about remote host identification, you might have to run the
suggested command to remove the old ssh key, then try again.)

Install OpenWRT on the router
.............................

1. Ssh into the router::

    $ ssh root@192.168.1.1

There is no password.

2. Run "ls" to make sure the openwrt file is there::

    root@OpenWRT:~# ls /tmp
    openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-squashfs-sysupgrade.bin
    root@OpenWRT:~#

3. Install OpenWRT by running sysupgrade::

    root@OpenWRT:~# sysupgrade /tmp/openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-squashfs-sysupgrade.bin
    <timestamp> upgrade: Commencing upgrade. Closing all shell sessions.
    Connection to 192.168.1.1 closed by remote host.
    Connection to 192.168.1.1 closed.

4. Wait several minutes.  (Until you hear a beep?)

5. Try pinging ``192.168.1.1`` and let it run until you start getting responses,
   then stop it by hitting Control-C::

    $ ping 192.168.1.1
    PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
    64 bytes from 192.168.1.1: icmp_seq=35 ttl=64 time=1.75 ms
    ...
    ^C

Note that you're still running a snapshot version of OpenWRT and there's
no web interface yet.

Install the Luci web interface
..............................

1. Add another ethernet cable, connecting the router's *WAN port (#1)* to the
   *Internet*. You should still have a cable connecting your computer to
   one of the router's LAN ports.

2. Ssh into the router from your computer::

    $ ssh root@192.168.1.1

3. Update the package list::

    root@OpenWRT:~# opkg update

After installing
----------------

Updating
........

You can download the latest snapshot sysupgrade file and apply it
as a normal update through Luci.

.. note:: Afterward you will have to re-install any additional packages you want, including ssh'ing in to install the Luci web interface.

Packages I install after updating OpenWRT
.........................................

* luci
* luci-theme-openwrt
* luci-app-sqm
* luci-app-qos
* `zerotier <https://zerotier.atlassian.net/wiki/spaces/SD/pages/743866369/Router+Firmwares?src=search>`_
* diffutils

E.g.::

    $ ssh root@192.168.1.1
    # opkg update
    # opkg install luci luci-theme-openwrt luci-app-sqm luci-app-qos zerotier diffutils


Using an external drive to get more disk space
...............................................

.. caution:: Backup your config before trying this. *It didn't work for me* and I had to restore a saved config to recover.

I put a 64GB micro-SD card in the USB slot and followed
`these instructions <https://openwrt.org/docs/guide-user/additional-software/extroot_configuration>`_
to move root to the card so I'd have lots of room.


.. |ac2| replace:: ac\ :sup:`2`
