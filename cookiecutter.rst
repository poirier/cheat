Cookiecutter
============
.. contents::

https://cookiecutter.readthedocs.io/en/latest/usage.html

Install
-------

    pipx install cookiecutter

Instantiating a new project from a cookiecutter template
---------------------------------------------------------

Assuming the template is a git repo somewhere, point cookiecutter at the git URL::

    cookiecutter https://github.com/audreyr/cookiecutter-pypackage.git

If it's in a local directory, point at that::

    cookiecutter ../my-template

You can also instantiate a zipped template, either local or remote.

User config
-----------

You `can set <https://cookiecutter.readthedocs.io/en/latest/advanced/user_config.html>`_
some personal configuration that will be used anytime you instantiate any template.

Replay
------

Cookiecutter can `save and reuse <https://cookiecutter.readthedocs.io/en/latest/advanced/replay.html>`_
your responses to the prompts during template instantiation.
