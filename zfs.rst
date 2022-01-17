ZFS
===

I learned most of this from Michael W. Lucas's book
`FreeBSD Mastery: ZFS <https://www.tiltedwindmillpress.com/product/fmzfs/>`_.
Don't let the title fool you. 99% of it is relevant
to ZFS on Linux too.

Highly recommended.

.. contents::

The parts
---------

Virtual device
..............

A virtual device, or VDEV, is a named collection of one or more
chunks of storage (usually disk partitions).

A VDEV with one device is called a *stripe*. It has no redundancy,
so if the underlying device fails, the data is gone.

(More generally, a *stripe* is a chunk of data written to
a single device.)

A VDEV with multiple disks/devices can store a copy of its
complete data on each disk/device. This is called a *mirrored*
VDEV. All but one device can fail without losing any data.

Otherwise a VDEV is *RAID* and depending on the configuration,
can lose one or more devices without losing data.

.. note:: In most cases, you can create the zdevs as part of pool creation and do not need to create them first.

Pool
....

A pool has a name and one or more VDEVs in it. You can add more
VDEVs to a pool, but can never remove a VDEV from a pool.

Best practice is to use the same kind of VDEV in a pool. E.g. don't
mix mirrored with RAID-1, or RAID-1 with RAID-Z3.

Always set the "ashift" to 12 when creating new pools.

Dataset
.......

A dataset is the thing that you mount into a system's file tree
as a directory. It's part of a pool. Datasets form a hierarchy,
with the pool forming a kind of default root dataset for the pool.


Practical commands
------------------

You have a new disk at ``/dev/sdc`` and you want to make it its own ZFS file system.

First, make it a pool.

.. code-block:: bash

    # zpool create -o ashift=12 poolname /dev/sdc
    # zpool list
    NAME      SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    poolname 3.62T   480K  3.62T        -         -     0%     0%  1.00x    ONLINE  -
    # zfs list
    NAME               USED  AVAIL     REFER  MOUNTPOINT
    poolname           516K  3.51T       96K  /poolname

    # zpool status -LP rpool
      pool: rpool
     state: ONLINE
      scan: none requested
    config:
            NAME         STATE      READ WRITE CKSUM
            rpool        ONLINE        0     0     0
              /dev/sda7  ONLINE        0     0     0

Notice that the pool is kind of a dataset of its own, and even gets
mounted by default, but you usually
want to create child datasets to actually store stuff in.

.. code-block:: bash

    # zfs create -p poolname/dataset1
    # zfs list
    NAME               USED  AVAIL     REFER  MOUNTPOINT
    poolname           516K  3.51T       96K  /poolname
    poolname/dataset1   96K  3.51T       96K  /poolname/dataset1

(``-p`` creates all non-existing parent datasets, inheriting mountpoints
from their parents. Any ``-o`` options on this command are not applied
to parent datasets created due to ``-p``.)

Suppose you decide you don't want that dataset anymore.

.. code-block:: bash

    # zfs destroy poolname/dataset1
    #

Compression
-----------

Enable compression with compression=on. Specifying on instead of lz4 or another specific algorithm will always pick the best available compression algorithm.

.. code-block:: bash

    # zfs set compress=on dataset
    # zfs get compress rpool
    NAME   PROPERTY     VALUE     SOURCE
    rpool  compression  on        local


Mounting ZFS datasets
---------------------

By default, ZFS datasets do not show up in ``/etc/fstab``, the traditional
file where we configure mounted filesystems in Unix. ZFS mounts them itself
based on the mount data configured directly on the datasets as properties.
See below how to use ``/etc/fstab`` if you really want to.

Pools normally have mountpoints named after the pool, e.g. pool ``poolname``
would be mounted at ``/poolname``. Children inherit that.

To control where a dataset is mounted, set the ``mountpoint`` property:

.. code-block:: bash

    # zfs set mountpoint=/opt poolname/dataset1

If you don't want a dataset mounted, you can set the property ``canmount=off``:

.. code-block:: bash

    # zfs set canmount=off poolname/dataset1

.. note:: Ordinarily properties not explicitly set on a dataset are inherited from their parent. But that does not apply to ``canmount`` for some reason. Child datasets will still be mounted after setting ``canmount=off`` on their parent.

Why would you have a dataset you didn't want to mount? Maybe to set properties
on it that its children can inherit.

To see the properties interesting for mounting:

.. code-block:: bash

    # zfs list -o name,canmount,mountpoint
    NAME              CANMOUNT  MOUNTPOINT
    sipower                off  /sipower
    sipower/Art             on  /opt/art
    sipower/books           on  /usr/local/books
    sipower/photo           on  /sipower/photo
    sipower/software        on  /sipower/software
    wdnas4                  on  /wdnas4

If you want or need to control mounting of a ZFS dataset using ``/etc/fstab``
or manual ``mount`` commands, set its ``mountpoint`` property to ``legacy``:

.. code-block:: bash

    # zfs set mountpoint=legacy poolname/dataset1

Then you can mount using filesystem type ``zfs`` either in ``/etc/fstab``
or using the ``mount`` command.

Removable media
---------------

By "removable media" here I mean any storage device you can disconnect
in any way, even if you first have to power down the system, like hard drives
and SSDs, not just USB thumb drives etc.

You can start using ZFS on removable media by just attaching it, finding
the device where it's showing up (maybe by using ``lsblk`` on Linux),
and creating pools and datasets as above.

*BEFORE REMOVING THE MEDIA*, use the ``zpool export`` command. This will unmount
things and tell ZFS not to consider this device part of the system anymore.

.. code-block:: bash

    # zpool list
    NAME      SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    sipower   928G   122G   806G        -         -     0%    13%  1.00x    ONLINE  -
    wdnas4   3.62T   564K  3.62T        -         -     0%     0%  1.00x    ONLINE  -
    # zpool export wdnas4
    # zpool list
    NAME      SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    sipower   928G   122G   806G        -         -     0%    13%  1.00x    ONLINE  -

Now you can disconnect the device, maybe take it to another system entirely or store
it for a while, and eventually connect it to some system that supports ZFS. To
make ZFS aware of it, use ``zpool import``.  Running it without arguments will list
the pools possible to import, then run it again to import a specific pool.

.. code-block:: bash

    # zpool import
       pool: wdnas4
         id: 4409664093715767562
      state: ONLINE
     action: The pool can be imported using its name or numeric identifier.
     config:

            wdnas4      ONLINE
              sdc       ONLINE
    # zpool import wdnas4
    # zpool list
    NAME      SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    sipower   928G   122G   806G        -         -     0%    13%  1.00x    ONLINE  -
    wdnas4   3.62T   732K  3.62T        -         -     0%     0%  1.00x    ONLINE  -
    #

As part of importing, the pool's datasets will be mounted according to their properties.

Space used
----------

This gets really complicated. See chapter 6 of
`FreeBSD Mastery: ZFS <https://www.tiltedwindmillpress.com/product/fmzfs/>`_ for all
the gory details.

Looking at pools

.. code-block:: bash

    # zpool get allocated,size,capacity
    NAME   PROPERTY   VALUE  SOURCE
    bpool  allocated  720M   -
    bpool  size       1.88G  -
    bpool  capacity   37%    -
    rpool  allocated  18.1G  -
    rpool  size       232G   -
    rpool  capacity   7%     -
    spool  allocated  1.68T  -
    spool  size       3.62T  -
    spool  capacity   46%    -

    # zpool get allocated,size,capacity,free spool
    NAME   PROPERTY   VALUE  SOURCE
    spool  allocated  1.68T  -
    spool  size       3.62T  -
    spool  capacity   46%    -
    spool  free       1.95T  -

But what's using up all the space in our pools? That's harder.

You can get a start with ``zfs list``.

.. code-block:: bash

    # zfs list
    NAME                                               USED  AVAIL     REFER  MOUNTPOINT
    rpool                                             18.1G   207G       96K  /
    rpool/ROOT                                        15.0G   207G       96K  none
    rpool/ROOT/ubuntu_u9xzty                          15.0G   207G     3.58G  /
    rpool/ROOT/ubuntu_u9xzty/srv                        96K   207G       96K  /srv
    rpool/ROOT/ubuntu_u9xzty/usr                      3.23M   207G       96K  /usr
    rpool/ROOT/ubuntu_u9xzty/usr/local                3.13M   207G     2.16M  /usr/local
    rpool/ROOT/ubuntu_u9xzty/var                      7.27G   207G       96K  /var
    rpool/ROOT/ubuntu_u9xzty/var/games                  96K   207G       96K  /var/games
    rpool/ROOT/ubuntu_u9xzty/var/lib                  6.88G   207G     2.38G  /var/lib
    rpool/ROOT/ubuntu_u9xzty/var/lib/AccountsService   816K   207G      104K  /var/lib/AccountsService
    rpool/ROOT/ubuntu_u9xzty/var/lib/NetworkManager   1.68M   207G      172K  /var/lib/NetworkManager
    rpool/ROOT/ubuntu_u9xzty/var/lib/apt               303M   207G      104M  /var/lib/apt
    rpool/ROOT/ubuntu_u9xzty/var/lib/dpkg              126M   207G     39.2M  /var/lib/dpkg
    rpool/ROOT/ubuntu_u9xzty/var/log                   401M   207G      192M  /var/log
    rpool/ROOT/ubuntu_u9xzty/var/mail                   96K   207G       96K  /var/mail
    rpool/ROOT/ubuntu_u9xzty/var/snap                  760K   207G      592K  /var/snap
    rpool/ROOT/ubuntu_u9xzty/var/spool                1.45M   207G      144K  /var/spool
    rpool/ROOT/ubuntu_u9xzty/var/www                   108K   207G      108K  /var/www
    rpool/USERDATA                                    3.03G   207G       96K  /
    rpool/USERDATA/devpi_ps1uzq                        394M   207G      394M  /home/devpi
    rpool/USERDATA/homeassistant_79drum               1.15G   207G      513M  /home/homeassistant
    rpool/USERDATA/hometheater_s261g2                  125M   207G     93.0M  /home/hometheater
    rpool/USERDATA/root_ndpbl6                         793M   207G      791M  /root
    rpool/USERDATA/strange_dyi0il                      618M   207G      225M  /home/strange

This shows a bunch of nested datasets, and each dataset's USED space includes that of all the
nested datasets, so you can't just add them up as-is.

The AVAIL column is a bit more useful, but you have to remember that because snapshots and
clones use Copy-On-Write, the AVAIL space could seemingly contain many times that much data.

You might think from this example that REFER tells you the unique space used by each dataset
and you could just add that up, but again, no. Multiple datasets can REFER to the same
collection of data. (Again, snapshots and clones do this.)

Deleting stuff doesn't necessarily free space.

1. ZFS can take some time to asynchronously update snapshots and clones, so you might see
   the statistics continue to change for a while.
2. Stuff you delete might be referred to elsewhere, so until you find and remove all the
   references, that space will still be in use.

I'm not going into this any deeper here. Go read chapter 6 of the book.

NFS Export
----------

If you want, you can have ZFS handle NFS export of a dataset, rather than adding
it to ``/etc/exports``.
This `blog post <https://blog.programster.org/sharing-zfs-datasets-via-nfs>`_
has more details.
