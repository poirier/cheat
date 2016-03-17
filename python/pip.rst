Pip
===

Based on `A Better Pip Workflow <http://www.kennethreitz.org/essays/a-better-pip-workflow>`_,
from a `hackernews comment by blaze33 <https://news.ycombinator.com/item?id=11211114>`_:

To keep your file structure with commands and nicely separate
your dependencies from your dependencies' dependencies::

  pip freeze -r requirements-to-freeze.txt > requirements.txt

instead of just::

  pip freeze > requirements.txt

.. danger::
    beware of git urls being replaced by egg names in the process.
