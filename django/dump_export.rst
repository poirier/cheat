Dump (Export) Django data
=========================

In docs:

* /ref/django-admin.html#dumpdata
* /topics/serialization.html#topics-serialization-natural-keys

Dumping
-------

Syntax::

    django-admin dumpdata --output=outputfile.json --indent=2 [app_label[.ModelName] [app_label[.ModelName] ...]]

We generally want to use natural keys, so add::

    --natural-foreign --natural-primary

And in each model, we need to add support for that.

First, add a ``natural_key`` method that returns a tuple whose value uniquely
identifies the record without using the pk::


    def natural_key(self):
        return (self.task.label, self.url)

Next, create a custom manager with a ``get_by_natural_key`` method
that takes that tuple as ``*args`` and returns the corresponding
record::

    class TaskLinkManager(models.Manager):
        def get_by_natural_key(self, task_label, url):
            return self.get(task__label=task_label, url=url)


    class TaskLink(models.Model):
        # ...
        objects = TaskLinkManager()

Finally, consider whether using get_by_natural_key will require
that some other model be restored first. If so, we need to
declare dependencies so restoration can occur in the right order.
E.g.::

    def natural_key(self):
        return (self.task.label, self.url)
    natural_key.dependencies = ["appname.Model1", "appname.Model2"]

Compressing dumps
-----------------

Dumps can be big but they compress very well and can be restored without
uncompressing, e.g. with bzip2::

    $ bzip2 bigdump.json
    $ python manage.py loaddata bigdump.json.bz2
