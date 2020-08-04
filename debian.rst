Debian
======

.. index:: ! debian

Timezone
--------

.. index:: debian; timezone
.. index:: debian; dpkg-reconfigure

Set system timezone::

    sudo dpkg-reconfigure tzdata

Services
--------

.. index:: debian; update-rc.d

``update-rc.d``:

* Make a service run in its default runlevels::

    update-rc.d <service> defaults

 or::

    update-rc.d <service> enable

* Make a service not run in any runlevel::

    update-rc.d <service> disable

Making a new init script:

* Read ``/etc/init.d/README``, which will point to other docs
* Copy ``/etc/init.d/skeleton`` and edit it.


Packages
--------

.. index:: debian; dpkg

* List packages that match a pattern:  ``dpkg -l <pattern>``
* List contents of a package: ``dpkg -L packagename``
* Show packages that installed files matching pattern: ``dpkg -S pattern``
* Show info about an installed package: ``dpkg-query -s packagename``
* show info about a package that is known: ``apt-cache showpkg packagename``
* Reconfigure a package: ``dpkg-reconfigure packagename``
* Change alternatives: ``update-alternatives ...``

Alternatives
------------

.. index:: debian; alternatives
.. index:: debian; update-alternatives

Change 'alternatives' default browser or editor::

    sudo update-alternatives --set x-www-browser /usr/bin/chromium-browser
    sudo update-alternatives --set editor /usr/bin/emacs24

If you get an error like::

    update-alternatives: error: alternative /snap/bin/firefox for x-www-browser not registered; not setting

then you can add the new alternative with::

    sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /snap/bin/firefox 50

and then try again.

Be prompted for which alternative you prefer for a link group::

    sudo update-alternatives --config x-www-browser

Find out what the top-level link groups are::

    sudo update-alternatives --get-selections

Set xdg program to open/browse a directory (DOES NOT WORK) (do NOT use sudo)::

    xdg-mime default /usr/share/applications/Thunar.desktop x-directory/normal

.. index::
    triple: xdg; xdg-settings; debian

Change 'xdg' default browser (for user)::

    xdg-settings get default-web-browser
    xdg-settings set default-web-browser google-chrome.desktop
    xdg-settings set default-web-browser firefox.desktop

Install without any prompts (http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt)::

    sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    <COMMAND>

Desktop applications
--------------------

Put your own .desktop files in ~/.local/share/applications.

`Archlinux on desktop entries <https://wiki.archlinux.org/index.php/desktop_entries>`_

`Desktop file spec <https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html>`_

To let the system know about new or changed desktop files::

    update-desktop-database [directory]

Launch the application from command line that has a <name>.desktop file somewhere::

    gtk-launch <name>
