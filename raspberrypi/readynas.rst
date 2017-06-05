Backing up to ReadyNAS using Crashplan on RaspberryPI
=====================================================

This assumes the setup from "USB drive with RaspberryPI" and "Crashplan on Raspberry PI" have already been done.

We have Crashplan running on our Raspberry Pi.  We want it to just backup to a share on our ReadyNAS with no complicated configuration within Crashplan. It looks like a good way to do that might be to just make /usr/local/var/crashplan be a mount from the NAS. Let's try that.

Get NFS client working on Raspberry Pi (https://help.ubuntu.com/community/SettingUpNFSHowTo#NFS_Client)

- `sudo apt-get install rpcbind nfs-common`
- `sudo update-rc.d rpcbind enable`
- `sudo update-rc.d nfs-common enable`
- `sudo reboot`  (to make sure it's all started)

Enable a share for this on the ReadyNAS:

- Login to ReadyNAS admin web
- Go to Services/Standard File Protocols
- Enable NFS and click Apply if it wasn't enabled already
- go to Shares/Add shares
- enter name=pibackup and a suitable description, turn off Public Access
- Click Apply
- Go to Shares/Share listing
- Next to pibackup, click the NFS icon
- Under Write-enabled hosts, add the Pi's IP address

Mount it on the Pi for testing:

- `sudo showmount -e 10.28.4.2`
- `sudo mkdir /mnt/pibackup`
- `sudo mount 10.28.4.2:/c/pibackup /mnt/pibackup`
- `sudo umount /mnt/pibackup`

Now arrange to mount it where crashplan is going to do backups:

- `sudo service crashplan stop`  (for safety)
- `sudo -e /etc/fstab`

        10.28.4.2:/c/pibackup /usr/local/var/crashplan	nfs	soft,intr,rsize=8192,wsize=8192

- `sudo service crashplan start`

Configure Crashplan and try it out. First, we'll do a small backup from here to Crashplan servers, just for sanity.

- Arrange to run the desktop client connected to the Raspberry Pi server (see Crashplan on Headless Boxes)

- Login with your Crashplan account if needed (first time).

- In Settings, give this computer a unique name (poirpi?)

- In Backup/files, select some small set of files to backup - maybe `/etc` (after showing hidden files)

- In Backup/Destinations, next to CrashPlan Central, click Start Backup.  (Enter Archive encryption key if prompted)

- Wait until the backup is complete

- Exit the desktop

Now, let's get another computer to backup to here (which is what we really want).

- Run CrashPlanDesktop locally on the source computer

- Go to Settings/Backup tab

- Find a small backup set and select it.

- under Destinations, click Change...

- Find the new Raspberry Pi and click its checkbox
- Click OK
- Click Save
- Go to Backup
- Check the status of the backup of that backup set on the new computer.

