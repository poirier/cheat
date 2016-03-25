Mock
====

* http://www.voidspace.org.uk/python/mock/mock.html
* https://docs.python.org/3/library/unittest.mock.html


Mock a function being called in another module
----------------------------------------------

Function being called from another module (medley/photos/tasks/galleryimport.py)::

    from urllib2 import urlopen

our test.py::

    with mock.patch('medley.photos.tasks.galleryimport.urlopen') as urlopen:
        urlopen.side_effect = ValueError("Deliberate exception for testing")

Mock a method on a class
------------------------

Use ``mock.patch('python.packagepath.ClassName.method_name``::

    # medley/photos/models.py
    class MedleyPhotoManager(...):
        def build_from_url(...):

Test code::

    with mock.patch('medley.photos.models.MedleyPhotoManager.build_from_url') as build_from_url:
        build_from_url.return_value = None

Replace something with an existing object or literal
----------------------------------------------------

Use ``mock.patch`` and pass ``new=``::

    with mock.patch("medley.photos.tasks.galleryimport.cache", new=get_cache('locmem://')):
        ...
    with mock.patch(target='medley.photos.tasks.galleryimport.MAX_IMPORTS', new=2):
        ...

Mock an attribute on an object we have a reference to
-----------------------------------------------------

Use ``mock.patch.object(obj, 'attrname')``:

    with mock.patch.object(obj, 'attrname') as foo:
        ...

Data on the mock
----------------

Attributes on mock objects::

    obj.call_count  # number of times it was called
    obj.called == obj.call_count > 0
    obj.call_args_list  # a list of (args,kwargs), one for each call
    obj.call_args  # obj.call_args_list[-1] (args,kwargs from last call)
    obj.return_value  # set to what it should return
    obj.side_effect  # set to an exception class or instance that should be raised when its called
    obj.assert_called() # doesn't work with autospec=True? just assert obj.called
    obj.assert_called_with(*args, **kwargs)  # last call was with (*args, **kwargs)
