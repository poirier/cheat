Fabric
======

Sample tasks::

    @task
    def db_backup():
        """
        Backup the database to S3 just like the nightly cron job
        """
        require('environment')
        require('instance', provided_by='instance')
        manage_run("dbbackup --encrypt")


    def db_exists(dbname):
        """
        Return True if a db named DBNAME exists on the remote host.
        """
        require('environment', provided_by=SERVER_ENVIRONMENTS)
        output = sudo('psql -l --pset=format=unaligned', user='postgres')
        dbnames = [line.split('|')[0] for line in output.splitlines()]
        return dbname in dbnames


    @task
    def db_dump(file):
        """
        Dump an instance's database to a remote file.

        Example:

          `fab staging instance:iraq db_dump:/tmp/staging_iraq.dump`

        dumps to staging_iraq.dump
        """
        require('environment', provided_by=SERVER_ENVIRONMENTS)
        require('instance', provided_by='instance')
        remote_file = file

        if files.exists(file):
            if not confirm("Remote file {file} exists and will be overwritten.  Okay?"
                    .format(file=remote_file)):
                abort("ERROR: aborting")

        # Don't need remote DB user and password because we're going to run pg_dump as user postgres
        sudo('pg_dump --format=custom --file={outputfile} {dbname}'
             .format(dbname=env.db_name, outputfile=remote_file),
             user='postgres')
        print("Database from {environment} {instance} has been dumped to remote file {file}"
              .format(environment=env.environment, instance=env.instance, file=remote_file))


    @task
    def local_restore(file):
        """
        Restore a local dump file to the local instance's database.
        :param file:
        :return:
        """
        # Find out the local DB settings
        import sys
        sys.path[0:0] = ['.']
        from cts.settings.local import DATABASES
        DB = DATABASES['default']
        assert DB['ENGINE'] == 'django.contrib.gis.db.backends.postgis'
        dbname = DB['NAME']
        owner = DB['USER'] or os.getenv('USER')
        local('dropdb {dbname} || true'.format(dbname=dbname), shell="/bin/sh")
        local('createdb --encoding UTF8 --lc-collate=en_US.UTF-8 --lc-ctype=en_US.UTF-8 --template=template0 --owner {owner} {dbname}'.format(owner=owner, dbname=dbname))
        local('sudo -u postgres pg_restore -Ox -j4 --dbname={dbname} {file}'.format(dbname=dbname, file=file))


    @task
    def db_restore(file):
        """
        Restore a remote DB dump file to a remote instance's database.

        This will rename the existing database to {previous_name}_bak
        and create a completely new database with what's in the dump.

        If there's already a backup database, the restore will fail.

        Example:

          `fab staging instance:iraq db_restore:/tmp/staging_iraq.dump`

        :param file: The remote file to restore.
        """
        require('environment', provided_by=SERVER_ENVIRONMENTS)
        require('instance', provided_by='instance')

        renamed = False
        restored = False

        if not files.exists(file):
            abort("Remote file {file} does not exist".format(file=file))

        try:
            if db_exists(env.db_name):
                # Rename existing DB to backup
                db_backup = '{dbname}_bak'.format(dbname=env.db_name)
                if db_exists(db_backup):
                    if confirm("There's already a database named {db_backup}. Replace with new backup?"
                            .format(db_backup=db_backup)):
                        sudo('dropdb {db_backup}'.format(db_backup=db_backup),
                             user='postgres')
                    else:
                        abort("ERROR: There's already a database named {db_backup}. "
                              "Restoring would clobber it."
                              .format(db_backup=db_backup))
                sudo('psql -c "ALTER DATABASE {dbname} RENAME TO {db_backup}"'
                     .format(dbname=env.db_name, db_backup=db_backup),
                     user='postgres')
                renamed = True
                print("Renamed {dbname} to {db_backup}".format(dbname=env.db_name, db_backup=db_backup))

            remote_file = file

            # Create new, very empty database.
            # * We can't use --create on the pg_restore because that will always restore to whatever
            #   db name was saved in the dump file, and we don't want to be restricted that way.
            # * Any extensions the backed-up database had will be included in the restore, so we
            #   don't need to enable them now.

            # If these parameters change, also change the parameters in conf/salt/project/db/init.sls
            # (TODO: we could use the output of psql -l to copy most of these settings from the
            # existing database.)
            sudo('createdb --encoding UTF8 --lc-collate=en_US.UTF-8 '
                 '--lc-ctype=en_US.UTF-8 --template=template0 --owner {owner} {dbname}'
                 .format(dbname=env.db_name, owner=env.db_owner),
                 user='postgres')

            # Don't need remote DB user and password because we're going to
            # run pg_restore as user postgres
            sudo('pg_restore -1 --dbname={dbname} {filename}'
                 .format(dbname=env.db_name, filename=remote_file),
                 user='postgres')
            restored = True

            # Run ANALYZE on the db to help Postgres optimize how it accesses it
            sudo('psql {dbname} -c ANALYZE'.format(dbname=env.db_name),
                 user='postgres')

            print("Database for {environment} {instance} has been restored from remote file {file}"
                  .format(environment=env.environment, instance=env.instance, file=remote_file))
        finally:
            if renamed and not restored:
                print("Error occurred after renaming current database, trying to rename it back")
                if db_exists(env.db_name):
                    # We already created the new db, but restore failed; delete it
                    sudo('dropdb {dbname}'.format(dbname=env.dbname), user='postgres')
                sudo('psql -c "ALTER DATABASE {db_backup} RENAME TO {dbname}"'
                     .format(dbname=env.db_name, db_backup=db_backup),
                     user='postgres')
                print("Successfully put back the original database.")
