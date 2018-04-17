Docker
======

Terminology
...........

Container: A container is used to execute an image.  See ``docker run``,
``docker-compose up``.

Image: A kind of snapshot of a computer system that can be run in a container.
Images are built from Dockerfiles.  See ``docker build``, ``docker-compose build``.

Common commands
...............

Build an image from Dockerfile in current directory::

    docker build -t imagetag .

Start a container from an image, run a command, and when the
command exits, stop the container without saving any changes::

    docker run --rm -it imagetag bash

Cleanup
.......

delete volumes
--------------

see: https://github.com/chadoe/docker-cleanup-volumes

::

    $ docker volume rm $(docker volume ls -qf dangling=true)
    $ docker volume ls -qf dangling=true | xargs -r docker volume rm

delete networks
---------------

    $ docker network ls
    $ docker network ls | grep "bridge"
    $ docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')

remove docker images
--------------------

see: http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images

::

    $ docker images
    $ docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

    $ docker images | grep "none"
    $ docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')

remove docker containers
------------------------

see: http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images

::

    $ docker ps
    $ docker ps -a
    $ docker rm $(docker ps -qa --no-trunc --filter "status=exited")

Resize disk space for docker vm
-------------------------------

::

    $ docker-machine create --driver virtualbox --virtualbox-disk-size "40000" default


