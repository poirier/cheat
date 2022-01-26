Travis CI
=========
.. contents::

Magic syntax to run tox tests with multiple Python versions (as of Nov 1, 2017 anyway)::

    # Use travis container-based build system for speed
    sudo: false

    # Ubuntu trusty (14.04) - latest that Travis offers
    dist: trusty

    # Make sure all the python versions we need are pre-installed
    # (apt-get is not available in the container-based build system)
    addons:
      apt:
        sources:
        - deadsnakes
        packages:
        - python2.7
        - python3.4
        - python3.5
        - python3.6

    language: python

    # The version of Python that'll be used to invoke tox. Has no effect
    # on what version of Python tox uses to run each set of tests.
    python:
      - "3.5"

    # Test a sampling of combinations
    env:
      - TOXENV=py27-1.7
      - TOXENV=py27-1.8
      - TOXENV=py27-1.10
      - TOXENV=py27-1.11
      - TOXENV=py34-1.7
      - TOXENV=py34-1.8
      - TOXENV=py34-1.11
      - TOXENV=py35-1.9
      - TOXENV=py35-1.10
      - TOXENV=py35-1.11
      - TOXENV=py36-1.8
      - TOXENV=py36-1.10
      - TOXENV=py36-1.11

    install:
      - pip install tox

    script:
      - tox
    #
    #matrix:
    #  allow_failures:
    #    - env: TOXENV=py27-trunk,py33-trunk
