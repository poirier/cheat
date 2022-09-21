.. index:: django; settings

Settings
========

Using the right one
-------------------

Baumgartner suggests symlinking the desired one (e.g. `dev.py` or `deploy.py`)
to `local.py` and hard-coding that in `manage.py`.

Greenfelds suggest... (FILL THIS IN)

12-factor says there should only be one settings file, and any values
that vary by deploy should be pulled from the environment.
See :ref:`envvars`.

Secret key
----------

Generate a secret key:

.. code-block:: python

    from django.utils.crypto import get_random_string
    chars = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)"
    return get_random_string(50, chars)

(https://github.com/django/django/blob/12617fbd859b1244e91bcf182a2fdf356b388821/django/core/management/utils.py#L79)

.. _envvars:

Env vars
--------

Suppose you have env vars in a .env file::

    SECRET_KEY=jdfsdfsdf
    PASSWORD=jsdkfjsdlkfjdsf

You can load them into Django using `dotenv <https://github.com/jacobian/django-dotenv>`_.
Pop open `manage.py`. Add::

    import dotenv
    dotenv.read_dotenv()

Or in a settings file::

    SECRET_KEY = os.environ.get("SECRET_KEY")

And if they're not all strings, use ast::

    import ast, os

    DEBUG = ast.literal_eval(os.environ.get("DEBUG", "True"))
    TEMPLATE_DIRS = ast.literal_eval(os.environ.get("TEMPLATE_DIRS", "/path1,/path2"))

You can load them into a shell this way::

    export $(cat .env | grep -v ^# | xargs)
