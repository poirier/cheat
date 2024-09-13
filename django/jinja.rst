Jinja templates in Django
=========================

For more information:

* https://docs.djangoproject.com/en/5.1/topics/templates/#django.template.backends.jinja2.Jinja2
* https://jinja.palletsprojects.com/

Where to put Jinja template files
---------------------------------

As we know, the default Django template engine looks for template
files in each Django app in the ``templates`` subdirectory.

Similarly, the Jinja template engine looks in each Django app in
the ``jinja2`` subdirectory. (Unless you set APP_DIRS=False,
but why confuse yourself?)

To help myself keep things straight, I use the convention
that my Jinja template files end in ``.j2.html``, but that's
not necessary; you can name your template files anything you want.
It's the directory you put them in that really matters.


Context
-------

From `<https://docs.djangoproject.com/en/5.1/topics/templates/#django.template.backends.jinja2.Jinja2>`_: "The most important entry in OPTIONS is 'environment'. It’s a dotted Python path to a callable returning a Jinja2 environment. It defaults to 'jinja2.Environment'. Django invokes that callable and passes other options as keyword arguments."

See also

* https://jinja.palletsprojects.com/en/3.1.x/api/#basics
* https://jinja.palletsprojects.com/en/3.1.x/api/#jinja2.Environment
* https://jinja.palletsprojects.com/en/3.1.x/api/#global-namespace

To set things in the context for all Jinja templates in Django,
create a function that returns a ``jinja2.Environment``, and set
``environment`` to its path in the Jinja Django template settings.
For example::

  # appname/jinja.py

  from django.templatetags.static import static

  def environment(**options):
      options.setdefault("autoescape", True)
      env = Environment(**options)
      env.globals.update(
          {
              "static": static,
                ...
          }
      )
      env.filters["my_format_date"] = my_format_date
      return env

and in settings.py::

  TEMPLATES = [
      {
          "NAME": "django", ...
      },
      {
          "NAME": "jinja2", ...
          "OPTIONS": {
              "environment": "appname.jinja.environment",
          },
      },
  ]


Calling functions from Jinja templates
--------------------------------------

It's very handy to be able to call code from your template and
have the return value inserted into the output. With Django's default
template engine, you have to write template tags, though with the
provided shortcut decorators it's pretty easy.

With Jinja in Django, it's also easy, just slightly different. Write
a function that takes whatever args you like and returns a string::

  from django.urls import reverse

  def django_url_tag(urlname, *args):
      return reverse(urlname, args=args)

Add a reference to the function to the globals in the environment::

  # appname/jinja.py


  def environment(**options):
      env = Environment(**options)
      env.globals.update(
          {
              "url": django_url_tag,
              ...
          }
      )
      return env

In your templates, put calls to your function inside `{{ }}`::

    # ...html
    <a href="{{ url("home", 1, 2) }}">Home</a>

Filters
-------

There's not really a need for `filters <https://jinja.palletsprojects.com/en/3.1.x/api/#custom-filters>`_ in Jinja, but you can create
them if you want. It's only the difference between writing::

    {{ varname | filter(arg1, arg2) }}

and::

    {{ function(varname, arg1, arg2) }}

If you prefer the former, write a function that takes the filter
input as the first arg and any additional args after that, and
returns a string::

    def myfilterfunction(varname, arg1, arg2):
        return "somestring"

and add a reference to the Jinja environment by adding it
to ``env.filters`` in your environment function::

    env.filters["myfilter"] = myfilterfunction

Using Jinja templates from views
--------------------------------

You don't have to do anything different in your views to
use Jinja templates. If Django finds the template file you
ask for in the default Django template engine's template
directories, it'll process it using the default Django template
engine. If it finds the template file in the Jinja template
engine's template directories, it'll process it using the Jinja
template engine.

To help myself keep things straight, though, I use the convention
that my Jinja template files end in ``.j2.html``.

Example::

  from django.shortcuts import render

  def home(request):
    context = { ... }
    return render(request, "home.j2.html", context)

settings.py
-----------

See:

* https://docs.djangoproject.com/en/5.1/topics/templates/#django.template.backends.jinja2.Jinja2

Update TEMPLATES::

  TEMPLATES = [
      {
          "NAME": "django", ...
      },
      {
          "NAME": "jinja2",
          "BACKEND": "django.template.backends.jinja2.Jinja2",
          "DIRS": [BASE_DIR / "src" / "appname" / "jinja2"],
          "APP_DIRS": True,  # <app>/jinja2
          "OPTIONS": {
              "auto_reload": True,
              "environment": "appname.jinja.environment",
          },
      },
  ]

