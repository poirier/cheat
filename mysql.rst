MySQL with Django
=================

Ubuntu: need to install (to use MySQL with Django)::

   sudo apt-get install mysql-client mysql-server libmysqlclient-dev

Django::

   pip install mysqlclient

   DATABASES['default'] = {
      'ENGINE': 'django.db.backends.mysql',
      'NAME': 'dbname',
      'USER': 'username',
   }


Using the client
~~~~~~~~~~~~~~~~

Starting the client::

    $ mysql --user=username [database]      # if user has no password
    $ mysql --user=username --password [database]   # to be prompted for password

To do things that require mysql root::

    $ mysql -u root   # If root has no password and older Debian
    $ mysql -u root -p  # if root has password and older Debian
    $ sudo mysql -u root   # On more recent Debian, no need for root password but must be root user

Users and permissions
~~~~~~~~~~~~~~~~~~~~~

In the client::

    mysql> SELECT user, host from mysql.user;                           # List existing users
    mysql> CREATE USER 'username' IDENTIFIED BY 'plaintextpassword';       # Create user with password
    mysql> CREATE USER 'username'@'localhost';   # no password, can only connect locally
    mysql> SHOW DATABASES;
    mysql> CREATE DATABASE databasename;
    mysql> GRANT ALL ON databasename.* TO "username"@"hostname" IDENTIFIED BY "password";
    mysql> FLUSH PRIVILEGES;
    mysql> DROP DATABASE databasename;
    mysql> DROP USER username;
    mysql> EXIT
    Bye

Change user password
~~~~~~~~~~~~~~~~~~~~

Note: default host is '%' which will not let you connect via unix socket, must set password for host 'localhost' to allow that::

    mysql> update mysql.user set password=password('foo'),host='localhost' where user='poirier_wordpres';   # On older MySQL
    mysql> set password for 'dpoirier'@'localhost' = 'plainpass';  # More recent MySQL
    mysql> flush privileges;

Recover lost password
~~~~~~~~~~~~~~~~~~~~~

http://dev.mysql.com/doc/refman/5.5/en/resetting-permissions.html

C.5.4.1.3. Resetting the Root Password: Generic Instructions
On any platform, you can set the new password using the mysql client::

    Stop mysqld
    Restart it with the --skip-grant-tables option. This enables anyone to connect without a password and with all privileges. Because this is insecure, you might want to use --skip-grant-tables in conjunction with --skip-networking to prevent remote clients from connecting.

    $ mysql
    mysql> UPDATE mysql.user SET Password=PASSWORD('MyNewPass') WHERE User='root';
    mysql> FLUSH PRIVILEGES;
    mysql> EXIT

    Stop the server
    Restart it normally (without the --skip-grant-tables and --skip-networking options).

Dumps
~~~~~

Make a dump::

    mysqldump --single-transaction _dbname_ > dumpfile.sql
    mysqldump --result-file=dumpfile.sql --single-transaction _dbname_

(Use ``--single-transaction`` to
`avoid locking the DB <https://www.howtogeekpro.com/180/how-to-backup-a-live-mysql-db-without-locking-tables-using-mysqldump/>`_
during the dump.)

Restore a dump::

    mysql dbname < dumpfile.sql

Create a new MySQL database
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Step by step::

    $ mysql -u root -p
    <ENTER MYSQL ROOT PASSWORD>
    mysql> create user 'ctsv2_TR'@'localhost';
    mysql> create database ctsv2_TR;
    mysql> grant all on ctsv2_TR.* to 'cstv2_TR'@'localhost';
    mysql> flush privileges;
    mysql> exit
    Bye
