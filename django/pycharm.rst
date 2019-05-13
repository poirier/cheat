Developing Django apps in PyCharm
=================================

Existing app
------------

These steps assume an existing app that works from the command line.

1) Get the Django app running from the command line.

2) Start pycharm.

3) Add and enable the following plugins, any others that look useful, and their
   dependencies:

   * Vue.js
   * Javascript support

4) Restart PyCharm

5) Open the base directory of the project (File -> Open -> nav to the top directory
   of the project).

6) Set up the Python virtualenv requirements file path

   * Open Settings (Control-Alt-S)
   * Go to Tools -> Python Integrated Tools
   * Set "Package requirements file" to the path to the requirements file
   * Click "OK"

7) Ignored paths

   * Open the "Project" sidebar on the left (that shows all the project
     dirs, files, etc
   * If you have a "node_modules" directory, right-click on it and from
     that menu, choose "Mark Directory As" -> "Excluded".
   * Do the same if you have other directories you want PyCharm to ignore.
     I'll typically do that with anything we're not tracking in Git, since
     it's not really part of the project source code.

8) Set the virtualenv of the PyCharm project to be the virtualenv that your
   working Django app is using.

   * open Settings (Control-Alt-S)
   * go to Project: (name) -> Project Interpreter
   * Click the gear icon on the right side next to the field for the virtualenv path
   * Select "Add" from the menu
   * Choose "Existing environment"
   * Set the Interpreter field to the complete path to the *python executable file*
     in the virtualenv you want to use. You cannot edit the field directly - you have to use the
     button with 3 dots on its right end to pop up a file selection dialog.
   * Click "OK", "OK".
   * Wait for PyCharm to inspect the new virtualenv and update its indices.

Those are the important things to be able to nicely edit the project in PyCharm.
It doesn't cover other tasks like running, debugging, deploying, testing, etc.,
nor the myriad of options that are more personal preferences.
