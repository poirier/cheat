Nexus 6P
========

This information is specific to the Google/Huawei Nexus 6P.
See also `more universal android info </android/>`_.

Code name: angler

There's lots of information about the Nexus 6P that is nicely
gathered in `this thread <https://forum.xda-developers.com/nexus-6p/general/guides-how-to-guides-beginners-t3206928>`_
on xda-developers.

SEE ALSO: Android universal instructions

Booting into different modes
----------------------------

Enter safe mode
...............

(this will boot with 3rd-party apps disabled):

1. Have Your Nexus 6P Powered on and at the Home Screen
2. Press and Hold the Power Button until You See the ‘Power Off’ Dialog Screen Pop Up,
3. Let Go of the Power Button
4. Then Tap and Hold Your Finger on the “Power Off’ Option.  After Holding for a Few Seconds You’ll be Asked if You Want to Reboot Into Safe Mode.
5. Simply Tap the ‘OK’ Option to Reboot Your Nexus 6P Into Safe Mode.  Then Wait for the Nexus 6P to Reboot

Enter fastboot aka bootloader mode
..................................

(https://www.androidexplained.com/nexus-6p-fastboot-mode/):

This lets you execute certain ADB and Fastboot commands from your computer, get to recovery mode from here.

1. Power Down the Nexus 6P
2. Once the Device is Off, Press and Hold the Power Button and Volume Down Button at the Same Time
3. Continue Holding These Two Buttons Until you See the Special Fastboot Mode Screen
4. When You are in Fastboot Mode, You Can Let Go of These Two Buttons

Enter recovery mode
...................

This lets you do a factory reset, wipe the cache partition or sideload an OTA update, etc.
Also, "reboot bootloader" goes back to fastboot/bootloader mode.

1. Boot the Nexus 6P into Fastboot Mode
2. Once in Fastboot Mode, Press the volume Down Button Twice. This Should Highlight the ‘Recovery’ Option
3. Press the Power Button to Select This Option. This Will Take You to a Black Screen with a Green Android Laying Down
4. Press and Hold the the Power Button, Then Press the Volume Up Button, You’ll Immediately be Taken to the Recovery Mode Menu

Here's a kernel? https://forum.xda-developers.com/nexus-6p/development/kernel-purez-kernel-v2-0-purezandroid-t3636909
https://github.com/purezandroid/purez-kernel-angler

Installing/replacing stuff
--------------------------

Custom recovery
................

This is a pre-req to install custom ROM.

