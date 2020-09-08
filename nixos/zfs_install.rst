NixOS install with ZFS
======================

Notes on how I installed NixOS using ZFS filesystems on a laptop

Based a lot on

* `https://nixos.wiki/wiki/NixOS_on_ZFS <https://nixos.wiki/wiki/NixOS_on_ZFS>`_
* `https://florianfranke.dev/posts/2020/03/installing-nixos-with-encrypted-zfs-on-a-netcup.de-root-server/ <https://florianfranke.dev/posts/2020/03/installing-nixos-with-encrypted-zfs-on-a-netcup.de-root-server/>`_
  (not responding as I write this, I'm looking at my cached copy on Pinboard... hopefully it'll come back)

Target system
-------------

My target system, which I call "moth", is a Lenovo X1 Carbon Thinkpad Generation 1,
with UEFI BIOS, Core i7-3667U 2.0 GHz, 8 GB memory.

The BIOS is configured to boot first off a USB drive if found, and to boot
only UEFI.

Install media
-------------

On Aug 27, 2020, I went to `the NixOS download page <https://nixos.org/download.html>`_
and downloaded the "Graphical live CD, 64-bit Intel/AMD" image as
``nixos-plasma5-20.03.2849.feff2fa6659-x86_64-linux.iso``.

I plugged in a USB3 thumb drive (SanDisk 64GB drive, way overkill but it was handy),
used ``lsblk`` to verify that it was ``/dev/sda``, and copied the install image to
it::

    sudo if=nixos-plasma5-20.03.2849.feff2fa6659-x86_64-linux.iso of=/dev/sda bs=1M

Boot the installer
------------------

When that finished successfully, I plugged the USB thumb drive into my target laptop
and powered it up. Since it's configured to boot first off a USB drive, I didn't need
to do anything special for it to boot into the NixOS graphical installer.

Networking
----------

I used the networking widget in the lower right status bar to get the laptop onto
my local network with access to the Internet.

Set up filesystems
------------------

I opened a Konsole window and used that for most of the rest of this.  I worked out the following
commands by repeatedly editing and trying a script, which is why there are commands at the top to
clean up things possibly left over from previous runs.

I set DISK to the "by-id" name of my hard drive::

    DISK=/dev/disk/by-id/ata-Samsung_SSD_860_EVO_mSATA_500GB_S41NNB0KC04340K

I started by wiping the partitions using an instruction from
`https://florianfranke.dev/posts/2020/03/installing-nixos-with-encrypted-zfs-on-a-netcup.de-root-server/
<https://florianfranke.dev/posts/2020/03/installing-nixos-with-encrypted-zfs-on-a-netcup.de-root-server/>`_::

    sgdisk --zap-all $DISK

I followed `these instructions <https://nixos.wiki/wiki/NixOS_on_ZFS#Single-disk>`_
on how to partition and set up::

    # I DID NOT create partition 2 since I don't need legacy (BIOS) boot
    # Partition 2 will be the boot partition, needed for legacy (BIOS) boot
    # sgdisk -a1 -n2:34:2047 -t2:EF02 $DISK

    # If you need EFI support, make an EFI partition:
    sgdisk -n3:1M:+512M -t3:EF00 $DISK

    # Partition 1 will be the main ZFS partition, using up the remaining space on the drive.
    sgdisk -n1:0:0 -t1:BF01 $DISK

    # Create the pool. If you want to tweak this a bit and you're feeling adventurous, you
    # might try adding one or more of the following additional options:
    # To disable writing access times:
    #   -O atime=off
    # To enable filesystem compression:
    #   -O compression=lz4
    # To improve performance of certain extended attributes:
    #   -O xattr=sa
    # For systemd-journald posixacls are required
    #   -O  acltype=posixacl
    # To specify that your drive uses 4K sectors instead of relying on the size reported
    # by the hardware (note small 'o'):
    #   -o ashift=12
    #
    # The 'mountpoint=none' option disables ZFS's automount machinery; we'll use the
    # normal fstab-based mounting machinery in Linux.
    # '-R /mnt' is not a persistent property of the FS, it'll just be used while we're installing.
    zpool create -O mountpoint=none -O atime=off -O compression=lz4 -O xattr=sa -O acltype=posixacl -o ashift=12 -R /mnt rpool $DISK-part1

    # Create the filesystems. This layout is designed so that /home is separate from the root
    # filesystem, as you'll likely want to snapshot it differently for backup purposes. It also
    # makes a "nixos" filesystem underneath the root, to support installing multiple OSes if
    # that's something you choose to do in future.
    zfs create -o mountpoint=none rpool/root
    zfs create -o mountpoint=legacy rpool/root/nixos
    zfs create -o mountpoint=legacy rpool/home

    # Mount the filesystems manually. The nixos installer will detect these mountpoints
    # and save them to /mnt/nixos/hardware-configuration.nix during the install process.
    mount -t zfs rpool/root/nixos /mnt
    mkdir /mnt/home
    mount -t zfs rpool/home /mnt/home

    # If you need to boot EFI, you'll need to set up /boot as a non-ZFS partition.
    mkfs.vfat $DISK-part3
    mkdir /mnt/boot
    mount $DISK-part3 /mnt/boot
