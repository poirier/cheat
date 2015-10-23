Django cheats
=============

These are just things I always find myself looking up, so I try to
make some notes of the most important parts that I can refer back to.

Contents:

.. toctree::
   :maxdepth: 2

   admin
   apps
   celery
   data
   database
   ddt
   email
   fabric
   forms
   home
   logging
   migrations
   nginx
   permissions
   queries
   security
   settings
   test
   translation
   urls


Misc to file:

Avoid circular imports::

    from django.db.models import get_model
    MyModel = get_model('applabel', 'mymodelname'.lower())
