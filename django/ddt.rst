Django Debug Toolbar
====================

`Install/config <http://django-debug-toolbar.readthedocs.io/en/stable/installation.html>`_

Install::

    pip install django-debug-toolbar

settings.py::

    DEBUG = True
    INTERNAL_IPS = ['127.0.0.1']
    INSTALLED_APPS += [
       'debug_toolbar',
    ]
    # The order of MIDDLEWARE and MIDDLEWARE_CLASSES is important. You should include
    # the Debug Toolbar middleware as early as possible in the list. However, it must
    # come after any other middleware that encodes the response’s content, such as
    # GZipMiddleware.
    MIDDLEWARE = [
        'debug_toolbar.middleware.DebugToolbarMiddleware',
    ] + MIDDLEWARE

urls.py::

    from django.conf import settings
    from django.conf.urls import include, url

    if settings.DEBUG:
        import debug_toolbar
        urlpatterns += [
            url(r'^__debug__/', include(debug_toolbar.urls)),
        ]
