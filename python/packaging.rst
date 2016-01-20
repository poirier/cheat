Python Packaging
================

`The authoritative docs <https://packaging.python.org/en/latest/>`_.

Example setup.py::

    # Always prefer setuptools over distutils
    from setuptools import setup, find_packages
    # To use a consistent encoding
    from codecs import open
    from os import path

    here = path.abspath(path.dirname(__file__))

    setup(
        name='ursonos',
        version='0.0.1',
        packages=find_packages(),
        url='',
        license='',
        author='poirier',
        author_email='dan@poirier.us',
        description='Urwid application to control Sonos',
        install_requires=[
            'soco',
            'urwid'
        ]
    )

To include non-Python files in the packaging, create a
`MANIFEST.in file <https://docs.python.org/2/distutils/sourcedist.html#the-manifest-in-template>`_.
Example::

    include path/to/*.conf

adds the files matching path/to/*.conf.  Another::

    recursive-include subdir/path *.txt *.rst

adds all files matching *.txt or *.rst that are anywhere
under subdir/path.  Finally::

    prune examples/sample?/build

should be obvious.
