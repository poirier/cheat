Denon
=====

Some notes on controlling a Denon receiver over TCP/IP.
Some of this might be specific to the model I own.

Connecting
----------

Make HTTP requests to port 80 on the Denon.

For many commands, use ``GET /MainZone/index.put.asp?cmd0={command}``.

Send key
--------

``GET /keypress/{key}``.

Power on and off
----------------

* ``GET /MainZone/index.put.asp?cmd0=PutZone_OnOff/ON``
* ``GET /MainZone/index.put.asp?cmd0=PutZone_OnOff/OFF``

Getting state
-------------

To get the current state, ``GET /goform/formMainZone_MainZoneXml.xml``.

Useful parts of the response include:

* ``<Mute><value>on</value></Mute>`` if muted
* ``<Power><value>ON</value></Power>`` if power is on
* e.g. ``<MasterVolume><value>-28.0</value></MasterVolume>`` (see below for values
  used for volume)
* If power is on, ``<InputFuncSelect><value>DVD</value></InputFuncSelect>`` gives
  the currently selected input.

Example response::

    <?xml version="1.0" encoding="utf-8" ?>
    <item>
    <FriendlyName><value>Denon</value></FriendlyName>
    <Power><value>ON</value></Power>
    <ZonePower><value>ON</value></ZonePower>
    <RenameZone><value>LIVING RM
    </value></RenameZone>
    <TopMenuLink><value>ON</value></TopMenuLink>
    <VideoSelectDisp><value>OFF</value></VideoSelectDisp>
    <VideoSelect><value></value></VideoSelect>
    <VideoSelectOnOff><value>OFF</value></VideoSelectOnOff>
    <VideoSelectLists>
        <value index='ON' >On</value>
        <value index='OFF' >Off</value>
    </VideoSelectLists>
    <ECOModeDisp><value>ON</value></ECOModeDisp>
    <ECOMode><value></value></ECOMode>
    <ECOModeLists>
        <value index='ON'  table='ECO : ON' param=''/>
        <value index='OFF'  table='ECO : OFF' param=''/>
        <value index='AUTO'  table='ECO : AUTO' param=''/>
    </ECOModeLists>
    <AddSourceDisplay><value>FALSE</value></AddSourceDisplay>
    <ModelId><value>2</value></ModelId>
    <BrandId><value>DENON_MODEL</value></BrandId>
    <SalesArea><value>1</value></SalesArea>
    <InputFuncSelect><value>DVD</value></InputFuncSelect>
    <NetFuncSelect><value>NET</value></NetFuncSelect>
    <selectSurround><value>Stereo                         </value></selectSurround>
    <VolumeDisplay><value>Absolute</value></VolumeDisplay>
    <MasterVolume><value>-28.0</value></MasterVolume>
    <Mute><value>off</value></Mute>
    <RemoteMaintenance><value></value></RemoteMaintenance>
    <SubwooferDisplay><value>FALSE</value></SubwooferDisplay>
    <Zone2VolDisp><value>TRUE</value></Zone2VolDisp>
    <SleepOff><value>Off</value></SleepOff>
    </item>


Volume
------

To toggle being muted,
``GET /MainZone/index.put.asp?cmd0=PutVolumeMute/TOGGLE``.
(See above for how to find out if it's currently muted.)

To set volume,
``GET /MainZone/index.put.asp?cmd0=PutMasterVolumeSet/{denon_volume}``.

Setting the volume on the Denon is kind of weird, because the range of
numbers is not 0-100 or anything sensible like that, it's
-79.5dB - 18.0dB .  (I usually have the front display set to another
option that shows the volume as 0-98, but that doesn't seem to affect
the web API.)

So if 0% volume = -79.5dB and 100% volume = 18.0dB,
50% is half-way in-between, or (-79.5 + 18.0) / 2.0 = -30.75.
And so forth... results:

   0%   volume = -79.5dB       0.0
   25%         = -55.125dB    24.375
   50%         = -30.75dB     48.75
   75%         = -6.375dB     73.125
   100%        = 18.0dB       97.5

But let's not use percent, we'd have to keep throwing in 100's.
Decimal is easier, e.g. 0.0 = silent and 1.0 = full volume:

  decimal       denon       denon+79.5    (denon+79.5)/97.5
   0   volume = -79.5dB       0.0         0.0
   0.25       = -55.125dB    24.375       0.25
   0.50       = -30.75dB     48.75        0.5
   0.75       = -6.375dB     73.125       0.75
   1.00       = 18.0dB       97.5         1.0

The resulting formula is:

   decimal volume = (denon Volume + 79.5) / 97.5

and so

   denon volume = decimal volume * 97.5 - 79.5

Inputs
------

To change inputs,
``GET /MainZone/index.put.asp?cmd0=PutZone_InputFunction/{code}``.
Keep reading to learn how to figure out the ``code`` to use.

The most confusing thing about trying to control the Denon over the network
is that each input source has multiple names and ways to identify it.

* You can "rename" inputs via the web interface. These new names are used:

   * on the front panel
   * in the web interface, displaying the currently selected input
   * in the API, returning the currently selected input
   * in the API, included in the status return inside "VideoSelectLists"
     as the text inside the <value> tags:

        <VideoSelectLists>
            <value index='ON' >On</value>
            <value index='OFF' >Off</value>
            <value index='SAT/CBL'>SAT/CBL     </value>
            <value index='DVD'>DVD         </value>
            <value index='BD'>BD          </value>
            <value index='GAME'>GAME        </value>
            <value index='AUX1'>AUX1        </value>
            <value index='AUX2'>AUX2        </value>
            <value index='MPLAY'>My media pla</value>
        </VideoSelectLists>

   It is bizarre to me that the API returns the user's renamed name
   of the current input. And yet, the web interface's remote control
   page does not use these names.  Keep reading.

* The label on the remote control. Also used in the Denon's web interface's
  virtual online remote control. These never change.

* The code used in the API to select a source. These never change, and do not
  match the remote control labels, nor the values returned in the API to tell
  you what input is currently selected.  They can be seen as the value of "index"
  in the XML excerpt above. Also as the final value in each line in the Javascript
  below, excerpted from the Denon web interface's code:

        appendSource($("div#S3 div.btn31"), $("<div>CBL/SAT</div>"), "SAT/CBL");
        appendSource($("div#S3 div.btn32"), $("<div>DVD</div>"), "DVD");
        appendSource($("div#S3 div.btn33"), $("<div>Blu-ray</div>"), "BD");
        appendSource($("div#S3 div.btn34"), $("<div>Game</div>"), "GAME");
        appendSource($("div#S3 div.btn35"), $("<div>AUX1</div>"), "AUX1");
        appendSource($("div#S3 div.btn36"), $("<div>Media Player</div>"), "MPLAY");
        appendSource($("div#S3 div.btn37"), $("<div>TV Audio</div>"), "TV");
        appendSource($("div#S3 div.btn38"), $("<div>AUX2</div>"), "AUX2");
        appendSource($("div#S3 div.btn39"), $("<div>Tuner</div>"), "TUNER");
        appendSource($("div#S3 div.btn310"), $("<div>iPod/USB</div>"), "USB/IPOD");
        appendSource($("div#S3 div.btn311"), $("<div>CD</div>"), "CD");
        appendSource($("div#S3 div.btn312"), $("<div>Bluetooth</div>"), "BT");
        appendSource($("div#S3 div.btn313"), $("<div>Online Music</div>"), "NETHOME");
        appendSource($("div#S3 div.btn314"), $("<div>Media Server</div>"), "SERVER");
        appendSource($("div#S3 div.btn315"), $("<div>Internet Radio</div>"), "IRP");


One more weirdness: There's a remote button labeled "Internet Radio", but
there's no corresponding source. Pressing it sets the source to "Online Music"
and then drills down into the "Internet Radio" part of that.
