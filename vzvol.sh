#!/bin/sh
# Debugging Stuff
#set -e 
#set -x
# 

ZROOT=$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[2] }')
ZUSER=$(whoami)
SIZE=10G
VOLNAME=DIE
VOLMK="sudo zfs create -V"
FSTYPE=DIE
errorfunc='MAIN'


if [ "$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[1] }')" = bootpool ]; then
	ZROOT=$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[2] }')
else
	ZROOT=$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[1] }')
fi

getargz() {
	errorfunc='getargz'
	while :; do
		case $1 in
			-h|--help)
				show_help
				exit
			;;
			-s|--size)
				if [ "$2" ]; then
					SIZE="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a size!"
					exit 1
				fi
			;;
			-u|--user)
				if [ "$2" ]; then
					ZUSER="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a username!"
					exit 1
				fi
			;;
			-v|--volume)
				if [ "$2" ]; then
					VOLNAME="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a zvol name!"
					exit 1
				fi
			;;
			-p|--pool)
				if [ "$2" ]; then
					ZROOT="${2}"
					shift
				else
					echo "Please provide a pool name!"
					exit 1
				fi
			;;
			-t|--type)
				if [ "$2" ]; then
					VOLTYPE="${2}"
					if [ "${VOLTYPE}" != "raw" -a "${VOLTYPE}" != "virtualbox" ]; then
						echo "Error. Invalid type ${VOLTYPE} selected!"
						exit 1
					fi
					shift
				else
					echo "Type not specified!"
					exit 1
				fi
			;;
			--sparse)
				VOLMK="sudo zfs create -s -V"
				shift
			;;
			--file-system)
				if [ "$2" ]; then
					FSTYPE="${2}"
					if [ "${FSTYPE}" != "zfs" -a "${FSTYPE}" != "ufs" -a "${FSTYPE}" != "fat32" -a "${FSTYPE}" != "ext2" -a "${FSTYPE}" != "ext3" -a "${FSTYPE}" != "ext4" -a "${FSTYPE}" != "xfs" ]; then
						echo "Error. Invalid filesystem ${FSTYPE} selected!"
						exit 1
					fi
				fi
				shift
			;;
			*)
				break
		esac
		shift
	done
}

show_help() {
	errorfunc='show_help'
	cat << 'EOT'
	
	virtbox-zvol is a shell script designed to help automate the process of 
	creating a ZFS zvol for use as a storage unit to back a light .VMDK

	This script is released under the 2-clause BSD license.
	(c) 2017 RainbowHackerHorse

	-h | --help
	Shows this help

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
	
EOT
}

checkzvol() {
	errorfunc='checkzvol'
	if [ "${VOLNAME}" = 'DIE' ]; then
		echo "Please provide a zvol name. See --help for more information."
		return 1
	fi 
}
zvol_fs_type() {
	errorfunc='zvol_fs_type'
	if [ "${FSTYPE}" = "ext2" -a "${FSTYPE}" = "ext3" -a "${FSTYPE}" = "ext4" -a "${FSTYPE}" = "xfs" ]; then
		echo "Warning. You have selected an FS type supplied by a port. Now checking to see if the port is installed."
		echo "Please note that unsupported FSes may exhibit unexpected behavior!"
		if [ "${FSTYPE}" = "ext2" -a "${FSTYPE}" = "ext3" -a "${FSTYPE}" = "ext4" ]; then
			if pkg info | grep -vq e2fsprogs; then
				echo "Error! You need to install sysutils/e2fsprogs first!"
				return 1
			fi
		elif [ "${FSTYPE}" = "xfs" ]; then
			if pkg info | grep -vq xfsprogs; then
				echo "Error! You need to install sysutils/xfsprogs first!"
				return 1
			fi
		fi
	fi
	case "${FSTYPE}" in
		zfs)
			zvol_create_fs_zfs
		;;
		ufs)
			zvol_create_fs_ufs
		;;
		fat32)
			zvol_create_fs_fat32
		;;
		ext2)
			zvol_create_fs_ext2
		;;
		ext3)
			zvol_create_fs_ext3
		;;
		ext4)
			zvol_create_fs_ext4
		;;
		xfs)
			zvol_create_fs_xfs
		;;
	esac
}

zvol_create_fs_zfs() {
	errorfunc='zvol_create_fs_zfs'
	echo "Creating ZFS Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	zpool create "${VOLNAME}" /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}
zvol_create_fs_ufs() {
	errorfunc='zvol_create_fs_ufs'
	echo "Creating UFS Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	newfs -E -J -O 2 -U /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}
zvol_create_fs_fat32() {
	errorfunc='zvol_create_fs_fat32'
	echo "Creating FAT32 Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	newfs_msdos -F32 /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}
zvol_create_fs_ext2() {
	errorfunc='zvol_create_fs_ext2'
	echo "Creating ext2 Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	mke2fs -t ext2 /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}
zvol_create_fs_ext3() {
	errorfunc='zvol_create_fs_ext3'
	echo "Creating ext3 Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	mke2fs -t ext3 /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}
zvol_create_fs_ext4() {
	errorfunc='zvol_create_fs_ext4'
	echo "Creating ext4 Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	mke2fs -t ext4 /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}
zvol_create_fs_xfs() {
	errorfunc='zvol_create_fs_xfs'
	echo "Creating XFS Filesystem on /dev/zvol/${ZROOT}/${VOLNAME}"
	mkfs.xfs /dev/zvol/"${ZROOT}"/"${VOLNAME}" || return 1
}

zvol_type_select() {
	errorfunc='zvol_type_select'
	if [ "${VOLTYPE}" = raw ]; then
		zvol_type_raw
	elif [ "${VOLTYPE}" = virtualbox ]; then
		zvol_type_virtualbox
	fi
}

zvol_type_virtualbox() {
	errorfunc='zvol_type_virtualbox'
	create_vzol || return 1
	create_vmdk || return 1
	echo "Please use /home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk as your VM Disk"
}
zvol_type_raw() {
	errorfunc='zvol_type_raw'
	create_vzol || return 1
	echo "You can find your zvol at: /dev/zvol/${ZROOT}/${VOLNAME}"
}

create_zvol() {
	errorfunc='create_vzol'
	if [ ! -e /dev/zvol/"${ZROOT}"/"${VOLNAME}" ]; then
		"${VOLMK}" "${SIZE}" "${ZROOT}"/"${VOLNAME}"
	fi
	sudo chown "${ZUSER}" /dev/zvol/"${ZROOT}"/"${VOLNAME}"
	sudo echo "own	zvol/${ZROOT}/${VOLNAME}	${ZUSER}:operator" | sudo tee -a /etc/devfs.conf
	if [ ! "${FSTYPE}" = DIE ]; then
		zvol_fs_type || return 1
	fi
}

create_vmdk() {
	errorfunc='create_vmdk'
	if [ ! -d /home/"${ZUSER}"/VBoxdisks/ ]; then
		mkdir -p /home/"${ZUSER}"/VBoxdisks/
	fi
	if [ ! -e /home/"${ZUSER}"/VBoxdisks/"${VOLNAME}".vmdk ]; then
		echo "Creating /home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk"
		sleep 3
		VBoxManage internalcommands createrawvmdk \
		-filename /home/"${ZUSER}"/VBoxdisks/"${VOLNAME}".vmdk \
		-rawdisk /dev/zvol/"${ZROOT}"/"${VOLNAME}"
	else
		echo "/home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk" already exists.
		return 1
	fi
}

error_code() {
	echo "Error occurred in function ${errorfunc}"
	echo "Exiting"
	exit 1
}

getargz "$@" || error_code
checkzvol || error_code
zvol_type_select || error_code
exit 0
