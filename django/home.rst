.. index:: django; home page

Quick And Dirty Home Page
=========================

In ``urls.py``::

    from django.views.generic import TemplateView

    urlpatterns = [
        ...
        url(r'^$', TemplateView.as_view(template_name='home.html'), name='home'),
    ]

