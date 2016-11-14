IPv6
====

Localhost
---------

Localhost is `::1`

Any addr
--------

Any addr (equivalent of 0.0.0.0) is `::`

With port
---------

Adding ":<portnumber>" to an IPv6 address would be ambiguous. The
solution is to put "[]" around the address part, e.g. `[::1]:8000`.

URLs with IPv6 addresses
------------------------

You need the `[]` here too, at least if you're using a hexadecimal
IPv6 address. (Even without a port number.)::

    http://[fe80::b746:6473:e65f:5dd4]/foo/bar
    http://[fe80::b746:6473:e65f:5dd4]:8000/foo/bar

Ping
----

Use ping6::

    ping6 ::1

Django
------

To run a local dev server listening on any IPv6 address::

    python manage.py runserver --ipv6 "[::]:8000"

It does NOT appear possible to have the dev server listen on both IPv4 and IPv6,
at least not in Django 1.8.  (But I'm sure you could put nginx in front to do that
for you.)

Private IPv6 network addresses
------------------------------

Try http://simpledns.com/private-ipv6.aspx to get a random private address range.

Example output::

    Here is a unique private IPv6 address range generated just for you (refresh page to get another one):

    Prefix/L:	  fd
    Global ID:	  442da008f4
    Subnet ID:	  cf4f
    Combined/CID:	  fd44:2da0:08f4:cf4f::/64
    IPv6 addresses:	  fd44:2da0:08f4:cf4f:xxxx:xxxx:xxxx:xxxx

    If you have multiple locations/sites/networks, you should assign each one a different "Subnet ID", but use the same "Global" ID for all of them.

To add an address to your loopback interface::

    sudo ifconfig lo add fd44:2da0:08f4:cf4f::1/64

Find out your ipv6 address
--------------------------

In theory, run "ifconfig" and look for "inet6 addr".  E.g.::

    enp0s25   Link encap:Ethernet  HWaddr 54:ee:75:8b:03:99
              inet addr:172.20.1.110  Bcast:172.20.3.255  Mask:255.255.252.0
              inet6 addr: fe80::b746:6473:e65f:5dd4/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

Try to find an "inet6 addr" that isn't "Scope:Link" or "Scope:Host"; you want
"Scope:Global".

Better way - if you think you have real IPv6 connectivity to the internet,
go to google.com and search for "what's my IP".  If you're connecting to
Google over IPv6, Google will tell you your IPv6 address (which might be
a NATting router, I suppose - I don't know if IPv6 still does that?)
But that won't help if you're just running IPv6 locally for testing.
