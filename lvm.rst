.. index:: ! lvm

LVM
===
.. contents::

LVM on Linux

Reference
http://tldp.org/HOWTO/LVM-HOWTO/index.html

Terminology
-----------

PV
    Physical volume (e.g. a partition, RAID array, etc)
VG
    Volume Group - a collection of PV's that we can use the space from
LV
    Logical volume - a partition created from space in a VG

Physical volumes
----------------

.. index:: pvdisplay, pvcreate, pvs

* List physical volumes : ``pvdisplay`` , or ``pvs`` for briefer output
* Info about one PV : ``pvdisplay <PV name>``
* Partition type for LVM: ``8e``
* Make a PV from a partition : ``pvcreate <partition>``

Volume groups
-------------

.. index:: vgcreate, vgextend, vgreduce, vgdisplay, vgs

* Create a volume group : ``vgcreate <NewVGName> <PVname> [<PVname>...]``
* Add PV to VG : ``vgextend <VGname> <PVname>``
* Remove PV from VG : ``vgreduce <VG name> <PV name>``
* List volume groups : ``vgdisplay``, or ``vgs`` for briefer output
* Removing a VG::

    Make sure that no logical volumes are present in the volume group,
    see later section for how to do this.

    Deactivate the volume group:

    # vgchange -a n my_volume_group

    Now you actually remove the volume group:

    # vgremove my_volume_group

Logical volumes
---------------

.. index:: lvdisplay, lvs, lvcreate, lvextend, lvreduce

* List logical volumes : ``lvdisplay``, or ``lvs`` for briefer output
* Create LV : ``lvcreate -L<SIZE> -n<NewLVName> <VGname>``   (SIZE=<num><units>, e.g. 1.47TiB)  or -l<EXTENTS>
* Device name of the logical volume = ``/dev/<VGname>/<LVname>``
* Enlarge LV : ``lvextend -l+<extents> /dev/<VGname>/<LVname>``
* Reduce LV: ``lvreduce -L<newSIZE> /dev/<VGNAME>/<LVname>``
    Add ``-r`` to resize the filesystem at the same time. Otherwise, be *sure* to shrink the filesystem first.

* Remove LV:

.. index:: umount, lvemove

A logical volume must be closed before it can be removed::

    # umount /dev/myvg/homevol
    # lvremove /dev/myvg/homevol
    lvremove -- do you really want to remove "/dev/myvg/homevol"? [y/n]: y
    lvremove -- doing automatic backup of volume group "myvg"
    lvremove -- logical volume "/dev/myvg/homevol" successfully removed

Resize file system after enlarging LV
-------------------------------------

.. index:: ext2fs, resize2fs

Either of these will use all the available space.

``sudo ext2fs -f /dev/<VGname>/<LVname>``
``sudo resize2fs /dev/<VGname>/<LVname>``
