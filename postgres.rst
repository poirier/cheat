Postgres
========

Snippets
--------

* In psql::

    #  \d *pattern*

Display definition of table, view, or other relations with name matching the pattern

See http://jacobian.org/writing/pg-encoding-ubuntu/ to fix postgres to default to UTF-8 on ancient Ubuntus. (Destroys data.)

To set up your user on ubuntu to auth to local postgres automatically https://help.ubuntu.com/community/PostgreSQL

Check replication::

      ON master, select * from pg_stat_replication;
      (from http://www.dansketcher.com/2013/01/27/monitoring-postgresql-streaming-replication/)


Environment Variables
----------------------

The following environment variables can be used to select default connection parameter values, which will be used if no value is directly specified. These are useful to avoid hard-coding database connection information into simple client applications, for example.

 PGHOST behaves the same as host connection parameter.

 PGHOSTADDR behaves the same as hostaddr connection parameter. This can be set instead of or in addition to PGHOST to avoid DNS lookup overhead.

 PGPORT behaves the same as port connection parameter.

 PGDATABASE behaves the same as dbname connection parameter.

 PGUSER behaves the same as user connection parameter.

 PGPASSWORD behaves the same as password connection parameter. Use of this environment variable is not recommended for security reasons (some operating systems allow non-root users to see process environment variables via ps); instead consider using the ~/.pgpass file (see Section 30.14).

 PGPASSFILE specifies the name of the password file to use for lookups. If not set, it defaults to ~/.pgpass (see Section 30.14).

Dump Postgres table to a .CSV file
----------------------------------

Started with this: http://stackoverflow.com/questions/1120109/export-postgres-table-to-csv-file-with-headings

Using COPY requires superuser but the error message helpfully tells you that you can use \copy instead :-)

Using caktus' django template, something like::

    $ fab -udpoirier production manage_run:dbshell
    [huellavaliente.com:2222] out: venezuelasms_production=> \copy messagelog_message to '/tmp/messages.csv' csv header
    [huellavaliente.com:2222] out: venezuelasms_production=> \q

    $ sftp -o Port=2222 dpoirier@huellavaliente.com
    Connected to huellavaliente.com.
    sftp> cd /tmp
    sftp> ls
    messages.csv
    sftp> get messages.csv
    Fetching /tmp/messages.csv to messages.csv
    /tmp/messages.csv                                                                                              100% 1776KB 888.0KB/s   00:02
    sftp> ^D


Postgres with non-privileged users
-----------------------------------

How do we do things on Postgres without giving superuser to the
user that actually uses the database every day?  The following
assumes a Postgres superuser named 'master'.  (Or the RDS
'master' user, who has most superuser privileges.)

In the examples below, for readability I'm omitting most of the common
arguments to specify where the postgres server is, what the database name is,
etc. You can set some environment variables to use as defaults for things::

    export PGDATABASE=dbname
    export PGHOST=xxxxxxxxx
    export PGUSER=master
    export PGPASSWORD=xxxxxxxxxx

Create user
-----------

This is pretty standard.  To create user ``$username`` with plain text password
``$password``::

    export PGUSER=master
    export PGDATABASE=postgres
    createuser -DERS $username
    psql -c "ALTER USER $username WITH PASSWORD '$password';"

Yes, none of the options in ``-DERS`` are strictly required, but if you don't
mention them explicitly, createuser asks you about them one at a time.

If not on RDS, for the user to actually do something useful like connect to postgres,
you might also have to edit pg_hba.conf and add a line like::

    local   <dbname>   <rolename>                                  md5

to let it connect using host='' (unix domain socket) and provide a password
to access <dbname>.  You could also put "all" there to let it access any
password it otherwise has auth for.  E.g. to allow local connections via both unix socket and tcp connections to localhost::

    local   all             all                                     md5
    host    all             all             127.0.0.1/32            md5

Create database
---------------

If you need a database owned by ``$project_user``, you can:

* Create it as ``$project_user`` if that user has CREATEDB::

    export PGUSER=$project_user
    createdb --template=template0 $dbname

* Create it as a superuser and specify that the owner should be ``$project_user``::

    export PGUSER=postgres
    createdb --template=template0 --owner=$project_user $dbname

* Create it as any other user, so long as the other user is a member, direct
  or indirect, of the ``$project_user`` role.  That suggests that we could
  add ``master`` to that role... need to research that.  I think we could do::

    export PGUSER=master
    psql -c "grant $project_user to master;" postgres
    createdb --template=template0 --owner=$project_user $dbname

  The question would be: Does master have enough privileges to grant itself
  membership in another role?

* Finally, you could create it as ``master`` when master is not a member
  of the project_user role. To do that, you'll need
  to create it as ``master`` and then modify the ownership and permissions::

    export PGUSER=master
    createdb --template=template0 $dbname
    psql -c "revoke all on database $dbname from public;"
    psql -c "grant all on database $dbname to master;"
    psql -c "grant all on database $dbname to $project_user;"

If you need to enable extensions etc, do that now (see below).  When done, then::

    psql -c "alter database $dbname owner to $project_user;"

A superuser could create the database already owned by a specific user,
but RDS's master user cannot.

PostGIS
-------

To enable PostGIS, as the master user::

    export PGUSER=master
    psql -c "create extension postgis;"
    psql -c "alter table spatial_ref_sys OWNER TO $project_user;"

where ``$project_user`` is the postgres user who will be using the database.

(Outside of RDS, only a superuser can use ``create extension``; RDS has special
handling for a whitelist of extensions.)

Hstore
------

Hstore is simpler, but you still have to use the master user::

    export PGUSER=master
    psql -c "create extension hstore;"

Grant read-only access to a database
------------------------------------

Only let `readonly_user` do reads::

    $ psql -c "GRANT CONNECT ON DATABASE $dbname TO $readonly_user;"
    $ psql -c "GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC TO $readonly_user;" $dbname

Restore a dump to a new database
--------------------------------

Create the database as above, including changing ownership to the project
user, and enabling any needed extensions. Then as the project user::

    export PGUSER=$project_user
    pg_restore --no-owner --no-acl --dbname=$dbname file.dump

Note that you might get some errors during the restore if it tries to create
extensions that already exist and that kind of thing, but those are
harmless. It does mean you can't use ``--one-transaction`` or
``--exit-on-error`` for the restore though, because they abort on
the first error.

Dump the database
-----------------

This is pretty standard and can be done by the project user::

    export PGUSER=$project_user
    pg_dump --file=output.dump --format=custom $dbname

Drop database
-------------

When it comes time to drop a database, only master has the permission, but
master can only drop databases it owns, so it takes two steps.  Also,
you can't drop the database you're connected to, so you need to connect
to a different database for the ``dropdb``.  The ``postgres`` database is
as good as any::

    export PGUSER=master PGDATABASE=postgres
    psql -c "alter database $dbname owner to master;"
    psql -c "drop database if exists $dbname;"

(Outside of RDS, a superuser can drop any database. A superuser still
has to be connected to some other database when doing it, though.)

Drop user
---------

This is standard too.  Just beware that you cannot drop a user if anything
they own still exists, including things like permissions on databases.::

    $ export PGUSER=master
    $ dropuser $user

Postgres on RDS
----------------

* Add ``django-extensions`` to the requirements and `django_extensions` to the `INSTALLED_APPS` so we can use the [sqldsn](http://django-extensions.readthedocs.org/en/latest/sqldsn.html) management command to get the exact Postgres settings we need to access the database from outside of Django.  Here's how it works::

    manage.py [--settings=xxxx] sqldsn
