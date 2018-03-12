Pipenv
======

`Pipenv docs <https://docs.pipenv.org/>`_

Converting from a requirements file
-----------------------------------

Just run "pipenv install [-r requirementsfile]" and it'll see that there's
no Pipfile but a requirements file, and will generate a new Pipfile and .lock
file for you. Then edit the Pipfile to clean it up.

Creating a requirements file
----------------------------

Do this::

    pipenv lock --requirements >non-dev-requirements.txt
    pipenv lock --requirements --dev >only-dev-requirements.txt

Keeping dev-only packages out of production
-------------------------------------------

1) Add dev-only packages using ``pipenv install --dev <packages>``
2) For development, install using ``pipenv install --dev``
3) In production, leave off the ``--dev``
