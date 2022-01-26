Android information
===================

Contents:

.. toctree::
   :maxdepth: 1

   nexus6p

.. contents::

The following information is not specific to any Android device.
See the links just above for device-specific info.

Android universal instructions (custom roms etc)

See device-specific pages for how to get into recovery mode, fastboot mode, etc etc

Installing adb and fastboot on a computer
-----------------------------------------

(not the android, a linux or windows or something)

`https://developer.android.com/studio/releases/platform-tools.html <https://developer.android.com/studio/releases/platform-tools.html>`_

Just download the zip, unpack, and put the binaries on your PATH or something.

Custom recovery
---------------

(Pre-req to install custom ROM)

https://www.xda-developers.com/how-to-install-twrp/

Download from https://twrp.me/Devices/

Before:

* Install adb and fastboot on a computer
* Enable USB debugging on the android device

To install TWRP:

1. Boot into bootloader mode (e.g. fastboot mode)
2. "fastboot flash recovery twrp-2.8.x.x-xxx.img"
3. "fastboot reboot"

ALTERNATIVELY if device is already rooted, you can
`install and use TWRP manager <https://play.google.com/store/apps/details?id=com.jmz.soft.twrpmanager&hl=en>`_


Custom ROM
----------
http://www.android.gs/install-custom-roms-android-devices-guide/

*THIS WIPES ALL YOUR DATA*

1. Copy zipfiles to phone file system
2. Boot into recovery mode
3. select “wipe data factory reset”, “wipe cache partition” and “wipe dalvick cache”.
4. Choose “install zip from SD card” and “choose zip from SD card”. Pick the update file and flash the same.
5. Optional: repeat this operation for applying the Google Apps package.
6. Reboot

Kernel
------
(as opposed to the whole ROM)

With fastboot
.............

1. Plug in the phone and boot to fastboot mode (back+power or camera+power).  Wait until the screen with skating ‘droids appears,
2. press the back button (the center bar should say "Fastboot" or "Fastboot USB")
3. On the computer::

        fastboot flash boot boot.img
        fastboot reboot
