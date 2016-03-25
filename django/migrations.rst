.. _migrations:

Migrations
==========

Data migration::

    def no_op(apps, schema_editor):
        pass

    def create_types(apps, schema_editor):
        ServiceType = apps.get_model('services', 'ServiceType')
        db_alias = schema_editor.connection.alias
        # do stuff
        ServiceType.objects.using(db_alias)....


    class Migration(migrations.Migration):
        ...
        operations = [
            migrations.RunPython(create_types, no_op),
        ]

Getting past bad migrations
---------------------------

For example, earlier migrations refer to models in apps that no longer exist.

The simplest thing is to start from an existing database so you don't have to migrate.

If you need to start from scratch, you should be able to::

   syncdb --all
   migrate --fake
