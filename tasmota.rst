Tasmota
=======

* `tasmota <https://tasmota.github.io/docs/>`_
* `tuya-convert <https://github.com/ct-Open-Source/tuya-convert>`_
* `HomeAssistant <https://www.home-assistant.io/docs/mqtt/discovery/>`_

Setup
-----

One-time steps.

On the laptop you'll be using to flash and configure the devices:

* Git clone tuya-convert
* cd to that directory
* run ./install_prereq.sh

.. note:: It's not obvious, but the ``tasmota.bin`` file included with tuya-convert is a stripped-down version. Don't try to install the full version of Tasmota with tuya-convert. Install the provided version, then upgrade to the full version.

Wherever you want to run the MQTT broker:

* apt-get install mosquitto

In HomeAssistant:

`https://www.home-assistant.io/docs/mqtt/discovery/ <https://www.home-assistant.io/docs/mqtt/discovery/>`_

* Go to Configuration/Integrations.
* "Search Integrations" for MQTT.
* Add MQTT and configure with the MQTT broker's IP address. Set the topic to something like "homeassistant".

Each device
-----------

This was for EFUN plugs, model SH331W. Tasmota info here:
`<https://templates.blakadder.com/efun_SH331W.html>`_

.. note:: To be safe, do not use the 'official' mobile app with the plugs ever. There's always a chance it'll upgrade them to a new firmware that prevents flashing Tasmota.

Start by running `tuya-convert <https://github.com/ct-Open-Source/tuya-convert>`_
to flash Tasmota to the device.

* Plug in the device. After a short period, the blue light should flash quickly.
* Go to the tuya-convert directory
* Run './start_flash.sh' and follow the directions
* When asked, install "tasmota.bin".

Configure the device WIFI:

**WARNING: TRIPLE_CHECK the WIFI config. If you enter it wrong, you might never be able to access the device again!!!**

* Connect laptop to the new 'tasmota-NNNN' WIFI access point (the device)
* Go to `http://192.168.4.1 <http://192.168.4.1>`_ and you should see the Tasmota interface
* Click "Configure WIFI" and fill in the information for your 2.4GHz WIFI network. Also set a hostname,
  I generally use a short punctuationless string like "readinglight". Submit and it'll restart.
* Connect laptop back to your normal WIFI network.
* Try connecting to `http://hostname <http://hostname>`_, where ``hostname`` is the hostname
  you set. If that doesn't work, use your access point or something to find the device on the network, and browse to it.

Upgrade firmware:

1. If you tuya-converted using the tasmota.bin that came with tuya-convert,
   you should upgrade to the full tasmota.bin at this point.
2. Once you've got the full tasmota.bin flashed, there's no need to upgrade
   again unless you need a new feature or a bug fix. Really!

* Go to the download site `http://ota.tasmota.com/tasmota/ <http://ota.tasmota.com/tasmota/>`_.
* Find the latest ``tasmota.bin.gz`` and *copy the link* (do *NOT* download).
* Click "Firmware Upgrade".
* Find "Update by web server" and paste the link into the "OTA URL" field.
* Start the upgrade.
* It might take several minutes until it's done and you can connect to the device again.

Configure the Tasmota template:

* Find the template for the device at e.g.
  `https://templates.blakadder.com/efun_SH331W.html <https://templates.blakadder.com/efun_SH331W.html>`_.
* Copy the JSON string.
* In the device Tasmota UI, go to Configure Other, paste the template, and select the checkbox.
* Also set Friendly Name 1. I use the hostname I set earlier here too.
* Save. It'll reboot.

Configure MQTT and enable discovery.

* In the device confiGo to Configure MQTT. Fill in the MQTT broker's IP address, and set the Topic to the same string as the Friendly Name 1.
* Submit. It'll reboot.
* Go to Console. In the command line, enter "SetOption19 1" and hit Enter.

Time zone.

If you're going to use the built-in Tasmota timer function, the device's time zone
will need to be set. I haven't done that (using time triggers from Homeassistant instead).
