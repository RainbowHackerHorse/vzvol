#!/bin/sh
zvol_fs_type() {
	errorfunc='zvol_fs_type'	
	echo "Now formatting /dev/zvol/${FORMAT_ME} as ${FSTYPE}"
	echo "This will DESTROY all data on /dev/zvol/${FORMAT_ME}"
	read -r -p "Do you want to continue? [y/N]?" line </dev/tty
	case "$line" in
		y)
			echo "Beginning format..."
		;;
		*)
			echo "Format cancelled!"
			return 1
		;;
	esac
	zfs set custom:fs="${FSTYPE}" "${FORMAT_ME}"
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