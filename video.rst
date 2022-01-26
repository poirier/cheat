Video
=====
.. contents::

Video tools to use on Linux

makemkv
-------

CLI good for ripping DVDs and Blu-Rays to mkv.

(Has GUI too.)

mkvinfo
-------

Find out lots of data about an mkv file.

mkvmerge
--------

CLI only.

Join mkv streams end-to-end without re-encoding.

Split mkv streams after timestamps or chapters without re-encoding.

Examples::

    mkvmerge --split timestamps:00:48:01.044833333,01:47:12.659566666 title_t00.mkv --output parts-%d.mkv
    mkvmerge --split chapters:5,8 title_t00.mkv --output parts-%d.mkv

avidemux
--------

.. warning:: DO NOT USE! Does not include subtitles in output and there's apparently no way to make it do that.  See instead "mkvmerge".

Was: GUI tool that's good for chopping up longer videos into shorter pieces without re-encoding
when you need to watch the video and scan back and forth to find the places you want to
split.
