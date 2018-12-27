.. index:: ! Kobo

Kobo ereader
============

Activating without connecting to kobo on the internet
-----------------------------------------------------

* Start up the kobo. It'll ask if you want to setup over wifi or not. Say not.
* Plug the kobo into your computer using a USB cable.
* On my laptop, it mounts automatically at /media/usb0; I don't know if I set that up somehow in the past.
* Use sqlite3 to add a dummy user::

    $ sqlite3 /media/usb0/.kobo/KoboReader.sqlite3
    sqlite> INSERT INTO user (UserID, UserKey, UserDisplayName, UserEmail) values("00000000-0000-0000-0000-000000000000","00000000-0000-0000-0000-000000000000","MyDummyUser@dummy.com","MyDummyUser@dummy.com");
    sqlite> .quit

Before rebooting, continue by manually updating the latest firmware, see next section.

Manually updating firmware
--------------------------

* Download a zipfile with the latest firmware for your Kobo device from
  `this wiki page <https://wiki.mobileread.com/wiki/Kobo_Firmware_Releases>`_
* The Kobo should be mounted over USB as above.
* Change to the kobo's ``.kobo`` directory
* Unpack the zipfile containing the firmware update
* Properly unmount the Kobo
* Unplug the USB cable

Within a minute or so, the Kobo should notice the update, install it,
and reboot.

KFMon Files monitor
-------------------

-- probably better to use KSM for me

* `github project <https://github.com/NiLuJe/kfmon>`_
* `more recent install instructions
  <https://github.com/koreader/koreader/wiki/Installation-on-Kobo-devices#alternate-installation-method-based-on-kfmon>`_
  are here (combined with install KOReader instructions)
* For historical interest only:
  `original discussion <https://www.mobileread.com/forums/showthread.php?t=218283>`_
  but the download link there no longer works, and you shouldn't use that old
  version anyway.

Installing KSM 09
-------------------

* do NOT use the regular KSM 09 download, see the warning in the first post
* https://www.mobileread.com/forums/showthread.php?t=293804

Installing KSM (Kobo Start Menu) 08
--------------------------------

* `instructions <https://www.mobileread.com/forums/showthread.php?t=240302>`_
* `download v8 zipfile <https://www.mobileread.com/forums/showthread.php?t=266821>`_
* follow the instructions, they're not bad
* One thing easy to miss: once it's starting okay,
  "From the home menu select "tools" > "activate" > "set runmenu settings.msh."
  There you will find the options "always," "once," etc. Choose "always" to make
  the Kobo Start Menu appear after each time you power the device on.)"

Installing Koreader
-------------------

* Download the latest koreader release from `here <https://github.com/koreader/koreader/releases>`_
* Follow the instructions from above

Sideloading books
-----------------

Just mount on USB as above and copy epub files to the root directory of the kobo,
or to any subdirectory (except subdirs starting with ".", which it won't look in).
