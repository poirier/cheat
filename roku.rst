Roku
====

Some notes on controlling Roku devices over TCP/IP.

Names of keys that can be used in the API::

    Home Rev Fwd Play Select Left Right Down Up
    Back InstantReplay Info Backspace Search Enter
    VolumeDown VolumeMute VolumeUp PowerOn PowerOff
    ChannelUp ChannelDown  InputTuner InputHDMI1
    InputHDMI2 InputHDMI3 InputHDMI4 InputAV1



/query/active-app:

Roku off. Or Roku on Home Screen, no screen saver.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app>Roku</app>
    </active-app>

The query/active-app command if the user is in the homescreen but the default screensaver is active.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app>Roku</app>
      <screensaver id="55545" type="ssvr" version="2.0.1">Default screensaver</screensaver>
    </active-app>

The query/active-app command if the user is in the Netflix app.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app id="12" type="appl" version="4.1.218">Netflix</app>
    </active-app>

The query/active-app command if the user is in the Roku Media Player with an active screensaver.::

    $ curl http://192.168.1.134:8060/query/active-app
    <active-app>
      <app id="2213" type="appl" version="4.1.1507">Roku Media Player</app>
      <screensaver id="5533" type="ssvr" version="1.1.1">Roku Digital Clock</screensaver>
    </active-app>

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
