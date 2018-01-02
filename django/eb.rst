Elastic Beanstalk with Django
=============================

SSH into a random instance. This assumes that you have copied the SSH private key into your
``$HOME/.ssh`` directory::

    (bringfido)$ eb ssh staging

Open the AWS Elasticbeanstalk web console::

    (bringfido)$ eb console staging

Scale the application to N web instances::

    (bringfido)$ eb scale <N> staging

Check the overall status of the environment, or detailed info about each instance::

    (bringfido)$ eb status -v staging
    (bringfido)$ eb health staging

If you need to work with Django on a server, after ssh'ing in::

    $ . /opt/python/current/env
    $ cd /opt/python/current/app
    $ python manage.py ....
