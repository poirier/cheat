LXDE
====

Using LXDE desktop with i3 window manager.

There's a brief note `here <https://wiki.lxde.org/en/LXDE:Questions#How_can_I_use_a_window_manager_other_than_Openbox_with_LXDE.3F>`_ but this gives a little more depth.

* Install lxde::

    sudo apt install lxde lxsession-logout

* Logout of the desktop

* Login again, this time choosing the LXDE desktop

* Create an executable shell script somewhere on your path, naming it "i3wm".
  It should run "i3".  (I don't know why it doesn't work to just set the window manager to i3, but it doesn't. Maybe someday I'll take the time to debug that.)

* Edit ~/.config/lxsession/LXDE/desktop.conf.  In the ``[Session]`` section, change windows_manager/command: ``windows_manager/command=i3wm``

* In ~/.config/lxsession/LXDE/autostart, remove "@pcmanfm --desktop --profile LXDE", it interferers with i3.

* Logout and login again.

* If you like, bind a key in i3 to "lxsession-logout" and use that to logout. Exiting i3 will *not* log you out with this configuration.
  Or just use the menus in lxpanel to log out.
