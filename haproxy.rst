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
        default_backend sslserver
    backend sslserver
        mode tcp
        server servername 1.2.3.4:443

Route based on SNI
------------------

This works even if haproxy is not terminating the SSL connection::

    acl site_b req_ssl_sni -i site_b.com
    use_backend site_b_backend if site_b
    backend site_b_backend
      mode tcp
      server b1 10.0.0.1:443
      server b2 10.0.0.2:443

Explanation: we set the condition "site_b" true if the
SSL SNI in the request (req_ssl_sni) is case-insensitively
equal to (-i) the string "site_b.com".  We use the backend
"site_b_backend" if the condition  "site_b" is true.
Backend "site_b_backend" means to forward the request without
terminating the SSL connection ("mode tcp") to either the
server at 10.0.0.1 port 443, or 10.0.0.2 port 443.

Route based on Host request header
----------------------------------

Use an ACL to check the header and then pick a backend::

    acl site_a hdr(host) -i site_a.com
    use_backend site_a_backend if site_a
    backend site_a_backend
      mode http
      server a1 10.0.0.1:80
      server a2 10.0.0.2:80
