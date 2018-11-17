Django with Vue
===============

Also Dokku...

If you want to serve your Django app, your Django app's static files,
and the files constituting your vue app, all from your Django process,
using `whitenoise <http://whitenoise.evans.io/en/stable/django.html>`_,
this seems to work.


Set up Django to gather static files from dist
----------------------------------------------

In settings::


    STATICFILES_DIRS = [
        ...
        os.path.join(BASE_DIR, 'dist'),
        ...
    ]

Configure whitenoise
--------------------

Do the basic Django configuration, but add a few things::

    WHITENOISE_INDEX_FILE = True
    WHITENOISE_ROOT = os.path.join(STATIC_ROOT, 'vue')

`WHITENOISE_INDEX_FILE <http://whitenoise.evans.io/en/stable/django.html#WHITENOISE_INDEX_FILE>`_
tells whitenoise to serve ``index.html`` for ``/`` when
it seems appropriate.

`WHITENOISE_ROOT <http://whitenoise.evans.io/en/stable/django.html#WHITENOISE_ROOT>`_
tells whitenoise to serve files at the root URL if it
finds them in WHITENOISE_ROOT.  E.g. if a request comes in
for ``/app.js`` and there's a file ``<WHITENOISE_ROOT>/app.js``,
then Whitenoise will handle the request and return that file.

At deploy
---------


Build your vue app for production and
have the resulting files put under dist/vue::

    mkdir -p dist/vue
    yarn run build --dest=dist/vue

(that runs vue-cli-service build).

Run collectstatic. It'll gather the files from dist along
with other static files::

    python manage.py collectstatic --noinput

Now 'runserver' or whatever.
