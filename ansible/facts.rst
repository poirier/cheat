.. _facts_example:

Facts output
------------

Example output of 'ansible moth -m setup' (abridged)::

    moth | SUCCESS => {
        "ansible_facts": {
            "ansible_all_ipv4_addresses": [
                "172.26.163.45",
                "10.28.4.5"
            ],
            "ansible_all_ipv6_addresses": [
                "fcae:c8f4:7d93:35ee:162::1",
                "fe80::b0f5:3cff:fe75:cff0",
                "fe80::33e1:2:9db5:7dc0"
            ],
            "ansible_apparmor": {
                "status": "enabled"
            },
            "ansible_architecture": "x86_64",
            "ansible_bios_date": "05/17/2016",
            "ansible_bios_version": "G6ETB4WW (2.74 )",
            "ansible_cmdline": {
                "BOOT_IMAGE": "/boot/vmlinuz-4.15.0-38-generic",
                "ro": true,
                "root": "UUID=cd980b7e-8c51-4b68-9a36-25bacd7d5ebf"
            },
            "ansible_date_time": {
                "date": "2019-01-11",
                "day": "11",
                "epoch": "1547232398",
                "hour": "13",
                "iso8601": "2019-01-11T18:46:38Z",
                "iso8601_basic": "20190111T134638560137",
                "iso8601_basic_short": "20190111T134638",
                "iso8601_micro": "2019-01-11T18:46:38.560229Z",
                "minute": "46",
                "month": "01",
                "second": "38",
                "time": "13:46:38",
                "tz": "EST",
                "tz_offset": "-0500",
                "weekday": "Friday",
                "weekday_number": "5",
                "weeknumber": "01",
                "year": "2019"
            },
            "ansible_default_ipv4": {
                "address": "10.28.4.5",
                "alias": "wlp3s0",
                "broadcast": "10.28.4.255",
                "gateway": "10.28.4.1",
                "interface": "wlp3s0",
                "macaddress": "84:3a:4b:73:6c:f8",
                "mtu": 1500,
                "netmask": "255.255.255.0",
                "network": "10.28.4.0",
                "type": "ether"
            },
            "ansible_default_ipv6": {},
            "ansible_device_links": {
                "ids": {
                    "sda": [
                        "ata-SanDisk_SD5SG2256G1052E_124928400505",
                        "wwn-0x5001b44821e51879"
                    ],
                    "sda1": [
                        "ata-SanDisk_SD5SG2256G1052E_124928400505-part1",
                        "wwn-0x5001b44821e51879-part1"
                    ]
                },
                "labels": {},
                "masters": {},
                "uuids": {
                    "sda1": [
                        "cd980b7e-8c51-4b68-9a36-25bacd7d5ebf"
                    ]
                }
            },
            "ansible_devices": {
                "loop0": {
                    "holders": [],
                    "host": "",
                    "links": {
                        "ids": [],
                        "labels": [],
                        "masters": [],
                        "uuids": []
                    },
                    "model": null,
                    "partitions": {},
                    "removable": "0",
                    "rotational": "1",
                    "sas_address": null,
                    "sas_device_handle": null,
                    "scheduler_mode": "none",
                    "sectors": "693784",
                    "sectorsize": "512",
                    "size": "338.76 MB",
                    "support_discard": "4096",
                    "vendor": null,
                    "virtual": 1
                },
                ...
                "sda": {
                    "holders": [],
                    "host": "SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)",
                    "links": {
                        "ids": [
                            "ata-SanDisk_SD5SG2256G1052E_124928400505",
                            "wwn-0x5001b44821e51879"
                        ],
                        "labels": [],
                        "masters": [],
                        "uuids": []
                    },
                    "model": "SanDisk SD5SG225",
                    "partitions": {
                        "sda1": {
                            "holders": [],
                            "links": {
                                "ids": [
                                    "ata-SanDisk_SD5SG2256G1052E_124928400505-part1",
                                    "wwn-0x5001b44821e51879-part1"
                                ],
                                "labels": [],
                                "masters": [],
                                "uuids": [
                                    "cd980b7e-8c51-4b68-9a36-25bacd7d5ebf"
                                ]
                            },
                            "sectors": "500115456",
                            "sectorsize": 512,
                            "size": "238.47 GB",
                            "start": "2048",
                            "uuid": "cd980b7e-8c51-4b68-9a36-25bacd7d5ebf"
                        }
                    },
                    "removable": "0",
                    "rotational": "0",
                    "sas_address": null,
                    "sas_device_handle": null,
                    "scheduler_mode": "cfq",
                    "sectors": "500118192",
                    "sectorsize": "512",
                    "size": "238.47 GB",
                    "support_discard": "512",
                    "vendor": "ATA",
                    "virtual": 1,
                    "wwn": "0x5001b44821e51879"
                }
            },
            "ansible_distribution": "Ubuntu",
            "ansible_distribution_file_parsed": true,
            "ansible_distribution_file_path": "/etc/os-release",
            "ansible_distribution_file_variety": "Debian",
            "ansible_distribution_major_version": "18",
            "ansible_distribution_release": "bionic",
            "ansible_distribution_version": "18.04",
            "ansible_dns": {
                "nameservers": [
                    "127.0.0.53"
                ],
                "search": [
                    "mynet"
                ]
            },
            "ansible_domain": "zero",
            "ansible_effective_group_id": 1000,
            "ansible_effective_user_id": 1000,
            "ansible_env": {
                "BASH_ENV": "/home/poirier/dotfiles/bash/.bashenvrc",
                "DBUS_SESSION_BUS_ADDRESS": "unix:path=/run/user/1000/bus",
                "HOME": "/home/poirier",
                "LANG": "en_US.UTF-8",
                "LOGNAME": "poirier",
                "MAIL": "/var/mail/poirier",
                "PATH": "/home/poirier/.pyenv/plugins/pyenv-virtualenv/shims:/home/poirier/.pyenv/shims:/home/poirier/.pyenv/bin:/home/poirier/.pyenv/plugins/pyenv-virtualenv/shims:/home/poirier/.pyenv/shims:/home/poirier/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/home/poirier/.local/bin:/home/poirier/.yarn/bin:/home/poirier/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games",
                "PWD": "/home/poirier",
                "PYENV_ROOT": "/home/poirier/.pyenv",
                "PYENV_SHELL": "bash",
                "PYENV_VIRTUALENV_INIT": "1",
                "SHELL": "/bin/bash",
                "SHLVL": "1",
                "SSH_AUTH_SOCK": "/tmp/ssh-pH3QNOurzC/agent.26808",
                "SSH_CLIENT": "127.0.0.1 33550 22",
                "SSH_CONNECTION": "127.0.0.1 33550 127.0.0.1 22",
                "TZ": "America/New_York",
                "USER": "poirier",
                "XDG_RUNTIME_DIR": "/run/user/1000",
                "XDG_SESSION_ID": "11860",
                "_": "/bin/sh"
            },
            "ansible_fips": false,
            "ansible_form_factor": "Notebook",
            "ansible_fqdn": "moth.zero",
            "ansible_hostname": "moth",
            "ansible_interfaces": [
                "zt7nnjxkbi",
                "wlp3s0",
                "wwp0s20u4i6",
                "lo"
            ],
            "ansible_is_chroot": false,
            "ansible_iscsi_iqn": "",
            "ansible_kernel": "4.15.0-38-generic",
            "ansible_lo": {
                "active": true,
                "device": "lo",
                "ipv4": {
                    "address": "127.0.0.1",
                    "broadcast": "host",
                    "netmask": "255.0.0.0",
                    "network": "127.0.0.0"
                },
                "ipv6": [
                    {
                        "address": "::1",
                        "prefix": "128",
                        "scope": "host"
                    }
                ],
                "mtu": 65536,
                "promisc": false,
                "type": "loopback"
            },
            "ansible_local": {},
            "ansible_lsb": {
                "codename": "bionic",
                "description": "Ubuntu 18.04.1 LTS",
                "id": "Ubuntu",
                "major_release": "18",
                "release": "18.04"
            },
            "ansible_machine": "x86_64",
            "ansible_machine_id": "d3e0714b1ee94fbd8512d59db7d1cf3f",
            "ansible_memfree_mb": 145,
            "ansible_memory_mb": {
                "nocache": {
                    "free": 1830,
                    "used": 5847
                },
                "real": {
                    "free": 145,
                    "total": 7677,
                    "used": 7532
                },
                "swap": {
                    "cached": 32,
                    "free": 7397,
                    "total": 7629,
                    "used": 232
                }
            },
            "ansible_memtotal_mb": 7677,
            "ansible_mounts": [
                {
                    "block_available": 16474502,
                    "block_size": 4096,
                    "block_total": 61271111,
                    "block_used": 44796609,
                    "device": "/dev/sda1",
                    "fstype": "ext4",
                    "inode_available": 14238018,
                    "inode_total": 15630336,
                    "inode_used": 1392318,
                    "mount": "/",
                    "options": "rw,relatime,errors=remount-ro,data=ordered",
                    "size_available": 67479560192,
                    "size_total": 250966470656,
                    "uuid": "cd980b7e-8c51-4b68-9a36-25bacd7d5ebf"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 116,
                    "block_used": 116,
                    "device": "/dev/loop1",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1721,
                    "inode_used": 1721,
                    "mount": "/snap/gnome-logs/43",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 15204352,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 116,
                    "block_used": 116,
                    "device": "/dev/loop2",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1720,
                    "inode_used": 1720,
                    "mount": "/snap/gnome-logs/40",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 15204352,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 104,
                    "block_used": 104,
                    "device": "/dev/loop5",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1598,
                    "inode_used": 1598,
                    "mount": "/snap/gnome-characters/139",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 13631488,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 1116,
                    "block_used": 1116,
                    "device": "/dev/loop4",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 27651,
                    "inode_used": 27651,
                    "mount": "/snap/gnome-3-26-1604/64",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 146276352,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 18,
                    "block_used": 18,
                    "device": "/dev/loop8",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1269,
                    "inode_used": 1269,
                    "mount": "/snap/gnome-calculator/238",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 2359296,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 1128,
                    "block_used": 1128,
                    "device": "/dev/loop6",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 27638,
                    "inode_used": 27638,
                    "mount": "/snap/gnome-3-26-1604/70",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 147849216,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 117,
                    "block_used": 117,
                    "device": "/dev/loop7",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1720,
                    "inode_used": 1720,
                    "mount": "/snap/gnome-logs/45",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 15335424,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 30,
                    "block_used": 30,
                    "device": "/dev/loop10",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 724,
                    "inode_used": 724,
                    "mount": "/snap/gnome-system-monitor/51",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 3932160,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 18,
                    "block_used": 18,
                    "device": "/dev/loop11",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1270,
                    "inode_used": 1270,
                    "mount": "/snap/gnome-calculator/222",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 2359296,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 338,
                    "block_used": 338,
                    "device": "/dev/loop9",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 36056,
                    "inode_used": 36056,
                    "mount": "/snap/gtk-common-themes/701",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 44302336,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 18,
                    "block_used": 18,
                    "device": "/dev/loop12",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1269,
                    "inode_used": 1269,
                    "mount": "/snap/gnome-calculator/260",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 2359296,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 30,
                    "block_used": 30,
                    "device": "/dev/loop13",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 724,
                    "inode_used": 724,
                    "mount": "/snap/gnome-system-monitor/54",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 3932160,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 1126,
                    "block_used": 1126,
                    "device": "/dev/loop14",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 27631,
                    "inode_used": 27631,
                    "mount": "/snap/gnome-3-26-1604/74",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 147587072,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 30,
                    "block_used": 30,
                    "device": "/dev/loop15",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 747,
                    "inode_used": 747,
                    "mount": "/snap/gnome-system-monitor/57",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 3932160,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 104,
                    "block_used": 104,
                    "device": "/dev/loop19",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1597,
                    "inode_used": 1597,
                    "mount": "/snap/gnome-characters/117",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 13631488,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 104,
                    "block_used": 104,
                    "device": "/dev/loop21",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 1597,
                    "inode_used": 1597,
                    "mount": "/snap/gnome-characters/124",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 13631488,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 274,
                    "block_used": 274,
                    "device": "/dev/loop23",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 27298,
                    "inode_used": 27298,
                    "mount": "/snap/gtk-common-themes/808",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 35913728,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 277,
                    "block_used": 277,
                    "device": "/dev/loop28",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 27345,
                    "inode_used": 27345,
                    "mount": "/snap/gtk-common-themes/818",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 36306944,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 706,
                    "block_used": 706,
                    "device": "/dev/loop18",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 12808,
                    "inode_used": 12808,
                    "mount": "/snap/core/5897",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 92536832,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 193,
                    "block_used": 193,
                    "device": "/dev/loop22",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 20404,
                    "inode_used": 20404,
                    "mount": "/snap/heroku/3669",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 25296896,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 194,
                    "block_used": 194,
                    "device": "/dev/loop24",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 20430,
                    "inode_used": 20430,
                    "mount": "/snap/heroku/3677",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 25427968,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 2711,
                    "block_used": 2711,
                    "device": "/dev/loop0",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 2577,
                    "inode_used": 2577,
                    "mount": "/snap/pycharm-professional/107",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 355336192,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 716,
                    "block_used": 716,
                    "device": "/dev/loop3",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 12810,
                    "inode_used": 12810,
                    "mount": "/snap/core/6034",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 93847552,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 716,
                    "block_used": 716,
                    "device": "/dev/loop17",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 12810,
                    "inode_used": 12810,
                    "mount": "/snap/core/6130",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 93847552,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 2712,
                    "block_used": 2712,
                    "device": "/dev/loop20",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 2577,
                    "inode_used": 2577,
                    "mount": "/snap/pycharm-professional/109",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 355467264,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 194,
                    "block_used": 194,
                    "device": "/dev/loop25",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 21319,
                    "inode_used": 21319,
                    "mount": "/snap/heroku/3685",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 25427968,
                    "uuid": "N/A"
                },
                {
                    "block_available": 60329506,
                    "block_size": 131072,
                    "block_total": 90023018,
                    "block_used": 29693512,
                    "device": "syn.mynet:/volume1",
                    "fstype": "nfs4",
                    "inode_available": 731447206,
                    "inode_total": 731684864,
                    "inode_used": 237658,
                    "mount": "/v",
                    "options": "rw,relatime,vers=4.0,rsize=131072,wsize=131072,namlen=255,soft,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=10.28.4.5,local_lock=none,addr=10.28.4.15",
                    "size_available": 7907509010432,
                    "size_total": 11799497015296,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 2713,
                    "block_used": 2713,
                    "device": "/dev/loop26",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 2583,
                    "inode_used": 2583,
                    "mount": "/snap/pycharm-professional/112",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 355598336,
                    "uuid": "N/A"
                },
                {
                    "block_available": 0,
                    "block_size": 131072,
                    "block_total": 867,
                    "block_used": 867,
                    "device": "/dev/loop16",
                    "fstype": "squashfs",
                    "inode_available": 0,
                    "inode_total": 10113,
                    "inode_used": 10113,
                    "mount": "/snap/bitwarden/16",
                    "options": "ro,nodev,relatime",
                    "size_available": 0,
                    "size_total": 113639424,
                    "uuid": "N/A"
                }
            ],
            "ansible_nodename": "moth",
            "ansible_os_family": "Debian",
            "ansible_pkg_mgr": "apt",
            "ansible_processor": [
                "0",
                "GenuineIntel",
                "Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz",
                "1",
                "GenuineIntel",
                "Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz",
                "2",
                "GenuineIntel",
                "Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz",
                "3",
                "GenuineIntel",
                "Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz"
            ],
            "ansible_processor_cores": 2,
            "ansible_processor_count": 1,
            "ansible_processor_threads_per_core": 2,
            "ansible_processor_vcpus": 4,
            "ansible_product_name": "3443CTO",
            "ansible_product_serial": "NA",
            "ansible_product_uuid": "NA",
            "ansible_product_version": "ThinkPad X1 Carbon",
            "ansible_python": {
                "executable": "/usr/bin/python3",
                "has_sslcontext": true,
                "type": "cpython",
                "version": {
                    "major": 3,
                    "micro": 7,
                    "minor": 6,
                    "releaselevel": "final",
                    "serial": 0
                },
                "version_info": [
                    3,
                    6,
                    7,
                    "final",
                    0
                ]
            },
            "ansible_python_version": "3.6.7",
            "ansible_real_group_id": 1000,
            "ansible_real_user_id": 1000,
            "ansible_selinux": {
                "status": "Missing selinux Python library"
            },
            "ansible_selinux_python_present": false,
            "ansible_service_mgr": "systemd",
            "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOag0MplD833lb8uTuna9XSgqzBb/chnOJ+JJd5IY3LPkML9vgYGsqM5TzCNIyTJU1Yu0NIAr7viQOYv5nOFVYA=",
            "ansible_ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAIHlbGrt1d2303ouFG685QFq+DU1xBogZ3zfpba+/EPi6",
            "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDOzkRKqn4P/7q5Yn8vipd5BcwL0nmIpvYmyivH4Y9kci8q1KU71JxQWlFm4kuX9KgrQyY8sI2R0GkIF0jzFiA0Lyd4u7wjPJPIeCwbNn5q54aiq0ewO5LdHS4t+e+hdnV4IFUr8z0vRlkzNpfVP/dGFbcK3aSFKkRaiRin9hO1UK27w1dBQ+NsBITM5EBLNdhvdeZqp5ie1QAFqVsfwsVvRHUpY6tsGOx9IhLb7yc4HC6j1iuhjIvpVfT63nCX7Ds4dktyfMxsKrxsyPBoGP8OqSc8XwdJaxUT2FAbGCrsPDRMdFmFTdxTKGziov001QZuQKKlpcfxDn+HBZNZjqhp",
            "ansible_swapfree_mb": 7397,
            "ansible_swaptotal_mb": 7629,
            "ansible_system": "Linux",
            "ansible_system_capabilities": [
                ""
            ],
            "ansible_system_capabilities_enforced": "True",
            "ansible_system_vendor": "LENOVO",
            "ansible_uptime_seconds": 5980956,
            "ansible_user_dir": "/home/poirier",
            "ansible_user_gecos": "Dan Poirier,,,",
            "ansible_user_gid": 1000,
            "ansible_user_id": "poirier",
            "ansible_user_shell": "/bin/bash",
            "ansible_user_uid": 1000,
            "ansible_userspace_architecture": "x86_64",
            "ansible_userspace_bits": "64",
            "ansible_virtualization_role": "host",
            "ansible_virtualization_type": "kvm",
            "ansible_wlp3s0": {
                "active": true,
                "device": "wlp3s0",
                "ipv4": {
                    "address": "10.28.4.5",
                    "broadcast": "10.28.4.255",
                    "netmask": "255.255.255.0",
                    "network": "10.28.4.0"
                },
                "ipv6": [
                    {
                        "address": "fe80::33e1:2:9db5:7dc0",
                        "prefix": "64",
                        "scope": "link"
                    }
                ],
                "macaddress": "84:3a:4b:73:6c:f8",
                "module": "iwlwifi",
                "mtu": 1500,
                "pciid": "0000:03:00.0",
                "promisc": false,
                "type": "ether"
            },
            "ansible_wwp0s20u4i6": {
                "active": false,
                "device": "wwp0s20u4i6",
                "macaddress": "56:42:fa:89:f2:0b",
                "module": "cdc_mbim",
                "mtu": 1500,
                "pciid": "3-4:1.6",
                "promisc": false,
                "type": "ether"
            },
            "ansible_zt7nnjxkbi": {
                "active": true,
                "device": "zt7nnjxkbi",
                "ipv4": {
                    "address": "172.26.163.45",
                    "broadcast": "172.26.255.255",
                    "netmask": "255.255.0.0",
                    "network": "172.26.0.0"
                },
                "ipv6": [
                    {
                        "address": "fcae:c8f4:7d93:35ee:162::1",
                        "prefix": "40",
                        "scope": "global"
                    }
                ],
                "macaddress": "b2:f5:3c:75:cf:f0",
                "mtu": 2800,
                "promisc": false,
                "speed": 10,
                "type": "ether"
            },
            "gather_subset": [
                "all"
            ],
            "module_setup": true
        },
        "changed": false
    }
