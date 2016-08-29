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
