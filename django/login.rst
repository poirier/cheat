.. index:: django; login
.. index:: django; logout

Django login and logout
=======================

`Django doc <http://docs.djangoproject.com/en/stable/topics/auth/#the-login-required-decorator>`_

* In settings.py, add::

    LOGIN_URL = '/login/'

* In urls.py, add::

    urlpatterns += patterns('',
                           (r'^login/$', django.contrib.auth.views.login),
                           (r'^logout/$', django.contrib.auth.views.logout),
                           )
* Create a template "registration/login.html", copying from the
  `sample in the doc <http://docs.djangoproject.com/en/stable/topics/auth/#the-login-required-decorator>`_
* Add a logout link to your base template::

    <a href="/logout/">Logout</a>

* On each view function where users should be logged in before using, add the decorator::

    @login_required
    def myview(...)

