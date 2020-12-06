MPD
===

https://www.musicpd.org/

Getting the service running
---------------------------

At one time, mpd was installed broken on Ubuntu. As of 20.04, it's set up
pretty well by default. I don't know when this was fixed.

On Ubuntu 20.04, by default mpd is set up to run as a system service, so
that's good. And the default ``/etc/mpd.conf`` file tells it to drop root privileges
and run as the ``mpd`` user.

As a system service, it's much easier to use ALSA for output than
Pulseaudio, and the default configuration does that.

To use ALSA, the ``mpd`` user has to belong to the ``audio`` group,
and it does.

One thing I'll change in ``/etc/mpd.conf`` is to listen either on all
interfaces, or at least some besides localhost, so I can control it from
other systems.

The default configuration uses the default ALSA hardware device. If
that's not what you want, you can see
https://www.musicpd.org/doc/html/plugins.html#alsa-plugin
and use ``aplay -L`` to get a list of all the possible values
for ``device``.  E.g. ``hw:CARD=PCH,DEV=3``.

MPC client
==========

Doc: https://www.musicpd.org/doc/mpc/html/

Playlist commands
-----------------

.. IMPORTANT::
    To play *anything*, you must first get it into the current playlist.
    Even if you just want to play one thing.

Commands for the playlist - unless otherwise specified, these operate
on the current playlist:

playlist
    List the playlist
clear
    Empty the playlist (stops playing if anything was playing)
crop
    Delete all playlist entries *except* the one currently playing
del <number>
    Delete one item from the playlist; 0 means the currently playing item,
    otherwise items are numbered starting at 1.  (To see playlist with numbers,
    try ``mpc playlist | cat -n``.  There's probably a better way.)
add <file>
    Add an item from the database to the current playlist, at the end.
    <file> should be a path to the item, as shown by "mpc ls".
insert <file>
    Like ``add``, only it puts the item immediately after the currently
    playing item, so it'll play next.  If random mode is enabled, it'll
    still be played next.
mv|move <from> <to>
    Move item at position <from> to be at position <to>.
shuffle
    Shuffle the items in the playlist

Commands for persistent playlists:

lsplaylists
    List all saved playlists
playlist <playlist>
    List items in playlist <playlist>
save <name>
    Save current playlist with name <name>.
load <name>
    *Add* contents of saved playlist named <name> to the
    current playlist.  (You can use ``clear`` first to empty the
    current playlist.)
rm <name>
    Delete database playlist named <name> from database.

Playing things
--------------

Status:

current
    Show what's playing right now
playlist [-f <format>]
    List songs in current playlist. See "man mpc" for format string syntax.

Control:

play [<position>]
    Start playing the item at <position> in the playlist.
    Deafult is number 1.
pause
    Pause playing
stop
    Stop playing
next
    Stop playing the current entry from the current playlist
    and start playing the next one.
prev
    Reverse of ``next``.

Playing a playlist from the music database with mpc
---------------------------------------------------

Suppose you have a playlist in the database already - e.g.
a file "/var/lib/mpd/playlists/WCPE.m3u" that you've created
earlier.

Now you want to play that playlist.

.. code-block:: bash

    $ mpc clear
    $ mpc lsplaylists
    WUNC
    WCPE
    Favorites
    $ mpc load WCPE
    loading: WCPE
    $ mpc play
    volume: 96%   repeat: on    random: off   single: off   consume: off
    loading: WCPE
    http://audio-ogg.ibiblio.org:8000/wcpe.ogg
    [playing] #1/1   0:00/0:00 (0%)
    volume: 96%   repeat: on    random: off   single: off   consume: off
