#!/bin/sh
vzvol_pkg_check_freebsd(){
	if [ "${FSTYPE}" = "ext2" -o "${FSTYPE}" = "ext3" -o "${FSTYPE}" = "ext4" -o "${FSTYPE}" = "xfs" ]; then
		echo "Warning. You have selected an FS type supplied by a port. Now checking to see if the port is installed."
		echo "Please note that unsupported FSes may exhibit unexpected behavior!"
		if [ "${FSTYPE}" = "ext2" -o "${FSTYPE}" = "ext3" -o "${FSTYPE}" = "ext4" ]; then
			pkg info | grep -q e2fsprogs
			if [ ! $? = 0 ]; then
				echo "Error! You need to install sysutils/e2fsprogs first!"
				return 1
			fi
		elif [ "${FSTYPE}" = "xfs" ]; then
			pkg info | grep -q xfsprogs
			if [ ! $? = 0 ]; then
				echo "Error! You need to install sysutils/xfsprogs first!"
				return 1
			fi
		fi
	fi
}