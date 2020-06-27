.. index:: ! releasing

Release - how to
================

How to release

.. index:: git; git flow

This is a checklist for releasing a new version of *something*
if we're using the
Git Flow <http://nvie.com/posts/a-successful-git-branching-model/>
process for development.

Git branches
------------

Since we use Git Flow, the two branches of concern at release time are:

* **master** - always has the most recently released code. Each release is
  tagged `X.X.X`.
* **develop** - contains the code under development for the next release

So technically, what makes a new release is merging `develop` to `master`
and tagging it.  Of course, we don't want to do that until we're ready.

We also use the git flow <https://github.com/nvie/gitflow> tool to help
with the Git Flow branching model, especially for releases.

Release steps
-------------

Take these steps to release the new version:

* Make a fresh clone of the repo (to make sure we're working off the same
  code that's on github):

    git clone git@github.com:org/project.git
    cd project

* Set up git flow in this new repo::

    git checkout master
    git flow init -d

* Start release branch using git flow:

    git flow release start <VERSION>

e.g.

    git flow release start '0.0.5'

Do **not** include ``v`` on the front of the version number - there's nothing
wrong with it, we're just not using it for our version numbers here and want
to be consistent.

* Run the tests locally. The tests must pass before
  proceeding.  Fix any problems and commit the changes.

* Set `VERSION` in `project/__init__.py` to the same version,
  e.g. `VERSION = '0.0.5'`.

* Start a new section in `RELEASE_NOTES.rst` for the new release. Always put
  the new release section above the previous ones.

* Review `git log` and add major new features and incompatibilities to
  the release notes.

* Commit changes.  Be sure to include the new version number in the commit
  message first line, e.g. "Bump version for 0.0.5".

* Push the release branch.

* Open a pull request from the release branch to the master branch.

* When pull request has been reviewed, use **git flow commands** to make the
  release:

    git flow release finish '0.0.5'

You'll be prompted for a commit message for the merge to master. The default
is fine (`Merge branch 'release/0.0.5'`).

You'll be prompted for a tag message.  Make it "Tag for v0.0.5" or whatever
the version is.

You'll be prompted for a commit message for the merge back to develop. The
default is fine.

* Push the merged master and develop branch and tag to github:

    git push origin master --tags
    git push origin develop --tags

* Verify that CI tests have passed for the pushed master

* Email the release announcement
