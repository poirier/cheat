Linux Notes, Misc.
==================
.. contents::

VPN
---

* Install "openconnect" and "network-manager-openconnect-gnome"
* Set up the VPN through network manager

Here's a partial solution to stop Linux routing ALL traffic through the VPN.
Unfortunately, it also turns off whatever DNS the VPN was providing, so I
need to figure out how to fix that or *no names resolve for anything in the
VPN...*

* open the VPN's connection settings
* go to the IPv4 tab
* click the "Routes" button near the bottom
* check the checkbox "Use this connection only for resources on its network"
* click "OK"
* go to the IPv6 tab and repeat
* save all the changes
* take the VPN down and bring it up again.

Creating RPMS
--------------

* from 'make install': See [http://asic-linux.com.mx/~izto/checkinstall/index.php checkinstall]
* from CPAN packages: See [http://perl.arix.com/cpan2rpm/ cpan2rpm]

Increase open file limit
-------------------------

Edit /etc/security/limits.conf and add or edit::

   hard nofile 2048
   soft nofile 2048

to change the default limits set at login.  Also double-check /etc/profile etc for ulimit commands that might set it lower again.

Trace file operations
---------------------

 strace -F -e trace=file,process -o strace.out ''command''

Changing fonts for GAIM, Sanity, etc.
-------------------------------------

Run gnome-font-properties

You *also* need to start gnome-settings-daemon at login time if you're not running the Gnome desktop.

Q: How do you use anti-aliased fonts in gnome2?

A: You need to set the GDK_USE_XFT environment variable, if you are using bash type 'export GDK_USE_XFT=1'. You should not need to do this - your Linux distribution should do this automatically.  Also AntiAliasingTroubleshooting may help you find the problem with your set-up.

*  __How do you make the entire session use anti-aliased fonts?__

Create a file, '.gnomerc', in your home directory and put in it ::

    #!/bin/sh
    export GDK_USE_XFT=1
    exec gnome-session

Note

If you use a display manager such as gdm, you don't need the "exec gnome-session" line and it may in fact be counterproductive.


You may also have to edit the file /etc/X11/!XftConfig. Look for lines with::


    #
    # Don't antialias small fonts
    #
    match
         any size < 14
         any size > 8
         edit antialias=false;


and comment them out.


Added 7-16-2002


NOTE /etc/X11/!XftConfig is deprecated. Use /etc/fonts/fonts.conf now. (11-26-2002)



*  __Is the Bitstream Vera font anywhere available for download?__

Yes, you can get them from http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/


In debian just type::

        apt-get install ttf-bitstream-vera

In gentoo just type::

        emerge ttf-bitstream-vera


Updated 2003-07-14



* __Where do I put new (downloaded) truetype fonts?__

You can just put them into $HOME/.fonts directory


See http://gnome-hacks.jodrell.net/hacks.html?id=42 for how to make GNOME settings apply elsewhere.
