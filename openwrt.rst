OpenWRT
=======

* `Table of Hardware <https://openwrt.org/toh/start>`_

.. contents::

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

DDNS
----

Dynamic DNS with Cloudflare

* Create A & AAAA records on cloudflare with dummy IP addresses.
  (Don't use real addresses. Now you can see when your DDNS works and sets them correctly.)
* Get an API token (not an API key, you want a "token") by going to
  `the user API tokens page <https://dash.cloudflare.com/profile/api-tokens>`_.
  Give the new token access to edit the zone data for your domain.
* On OpenWRT, install "ddns-scripts ddns-scripts-cloudflare ddns-scripts-services luci-apps-ddns"
* You should now have a "Services" item on the main OpenWRT Luci menu, but I didn't right away.
  I reloaded, logged out and in, restarted uhttpd, and somehow later I did have the Services item.
* Go to Services/Dynamic DNS.
* You're going to end up with two services at the bottom of the page, for IPv4 and IPv6.
* Create or edit the ipv4 one:

Enabled
  Check this box
Lookup Hostname
  OpenWRT will try to look up this hostname in DNS and if the resulting IP address is different
  from your current WAN address, will try to update it using DDNS. So put in the fqdn of the
  domain you're trying to do DDNS with.
IP address version
  "IPv4-Address"
DDNS Service provider
  "cloudflare.com-v4". After changing this, there will be a button to change the service. Click
  it before continuing.
Domain
  "name@domain" - **WEIRDNESS** for cloudflare. "domain" should be the domain part of the fqdn
  you're trying to set, and "name" the specific beginning of the fqdn. E.g. if you're trying
  to set up "www.example.com", you would enter "www@example.com" here for some reason.
Username
  "Bearer"
Password
  Enter your API token.
Use HTTP secure
  Check this
Path to CA-Certificate
  /etc/ssl/certs

* Save
* Save & Apply
* Reload the service
* Hopefully things will work. If not, click "Edit" on the service, go to the "Log File Viewer"
  tab, click the "Read / Reread log file" button, scroll to the end, and see if you can figure
  out from the error messages what is wrong.
* Now do IPv6 about the same way, except set "IP address version" to "IPv6-Address".
* I also had to make a change under the "Advanced Settings" tab:

IP address source
  Interface
Interface
  eth1

Otherwise OpenWRT, from the error messages, seemed to fail to figure out its own IPv6 address.

Port Forwarding
----------------

Suppose you want HTTP requests for port 80 arriving at your home IP address to
be handled by a system behind your router. You want to forward port 80 TCP to
that system.

* Go to Network/Firewall.
* Go to the Port Forwards tab.
* Click Add.
* Fill in the form:

Name
  Something to remind you why this is being forwarded.
Protocol
  TCP
External port
  80
Destination zone
  lan
Internal IP address
  IP address of the internal system that should handle the reuest
Internal port
  Can leave blank and it'll go to the same port on the internal system. Or
  enter a different port number to send the request to that port.
