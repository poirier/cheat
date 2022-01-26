Tasmota
=======

* `tasmota <https://tasmota.github.io/docs/>`_
* `tuya-convert <https://github.com/ct-Open-Source/tuya-convert>`_
* `HomeAssistant <https://www.home-assistant.io/docs/mqtt/discovery/>`_
.. contents::

Setup
-----

One-time steps.

On the laptop you'll be using to flash and configure the devices:

* Git clone tuya-convert
* cd to that directory
* run ./install_prereq.sh

.. note:: It's not obvious, but the ``tasmota.bin`` file included with tuya-convert is a stripped-down version. Don't try to install the full version of Tasmota with tuya-convert. Install the provided version, then upgrade to the full version.

MQTT broker
-----------

An MQTT broker needs to be running somewhere. If you have Ubuntu or Debian,
then wherever you want to run the MQTT broker:

* apt-get install mosquitto

Then in HomeAssistant, set up
`MQTT discovery <https://www.home-assistant.io/docs/mqtt/discovery/>`_:

* Go to Configuration/Integrations.
* "Search Integrations" for MQTT.
* Add MQTT and configure with the MQTT broker's IP address. Set the topic to something like "homeassistant".

Each device
-----------

This was for EFUN plugs, model SH331W. Tasmota info here:
`<https://templates.blakadder.com/efun_SH331W.html>`_

.. note:: To be safe, do not use the 'official' mobile app with the plugs, *ever*. There's always a chance it'll upgrade them to a new firmware that prevents flashing Tasmota.

Start by running `tuya-convert <https://github.com/ct-Open-Source/tuya-convert>`_
to flash Tasmota to the device.

* Plug in the device. After a short period, the blue light should flash quickly.
* Go to the tuya-convert directory
* Run './start_flash.sh' and follow the directions
* When asked, install "tasmota-lite.bin".

Configure the device WIFI
-------------------------

**WARNING: TRIPLE_CHECK the WIFI config. If you enter it wrong, you might never be able to access the device again!!!**

* Connect laptop to the new 'tasmota-NNNN' WIFI access point (the device)
* Go to `http://192.168.4.1 <http://192.168.4.1>`_ and you should see the Tasmota interface
* Click "Configure WIFI" and fill in the information for your 2.4GHz WIFI network. Also set a hostname.
  I generally use a short punctuationless string like "readinglight". Submit and it'll restart.
* Connect laptop back to your normal WIFI network.
* Try connecting to `http://hostname <http://hostname>`_, where ``hostname`` is the hostname
  you set. If that doesn't work, use your access point or something to find the device on the network, and browse to it.

Upgrade firmware
----------------

1. If you tuya-converted using the tasmota.bin that came with tuya-convert,
   you should upgrade to the full tasmota.bin at this point, as follows.
2. Once you've got the full tasmota.bin flashed, there's no need to upgrade
   again unless you need a new feature or a bug fix. Really!

* Go to the download site `http://ota.tasmota.com/tasmota/ <http://ota.tasmota.com/tasmota/>`_.
* Find the latest ``tasmota.bin.gz`` and *copy the link* (do *NOT* download).
  At the moment that link is ``http://ota.tasmota.com/tasmota/tasmota.bin.gz``
* Go to the web page for your Tasmota device.
* Click "Firmware Upgrade".
* Find "Update by web server" and paste the link into the "OTA URL" field.
* Check the box.
* Start the upgrade.
* It might take several minutes until it's done and you can connect to the device again.

Configure the Tasmota template
------------------------------

* Find the template for the device at e.g.
  `https://templates.blakadder.com/efun_SH331W.html <https://templates.blakadder.com/efun_SH331W.html>`_.
* Copy the JSON string.
  Example for my EFUN plugs, it's ``{"NAME":"Efun-Plug","GPIO":[56,0,158,0,0,134,0,0,131,17,132,21,0],"FLAG":0,"BASE":18}``.
* In the device Tasmota UI, go to *Configure Other* (*not* Configure Template,
  that's for editing the details of the template), paste the template, and select the checkbox.
* Also set Friendly Name 1. I use the hostname I set earlier here too.
* Save. It'll reboot.

Configure MQTT and enable discovery for Home Assistant
------------------------------------------------------

* In the device confiGo to Configure MQTT. Fill in the MQTT broker's IP address, and set the Topic to the same string as the Friendly Name 1.
* Submit. It'll reboot.
* Go to Console. In the command line, enter "SetOption19 1" and hit Enter.

Time zone.
----------

If you're going to use the built-in Tasmota timer function, the device's time zone
will need to be set.  Daylight Saving Time makes this... fun.

I'm in US Eastern. The offsets from UTC are EST -5, EDT -4, or in minutes::

    EST: -5 * 60 minutes = -300  TimeSTD
    EDT: -4 * 60 minutes = -240  TimeDST

Let's work this out. Go to https://tasmota.github.io/docs/Commands/ and search for TimeSTD,
and we find::

    Set policies for the beginning of daylight saving time (DST) and return back to standard time (STD)
    0 = reset parameters to firmware defaults
    H,W,M,D,h,T
    H = hemisphere (0 = northern hemisphere / 1 = southern hemisphere)
    W = week (0 = last week of month, 1..4 = first .. fourth)
    M = month (1..12)
    D = day of week (1..7 1 = sunday 7 = saturday)
    h = hour (0..23)
    T = timezone (-780..780) (offset from UTC in MINUTES - 780min / 60min=13hrs)
    Example: TIMEDST 1,1,10,1,2,660
    _If timezone is NOT 99, DST is not used (even if displayed) see

USA rules are at
https://www.nist.gov/pml/time-and-frequency-division/popular-links/daylight-saving-time-dst
and say that daylight saving time in the United States:

* begins at 2:00 a.m. on the second Sunday of March (at 2 a.m. the local time time skips ahead to 3 a.m. so there is one less hour in the day).
* ends at 2:00 a.m. on the first Sunday of November (at 2 a.m. the local time becomes 1 a.m. and that hour is repeated, so there is an extra hour in the day).

So the commands for US Eastern will be::

    TimeSTD 0,1,11,1,2,-300
    TimeDST 0,2,3,1,2,-240
    TimeZone 99

All-in-one
----------

You can speed up some of this if you're doing it over and over using the Backlog command, which lets you
string multiple commands together in the Console. E.g.::

    Backlog FriendlyName efun-f;DeviceName efun-f;Hostname efun-f; Topic efun-f; MqttHost 192.168.1.2; SetOption19 1;TimeDST 0,2,3,1,2,-240;TimeSTD 0,1,11,1,2,-300;TimeZone 99;Latitude 35.913200; Longitude -79.055847

The available commands are documented at `https://tasmota.github.io/docs/Commands/ <https://tasmota.github.io/docs/Commands/>`_.
`Backlog command <https://tasmota.github.io/docs/Commands/#the-power-of-backlog>`_.
