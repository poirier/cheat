Django Debug Toolbar
====================

Install::

    pip install django-debug-toolbar

settings.py::

    INTERNAL_IPS = ('127.0.0.1',)

    MIDDLEWARE_CLASSES = (
        # ...
        'debug_toolbar.middleware.DebugToolbarMiddleware',
        # ...
    ) # must come after any other middleware that encodes the response's content (such as GZipMiddleware).

    INSTALLED_APPS = [
       ...
       'debug_toolbar',
       ...
    ]

    DEBUG_TOOLBAR_CONFIG = {
        'INTERCEPT_REDIRECTS': False,
    }
