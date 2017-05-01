LIRC: linux infrared remote control
===================================

`LIRC <http://lirc.org>`_

Intro
-----

This is about how to use an arbitrary infrared remote control (like for
your TV) to control your own program running under Linux.

The end result will be that LIRC will receive signals from your
remote and translate them to keypresses, and your program can
connect to LIRC and get these keypresses as they happen, then do
whatever it wants with them.

Difficulties
------------

One problem I ran into getting started with most of the howtos
and tutorials I found on the web was that almost anything not quite
right in your configuration resulted in things not working with
no indication of what the problem was. That is, you could press
buttons on the remote all day and there was no indication that
the PC was seeing any of it.

Why is this so hard
-------------------

Here's what I *think* is going on, based on how these things
seem to need to be configured etc.

Sending data via infra-red is messy. An infra-red receiver
attached to your computer just continuously measures and
reports the level of infra-red frequency light hitting it.

Then something we'll call a decoder program - e.g. LIRC - has to monitor that continuous
stream of light levels and try to spot it when extra
infra-red from a remote is hitting it, by the pattern of
changes to the levels.

There's no standard on how IR remotes encode data into IR.
So the only reasonable way to make this work is to tell
the decoder what remote or
remotes we're expecting to see commands from, so it can try
to match up what it's seeing to commands from those specific
remotes. Otherwise there are just too many possibilities to
watch for them all.

The unfortunate consequence of this is that if we haven't
told it the right remote, it just won't see any IR commands
at all.

Luckily, there are some very smart people who have built tools
that can look at input from a remote for a while and try to
guess what remote it is, and we might have to resort to using
them. But it's much easier to use a configuration someone else
has already worked out for us, so we'll try that first.

How to tell if it's working
---------------------------

We need an easy way to tell if LIRC is seeing and correctly
interpreting our remote commands.  We'll use the `irw` tool.

Run ``irw /var/run/lirc/lircd``, then start pressing buttons on
the remote. If things are working, it should print out codes
and key names. If not, you probably won't see anything.

When done, hit `Control-C` to stop `irw`.

The easy start
--------------

So, I'll start with the approach most often documented, that
if it works, is simple. But if this doesn't work, don't waste
a lot of time fiddling with it. Move on to the next section.

This approach will only work if LIRC has a configuration file
for your remote - and you know which one it is.

1. Install LIRC.  On Ubuntu, ``sudo apt install lirc`` should do it.

#. During the install, Ubuntu will prompt you to pick your remote
   so that it can configure LIRC for you. Feel free to try this.

#. If LIRC is already installed, or you want to try a different
   configuration, you can re-run the install-time configuration
   using ``sudo dpkg-reconfigure lirc``.

#. Check if things are working as described above. If they are,
   you can skip down to the section on using LIRC input from a
   program. If not, you can try configurations for other remotes
   that seem likely.

If the easy approach doesn't work
---------------------------------


