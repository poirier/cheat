=======
Testing
=======

.. code-block:: python

    self.assertEqual(a, b, msg=None)


    rsp = self.client.get(url, [follow=True])
    rsp = self.client.post(url, data, [follow=True])

    rsp.content is a byte string
    rsp['HeaderName']
    rsp.context['template_var']

    assert self.client.login(**login_parms)
    login(email='foo@example.com', password='cleartextpassword')



# http://docs.python.org/library/unittest.html
# https://docs.djangoproject.com/en/stable/topics/testing/

.. code-block:: python

    from django.test import TestCase
    from django.contrib.auth.models import User


    class XxxTest(TestCase):
        def setUp(self):
            self.user = User.objects.create_user('tester', 'test@example.com', 'testpass')

        def test_something(self):
            response = self.client.get(show_timemap)
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.context['lat'], '123.123')
            self.assertEqual(response.context['lon'], '456.456')
            self.assertContains(response, "some text")
            self.assertNotContains(response, "other text")
            self.assertIsNone(val)
            self.assertIsNotNone(val)
            self.assertIn(thing, iterable)  # Python >= 2.7
            self.assertNotIn(thing, iterable)  # Python >= 2.7


# Test uploading a file

(from `<https://docs.djangoproject.com/en/stable/topics/testing/tools/#django.test.Client.post>`_)

Submitting files is a special case. To POST a file, you need only
provide the file field name as a key, and a file handle to the file
you wish to upload as a value. For example::

    >>> c = Client()
    >>> with open('wishlist.doc') as fp:
    ...     c.post('/customers/wishes/', {'name': 'fred',
    ...                                   'attachment': fp})

(The name attachment here is not relevant; use whatever name your file-processing code expects.)

Note that if you wish to use the same file handle for multiple post() calls then you will need to manually reset the file pointer between posts. The easiest way to do this is to manually close the file after it has been provided to post(), as demonstrated above.

You should also ensure that the file is opened in a way that allows the data to be read. If your file contains binary data such as an image, this means you will need to open the file in rb (read binary) mode.


Writing a test for a separately-distributed Django app
------------------------------------------------------

# setup.py::

    ...
    setup(
        ...
        test_suite="runtests.runtests",
        ...
    )

# runtests.py::

    #!/usr/bin/env python
    import os
    import sys

    from django.conf import settings

    if not settings.configured:
        settings.configure(
            DATABASES={
                'default': {
                    'ENGINE': 'django.db.backends.sqlite3',
                    'NAME': ':memory:',
                }
            },
            INSTALLED_APPS=(
                'selectable',
            ),
            SITE_ID=1,
            SECRET_KEY='super-secret',
            ROOT_URLCONF='selectable.tests.urls',
        )


    from django.test.utils import get_runner


    def runtests():
        TestRunner = get_runner(settings)
        test_runner = TestRunner(verbosity=1, interactive=True, failfast=False)
        args = sys.argv[1:] or ['selectable', ]
        failures = test_runner.run_tests(args)
        sys.exit(failures)


    if __name__ == '__main__':
        runtests()

