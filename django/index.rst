.. index:: ! django

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
   celery_starting
   compressor
   data
   database
   ddt
   django_celery_beat
   dokku
   drf_blog_post
   drf_serializers
   dump_export
   eb
   email
   fabric
   filter
   forms
   home
   jinja
   logging
   login
   middleware
   migrations
   nginx
   permissions
   pycharm
   queries
   security
   sentry
   settings
   static_files
   templates
   test
   translation
   urls
   vue


Misc to file:

.. index:: django; circular imports

Avoid circular imports::

    from django.db.models import get_model
    MyModel = get_model('applabel', 'mymodelname'.lower())
