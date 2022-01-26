Homeassistant in jail?
----------------------

maybe something like this (from chapter 22 of Abs. FreeBSD 3)...

* Add another IP address (alias) in /etc/rc.conf, e.g.::

    ifconfig_re0_alias0="inet 192.168.0.205/32"

* Enable jails in /etc/rc.conf::

    jail_enable=YES

That'll start everything in /etc/jail.conf at boot time, good enough for now.

* Download base.txz if I don't have it already::

    curl http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/13.0-RELEASE/base.txz

* Make a dir for the jail::

    mkdir -p /jails/ha.home

* Unpack base there::

    tar -xpf base.txz -C /jails/ha.home

* Create or add to /etc/jail.conf::

    ha {
      host.hostname="ha.home";
      ip4.addr="192.168.0.205";
      path="/jails/ha.home";
      mount.devfs;
      exec.clean;
      exec.start="sh /etc/rc";
      exec.stop="sh /etc/rc.shutdown";
    }

* copy some things from the host::

    cp /etc/resolv.conf /etc/localtime /jails/ha.home/etc
    touch /jail/ha.home/etc/fstab

* Create /jails/ha.home/etc/rc.conf::

    sendmail_enable="NO"
    sendmail_submit_enable="NO"
    sendmail_outbound_enable="NO"
    sendmail_msp_queue_enable="NO"
    syslogd_enable="NO"
    cron_enable="NO"

* Try starting it, then stopping it::

    jail -c ha
    jls
    jexec ha ps -ax
    jexec ha /bin/sh
    jail -r ha

* Back on the host, do some package installs into the jail::

    jail -c ha
    pkg -j ha install rust py38-pip py38-sqlite3 jpeg-turbo

(Yes, you have to install a whole additional language,
Rust, in order to build the Python cryptography package.
Sigh.)

* Install homeassistant in the system::

    jexec ha pip-3.8 install homeassistant

* Start it running::

    jexec ha hass

Give it a few minutes, then try going to
http://192.168.0.205:8123 to continue setting it up.
