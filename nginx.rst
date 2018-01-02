Nginx
=====

`Docs are here <http://nginx.org/en/docs/>`_ but good luck finding anything there
if you don't already where it is.

Most useful variables
---------------------

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

See above for "variables" that get set automaticaly for each request
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
