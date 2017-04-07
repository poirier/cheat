Dokku
=====

Readying a Django project for deploying to `Dokku <http://dokku.viewdocs.io/dokku/>`_.

This lists the things to add or change to easily deploy a Django application
to Dokku.

It started out not trying to cover all of setting up a site on Dokku, only
the parts relevant to a Django project -- but it has grown. Still,
you should read the Dokku getting
started docs, then use this as a cheatsheet to quickly enable existing
Django projects to deploy on Dokku.

.. toctree::

    dokku_files
    dokku_postgres
    dokku_ssl

Additional info (move to their own files as they're ready)...

Static files
------------

We use `whitenoise <http://whitenoise.evans.io/en/stable/>`_
to serve static files from Django.
If the site gets incredible amounts of traffic, throw a CDN in front,
but honestly, very few sites actually need that.
(If you have a philosophical objection to serving static files
from Django, you can customize the nginx config through Dokku
and probably manage to get nginx to do the static file serving,
but I haven't bothered figuring it out myself.)

Or put your static files `on S3 <https://www.caktusgroup.com/blog/2014/11/10/Using-Amazon-S3-to-store-your-Django-sites-static-and-media-files/>`_.

Django media
------------

If your site requires uploaded files to be persisted, remember
that the container running your code is ephemeral and any changes
made to files inside it will vanish at the next deploy.

First, you can
`use S3 for your media files <https://www.caktusgroup.com/blog/2014/11/10/Using-Amazon-S3-to-store-your-Django-sites-static-and-media-files/>`_.

Or you can
`use persistent storage <http://dokku.viewdocs.io/dokku~v0.9.2/advanced-usage/persistent-storage/>`_
on dokku, which is a way of mounting directories from the dokku server
inside the running container where your site code can store and read files
that will continue to exist past the lifetime of that particular container.

Simple hostnames
----------------

The simple way to set up hostnames is:

* Pick a hostname you can control, e.g. ``dokku.me``.
* During initial setup of dokku, configure that as the server's name.
* Create a DNS A record pointing ``dokku.me`` at the server's IP
  address.
* Add a wildcard entry for ``*.dokku.me`` at the same address.
* For each app you put on that server, give the app the same name
  you want to use for its subdomain.  For example, an app named
  ``foo`` would be accessible on the internet at ``foo.dokku.me``,
  without having to make any more changes to your DNS settings.

So, you could name your dokku server ``projectname.tld``, and then
have ``staging.projectname.tld`` and ``www.projectname.tld``.

If you want to get fancier, http://dokku.viewdocs.io/dokku~v0.9.2/configuration/domains/#customizing-hostnames.

Also, note that any requests simply addressed to ``dokku.me`` will
get routed to the alphabetically first app on the server, but you
can change that: http://dokku.viewdocs.io/dokku~v0.9.2/configuration/domains/#default-site
or just set up a "00default" app.

Zero downtime deploys
---------------------

WRITEME - see http://dokku.viewdocs.io/dokku~v0.9.2/deployment/zero-downtime-deploys/

Behind a load balancer
----------------------

If requests are being terminated at a load balancer and then proxied
to our dokku server, some nginx config customization will be needed
so your app can see the actual origin of the requests:
http://dokku.viewdocs.io/dokku~v0.9.2/configuration/ssl/#running-behind-a-load-balancer

Managing users
--------------

In other words, who can mess with the apps on a dokku server?

The way this currently works is that everybody ends up sshing to the server
as the ``dokku`` user to do things. To let them do that, we want to add a
public key for them to the dokku config, by doing this:

.. code-block:: bash

    $ cat /path/to/ssh_keyfile.pub | ssh dokku ssh-keys:add <KEYNAME>

The <KEYNAME> is just to identify the different keys. I suggest using the
person's typical username. Just remember there will not be a user of that
name on the dokku server.

When it's time to revoke someone's access:

.. code-block:: bash

    $ ssh dokku ssh_keys:remove <KEYNAME>

and now you see why the <KEYNAME> is useful.

For now, there's not a simple way to limit particular users to particular
apps or commands.

Run a command
-------------

Suppose you want to run something like ``python manage.py createsuperuser``
in the app environment?

.. code-block:: bash

    $ ssh dokku run <appname> python manage.py createsuperuser

will do it.

Running other daemons (like Celery)
-----------------------------------

Suppose you need to run another instance of your app in another
way, for example to run ``celery beat`` and ``celery worker``.

Use the ``Procfile`` to tell Dokku what processes to run.
E.g. if your Procfile is::

    web: gunicorn path/to/file.wsgi

try editing it to::

    web: gunicorn path/to/file.wsgi
    beat: celery beat -A appname -linfo
    worker: celery worker -A appname -linfo

With just that, the extra processes won't run automatically. You can run
them by telling Dokku to `scale them up <http://dokku.viewdocs.io/dokku~v0.9.2/deployment/process-management/>`_,
e.g.:

.. code-block:: bash

    $ ssh dokku ps:scale <appname> beat=1 worker=4

You can check the current scaling settings:

.. code-block:: bash

    $ ssh dokku ps:scale <appname>
    -----> Scaling for <appname>
    -----> proctype           qty
    -----> --------           ---
    -----> web                1
    -----> beat               1
    -----> worker             4

and see what's actually running (example from another app
that only has one process):

.. code-block:: bash

    $ ssh dokku ps:report <appname>
    =====> <appname>
           Processes:           1
           Deployed:            true
           Running:             true
           Restore:             true
           Restart policy:      on-failure:10
           Status web.1         true       (CID: 03ea8977f37e)

Since we probably don't want to have to remember to manually scale these
things up and check that they're running, we can add a DOKKU_SCALE file to
our repo::

    web=1
    beat=1
    worker=4

which is equivalent to running ``ps:scale web=1 beat=1 worker=4``

Secrets
-------

First, if possible, use Dokku plugin integrations for things
like databases, Redis, cache, etc. They automatically set
environment variables in each app that your settings can read,
so you don't have to manage different settings for each environment.
See each plugin's doc, of course, for more on that.

The way to handle other secrets for each environment is to
set them as config on the app, which will add them as environment
variables, again so your settings can read them at runtime.

The downside is that the secrets aren't being managed/versioned
etc for us... but I think we can handle the few we'll need by
manually keeping them in Lastpass or something.

`Here are the docs for setting config.
<http://dokku.viewdocs.io/dokku/configuration/environment-variables/>`_

Before setting any config, note that by default, making any
change to the config triggers a new deploy. If you're not ready
for that, include ``--no-restart`` in the command, as these
examples will do.

To set config variables:

.. code-block:: bash

    $ ssh dokku config:set <appname> --no-restart VAR1=VAL1 VAR2=VAL2 ...

To remove a variable:

.. code-block:: bash

    $ ssh dokku config>unset <appname> --no-restart VAR1

Check the value of some variable:

.. code-block:: bash

    $ ssh dokku config:get <appname> VAR1
    VAL1

Get all the settings in a single line, handy for use in shell commands
or to set on another app:

.. code-block:: bash

    $ ssh dokku config <appname> --shell
    VAR1=VAL1 VAR2=VAL2
    $ export $(ssh dokku config <appname> --shell)
    $ ssh dokku config:set <appname1> $(ssh dokku config <appname2> --shell)

Get all the settings in a format handy to save in a file for later sourcing:

.. code-block:: bash

    $ ssh dokku config <appname> --export
    export VAR1=VAL1
    export VAR2=VAL2
    $ ssh dokku config <appname> --export >appname.env
    $ . appname.env

Note: you can also set config vals globally - just change ``<appname>`` to
``--global`` in any of these commands.

Logs
----

Dokku collects stdout from your processes and you can view it with
the ``dokku logs`` command.

`nginx logs <http://dokku.viewdocs.io/dokku/configuration/nginx/#nginx-configuration>`_
are similarly stored on the server and can be accessed using
``dokku nginx:access-log <appname>`` or ``dokku nginx:error-log <appname>``.

Dokku event logging can be enabled with `dokku events:on <http://dokku.viewdocs.io/dokku/advanced-usage/event-logs/>`_
and then viewed with ``dokku events``. This shows things like deploy steps.

Deploying from private git repos
--------------------------------

`Docs <http://dokku.viewdocs.io/dokku/deployment/application-deployment/#deploying-with-private-git-submodules>`_,
such as they are...

I think the upshot is:

* Create a new ssh key for deploying
* Add it to the repo on Github (or whatever) as an authorized deploy key
  (TODO: Link to github docs on that)
* Drop a copy of the public key file into ``/home/dokku/.ssh/``
  on the Dokku system (with appropriate permissions)

Deploying non-master branch
---------------------------

`The docs <http://dokku.viewdocs.io/dokku/deployment/application-deployment/#deploying-non-master-branch>`_

By default, dokku deploys when the app's master branch on the dokku server is updated. There
are (at least) two ways to deploy a branch other than master.

1) Push your non-master local branch to the master branch on the server:

.. code-block:: bash

    $ git push dokku <local branch>:master

but that requires you to always remember that if you have apps that are always supposed
to use a different branch than master.

2) Configure your app so the default branch is different, by changing the config value ``DOKKU_DEPLOY_BRANCH``:

.. code-block:: bash

    $ ssh dokku config:set --no-restart app-name DOKKU_DEPLOY_BRANCH=some-branch

This seems like a more useful approach.  Just "git push dokku some-branch" every time
you want to deploy your app.

Developing with multiple remote apps
------------------------------------

Suppose you have local development and sometimes you want to push to staging
and sometimes to production.  Maybe you have other apps too.

The key is to set up a different git remote for each remote app.  E.g.:

.. code-block:: bash

    $ ssh dokku app:create staging
    $ ssh dokku config:set --no-restart staging DOKKU_DEPLOY_BRANCH=develop

    $ git remote add staging dokku@my-dokku-server.com:staging

    $ ssh dokku app:create production
    $ ssh dokku config:set --no-restart production DOKKU_DEPLOY_BRANCH=master

    $ git remote add production dokku@my-dokku-server.com:production

Then to deploy, push the approprate branch to the appropriate branch:

.. code-block:: bash

    $ git push staging develop
    $ git push production master

