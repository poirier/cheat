=====
Admin
=====

URLs
====

List    	{{ app_label }}_{{ model_name }}_changelist
Change	{{ app_label }}_{{ model_name }}_change	object_id

https://docs.djangoproject.com/en/dev/ref/contrib/admin/#reversing-admin-urls


Customize top-right corner of admin pages
=========================================

Create your own `templates/admin/base_site.html` that comes ahead of the
admin's default one in the templates path.

At least in Django 1.8+, this gives you a "View site" link for free:

    % extends "admin/base.html" %}

    {% block title %}{{ title }} | {{ site_title|default:_('Django site admin') }}{% endblock %}

    {% block branding %}
    <h1 id="site-name"><a href="{% url 'admin:index' %}">{{ site_header|default:_('Django administration') }}</a></h1>
    {% endblock %}

    {% block userlinks %}
        <a href="{% url "clear-cache" %}">Clear cache</a> /
        {{ block.super }}
    {% endblock userlinks %}

Prior to Django 1.8:

    {% extends "admin/base.html" %}

    {% block title %}{{ title }} | Caktus Admin{% endblock %}

    {% block branding %}<h1 id="site-name">Caktus Admin</h1>{% endblock %}

    {% block nav-global %}
        <div style='display:block; padding:0 1em 0.5em 1em; float:right;'>
            <a href='{% url "home" %}'>Return to Caktus Home</a>
            | <a href='{% url "clear-cache" %}'>Clear cache</a>
        </div>
    {% endblock %}
