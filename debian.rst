Debian
======

Services
--------

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

* List packages that match a pattern:  ``dpkg -l <pattern>``
* List contents of a package: ``dpkg -L packagename``
* Show packages that installed files matching pattern: ``dpkg -S pattern``
* Show info about an installed package: ``dpkg -p packagename``
* show info about a package that is known: ``apt-cache showpkg packagename``
* Reconfigure a package: ``dpkg-reconfigure packagename``
* Change alternatives: ``update-alternatives ...``

Alternatives
------------

Change 'alternatives' default browser or editor::

    sudo update-alternatives --set x-www-browser /usr/bin/chromium-browser
    sudo update-alternatives --set editor /usr/bin/emacs24

Be prompted for which alternative you prefer for a link group::

    sudo update-alternatives --config www-browser

Find out what the top-level link groups are::

    sudo update-alternatives --get-selections

Set xdg program to open/browse a directory (DOES NOT WORK) (do NOT use sudo)::

    xdg-mime default /usr/share/applications/Thunar.desktop x-directory/normal

Change 'xdg' default browser (for user)::

    xdg-settings get default-web-browser
    xdg-settings set default-web-browser google-chrome.desktop
    xdg-settings set default-web-browser firefox.desktop

Install without any prompts (http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt)::

    sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    <COMMAND>
