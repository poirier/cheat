Middleware
----------

Middleware ordering
...................

`Middleware ordering docs <https://docs.djangoproject.com/en/stable/ref/middleware/#middleware-ordering>`_

Re: whitenoise middleware: The WhiteNoise middleware should be placed directly after the Django SecurityMiddleware (if you are using it) and before all other middleware:



Mostly copy of the Django middleware docs (2.1):

Here are some hints about the ordering of various Django middleware classes:

#. :class:`~django.middleware.security.SecurityMiddleware`

   It should go near the top of the list if you're going to turn on the SSL
   redirect as that avoids running through a bunch of other unnecessary
   middleware.

#. :class:`~django.middleware.cache.UpdateCacheMiddleware`

   Before those that modify the ``Vary`` header (``SessionMiddleware``,
   ``GZipMiddleware``, ``LocaleMiddleware``).

#. :class:`~django.middleware.gzip.GZipMiddleware`

   Before any middleware that may change or use the response body.

   After ``UpdateCacheMiddleware``: Modifies ``Vary`` header.

#. :class:`~django.contrib.sessions.middleware.SessionMiddleware`

   After ``UpdateCacheMiddleware``: Modifies ``Vary`` header.

#. :class:`~django.middleware.http.ConditionalGetMiddleware`

   Before any middleware that may change the response (it sets the ``ETag``
   header).

   After ``GZipMiddleware`` so it won't calculate an ``ETag`` header on gzipped
   contents.

#. :class:`~django.middleware.locale.LocaleMiddleware`

   One of the topmost, after ``SessionMiddleware`` (uses session data) and
   ``UpdateCacheMiddleware`` (modifies ``Vary`` header).

#. :class:`~django.middleware.common.CommonMiddleware`

   Before any middleware that may change the response (it sets the
   ``Content-Length`` header). A middleware that appears before
   ``CommonMiddleware`` and changes the response must reset ``Content-Length``.

   Close to the top: it redirects when `APPEND_SLASH` or
   `PREPEND_WWW` are set to ``True``.

#. :class:`~django.middleware.csrf.CsrfViewMiddleware`

   Before any view middleware that assumes that CSRF attacks have been dealt
   with.

   It must come after ``SessionMiddleware`` if you're using
   `CSRF_USE_SESSIONS`.

#. :class:`~django.contrib.auth.middleware.AuthenticationMiddleware`

   After ``SessionMiddleware``: uses session storage.

#. :class:`~django.contrib.messages.middleware.MessageMiddleware`

   After ``SessionMiddleware``: can use session-based storage.

#. :class:`~django.middleware.cache.FetchFromCacheMiddleware`

   After any middleware that modifies the ``Vary`` header: that header is used
   to pick a value for the cache hash-key.

#. :class:`~django.contrib.flatpages.middleware.FlatpageFallbackMiddleware`

   Should be near the bottom as it's a last-resort type of middleware.

#. :class:`~django.contrib.redirects.middleware.RedirectFallbackMiddleware`

   Should be near the bottom as it's a last-resort type of middleware.
