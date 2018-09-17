Gradually fixing your Python code's style
=========================================

Sometimes we inherit some code that doesn't follow the style guidelines
we prefer when we're writing new code. We could just run
`flake8 <http://flake8.pycqa.org/en/latest/>`_ on
the whole codebase and fix everything before we continue, but that's not
necessarily the best use of our time.

Another approach is to just update the styling of files when we need to make
other changes to them. To do that, it's helpful to be able to run a code style
checker on just the files we're changing.  I've written tools to do that for
various source control tools and languages over the years. Here's the one I'm
currently using for Python and flake8.

I call this script `flake`.  I have a key in my IDE bound to run it and show
the output so I can click on each line to go to the code that
has the problem, which makes it pretty easy to fix things.

It can run in two modes. By default, it checks any files that have uncommitted
changes.  Or I can pass it the name of a git branch, and it checks all files
that have changes compared to that branch.  That works well when I'm working
on a feature branch that is several commits downstream from `develop` and I
want to be sure all the files I've changed while working on the feature are
now styled properly.

The script is in Python, of course.

Work from the repository root
-----------------------------

Since we're going to be working with file paths output from git commands, it's
simplest if we first make sure we're in the root directory of the repository.

.. code-block:: python

    #!/usr/bin/env python3

    if not os.path.isdir('.git'):
        print("Working dir: %s" % os.getcwd())
        result = subprocess.run(['git', 'rev-parse', '--show-toplevel'], stdout=subprocess.PIPE)
        dir = result.stdout.rstrip(b'\n')
        os.chdir(dir)
        print("Changed to %s" % dir)

We use `git rev-parse --show-toplevel` to find out what the top directory in
the repository working tree is, then change to it.  But first we check for
a `.git` directory, which tells us we don't need to change directories.

Find files changed from a branch
--------------------------------

If a branch name is passed on the command line, we want to identify the Python
files that have changed compared to that branch.

.. code-block:: python

    if len(sys.argv) > 1:
        # Run against files that are different from *branch_name*
        branch_name = sys.argv[1]
        cmd = ["git", "diff", "--name-status", branch_name, "--"]
        out = subprocess.check_output(cmd).decode('utf-8')
        changed = [
            # "M\tfilename"
            line[2:]
            for line in out.splitlines()
            if line.endswith(".py") and "migrations" not in line and line[0] != 'D'
        ]

We use `git diff --name-status <branch-name> --` to list the changes compared
to the branch. We skip file deletions - that means we no longer have a file to
check - and migrations, which never seem to quite be PEP-8 compliant and which
I've decided aren't worth trying to fix.  (You may decide differently, of
course.)

Find files with uncommited changes
----------------------------------

Alternatively, we just look at the files that have uncommitted changes.

.. code-block:: python

    else:
        # See what files have uncommited changes
        cmd = ["git", "status", "--porcelain", "--untracked=no"]
        out = subprocess.check_output(cmd).decode('utf-8')
        changed = []
        for line in out.splitlines():
            if "migrations" in line:
                # Auto-generated migrations are rarely PEP-8 compliant. It's a losing
                # battle to always fix them.
                continue
            if line.endswith('.py'):
                if '->' in line:
                    # A file was renamed. Consider the new name changed.
                    parts = line.split(' -> ')
                    changed.append(parts[1])
                elif line[0] == 'M' or line[1] != ' ':
                    changed.append(line[3:])

Here we take advantage of `git --porcelain` to ensure the output won't
change from one git version to the next, and it's fairly easy to parse in
a script. (Maybe I should investigate using `--porcelain` with the other
git commands in the script, but what I have now works well enough.)

Run flake8 on the changed files
-------------------------------

Either way, `changed` now has a list of the files we want to run flake8 on.

.. code-block:: python

    cmd = ['flake8'] + changed
    rc = subprocess.call(cmd)
    if rc:
        print("Flake8 checking failed")
        sys.exit(rc)

Running `flake8` with `subprocess.call` this way sends the output to stdout
so we can see it.  `flake8` will exit with a non-zero status if there are problems;
we print a message and also exit with a non-zero status.

Wrapping up
-----------

I might once have written a script like this in Shell or Perl, but
Python turns out to work quite well once you get a handle on the
`subprocess <https://docs.python.org/3/library/subprocess.html>`_ module.

The resulting script is useful for me.  I hope you'll find parts of it
useful too, or at least see something you can steal for your own scripts.


