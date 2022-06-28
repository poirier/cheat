Roku
====

Some notes on controlling Roku devices over TCP/IP.

Connecting
----------

To send a command to the Roku, do an HTTP GET or POST to a URL
of the form ``"http://{ipaddress}:8060{path}"``.

.. important:: Using a hostname will not work. You must use the raw IP address. More specifically, unless the Host: header in the HTTP request contains the IP address (not a hostname), the Roku will always return a 403 error.

E.g. to send a remote key (see below), "{path}" looks
like ``"/keypress/{key}"``.

Remote
------

Names of keys that can be used in the API::

    Home Rev Fwd Play Select Left Right Down Up
    Back InstantReplay Info Backspace Search Enter
    VolumeDown VolumeMute VolumeUp PowerOn PowerOff
    ChannelUp ChannelDown  InputTuner InputHDMI1
    InputHDMI2 InputHDMI3 InputHDMI4 InputAV1

HTTP POST to ``/keypress/{keyname}``

Power
-----

To power on or off, send the PowerOn or PowerOff key.

Change apps (channel)
---------------------

To go home, send the Home key.

Otherwise, use a POST ``/launch/{id}``, where {id} is an id
value returned by the query apps command (below).

Device info
-----------

``GET /query/device-info`` and you'll get a response like the one
below.

The most useful thing here is the power status, e.g.
``"<power-mode>Ready</power-mode>"``.  The power is ON if you
get ``"<power-mode>PowerOn</power-mode>"``, and otherwise OFF.

Example response::

    <device-info>
        <udn>298c0003-680f-102c-803a-c0d2f363466b</udn>
        <serial-number>.........</serial-number>
        <device-id>.........</device-id>
        <advertising-id>..........</advertising-id>
        <vendor-name>TCL</vendor-name>
        <model-name>55R615</model-name>
        <model-number>7120X</model-number>
        <model-region>US</model-region>
        <is-tv>true</is-tv>
        <is-stick>false</is-stick>
        <screen-size>55</screen-size>
        <panel-id>20</panel-id>
        <ui-resolution>1080p</ui-resolution>
        <tuner-type>ATSC</tuner-type>
        <supports-ethernet>true</supports-ethernet>
        <wifi-mac>............</wifi-mac>
        <wifi-driver>realtek</wifi-driver>
        <has-wifi-extender>false</has-wifi-extender>
        <has-wifi-5G-support>true</has-wifi-5G-support>
        <can-use-wifi-extender>true</can-use-wifi-extender>
        <ethernet-mac>............</ethernet-mac>
        <network-type>ethernet</network-type>
        <friendly-device-name>55&quot; TCL Roku TV</friendly-device-name>
        <friendly-model-name>TCL•Roku TV</friendly-model-name>
        <default-device-name>TCL•Roku TV - ...........</default-device-name>
        <user-device-name>55&quot; TCL Roku TV</user-device-name>
        <user-device-location>here</user-device-location>
        <build-number>30C.00E04193A</build-number>
        <software-version>11.0.0</software-version>
        <software-build>4193</software-build>
        <secure-device>true</secure-device>
        <language>en</language>
        <country>US</country>
        <locale>en_US</locale>
        <time-zone-auto>true</time-zone-auto>
        <time-zone>US/Eastern</time-zone>
        <time-zone-name>United States/Eastern</time-zone-name>
        <time-zone-tz>America/New_York</time-zone-tz>
        <time-zone-offset>-240</time-zone-offset>
        <clock-format>24-hour</clock-format>
        <uptime>343238</uptime>
        <power-mode>Ready</power-mode>
        <supports-suspend>true</supports-suspend>
        <supports-find-remote>false</supports-find-remote>
        <supports-audio-guide>true</supports-audio-guide>
        <supports-rva>true</supports-rva>
        <developer-enabled>true</developer-enabled>
        <keyed-developer-id>..............</keyed-developer-id>
        <search-enabled>true</search-enabled>
        <search-channels-enabled>true</search-channels-enabled>
        <voice-search-enabled>true</voice-search-enabled>
        <notifications-enabled>true</notifications-enabled>
        <notifications-first-use>true</notifications-first-use>
        <supports-private-listening>true</supports-private-listening>
        <supports-private-listening-dtv>true</supports-private-listening-dtv>
        <supports-warm-standby>true</supports-warm-standby>
        <headphones-connected>false</headphones-connected>
        <supports-audio-settings>false</supports-audio-settings>
        <expert-pq-enabled>1.0</expert-pq-enabled>
        <supports-ecs-textedit>true</supports-ecs-textedit>
        <supports-ecs-microphone>true</supports-ecs-microphone>
        <supports-wake-on-wlan>true</supports-wake-on-wlan>
        <supports-airplay>true</supports-airplay>
        <has-play-on-roku>true</has-play-on-roku>
        <has-mobile-screensaver>true</has-mobile-screensaver>
        <support-url>support.tcl.com/us</support-url>
        <grandcentral-version>7.2.53</grandcentral-version>
        <trc-version>3.0</trc-version>
        <trc-channel-version>6.0.15</trc-channel-version>
        <davinci-version>2.8.20</davinci-version>
        <av-sync-calibration-enabled>1.0</av-sync-calibration-enabled>
    </device-info>



Query apps
----------

Active app
..........

``GET /query/active-app``

Roku off. Or Roku on Home Screen, no screen saver.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app>Roku</app>
    </active-app>

The ``/query/active-app`` command if the user is in the homescreen but the default screensaver is active.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app>Roku</app>
      <screensaver id="55545" type="ssvr" version="2.0.1">Default screensaver</screensaver>
    </active-app>

The ``/query/active-app`` command if the user is in the Netflix app.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app id="12" type="appl" version="4.1.218">Netflix</app>
    </active-app>

The ``/query/active-app`` command if the user is in the Roku Media Player with an active screensaver.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app id="2213" type="appl" version="4.1.1507">Roku Media Player</app>
      <screensaver id="5533" type="ssvr" version="1.1.1">Roku Digital Clock</screensaver>
    </active-app>

To get a list of all apps, ``GET /query/apps``.

Example response querying all apps::

    <?xml version="1.0" encoding="UTF-8" ?>
    <apps>
      <app id="tvinput.hdmi1" type="tvin" version="1.0.0">Computer</app>
      <app id="tvinput.dtv" type="tvin" version="1.0.0">Live TV</app>
      <app id="12" type="appl" version="5.1.98079463">Netflix</app>
      <app id="13" type="appl" version="12.3.2021122417">Prime Video</app>
      <app id="28" type="appl" version="5.5.4">Pandora</app>
      <app id="1453" type="appl" version="2.5.3">TuneIn</app>
      <app id="837" type="appl" version="2.20.93005147">YouTube</app>
      <app id="151908" type="appl" version="6.0.15">The Roku Channel</app>
      <app id="23353" type="appl" version="5.1.2">PBS</app>
      <app id="2213" type="appl" version="5.5.12">Roku Media Player</app>
      <app id="61322" type="appl" version="50.60.70744">HBO Max</app>
      <app id="44191" type="appl" version="4.0.31">Emby</app>
      <app id="26950" type="appl" version="5.5.20">QVC &amp; HSN</app>
      <app id="92207" type="appl" version="4.7.0">WRAL-TV North Carolina</app>
      <app id="615685" type="appl" version="1.1.805">IMDb TV</app>
      <app id="187665" type="appl" version="44.6.2100000011">adult swim</app>
      <app id="30547" type="appl" version="2.0.51">WeatherNation</app>
      <app id="54065" type="appl" version="3.6.2">ABC News Live</app>
      <app id="27536" type="appl" version="5.13.2">CBS News</app>
      <app id="222642" type="appl" version="1.1.0">Radio by myTuner</app>
      <app id="645615" type="appl" version="1.1.1">vTuner Internet Radio</app>
      <app id="9581" type="appl" version="3.1.2">NBC News</app>
      <app id="156835" type="appl" version="1.3.44">My  Music</app>
      <app id="583182" type="appl" version="3.6.2">ABC11 North Carolina</app>
      <app id="260451" type="appl" version="1.0.2">4K Views</app>
      <app id="43483" type="appl" version="1.0.4">Railroads Unlimited</app>
      <app id="42959" type="appl" version="1.3.1">The Train Channel</app>
    </apps>
