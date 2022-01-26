.. index::  !tmux

Tmux
====
.. contents::

My tmux char: C-g (control-g)

session: a whole set of processes.  Your tmux client is attached to one session.
window:

Bindings::

    Open prompt:    :

    Client:
      detach current:  d
      detach any:      D
      suspend:         C-z

    Sessions:
      rename   $
      select   s
      last     L

    Windows:
      Info:       i
      Create:     c
      Kill:       &
      Switch to:  '
      Choose:     w
      Rename:     ,
      Switch to 0-9: 0-9
      Previously selected:   l
      Next:                  n
      Previous:              p
      Next window with bell   M-n

    Pane:
      Kill:        x
      Previous:    ;
      swap with previous   {
      swap with next       }

    Panes:
      Split current pane into two:
        Top and bottom: -
        Left and right: |
