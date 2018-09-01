Filtering and Pagination with Django
====================================

* `django_filter <https://django-filter.readthedocs.io>`_
* `Django pagination <https://docs.djangoproject.com/en/stable/topics/pagination/>`_

If you want to build a page that lists some things, and allows
filtering and pagination, you have to get a few separate things
to work together.  Django provides some tools for doing pagination,
but gives no information on how to make that work with anything else.
Similarly, django_filter makes it (kind of) easy to add filters to
a view, but doesn't tell you how to add pagination (or other things)
without breaking filtering.

Filters
-------

Let's start with an example of how you might subclass ``ListView`` to
add filtering. To make it filter the way you want, you need to
create a subclass of
`FilterSet <https://django-filter.readthedocs.io/en/master/ref/filterset.html>`_
and set ``filterset_class`` to that class. Writing a filter set is
beyond the scope of this page.

.. code-block:: python

    class FilteredListView(ListView):
        filterset_class = None

        def get_queryset(self):
            self.filterset = self.filterset_class(
                self.request.GET,
                queryset=super().get_queryset()
            )
            return self.filterset.qs.distinct()

        def get_context_data(self, **kwargs):
            context = super().get_context_data(**kwargs)
            context['filterset'] = self.filterset
            return context

Here's an example of how you might create a concrete view to use it:

.. code-block:: python

    class BookListView(FilteredListView):
        filterset_class = BookFilterset

And part of the template that might display the result:

.. code-block:: django

    <h1>Books</h1>
      <form action="" method="get">
        {{ filterset.form.as_p }}
        <input type="submit" />
      </form>

    <ul>
        {% for object in object_list %}
            <li>{{ object }}</li>
        {% endfor %}
    </ul>

``filterset.form`` is a form that controls the filtering, so
we just render that however we want and add a way to submit it.

That's all you need to make a simple filtered view.

Pagination
----------

Django's ``ListView`` has some built-in support for pagination, which
is easy enough to enable:

.. code-block:: python

    class BookListView(FilteredListView):
        paginate_by = 50

Once paginate_by is set to the number of items you want per page,
``object_list`` will contain only the items on the current page,
and there will be some additional items in the context:

paginator
    A Paginator object
page_obj
    A Page object
is_paginated
    True if there are pages

We need to update the template so we can control the pages.

Let's start by just telling the user where we are:

.. code-block:: django

    {% if is_paginated %}
    Page {{ page_obj.number }} of {{ paginator.num_pages }}
    {% endif %}

To tell the view which page to display, we want to add a query parameter
named ``page`` whose value is either a page number or the special value
``"last"``.  In the simple case, we can just make a link with
``?page=N``, e.g.:

.. code-block:: html

    <a href="?page=2">Goto page 2</a>

You can use the page_obj and paginator objects to build a full set
of pagination links, but there's a problem we should solve first.

Combining filtering and pagination
----------------------------------

Unfortunately, linking to pages like that breaks filtering. More specifically,
whenever you follow one of those links, the view will forget whatever filtering
the user has applied, because that filtering is also controlled by query
parameters.   So if you're on a page
``https://example.com/objectlist/?type=paperback``
and then follow a page link, you'll end up at
``https://example.com/objectlist/?page=3``
when you wanted to have
``https://example.com/objectlist/?type=paperback&page=3``.

It would be nice if Django helped out with a way to build links that set
one query parameter without losing the existing ones, but I found a
nice example of a template tag
`on StackOverflow <https://stackoverflow.com/questions/22734695/next-and-before-links-for-a-django-paginated-query/22735278#22735278>`_
and modified it slightly into this custom template tag that helps
with that:

.. code-block:: python

    # <app>/templatetags/my_tags.py
    from django import template

    register = template.Library()


    @register.simple_tag(takes_context=True)
    def url_replace(context, **kwargs):
        """
        Return encoded URL parms that are the same as the current
        request, only with the specified GET params added or changed.

        Also removes any empty parameters to keep things neat.

        Example:

        <a href="{% url_replace page=3 %}">Page 3</a>

        Based on https://stackoverflow.com/questions/22734695/next-and-before-links-for-a-django-paginated-query/22735278#22735278
        """
        d = context['request'].GET.copy()
        for k, v in kwargs.items():
            d[k] = v
        for k in [k for k, v in d.items() if not v]:
            del d[k]
        return d.urlencode()

Here's how you can use that template tag to build pagination links
that preserve other query parameters used for things like filtering:

.. code-block:: django

    {% if is_paginated %}
      {% if page_obj.has_previous %}
        <a href="?{% url_replace page=1 %}">First</a>
        {% if page_obj.previous_page_number != 1 %}
          <a href="?{% url_replace page=page_obj.previous_page_number %}">Previous</a>
        {% endif %}
      {% endif %}

      Page {{ page_obj.number }} of {{ paginator.num_pages }}

      {% if page_obj.has_next %}
        {% if page_obj.next_page_number != paginator.num_pages %}
          <a href="?{% url_replace page=page_obj.next_page_number %}">Next</a>
        {% endif %}
        <a href="?{% url_replace page=paginator.num_pages %}">Last</a>
      {% endif %}

      <p>Objects {{ page_obj.start_index }}&mdash;{{ page_obj.end_index }}</p>
    {% endif %}

Now, if you're on a page like ``https://example.com/objectlist/?type=paperback&page=3``,
the links will look like ``?type=paperback&page=2``, ``?type=paperback&page=4``, etc.
