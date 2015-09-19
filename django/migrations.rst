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
