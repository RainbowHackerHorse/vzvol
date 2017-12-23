#!/bin/sh
vzvol_fscheck() {
	if [ "${FSTYPE}" != "zfs" -a "${FSTYPE}" != "ufs" -a "${FSTYPE}" != "fat32" -a "${FSTYPE}" != "ext2" -a "${FSTYPE}" != "ext3" -a "${FSTYPE}" != "ext4" -a "${FSTYPE}" != "xfs" ]; then
		echo "Error. Invalid filesystem ${FSTYPE} selected!"
		return 1
	fi
}
