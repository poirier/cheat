Salt Stack
==========
.. contents::

(I have not used this in *years*. Salt was horrible.)

https://docs.saltstack.com/en/latest/topics/tutorials/pillar.html

Fetching pillar data in templates
---------------------------------

In the Jinja2 context, ``pillar`` is just a dictionary, so you can
use the usual Python dictionary methods, e.g.::

    {% for user, uid in pillar.get('users', {}).items() %}
    {{user}}:
      user.present:
        - uid: {{uid}}
    {% endfor %}

If you have nested data, it can be easier to use
``salt['pillar.get']``, which accepts a single key parameter
like ``key1:key2``.  E.g. if the pillar data looks like::

    apache:
        user: fred

you could access the username as::

    {{ salt['pillar.get']['apache:user'] }}

instead of::

    {{ pillar['apache']['user'] }}

though that would work too.
