#!/bin/sh
vzvol_delete() {
	errorfunc='vzvol_delete'
	echo "WARNING!"
	echo "This will DESTROY ${DELETE_ME}"
	echo "Unless you have a snapshot of this zvol,"
	echo "ALL DATA WILL BE DELETED AND UNRECOVERABLE!"
	read -p "Do you want to continue? [y/N]?" line </dev/tty
	case "$line" in
		y)
			echo "Deleting ${DELETE_ME}"
			"$VZVOL_SU_CMD" zfs destroy "${DELETE_ME}"
			if [ -f "${DELETE_VMDK}" ]; then
				rm -f "${DELETE_VMDK}"
			fi
		;;
		*)
			echo "Deletion cancelled!"
			return 1
		;;
	esac
}