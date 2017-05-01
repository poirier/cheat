MPD
===

Fixing on Ubuntu
----------------

On Ubuntu, mpd is installed broken. You'll have to go read
`this page <https://help.ubuntu.com/community/MPD>`_ and do
some work to fix things so mpd will actually work on Ubuntu.
Sigh.

.. IMPORTANT::
    To play *anything*, you must first get it into the current playlist.
    Even if you just want to play one thing.

Playlist commands
-----------------

Commands that change the playlist:

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
save <name>
    Save current playlist as database playlist with name <name>.
load <name>
    *Add* contents of database playlist named <name> to the
    current playlist.
rm <name>
    Delete database playlist named <name> from database.

Playing things
--------------

Status:

playlist [-f <format>]
    List songs in current playlist. See "man mpc" for format string syntax.
current
    Show what's playing right now

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
