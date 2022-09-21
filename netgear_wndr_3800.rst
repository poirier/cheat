Netgear WNDR 3800
=================

Factory reset (from https://web.archive.org/web/20220921151634/https://openwrt.org/toh/netgear/wndr3700,
21 Sept 2022, "Alternate advice"):

* Configure your ethernet connection (on the client machine you're using to configure the WNDR3700) using a static IP as 192.168.1.2, netmask 255.255.255.0. (The WNDR3700 in factory reset mode is going to come up as 192.168.1.1.)
* Connect your computer to one of the LAN (not WAN) ports on the router.
* Start a continuous ping from your client computer to 192.168.1.1 (Linux and Mac OS ping will continue until stopped by default; Windows ping by default sends 4 pings and then stops, so use “ping -t” under Windows); probably nothing will answer these pings yet, but you can use the output to tell you when the router is ready in the next couple steps.
* Power the router off.
* Hold down the factory reset button on the bottom of the case. Now turn the router back on while continuing to hold the factory reset button…
* Wait until the router is listening on 192.168.1.1 (this takes 45-60 seconds; to confirm, you can ping 192.168.1.1, and see if it responds; it's best to start a sequence of ping requests above, before your hands get busy with the factory reset button).
* Release the factory reset button. (If you happen to have a serial cable connected, you'll see that the system is in firmware recovery mode and that it will be waiting for you to upload firmware. But you don't need the serial cable at all.)
* Run a tftp CLIENT on your computer (enter no hostname on the command line) and enter the following::

    verbose
    trace
    rexmt 1
    binary
    connect 192.168.1.1
    put WNDR3700-V1.0.4.35NA.img (or whatever the filename is that you are trying to flash)

Once done, the router will flash itself to the stock NETGEAR firmware file that you provided and reboot automatically.
