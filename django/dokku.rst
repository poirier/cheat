.. index:: ! Dokku

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

Start with the pages in this list, in order, then come back
to this page and continue reading:

.. toctree::

    dokku_admin
    dokku_files
    dokku_postgres
    dokku_ssl

Additional info (move to their own files as they're ready)...

Environment variables
---------------------

I can't find docs on what environment variables Dokku sets globally
when running apps. But just about any Django app is going to be linked to a database,
so if you need to detect whether the app is running under Dokku
or Heroku, looking for DATABASE_URL should be good enough.

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
on Dokku, which is a way of mounting directories from the dokku server
inside the running container where your site code can store and read files
that will continue to exist past the lifetime of that particular container.

Simple hostnames
----------------

If the server is set up properly, assuming the server's domain
name is ``dokkuserver.domain``, creating an app named ``foo`` will
automatically ``foo.dokkuserver.domain``
resolve to the server's address, and requests with host ``foo.dokkuserver.domain``
to be routed to that app.

If you want to get fancier, http://dokku.viewdocs.io/dokku/configuration/domains/.

Also, note that any requests simply addressed to ``dokku.me`` will
get routed to the alphabetically first app on the server, but you
can change that: http://dokku.viewdocs.io/dokku/configuration/domains/
or just set up a "00default" app.

Zero downtime deploys
---------------------

WRITEME - see http://dokku.viewdocs.io/dokku/deployment/zero-downtime-deploys/

Behind a load balancer
----------------------

If requests are being terminated at a load balancer and then proxied
to our dokku server, some nginx config customization will be needed
so your app can see the actual origin of the requests:
http://dokku.viewdocs.io/dokku/configuration/ssl/#running-behind-a-load-balancer

Run a command
-------------

Suppose you want to `run <http://dokku.viewdocs.io/dokku/deployment/one-off-processes/>`_
something like ``python manage.py createsuperuser``
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
them by telling Dokku to `scale them up <http://dokku.viewdocs.io/dokku/deployment/process-management/#psscale-command>`_,
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

Get all the settings in a format handy to save in a file for later sourcing
in a local shell:

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

Note: this doesn't apply to your main project repo. That can be private and Dokku
doesn't care, because you're pushing it directly from your development system to
the Dokku server.

But if your requirements include references to private git repos, then
you'll need to arrange for Dokku to get access to those repos when it's
``pip installing`` your requirements.

`Dokku docs <http://dokku.viewdocs.io/dokku/deployment/application-deployment/#deploying-with-private-git-submodules>`_,
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

2) Configure your app so the default branch is different, by using the git:set command:

.. code-block:: bash

    $ ssh dokku git:set appname deploy-branch SOME_BRANCH_NAME

This seems like a more useful approach.  Just "git push dokku some-branch" every time
you want to deploy your app.

Developing with multiple remote apps
------------------------------------

Suppose you have local development and sometimes you want to push to staging
and sometimes to production.  Maybe you have other apps too.

The key is to set up a different git remote for each remote app.  E.g.:

.. code-block:: bash

    $ ssh dokku app:create staging
    $ ssh dokku git:set staging deploy-branch develop

    $ git remote add staging dokku@my-dokku-server.com:staging

    $ ssh dokku app:create production
    $ ssh dokku git:set production deploy-branch master

    $ git remote add production dokku@my-dokku-server.com:production

Then to deploy, push the approprate branch to the appropriate branch:

.. code-block:: bash

    $ git push staging develop
    $ git push production master

Customizing nginx config
------------------------

If you need to completely override the nginx config, you'll need
to `provide an nginx config file template <http://dokku.viewdocs.io/dokku~v0.9.4/configuration/nginx/#customizing-the-nginx-configuration>`_.

Luckily, much customization can be done just by
`providing snippets <http://dokku.viewdocs.io/dokku~v0.9.4/configuration/nginx/#customizing-via-configuration-files-included-by-the-default-tem>`_
of configuration for nginx to include after it's base config file.

To do this, arrange for the snippets to get copied
to ``/home/dokku/<appname>/nginx.conf.d/`` during deployment,
probably in a pre- or post-deploy script.

Logging to papertrail
---------------------

Use the `logspout <https://github.com/michaelshobbs/dokku-logspout>`_ plugin.

Adding Sentry service
---------------------

https://github.com/darklow/dokku-sentry

