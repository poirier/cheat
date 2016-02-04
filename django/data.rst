=============
Data fixtures
=============

Export/dump data to use as a fixture::

    python manage.py dumpdata --format=yaml --natural app.model >data.yaml

Load it again::

    python manage.py loaddata data.yaml

Natural keys
------------

https://docs.djangoproject.com/en/stable/topics/serialization/#natural-keys

.. code-block:: python

    from django.db import models

    class PersonManager(models.Manager):
        def get_by_natural_key(self, first_name, last_name):
            return self.get(first_name=first_name, last_name=last_name)

    class Person(models.Model):
        objects = PersonManager()
        ...

        def natural_key(self):
            return (self.first_name, self.last_name)

        class Meta:
            unique_together = (('first_name', 'last_name'),)

Dependencies
~~~~~~~~~~~~

If part of the natural key is a reference to another model, then
that model needs to be deserialized first:

.. code-block:: python

    class Book(models.Model):
        name = models.CharField(max_length=100)
        author = models.ForeignKey(Person)

        def natural_key(self):
            return (self.name,) + self.author.natural_key()
        natural_key.dependencies = ['example_app.person']
