Org mode (Emacs)
================
.. contents::

http://orgmode.org/org.html
See also http://orgmode.org/orgcard.pdf

================= ============
Binding           Operation
================= ============
*Tasks*
M-S-Ret           Add a TODO item at same level
C-c C-t           Change TODO state
C-c / t           Show only uncompleted todos
*Agenda*
C-c C-a n         View schedule and unscheduled tasks
b                 Move backward (previous day)
f                 Move forward (next day)
*Scheduling*
C-c C-s           Schedule a task (set a date and optional time to do it)
C-u C-c C-s       Unschedule a task (remove schedule date/time)
================= ============


Keys outside org-mode::

    Key     What
    C-c a X     Agenda view X

    C-c l      org-store-link
    C-c c      org-capture
    C-c b      org-iswitchb (?)

Keys in org-mode file::

    C-c C-x p   org-set-property
    M-Return    org-meta-return - start new line with new heading at same level
    M-S-right arrow  move current heading one deeper

    C-c C-s     schedule task
    C-c C-d     set task deadline
    C-c C-q     org-set-tags-command add task tag - USE FOR CONTEXT
    C-c / d     org-check-deadlines - spared tree with deadlines that are past-due or soon to be

    <TAB>       org-cycle
    S-<TAB>     org-global-cycle

Keys in agenda views::

    TBD
