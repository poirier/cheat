Sonos
=====

Music library on Linux
----------------------

To have Sonos play music files hosted on a Linux server, you have
to share them using Samba, and Sonos uses ancient Samba protocol
versions.

You need something like this subset of a smb.conf file::

    [global]
    ntlm auth = yes
    server min protocol = NT1

    [music]
     path = /home/poirier/Music
     writable = yes
     guest ok = yes
     guest only = no
     read only = no
     create mode = 0777
     directory mode = 0777
     browseable = yes
     public = yes

(Not all of that might be required, but ``server min protocol = NT1``
definitely seems to be.)

Sources:

* https://en.community.sonos.com/controllers-software-228995/samba-connectivity-terribly-disappointed-6782466
* https://en.community.sonos.com/controllers-software-228995/using-sonos-with-linux-6847519?postid=16469261#post16469261
