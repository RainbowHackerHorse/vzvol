#!/bin/sh
zvol_create() {
	errorfunc='zvol_create'
	if [ ! -e /dev/zvol/"${ZROOT}/${VOLNAME}" ]; then
		zfs create -V "${SIZE}" "${ZROOT}/${VOLNAME}"
	fi
	ZVOL_NAME=/dev/zvol/"${ZROOT}/${VOLNAME}"
	sleep 5
	echo "Testing to ensure zvol was created"
	if [ -L "${ZVOL_NAME}" ]; then
		ZVOL_NAME=/dev/$( file "${ZVOL_NAME}" | awk -F "/" '{print $7}' )
		vzvol_permissions
	elif [ -c "${ZVOL_NAME}" ]; then
		vzvol_permissions
	else
		echo "Error. ${ZVOL_NAME} not found"
		return 1
	fi
}