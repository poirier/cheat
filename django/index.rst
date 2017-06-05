Django
=============

These are just things I always find myself looking up, so I try to
make some notes of the most important parts that I can refer back to.

Contents:

.. toctree::
   :maxdepth: 3

   admin
   apps
   celery
   data
   database
   ddt
   dokku
   eb
   email
   fabric
   forms
   home
   logging
   login
   migrations
   nginx
   permissions
   queries
   security
   settings
   templates
   test
   translation
   urls


Misc to file:

Avoid circular imports::

    from django.db.models import get_model
    MyModel = get_model('applabel', 'mymodelname'.lower())
