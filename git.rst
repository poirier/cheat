Git
===

Fetching
--------

Update all local remote tracking branches from all remotes::

    git fetch --all

Update all local remote tracking branches from origin::

    git fetch origin

Update/create local branch origin/master from remote origin's branch master with default configuration::

    git fetch origin master

Update/create local branch 'tmp' from remote origin's branch master (but only updates
if fast-forward is possible)::

    get fetch origin master:tmp

Peek at an artitrary remote's branch by pulling it into a (temporary) local branch, then
check its log. The temporary local branch will eventually be garbage collected::

    git fetch git://git.kernel.org/pub/scm/git/git.git maint
    git log FETCH_HEAD


Branches and checkouts
----------------------

Check out an existing branch::

    git checkout <branch>

Create new branch::

    git branch <branchname> [<start point>]

Create new branch and check it out in one command::

    git checkout -b <newbranch> [<start point>]


Import one repo into another with history
-----------------------------------------

http://stackoverflow.com/questions/1683531/how-to-import-existing-git-repository-into-another

Cleaning
--------

Delete untracked files (be careful!)::

    git clean -fdx

Prune branches that have been merged and are no longer upstream::

    http://devblog.springest.com/a-script-to-remove-old-git-branches

Prune branches that track remote branches that no longer exist
(http://kparal.wordpress.com/2011/04/15/git-tip-of-the-day-pruning-stale-remote-tracking-branches/)::

    $ git remote prune origin --dry-run
    $ git remote prune origin

Pulls
-----

Easier access to pull requests on Github.  Add to config::

    # This will make pull requests visible in your local repo
    # with branch names like 'origin/pr/NNN'
    # WARNING: This also breaks adding a new remote called "origin" manually
    # because git thinks there already is one.  Comment this out temporarily
    # in that case, unless you can think of a better solution.
    [remote "pulls"]
        fetch = +refs/pull/*/head:refs/remotes/origin/pr/*

Aliases
-------

Handy aliases for config::

    [alias]
    lg = log --oneline --graph --date-order
    lgd = log --oneline --graph --date-order --format=format:\"%ai %d %s\"

    cb = checkout -b
    cd = checkout develop
    co = checkout

    gd = !git fetch origin && git checkout develop && git pull origin develop
    gm = !git fetch origin && git checkout master && git pull origin master

    # push -u the current branch
    pu = "!CURRENT=$(git symbolic-ref --short HEAD) && git push -u origin $CURRENT"

    # push -f
    pf = push -f

    # Find the common ancestor of HEAD and develop and show a diff
    # from that to HEAD
    dd = "!git diff $(git merge-base develop HEAD)"
    # Find the common ancestor of HEAD and master and show a diff
    # from that to HEAD
    dm = "!git diff $(git merge-base master HEAD)"

    # These need 'hub' installed.
    # Create pull request against develop.  Must pass issue number.
    #pr = pull-request -b develop -i
    # Create pull request against develop, not passing issue number:
    pr = pull-request -b develop

    # Checkout pull request
    # Assume origin/pr/NN is pull request NN
    # Need a bash function because we need to concatenate something to $1
    #cpr = "!f() {set -x;git checkout origin/pr/$1; };f"
    cpr = "!gitcpr"

    # Undo any uncommited changes
    abort = checkout -- .

Submodules
----------

This will typically fix things::

    git submodule update --init --recursive

(and yes, you need --init every time)

Add a new submodule [http://git-scm.com/book/en/Git-Tools-Submodules]
::

    $ git submodule add git@github.com:mozilla/basket-client basket-client

Combining feature branches
--------------------------

Suppose you have branch A and branch B, which branched off of master
at various times, and you want to create a branch C that contains
the changes from both A & B.

According to Calvin: checkout the first branch, then git checkout -b BRANDNEWBRANCH. then rebase it on the second.

(SEE DIAGRAMS BELOW)

Example::

    # Start from master
    git checkout master
    git pull [--rebase]

    # Create the new branch from tip
    git checkout -b C

    # rebase A on master
    git checkout A
    git rebase -i master
    # merge A into C
    git checkout C
    git merge A

    # rebase B
    git checkout B
    git rebase -i master
    # merge B into C
    git checkout C
    git merge B

    # I think???
    # Review before using, and verify the result

Combining git branches diagrams

Start::

    o - o - o - o <--- master
     \   \
      \   o - o - o  <--- A
       o - o - o <--- B

Rebase A on master::

                     master
                     /
    o - o - o - o - o - o - o <--- A
     \
      o - o - o <--- B

Create new branch N from master::

                    master
                     /
    o - o - o - o - o - o - o <--- A
     \               \
      \               N
       \
        o - o - o <--- B

Switch to N and merge A::

                    master
                     /
    o - o - o - o - o - o - o <--- A
     \               \
      \               o - o - o  <--- N  (includes A)
       \
        o - o - o <--- B

Rebase B on master::

                    master
                     /
    o - o - o - o - o - o - o - o <--- A
                    |\
                    |  o - o - o <--- N (includes A)
                    \
                      o - o - o  <--- B

On N, merge B::

                    master
                    /
    o - o - o - o - o - o - o - o <--- A
                    |\
                    | o - o - o -  o - o - o <--- N (includes A and B)
                    \
                     o - o - o  <--- B

Delete A and B if desired.

Undoing things
--------------

If you've committed some changes, then for some reason decide you didn't
want to commit them yet - but still want the changes present in your local
working directory - there are several options.

To get rid of the actual ``commit`` but keep all those changes staged::

    $ git reset --soft HEAD~

To get rid of the actual commit and keep the changes, but not staged::

    $ git reset HEAD~

And if you didn't want those changes at all - *WARNING* this will lose
changes - gone::

    $ git reset --hard HEAD~
