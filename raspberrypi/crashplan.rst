Crashplan on Raspberry PI
=========================

Good blog post: http://www.bionoren.com/blog/2013/02/raspberry-pi-crashplan/
    READ THE COMMENTS!


I made a number of changes, e.g.:

Use Oracle Java: http://www.raspberrypi.org/archives/4920

        sudo apt-get update && sudo apt-get install oracle-java7-jdk

See first my SimpleNote: "USB drive with Raspberry PI", then continue here


- Install oracle Java:

        sudo apt-get update && sudo apt-get install oracle-java7-jdk

- Download [crashplan](http://www.crashplan.com/consumer/download.html?os=Linux) and extract it

- Run the crashplan installer (Crashplan-install/install.sh). I’ll assume that you installed to the default /usr/local/crashplan/. If you get an error “The current version of Java (1.8) is incompatible with CrashPlan”, edit install.sh and change OKJAVA="1.5 1.6 1.7" to OKJAVA="1.5 1.6 1.7 1.8"

- (It'll say it started, but it'll crash immediately so don't worry about it yet.)

- download some fixed/extra files:

        wget http://www.jonrogers.co.uk/wp-content/uploads/2012/05/libjtux.so
        wget http://www.jonrogers.co.uk/wp-content/uploads/2012/05/libmd5.so

- copy:

        sudo cp libjtux.so libmd5.so /usr/local/crashplan

- Install libjna-java:

        sudo apt-get install libjna-java

- Hack:
edit /usr/local/crashplan/bin/CrashPlanEngine and find the line that *begins* with FULL_CP=
(its around the start case)
add /usr/share/java/jna.jar: to the begining of the string. This fixes the cryptic “backup disabled — not available” error.  I ended up with:

                   FULL_CP="/usr/share/java/jna.jar:$TARGETDIR/lib/com.backup42.desktop.jar:$TARGETDIR/lang"

- This will backup by default to /usr/local/var/crashplan.  We'll fix that next.  But for now, reboot and make sure crashplan is now running:

        sudo reboot
        ... wait, log back in ...
        /usr/local/crashplan/bin/CrashPlanEngine status

Nope, it's stopped.  Did I miss a step?

From a crashplan log (/usr/local/crashplan/log/engine_output.log):

        Exiting!!! java.lang.UnsatisfiedLinkError: /usr/local/crashplan/libjtux.so: /usr/local/crashplan/libjtux.so: cannot open shared object file: No such file or directory (Possible cause: can't load IA 32-bit .so on a ARM-bit platform).

But that could well be from the initial attempt to start, before we replaced the .so file.

Deleted log file, tried "sudo service crashplan start" again, checked status again...  it's running.   So maybe it's just not being started at boot?  The installer implied it would be...

There's a rc2.d/S99crashplan which is promising.  Try booting again, and wait a sec?

Nope, after several minute, still stopped.

Try this:

        sudo update-rc.d crashplan defaults
        reboot

Yes!  It's running.

now continue with my "Backing up to ReadyNAS using Crashplan on RaspberryPI" simplenote.
