Filtering and Pagination with Django
====================================

If you want to build a page that lists some things, and allows
filtering and pagination, you have to get a few separate things
to work together.  Django provides some tools for doing pagination,
but the documentation doesn't tell us how to make that work with anything else.
Similarly, django_filter makes it relatively easy to add filters to
a view, but doesn't tell you how to add pagination (or other things)
without breaking filtering.

The heart of the problem is that both features use query parameters,
and we need to find a way to let each feature control its own query
parameters without breaking the other one.

Filters
-------

Let's start with a review of filtering, with an example of how you might
subclass ``ListView`` to add filtering. To make it filter the way you want,
you need to create a subclass of
`FilterSet <https://django-filter.readthedocs.io/en/master/ref/filterset.html>`_
and set ``filterset_class`` to that class.  (See the docs for how to
write a filterset.)

.. code-block:: python

    class FilteredListView(ListView):
        filterset_class = None

        def get_queryset(self):
            # Get the queryset however you usually would.  For example:
            queryset = super().get_queryset()
            # Then use the query parameters and the queryset to
            # instantiate a filterset and save it as an attribute
            # on the view instance for later.
            self.filterset = self.filterset_class(self.request.GET, queryset=queryset)
            # Return the filtered queryset
            return self.filterset.qs.distinct()

        def get_context_data(self, **kwargs):
            context = super().get_context_data(**kwargs)
            # Pass the filterset to the template - it provides the form.
            context['filterset'] = self.filterset
            return context

Here's an example of how you might create a concrete view to use it:

.. code-block:: python

    class BookListView(FilteredListView):
        filterset_class = BookFilterset

And here's part of the template that uses a form created by the filterset
to let the user control the filtering.

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

Default values for filters
--------------------------

I'm going to digress slightly here, and show a way to give filters default
values, so when a user loaded a page initially, for example, the items would
be sorted most recent first. I couldn't find anything about this in the
django_filter documentation, and it took me a while to figure out a good
solution.

To do this, I override ``__init__`` on my filter set and add default values
to the data being passed:

.. code-block:: python

    class BookFilterSet(django_filters.FilterSet):
        def __init__(self, data, *args, **kwargs):
            data = data.copy()
            data.setdefault('format', 'paperback')
            data.setdefault('order', '-added')
            super().__init__(data, *args, **kwargs)

I tried some other approaches, but this seemed to work out the simplest,
in that it didn't break or complicate things anywhere else.

Pagination
----------

Now let's review pagination in Django.

Django's ``ListView`` has some built-in support for pagination, which
is easy enough to enable:

.. code-block:: python

    class BookListView(FilteredListView):
        paginate_by = 50

Once ``paginate_by`` is set to the number of items you want per page,
``object_list`` will contain only the items on the current page,
and there will be some additional items in the context:

paginator
    A `Paginator <https://docs.djangoproject.com/en/stable/topics/pagination/#django.core.paginator.Paginator>`_ object
page_obj
    A `Page <https://docs.djangoproject.com/en/stable/topics/pagination/#page-objects>`_ object
is_paginated
    True if there are pages

We need to update the template so the user can control the pages.

Let's start our template updates by just telling the user where we are:

.. code-block:: django

    {% if is_paginated %}
    Page {{ page_obj.number }} of {{ paginator.num_pages }}
    {% endif %}

To tell the view which page to display, we want to add a query parameter
named ``page`` whose value is a page number.  In the simplest case, we can
just make a link with ``?page=N``, e.g.:

.. code-block:: html

    <a href="?page=2">Goto page 2</a>

You can use the ``page_obj`` and ``paginator`` objects to build a full set
of pagination links, but there's a problem we should solve first.

Combining filtering and pagination
----------------------------------

Unfortunately, linking to pages like that breaks filtering. More specifically,
whenever you follow one of those links, the view will forget whatever filtering
the user has applied, because that filtering is also controlled by query
parameters, and these links don't include the filter's parameters.

So if you're on a page
``https://example.com/objectlist/?type=paperback``
and then follow a page link, you'll end up at
``https://example.com/objectlist/?page=3``
when you wanted to be at
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
    def param_replace(context, **kwargs):
        """
        Return encoded URL parameters that are the same as the current
        request's parameters, only with the specified GET parameters added or changed.

        It also removes any empty parameters to keep things neat,
        so you can remove a parm by setting it to ``""``.

        For example, if you're on the page ``/things/?with_frosting=true&page=5``,
        then

        <a href="/things/?{% param_replace page=3 %}">Page 3</a>

        would expand to

        <a href="/things/?with_frosting=true&page=3">Page 3</a>

        Based on
        https://stackoverflow.com/questions/22734695/next-and-before-links-for-a-django-paginated-query/22735278#22735278
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

    {% load my_tags %}

    {% if is_paginated %}
      {% if page_obj.has_previous %}
        <a href="?{% param_replace page=1 %}">First</a>
        {% if page_obj.previous_page_number != 1 %}
          <a href="?{% param_replace page=page_obj.previous_page_number %}">Previous</a>
        {% endif %}
      {% endif %}

      Page {{ page_obj.number }} of {{ paginator.num_pages }}

      {% if page_obj.has_next %}
        {% if page_obj.next_page_number != paginator.num_pages %}
          <a href="?{% param_replace page=page_obj.next_page_number %}">Next</a>
        {% endif %}
        <a href="?{% param_replace page=paginator.num_pages %}">Last</a>
      {% endif %}

      <p>Objects {{ page_obj.start_index }}&mdash;{{ page_obj.end_index }}</p>
    {% endif %}

Now, if you're on a page like ``https://example.com/objectlist/?type=paperback&page=3``,
the links will look like ``?type=paperback&page=2``, ``?type=paperback&page=4``, etc.

Useful links
------------

* `django_filter <https://django-filter.readthedocs.io>`_
* `Django pagination <https://docs.djangoproject.com/en/stable/topics/pagination/>`_
* `param_replace template tag <https://stackoverflow.com/questions/22734695/next-and-before-links-for-a-django-paginated-query/22735278#22735278>`_

I haven't tried it, but if you need something more sophisticated for building
these kinds of links,
`django-qurl-templatetag <https://github.com/sophilabs/django-qurl-templatetag>`_
might be worth looking at.

