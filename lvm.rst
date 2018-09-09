LVM
===

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

* List physical volumes : ``pvdisplay``
* Info about one PV : ``pvdisplay <PV name>``
* Partition type for LVM: ``8e``
* Make a PV from a partition : ``pvcreate <partition>``

Volume groups
-------------

* Create a volume group : ``vgcreate <NewVGName> <PVname> [<PVname>...]``
* Add PV to VG : ``vgextend <VGname> <PVname>``
* Remove PV from VG : ``vgreduce <VG name> <PV name>``
* List volume groups : ``vgdisplay``

Logical volumes
---------------

* List logical volumes : ``lvdisplay``
* Create LV : ``lvcreate -L<SIZE> -n<NewLVName> <VGname>``   (SIZE=<num><units>, e.g. 1.47TiB)  or -l<EXTENTS>
* Device name of the logical volume = ``/dev/<VGname>/<LVname>``
* Enlarge LV : ``lvextend -l+<extents> /dev/<VGname>/<LVname>``

Resize file system after enlarging LV
-------------------------------------

``sudo ext2fs -f /dev/<VGname>/<LVname>``
``sudo resize2fs /dev/<VGname>/<LVname>``
