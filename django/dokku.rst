Dokku
=====

Readying a Django project for deploying to `Dokku <http://dokku.viewdocs.io/dokku/>`_.

This lists the things to add or change to easily deploy a Django application
to Dokku.  It doesn't try to cover all of setting up a site on Dokku, only
the parts relevant to a Django project. You should read the Dokku getting
started docs, then use this as a cheatsheet to quickly enable existing
Django projects to deploy on Dokku.

We use `whitenoise <http://whitenoise.evans.io/en/stable/>`_
to serve static files from Django.
If the site gets incredible amounts of traffic, throw a CDN in front,
but honestly, very very few sites actually need that.
(If you have a philosophical objection to serving static files
from Django, you can customize the nginx config through Dokku
and probably manage to get nginx to do the static file serving,
but I haven't bothered figuring it out myself.)

.. toctree::

    dokku_files
    dokku_postgres
    dokku_ssl

Additional info (move to their own files as they're ready)...

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

