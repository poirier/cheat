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
