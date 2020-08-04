.. index:: django; translation

===========
Translation
===========

Change language
---------------

Switch context to a new language::

    from django.utils import translation
    translation.activate('en-us')

(link to Using translations outside views and templates)

Blocktrans
----------

https://docs.djangoproject.com/en/stable/topics/i18n/translation/#blocktrans-template-tag

This is confusing!  Here's the syntax, as best I can work out::

    {% blocktrans
        [with parm1=expr1 [parm2=expr2 ...]]
        [count parm=expr]
        [asvar varname]
        [trimmed]
    %}
        text
      [{% plural %}text]
    {% endblocktrans %}
