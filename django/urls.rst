====
URLs
====

reverse
=======

.. code-block:: python

    from django.core.urlresolvers import reverse

    reverse(viewname='myview',   # remaining args optional
            urlconf=None,
            args=(1, 2),
            kwargs={'pk': foo.pk},
            current_app=None)

redirect
========

.. code-block:: python

    from django.shortcuts import redirect

.. function:: redirect(to[, permanent=False], *args, **kwargs)

   Returns an :class:`~django.http.HttpResponseRedirect` to the appropriate URL
   for the arguments passed.

   The arguments could be:

       * A model: the model's `get_absolute_url()` function will be called.

       * A view name, possibly with arguments: `urlresolvers.reverse()` will
         be used to reverse-resolve the name.

       * A URL, which will be used as-is for the redirect location.

   By default issues a temporary redirect; pass ``permanent=True`` to issue a
   permanent redirect

Examples
--------

You can use the :func:`redirect` function in a number of ways.

    1. By passing some object; that object's
       :meth:`~django.db.models.Model.get_absolute_url` method will be called
       to figure out the redirect URL::

            def my_view(request):
                ...
                object = MyModel.objects.get(...)
                return redirect(object)

    2. By passing the name of a view and optionally some positional or
       keyword arguments; the URL will be reverse resolved using the
       :func:`~django.core.urlresolvers.reverse` method::

            def my_view(request):
                ...
                return redirect('some-view-name', foo='bar')

    3. By passing a hardcoded URL to redirect to::

            def my_view(request):
                ...
                return redirect('/some/url/')

       This also works with full URLs::

            def my_view(request):
                ...
                return redirect('http://example.com/')

By default, :func:`redirect` returns a temporary redirect. All of the above
forms accept a ``permanent`` argument; if set to ``True`` a permanent redirect
will be returned:

.. code-block:: python

    def my_view(request):
        ...
        object = MyModel.objects.get(...)
        return redirect(object, permanent=True)


https://docs.djangoproject.com/en/dev/topics/http/urls/

.. code-block:: python

    from django.conf.urls.defaults import patterns, include, url
    from django.contrib import admin admin.autodiscover()

    urlpatterns = patterns('',
        (r'^polls/', include('polls.urls')),
        url(r'^admin/', include(admin.site.urls)),
    )
    urlpatterns = patterns('polls.views',
        (r'^, 'index'),
        (r'^(?P<poll_id>\d+)/, 'detail'),
        (r'^(?P<poll_id>\d+)/results/, 'results'),
        (r'^(?P<poll_id>\d+)/vote/, 'vote'),
        url(r'^(?P<poll_id>\d+)/foo/, 'fooview', name='app-viewname'),
    )
