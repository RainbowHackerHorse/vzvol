Testing Status: [![CircleCI](https://circleci.com/gh/RainbowHackerHorse/vzvol.svg?style=svg)](https://circleci.com/gh/RainbowHackerHorse/vzvol)

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

### FreeBSD
- The -p flag requires the installation of sysutils/pv. This port is not needed if you don't use -p
- XFS filesystem support requires the installation of sysutils/xfsprogs
- ext2, ext3, and ext4 require the installation of sysutils/e2fsprogs
- vzvol no longer requires sudo, however now, it must either be run as root, or with sudo.

By default, on FreeBSD, these options are enabled. They can be disabled if installing
fron ports.

### Linux
- `dialog`
- dosfstools
- xfsprogs
- pv
- zfsutils

## Contributing
Fork and open a PR with your changes.
If you've contributed, please ensure you edit CONTRIBUTORS and add your GitHub username
to the bottom if it isn't already listed!

## Package Status
### vzvol is currently supported in the following OS pkg systems:
#### FreeBSD Ports
1. `cd /usr/ports/sysutils/vzvol && make install clean` or `pkg install vzvol`

#### Debian (Using my repo)
1. Ensure `apt-transport-https` is installed.
2. Add `deb https://repo-hackerhorse-io.nyc3.digitaloceanspaces.com/deb/ debian main` to /etc/apt/sources.list.d/vzvol.list (Once DO allows for CNAMEs on Spaces, this will change to https://repo.hackerhorse.io/deb)
3. Run `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FF07F6AE`
4. Run `apt-get update`
5. Run `apt-get install vzvol`

### Unsupported
- Debian Linux - If you know a Debian pkg maintainer who would like to sponser us getting a pkg made officially, get us in touch!


## Building Linux Packages
I made building Linux packages easy here, thanks to FPM.

Dependencies: FPM

1. Clone the git repo
2. `cd` to where you cloned the repo to
3. `cd build`
4. ./vzvol_build.sh "version" "deb/rpm" "vzvol git directory" "maintainer email"

### Creating a repo
I'm lazy and found a thing called aptly. This is how I created the Debian repo.

1. `aptly repo create vzvol`
2. `aptly repo add vzvol vzvol_VERSION_all.deb` 
3. `aptly snapshot create vzvol from repo vzvol`
4. `aptly publish -distribution=debian -architectures=amd64 snapshot vzvol`
5. `aptly publish -distribution=ubuntu -architectures=amd64 snapshot vzvol`

Your repo will be in ~/.aptly/public
Publish where you please, or just mirror mine!
