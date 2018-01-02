HAProxy
=======

Make sure to use the docs corresponding to the version you are using.

1.5: https://cbonte.github.io/haproxy-dconv/1.5/configuration.html

Pass SSL thru
-------------

Use proxy "mode tcp".  E.g::

    listen sectionname
        bind :443
        mode tcp
        server server1 10.0.0.1:443

Route based on SNI
------------------

    acl site_b req_ssl_sni -i site_b.com
    use_backend site_b_backend if site_b
    backend site_b
      mode tcp
      server b1 10.0.0.1:443
      server b2 10.0.0.2:443

Route based on Host request header
----------------------------------

Use an ACL to check the header and then pick a backend::

    acl site_a hdr(host) -i site_a.com

    use_backend site_a_backend if site_a

    backend site_a_backend
      mode http
      server a1 10.0.0.1:80
      server a2 10.0.0.2:80
