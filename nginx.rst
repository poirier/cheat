.. index:: ! nginx

Nginx
=====

`Nginx docs are here <http://nginx.org/en/docs/>`_, but good luck finding anything there
if you don't already where it is.

I *HIGHLY RECOMMEND* going to
`https://ssl-config.mozilla.org <https://ssl-config.mozilla.org>`_
to generate a base config file, then customizing it.

.. contents::


Let's Encrypt
-------------

Let's Encrypt's `certbot <https://certbot.eff.org>`_ utility has an ``nginx``
option that doesn't do what I initially thought it did. It does not try to
automatically figure out from your nginx config what you're trying to do and update
your config correctly to use a Let's Encrypt certificate.

Instead, the ``nginx`` option temporarily changes your nginx configuration
to serve the response to the Let's Encrypt http challenge, does the certificate
request, restores your configuration, then tells you where it put the resulting
certificate and key (if successful)::

    root@junebug:~# certbot certonly -m dan@poirier.us --test-cert --agree-tos --cert-name=testit --non-interactive --nginx -d www.example.com
    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Plugins selected: Authenticator nginx, Installer nginx
    Obtaining a new certificate
    Performing the following challenges:
    http-01 challenge for www.example.com
    Waiting for verification...
    Cleaning up challenges

    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at:
       /etc/letsencrypt/live/testit/fullchain.pem
       Your key file has been saved at:
       /etc/letsencrypt/live/testit/privkey.pem
       Your cert will expire on 2021-09-20. To obtain a new or tweaked
       version of this certificate in the future, simply run certbot
       again. To non-interactively renew *all* of your certificates, run
       "certbot renew"

The nice things about this is that
you don't have to configure nginx yourself in a way that will let it both
start without having a certificate yet and serve the certbot challenge.

.. warning:: If something goes wrong, certbot can leave an instance of nginx running that is not managed by your service manager (e.g. systemd) and mess things up until you kill it manually.

Commented config file
---------------------

FIND OUT: what happens if we get a port 443 ssl request for a hostname
that we're not serving? Does nginx reject it completely, or try to serve
it with some existing hostname configuration?

This started from https://ssl-config.mozilla.org but is heavily modified.

.. code-block::

    # Put this at
    # /etc/nginx/conf.d/00-default-vhost.conf
    # It returns a 410 for any port 80 request for a domain name we're not serving with
    # a more specific configuration.
    server {
      listen 80 default_server;
      listen [::]:80 default_server;

      server_name _;
      return 410;
      log_not_found off;
      server_tokens off;
    }


Now for each site ``mysite.example.com`` that you want to serve...

.. index:: nginx; ssl redirection

.. code-block::
    # /etc/nginx/sites-enabled/mysite.example.com.conf
    server {
      listen 80;            # http://nginx.org/en/docs/http/ngx_http_core_module.html#listen
      listen [::]:80;
      server_name example.com www.example.com;  # http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name

      location '/.well-known/acme-challenge' {
        # Don't redirect Let's Encrypt to https
        root        /var/www/mysite.example.com;
      }

      location / {
        # Redirect to https
        return 301 https://$host$request_uri;
      }
    }

    server {
      listen 443 ssl http2;                     # http://nginx.org/en/docs/http/ngx_http_core_module.html#listen
      listen [::]:443 ssl http2;
      server_name example.com www.example.com;  # http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name

      root /var/www/mysite.example.com;

      # modern SSL configuration
      ssl_protocols TLSv1.3;
      ssl_prefer_server_ciphers off;

      ssl_certificate /path/to/signed_cert_plus_intermediates;
      ssl_certificate_key /path/to/private_key;
      ssl_session_timeout 1d;
      ssl_session_cache shared:MySiteExampleCom:10m;  # about 40000 sessions
      ssl_session_tickets off;

      # HSTS (ngx_http_headers_module is required) (63072000 seconds)
      # Do NOT uncomment this until you're SURE your https is working and will
      # continue working. You might set max-age very short for testing until
      # then. Do an internet search for more about HSTS.
      # add_header Strict-Transport-Security "max-age=63072000" always;
    }

Most useful variables
---------------------

.. index:: nginx; variables

$host
    in this order of precedence: host name from the request line, or host name from the “Host” request header field, or the server name matching a request

$http_host
    Value of the "Host:" header in the request (same as all $http_<headername> variables)

$https
    “on” if connection operates in SSL mode, or an empty string otherwise

$request_method
    request method, usually “GET” or “POST”

$request_uri
    full original request URI (with arguments)

$scheme
    request scheme, e.g. “http” or “https”

$server_name
    name of the server which accepted a request

$server_port
    port of the server which accepted a request


Variables in configuration files
--------------------------------

.. index:: nginx; using variables

See above for "variables" that get set automatically for each request
(and that we cannot modify).

The ability to set variables at runtime and control logic flow based on them
is part of the `rewrite module <http://nginx.org/en/docs/http/ngx_http_rewrite_module.html>`_
and *not* a general feature of nginx.

You can `set <http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set>`_ a
variable::

    Syntax:	set $variable value;
    Default:	—
    Context:	server, location, if

"The value can contain text, variables, and their combination." -- but I have not yet found
the documentation on how these can be "combined".

Then use `if <http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#if>`_ etc.::

    Syntax:	if (condition) { rewrite directives... }
    Default:	—
    Context:	server, location

Conditions can include::

* a variable name; false if the value of a variable is an empty string or “0”;
* comparison of a variable with a string using the “=” and “!=” operators;
* matching of a variable against a regular expression using the “~” (for case-sensitive matching) and “~*” (for case-insensitive matching) operators. Regular expressions can contain captures that are made available for later reuse in the $1..$9 variables. Negative operators “!~” and “!~*” are also available. If a regular expression includes the “}” or “;” characters, the whole expressions should be enclosed in single or double quotes.
* checking of a file existence with the “-f” and “!-f” operators;
* checking of a directory existence with the “-d” and “!-d” operators;
* checking of a file, directory, or symbolic link existence with the “-e” and “!-e” operators;
* checking for an executable file with the “-x” and “!-x” operators.

Examples::

    if ($http_user_agent ~ MSIE) {
        rewrite ^(.*)$ /msie/$1 break;
    }

    if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
        set $id $1;
    }

    if ($request_method = POST) {
        return 405;
    }

    if ($slow) {
        limit_rate 10k;
    }

    if ($invalid_referer) {
        return 403;
    }

.. warning::

    You *CANNOT* put any directive you want inside the ``if``,
    only rewrite directives like ``set``, ``rewrite``, ``return``, etc.

.. warning::

    The values of variables you set this way can *ONLY* be used in ``if`` conditions,
    and maybe rewrite directives; don't try to use them elsewhere.

Let's Encrypt
-------------

Based rather loosely on `https://certbot.eff.org/lets-encrypt/pip-nginx <https://certbot.eff.org/lets-encrypt/pip-nginx>`_.

* Before you start, your site must already be on the internet accessible using all the domain names you
  want certificates for, at port 80, and without
  any automatic redirect to port 443. If that makes you paranoid, you can configure nginx to redirect
  80 to 443 except for /.well-known/acme-challenge. Here's an unsupported example::

    server {
      listen 80;

      location '/.well-known/acme-challenge' {
        root        /var/www/demo;
      }

      location / {
        if ($scheme = http) {
          return 301 https://$server_name$request_uri;
        }
    }

* Install certbot. Assuming Ubuntu, "sudo apt install certbot python3-certbot-nginx" should do it.
* Run "sudo certbot certonly --nginx" and follow the instructions.
* Set up automatic renewal. This will add a cron command to do it::

    echo "0 0,12 * * * root /usr/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null

* run "sudo certbot renew --dry-run" to test renewal

