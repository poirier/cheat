.. index:: django; nginx

.. _nginx:

NGINX
=====

Some tips on Nginx for use with Django


Files
-----

Just add a new file to ``/etc/nginx/sites-enabled`` for each site,
making sure ``server_name`` is set correctly in each.

Redirecting to SSL
------------------

We usually want to force SSL::

    server {
      listen *:80;
      listen [::]:80;
      server_name DOMAIN;
      access_log PATH_access.log;
      error_log PATH_error.log;
      return 301 https://DOMAIN$request_uri;
    }


Proxying to gunicorn
--------------------

Serve static and media files with nginx, and proxy everything
else to Django::

    upstream django {
      server unix:/tmp/PATH fail_timeout=0;
    }

    server {
      listen *:443 ssl;   # add spdy here too if you want
      listen [::]:443 ssl;
      server_name DOMAIN;
      ssl_certificate PATH.crt;
      ssl_certificate_key PATH.key;

      access_log PATH_access.log;
      error_log PATH_error.log;
      root PATH;
      location /media {
        alias PATH;
      }
      location /static {
        alias PATH;
      }
      location / {
        client_max_body_size 500M;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_buffering on;
        proxy_intercept_errors on;
        proxy_pass http://django;
      }

      # See https://www.trevorparker.com/hardening-ssl-in-nginx/
      ssl_protocols             TLSv1 TLSv1.1 TLSv1.2;
      ssl_prefer_server_ciphers on;
      ssl_ciphers               DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:ECDHE-RSA-AES1\
    28-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM\
    -SHA384:kEDH+AESGCM:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES\
    256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SH\
    A256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SH\
    A384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SH\
    A256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:\
    !RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA;
      ssl_session_timeout       5m;
      ssl_session_cache         shared:SSL:10m;

      add_header Strict-Transport-Security max-age=31536000;
    }
