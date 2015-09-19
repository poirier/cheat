Databases
=========

Performance
-----------

From Django 1.6 on, always add `CONN_MAX_AGE` to database settings
to enable persistent connections. `300` is a good starting
value (5 minutes).  `None` will keep them open indefinitely.

BUT - keep in mind that every open connection to Postgres
consumes database server resources. So you might want *instead*
to run pgbouncer locally.
