# vzvol
vzvol is a tool to assist in the creation of ZFS zvols as storage for various virtualization providers.

## What
Creates a ZFS zvol, and configures permissions Creates and registers a VirtualBox VMDK shim for the zvol if you ask nicely. 

## Why
This allows you to use the zvol to back a disk for VirtualBox, bhyve, or other virtualization providers.
`vzvol` also allows you to format your zvol with many filesystems, including:
- zfs
- ufs2
- fat32
- ext2,3,4
- xfs

More info coming soon now that this deserves its own repo