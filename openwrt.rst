OpenWRT
=======

* `Table of Hardware <https://openwrt.org/toh/start>`_

UCI
---

`The Unified Configuration Interface (UCI) <https://openwrt.org/docs/guide-user/base-system/uci>`_

The files with the actual config are under /etc/config. These files have a consistent
syntax and a set of ``uci`` commands that can be used to modify them.

The data in these files is used
to write/update whatever tool-specific config files the various tools expect.

You can edit the files manually, or use ``uci set`` and other commands to change them.

When done, use ``uci commit`` to apply the updated uci config files to the individual
unix tools' own config files. Then either reboot, or figure out how to restart the
affected services, e.g. ``/etc/init.d/uhttpd restart`` to restart the uhhtpd web server.

There's a lot more info about specific ``uci`` commands at the link above.

Irqbalance
----------

`irqbalance package <https://openwrt.org/packages/pkgdata/irqbalance>`_

Irqbalance spreads the work of handling network traffic across all of a
modern processor's cores, which is often necessary these days to manage
gigabit speeds.

Install the package. Edit /etc/config/irqbalance to enable it. Reboot.

(Per `this forum post <https://forum.openwrt.org/t/enabling-irqbalance/98750/2>`_,
it's no longer necessary in 21.02 to manually start the irqbalance
program from /etc/rc.local or similar.)
