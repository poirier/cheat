Beautiful Soup
==============

Intro
-----

Docs: https://www.crummy.com/software/BeautifulSoup/bs4/doc/

Install::

    pip install beautifulsoup4

Create a BeautifulSoup object from a string containing HTML::

    from bs4 import BeautifulSoup

    soup = BeautifulSoup("html string", "lxml")

Tags and NavigableStrings
-------------------------

When you're searching and navigating around in the HTML document,
your results will be `Tags <https://www.crummy.com/software/BeautifulSoup/bs4/doc/#tag>`_ and
`NavigableStrings <https://www.crummy.com/software/BeautifulSoup/bs4/doc/#navigablestring>`_.

A Tag represents an HTML tag and everything inside it. The tag name is
``tag.name`` (str) and what's inside is ``tag.contents`` (list of
Tags and NavigableStrings), or ``tag.children`` (generator of
Tags and NavigableStrings).

A NavigableString represents a piece of text that has no further
HTML tags inside it.

For both, if you want a ``str`` representation of the part of the document
they represent, you
can just call ``str`` on them: ``str(some_tag)`` or ``str(nav_string)``.
(For tags, this includes the tag element itself, not just what's inside
of it.)

If you have a Tag (but not a nav string),
you can call `.get_text() <https://www.crummy.com/software/BeautifulSoup/bs4/doc/#get-text>`_
to get the text *inside* the tag, and also allow some options to process the text
before returning it::

    s = tag.get_text()

If you have a NavigableString (but not a tag), you can reference `.string`
to get a `str` with the string's content. This is the same as calling `str()`
on it.

You *can* access ``.string`` on a Tag, but the meaning in that case is
`convoluted <https://www.crummy.com/software/BeautifulSoup/bs4/doc/#string>`_.
I find it easier to just avoid it. ``str`` and ``get_text()`` are enough
anyway.

Navigating from some tag or the top of the document
---------------------------------------------------

These should all work both on a Tag and on the BeautifulSoup object if you
want to work with the whole document.

Queries
.......

Many of these methods can take the same arguments to specify which tags
and nav strings to return. Here's a small selection of things you can do,
using find() or find_all() as the sample method.

Search for tags with a particular name: ``find_all("p")``

Search for tags with an attribute value: ``find(id="content-list")`` or ``find_all(class_="btn")``.
(You can filter an attribute based on a string, a regular expression, a list, a function, or the value True.)

If an attribute has a non-Pythonic name, or a name that matches
a defined argument of find(), pass attrs={"attrname": value}.

find() and find_all()
.....................

``find_all(q)`` returns an iterable of all the tags or nav strings in the document that
match q.  The result can be empty.

``find(q)`` is exactly the same, except it returns the first result of ``find_all``,
or ``None`` if nothing matched.

Children
........

Iterate over a tag's direct children::

   for tag_or_nav_string in tag.contents:
       # do something

Descendants
...........

To find the first descendant of a given type, just apply the tag name
as an attribute::

   first_paragraph = tag.p

(This is just a shortcut for ``tag.find("p")``.)

You can find any descendant with a specific ID::

    tag_with_id = tag.find(id=id)
    if tag_with_id is None:
       # Handle not found

You can find all descendants that match some criteria. The simplest
is all the descendants of a particular tag name::

    p_tags = tag.find_all("p")

Siblings
........

Find the first matching sibling after this tag::

    first_sibling = tag.find_next_sibling(q)

or all matching siblings that follow this tag::

    later_siblings = tag.find_next_siblings(q)

Change "next" to "previous" on any of these to go backward.
