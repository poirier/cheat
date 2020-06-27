.. index:: django; templates
.. index:: django; template tags

Templates
=========

Template tag to set variables
-----------------------------

Example usage::

    {% set foo="bar" a=1 %}
    ...
    Hello everyone, foo is {{ foo }} and a is {{ a }}.

Here's the code::

    from django import template

    register = template.Library()

    @register.simple_tag(takes_context=True)
    def set(context, **kwargs):
        context.update(kwargs)
        return ''


Working block tag with arguments
--------------------------------

Here's an example of a working block tag. Usage is
``{% detail_link arg1=1 arg2=2 %}...{% end_detail_link %}``
and what ends up in the output is
``<a arg1="1" arg2="2" target="_blank">...</a>``.


The code::

    from django import template
    from django.template.base import token_kwargs, TemplateSyntaxError
    from django.utils.html import format_html, format_html_join
    from django.utils.safestring import mark_safe

    register = template.Library()


    def do_detail_link(parser, token):
        """
        Block tag to help render links to detail pages consistently
        with an option to open in a new tab or window.

        {% detail_link href="xxxx" arg1="yyy" ... %} what to display {% end_detail_link %}

        is rendered as

        <a href="xxxx" arg1="yyy" ... target="_blank" %} what to display </a>

        This adds `target="_blank"` to open the link in a new tab or window.
        That's the main purpose of this block tag (and so we can disable that in
        one place, here, if we ever want to).  But you can override it by specifying
        another value for `target` if you want.
        """
        # This is called each time a detail_link tag is encountered while parsing
        # a template.

        # Split the contents of the tag itself
        args = token.split_contents()  # e.g. ["detail_link", "arg1='foo'", "arg2=bar"]
        tag_name = args.pop(0)

        # Parse out the arg1=foo arg2=bar ... arguments from the arg list into a dictionary.
        # kwargs will have "arg1" etc as keys, while the values will be
        # template thingies that can later be rendered using different contexts
        # to get their value at different times.
        kwargs = token_kwargs(args, parser)

        # If there are any args left, we have a problem; this tag only
        # accepts kwargs.
        if args:
            raise TemplateSyntaxError("%r only accepts named kwargs" % tag_name)

        # Open in new tab unless otherwise told (by setting target to something else).
        if 'target' not in kwargs:
            kwargs['target'] = parser.compile_filter('"_blank"')

        # Parse inside of block *until* we're looking at {% end_detail_link %},
        # then we don't care about end_detail_link, so discard it.
        # When we return, the parsing will then continue after our end tag.
        nodelist = parser.parse(('end_detail_link',))
        parser.delete_first_token()

        # Now return a node for the parsed template
        return DetailLinkNode(nodelist, tag_name, kwargs)


    register.tag('detail_link', do_detail_link)


    class DetailLinkNode(template.Node):
        """
        Stores info about one occurrence of detail_link in a template.

        See also `do_detail_link`.
        """
        def __init__(self, nodelist, tag_name, kwargs):
            self.nodelist = nodelist
            self.tag_name = tag_name
            self.kwargs = kwargs

        def render(self, context):
            """Turn this node into text using the given context."""

            # Start with the part inside the block
            innerds = self.nodelist.render(context)

            # Now work out the <a> wrapper.
            args = format_html_join(
                ' ',
                '{}="{}"',
                ((name, value.resolve(context)) for name, value in self.kwargs.items())
            )
            result = format_html(
                mark_safe("<a {}>{}</a>"),
                args,
                mark_safe(innerds)
            )
            return result



Debugging template syntax errors during tests
---------------------------------------------

The normal error message when a view fails rendering a template
during testing gives no clue where the error is.

You can get a better idea by temporarily editing your local Django
installation. Find the file ``django/template/base.py``. Around line
194 (in Django 1.8.x), in the ``__init__`` method of the ``Template``
class, look for this code::

        self.nodelist = engine.compile_string(template_string, origin)

and change it to::

        try:
            self.nodelist = engine.compile_string(template_string, origin)
        except TemplateSyntaxError:
            print("ERROR COMPILING %r" % origin.name)
            raise

TODO: would be nice to get a line number too (this just gives a filename,
which is often enough in combination with the error message).
