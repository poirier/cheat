Bootstrap
=========
.. contents::

.. warning::

    THIS IS NOT DONE AND PROBABLY WRONG.

The grid.

SO what does a class `col-SIZE-N` mean?

Each SIZE has a BREAKPOINT:

xs: -1
sm: 750px
md: 970px
lg: 1170px

Call the window width WIDTH.

For a single class col-SIZE-N::

    if WIDTH >= BREAKPOINT(SIZE), then
        ELEMENT-WIDTH=WIDTH*N/12
        display INLINE (same line as previous element if possible)
    else
        ELEMENT-WIDTH=100%
        display BLOCK (element gets its own line)


What if we have col-SIZE1-N1 and col-SIZE2-N2, with BREAKPOINT(SIZE1) < BREAKPOINT(SIZE2)?::

    IF WIDTH >= BREAKPOINT(SIZE2), then
       ELEMENT_WIDTH = WIDTH * N2 / 12
       INLINE
    elif WIDTH >= BREAKPOINT(SIZE1), then
       ELEMENT_WIDTH = WIDTH * N1 / 12
       INLINE
    else:
       BLOCK display

and so forth - just look at the class with the largest size

NOTE: Since all widths are >= the breakpoint of XS, then if XS is present,
the element will ALWAYS be laid out inline.  Though col-xs-12 is pretty
much equivalent to not having an XS class, right???????????/
