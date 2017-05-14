USB drive with Raspberry PI
===========================

Here are detailed steps to get a Raspberry PI running entirely off a USB drive (after booting from its SD card).

Some sources:

* Move root to USB drive:
    http://magnatecha.com/using-a-usb-drive-as-os-root-on-a-raspberry-pi/
    http://elinux.org/Transfer_system_disk_from_SD_card_to_hard_disk

* UUIDs:
    http://liquidat.wordpress.com/2013/03/13/uuids-and-linux-everything-you-ever-need-to-know/

Detailed log:

* Start with 4 GB SD card
* Copy 2013-07-26-wheezy-raspbian.img onto it:

        sudo dd if=path/2013-07-26-wheezy-raspbian.img of=/dev/mmcblk0 bs=1M

* Partition USB drive:

  * Partition 1: system root: 16 GB
  * Partition 2: Swap: 1 GB
  * Partition 3: /usr/local: rest of drive

* Format the partitions too (ext4)
    * sudo mkfs.ext3 -q -m 0 -L ROOT /dev/sdb1
    * sudo mkswap -q -L SWAP120 /dev/sdb2
    * sudo mkfs.ext3 -q -m 0 -L LOCAL /dev/sdb3
* Boot off 4 GB SD card
* ssh to its IP address (get from router or whatever)::

        ssh pi@[IP ADDRESS]
        password: raspberry

* Copy current root partition to USB drive (see blog post mentioned above to make sure you're using the right partitions)::

        sudo dd if=/dev/mmcblk0p2 of=/dev/sda1 bs=4M

* Resize::

        sudo e2fsck -f /dev/sda1
        sudo resize2fs /dev/sda1

* See what UUID it got::

        $ sudo blkid /dev/sda1
        /dev/sda1: UUID="9c7e2035-df9b-490b-977b-d60f2170889d" TYPE="ext4"

* Mount::

        sudo mount /dev/sda1 /mnt

* Edit config files and change current root partition to the new root UUID in fstab, and /dev/sda1 in cmdline.txt (cmdline.txt doesn't support UUID, darn)

   * `vi /mnt/etc/fstab`::

        UUID=9c7e2035-df9b-490b-977b-d60f2170889d    /   ext4    defaults,noatime,async  0       1

  * `vi /boot/cmdline.txt`  (http://elinux.org/RPi_cmdline.txt)

* Umount /mnt::

        sudo umount /mnt

* Reboot and check things out

Swap:

* Format swap partition::

        $ sudo mkswap -L swappart /dev/sda2
        Setting up swapspace version 1, size = 1048572 KiB
    LABEL=swappart, UUID=a471af01-938b-4ad0-8653-dafe211cdfba

* Make sure it'll work::

        sudo swapon -U a471af01-938b-4ad0-8653-dafe211cdfba
        free -h

* Edit /etc/fstab, add at end::

        UUID=a471af01-938b-4ad0-8653-dafe211cdfba swap swap defaults 0 0

* Remove the default 100M swap file::

        sudo apt-get purge dphys-swapfile

* reboot and check swap space again, should be 1 G (not 1.1 G)


Now move /usr/local to the USB drive:

* Format partition::

        sudo mkfs.ext4 -L usr.local /dev/sda3

* Find out its UUID::

        $ blkid /dev/sda3
        /dev/sda3: LABEL="usr.local" UUID="3c6e0024-d0e4-412e-a4ab-35d7c9027070" TYPE="ext4"

* Mount it temporarily on /mnt::

        sudo mount UUID="3c6e0024-d0e4-412e-a4ab-35d7c9027070" /mnt

* Copy the current /usr/local over there::

        (cd /usr/local;sudo tar cf - .) | ( cd /mnt;sudo tar xf -)

* Umount::

        sudo umount /mnt

* Remove files from /usr/local::

        sudo rm -rf /usr/local/*

* Edit /etc/fstab to mount /dev/sda3 on /usr/local at boot::

        UUID=3c6e0024-d0e4-412e-a4ab-35d7c9027070       /usr/local      ext4    defaults,noatime        0       1

* See if that works::

        sudo mount -a
        df -h

* reboot and make sure it works again
