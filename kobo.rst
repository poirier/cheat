.. index:: ! Kobo

Kobo ereader
============
.. contents::

.. index:: kobo; activation

Activating without connecting to kobo on the internet
-----------------------------------------------------

.. warning:: The SQL statement below may need to change with updates to the Kobo firmware.

* Start up the kobo. It'll ask if you want to setup over wifi or not. Say not.
* Plug the kobo into your computer using a USB cable.
* On my laptop, it mounts automatically at /media/usb0; I don't know if I set that up somehow in the past.
* Use sqlite3 to add a dummy user::

    $ sqlite3 /media/usb0/.kobo/KoboReader.sqlite3
    sqlite> INSERT INTO user values("00000000-0000-0000-0000-000000000000","00000000-0000-0000-0000-000000000000","MyDummyUser@dummy.com","MyDummyUser@dummy.com","000011");
    sqlite> .quit

Before rebooting, continue by manually updating the latest firmware, see next section.

Adding fonts
------------

.. index:: kobo; fonts

`instructions <https://www.mobileread.com/forums/showpost.php?p=2404011&postcount=1>`_

Briefly, mount kobo, create ``fonts`` dir at top level (should be next
to ``.kobo``), and copy font files there.

Manually updating firmware
--------------------------

The most recent firmware may now be at https://pgaskin.net/KoboStuff/kobofirmware.html.
Older versinos may be found at https://wiki.mobileread.com/wiki/Kobo_Firmware_Releases.

* Download a zipfile with the latest firmware for your Kobo device from one of the links above.
* The Kobo should be mounted over USB as above.
* Change to the kobo's ``.kobo`` directory
* Unpack the zipfile containing the firmware update
* Properly unmount the Kobo
* Unplug the USB cable

Within a minute or so, the Kobo should notice the update, install it,
and reboot.

Installing Koreader
-------------------

* Download the latest koreader release from `here <https://github.com/koreader/koreader/releases>`_
* Follow the instructions from above

KOReader tips and tricks
------------------------

Many from `here <https://www.mobileread.com/forums/showthread.php?t=242906>`_.

* Start Koreader with the last opened file: When in Koreader's File Manager click on the top. A menu will open. Check "Start with last opened file".

* Make Defaults: In some parts of the menu within a book in Koreader you can do a long tap on an entry.
  This will not submit the corresponding event but will pop up a question like "Set [whatever you clicked] as a default for [whatever option group this belongs to]".
  You can e.g. set the default font, font size, font-weight and so on for new books (books that are not in history right now).
  Right now this will not work with menus that use "decrease/increase" instead of the actual values.

Other Screen gestures (some gestures are not recognized by all devices, and some settings are not available for all neither):

* After following links in both EPUB and PDF documents, you can easily go back to the original page by executing a swipe from left to right.
* Two finger Swipe up/down: change the light settings
* Two finger Swipe left: open bookmarks
* Two finger swipe right: open TOC (table of content)
* Long tap on history entry: delete entry from history. If you reopen this book it will be starte from beginning with default settings
* Long tap on file manager entry: file operations (e.g. copy/delete...)
* Long tap on mini bar: open "Go to" menu

Files:

defaults.lua: All default settings.
You can do changes here, but if you install a new version of Koreader this file will get overwritten. Because of that you can copy this file to a new file called defaults.persistent.lua and do changes there. This file will not be overwritten, and all changes done there will be processed after the ones in defaults.lua.
These files are the right place to create tapzones.

KOreader fonts
--------------



KOreader dictionaries
---------------------

* `Vague-ish instructions <https://github.com/koreader/koreader/wiki/Dictionary-support>`_
* go `here <https://tuxor1337.frama.io/firedict/dictionaries.html>`_ and
  download GNU Collaborative International Dictionary of English. You'll end
  up with a file named ``gcide.zip``
* mount Kobo to filesystem
* cd to <mountpoint>/.add/koreader/data/dicts
* unzip ``gcide.zip``.  It'll create a new ``gcide`` directory containing several files
* cleanup unmount & eject

If you want another dictionary, try
`this page <https://gitlab.com/artefact2/wiktionary-to-stardict/blob/master/README.md>_
which has a tool that can download the English Wiktionary and convert to the proper
format to load onto the Kobo, same as above.

Sideloading books
-----------------

Just mount on USB as above and copy epub files to the root directory of the kobo,
or to any subdirectory (except subdirs starting with ".", which it won't look in).
