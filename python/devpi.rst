Devpi
=====

`Devpi <http://doc.devpi.net/>`_
is a Python PyPi staging server and packaging, testing, release tool.

.. warning:: By default exposing devpi-server to the internet is not safe!

Security/authentication/authorization is the most
confusing part of deploying devpi. Do *NOT* expose
it to the internet until you're sure you completely
understand this.

The docs do not help much. The necessary information is scattered
in tidbits all over.

My solution for now is to just **not** expose my devpi
to the internet, but to have it only listen on my
VPN interface.

Having decided that, I just make the whole thing wide
open so I don't have to mess with authentication all
the time.

To allow anyone, without authentication, to upload
packages to an index, use a command like::

    devpi index /emilie/dev acl_upload=:ANONYMOUS:

(You have to be logged in as root or emilie, most likely,
in order to do this command.)

BUT THAT DOES NOT APPEAR TO WORK. Apparently I still need
to be logged into devpi to use ``devpi upload``.  Maybe I can
use "setup.py" commands? ...

`Server command reference <https://devpi.net/docs/devpi/devpi/stable/+d/userman/devpi_commands.html#devpi-command-reference-server>`_

Uploading packages
-------------------
https://devpi.net/docs/devpi/devpi/stable/+d/quickstart-releaseprocess.html#devpi-upload-uploading-one-or-more-packages
https://devpi.net/docs/devpi/devpi/stable/+d/userman/devpi_misc.html#uploading-different-release-file-formats
https://devpi.net/docs/devpi/devpi/stable/+d/userman/devpi_misc.html#uploading-sphinx-docs
https://devpi.net/docs/devpi/devpi/stable/+d/userman/devpi_misc.html#bulk-uploading-release-files
https://devpi.net/docs/devpi/devpi/stable/+d/userman/devpi_misc.html#using-plain-setup-py-for-uploading
