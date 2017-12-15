# vzvol
vzvol is a tool to assist in the creation of ZFS zvols as storage for various virtualization providers.

## What
Creates a ZFS zvol, and configures permissions, and creates and registers a VirtualBox VMDK shim for the zvol if you ask nicely. 

## Why
This allows you to use the zvol to back a disk for VirtualBox, bhyve, or other virtualization providers.
`vzvol` also allows you to format your zvol with many filesystems, including:
- zfs
- ufs2
- fat32
- ext2,3,4
- xfs

## Dependencies
`vzvol` is written to be a 0-dependency program for its main functionality.
However, to enable the use of certain functions, some additional packages are required:
- The -p flag requires the installation of sysutils/pv. This port is not needed if you don't use -p
- XFS filesystem support requires the installation of sysutils/xfsprogs
- ext2, ext3, and ext4 require the installation of sysutils/e2fsprogs

## Will this ever be in the FreeBSD Ports Tree?
I have no idea. Do you find it useful? I'd love to get it in ports, but
only if people actually find this useful. :)
I'm currently working on a port, and you can see progress and help me fix mistakes in my Makefile at:
https://github.com/RainbowHackerHorse/port-vzvol

## Contributing
Fork and open a PR with your changes.

## Help
virtbox-zvol is a shell script designed to help automate the process of 
creating a ZFS zvol for use as a storage unit for virtualization, or testing.
vzvol was originally created to allow you to back a light .VMDK with a zvol for 
use with VirtualBox, however additional functionality has been added over time to
make vzvol a general-use program. I hope you find it useful!

This script is released under the 2-clause BSD license.
(c) 2017 RainbowHackerHorse

https://github.com/RainbowHackerHorse/vzvol

-h | --help
Shows this help

zvol Creation Flags:

-s | --size
Allows you to set a size for the zvol.
Size should be set using M or G.
Example: --size 10G | -s 1024M
Defaults to 10G if nothing specified.

-u | --user
Sets the user under which we grant permissions for the zvol.
Defaults to your username if nothing is specified.

-v | --volume
MANDATORY OPTION!!
Sets the zvol name. If nothing is specified or this option is left off,
the command will FAIL!

-p | --pool
This flag will allow you to override the logic to choose the zpool you want
your zvol on.
By default, this script selects the first zpool available, unless your 
first pool is "bootpool" (as with an encrypted system).
If your first pool is "bootpool", this script will default to the second
listed pool, usually "zroot" in a default install.

--sparse
The sparse flag allows you to create a sparse zvol instead of a pre-allocated one.
Be careful using this option! Disk space will not be pre-allocated prior to creating
the zvol which can cause you to run out of room in your VM!

-t | --type
This option allows you to set the disk type behavior.
The following types are accepted:
virtualbox 	- The default behavior, vzvol will create a shim VMDK to point to the created 
			zvol.
raw			- Create a raw, normal zvol with no shim, in the default location of 
			/dev/zvol/poolname/volumename
--file-system
Setting this flag allows you to format the zvol with your choice of filesystem.
The default for vzvol is to not create a filesystem on the new zvol.
The following types are accepted:
Filesystems with support in FreeBSD:
	zfs 		- Creates a zfs filesystem, using the name set in --volume as the pool name.
	ufs 		- Create a FreeBSD compatible UFS2 filesystem.
	fat32		- Create an MS-DOS compatible FAT32 filesystem.

Filesystems that require a port be installed:
*REQUIRES* sysutils/e2fsprogs!
	ext2		- Creates a Linux-compatible ext2 filesystem.
	ext3		- Creates a Linux-compatible ext3 filesystem. 	
	ext4		- Creates a Linux-compatible ext4 filesystem. 	
*REQUIRES* sysutils/xfsprogs!
	xfs 		- Create an XFS filesystem. 

--import 
The --import flag allows you to import the contents of a downloaded disk image to
your newly created zvol. This is useful when using a pre-installed VM image, such as
https://github.com/RainbowHackerHorse/FreeBSD-On-Linode 

-p
The -p flag is used with --import to show a progress bar for image data importation
to the vzol. -p requires that sysutils/pv be installed.

zvol Management Flags:

--format
The --format flag allows you to reformat a zvol created by vzvol, using the same 
options and arguments as --file-system.
You must specify the fs type, and then the zvol to format.
Example: vzvol --format xfs zroot/smartos

--delete
The --delete flag deletes the zvol you specify. If a .VMDK file is associated with
the zvol, the .VMDK will also be deleted.
You MUST specify the zpool the zvol resides on.
You can get this information from running vzvol --list or zfs list -t volume
Example: vzvol --delete zroot/smartos11

--list
List all zvols on your system, the type, and any associated .VMDK files.
Example output:
ZVOL              TYPE        VMDK                        
zroot/smartos     RAW         none                        
zroot/ubuntu1604  VirtualBox  /home/username/VBoxDisks/ubuntu1604.vmdk  
