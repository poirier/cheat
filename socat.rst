Socat
=====

http://stackoverflow.com/questions/2149564/redirecting-tcp-traffic-to-a-unix-domain-socket-under-linux

Turns out socat can be used to achieve this::

    socat TCP-LISTEN:1234,reuseaddr,fork UNIX-CLIENT:/tmp/foo

And with a bit of added security::

    socat TCP-LISTEN:1234,bind=127.0.0.1,reuseaddr,fork,su=nobody,range=127.0.0.0/8 UNIX-CLIENT:/tmp/foo
