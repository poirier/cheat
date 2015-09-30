Applications
============

`https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig <https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig>`_

In ``__init__.py``::

    # programs/__init__.py

    default_app_config = 'programs.apps.ProgramsConfig'

In ``apps.py``::

    # programs/apps.py

    from django.apps import AppConfig

    class ProgramsConfig(AppConfig):
        name = 'programs'  # required: must be the Full dotted path to the app
        label = 'programs'  # optional: app label, must be unique in Django project
        verbose_name = "Rock ’n’ roll"  # optional

        def ready():
            """
            This runs after all models have been loaded, but you may not
            modify the database in here.

            Here's a trick to run something after each migration, which is often
            good enough.
            """
            from django.db.models.signals import post_migrate

            post_migrate.connect(`callable`)

