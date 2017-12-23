#!/bin/sh
zvol_create() {
	errorfunc='zvol_create'
	if [ ! -e /dev/zvol/"${ZROOT}/${VOLNAME}" ]; then
		if [ "${ZUSER}" = root ]; then
			zfs create -V "${SIZE}" "${ZROOT}/${VOLNAME}"
		else
			"${VZVOL_SU_CMD}" zfs create -V "${SIZE}" "${ZROOT}/${VOLNAME}"
		fi
	fi
	ZVOL_NAME=/dev/zvol/"${ZROOT}/${VOLNAME}"
	echo "Testing to ensure zvol was created"
	if [ ! -f "${ZVOL_NAME}" ]; then
		if [ -L "${ZVOL_NAME}" ]; then
			ZVOL_NAME=/dev/$( file "${ZVOL_NAME}" | awk -F "/" '{print $7}' )
		else
			echo "Error. ${ZVOL_NAME} not found"
			return 1
		fi
	fi
	if [ "${ZUSER}" = root ]; then
		chown "${ZUSER}" "${ZVOL_NAME}"
		( echo "own	zvol/${ZROOT}/${VOLNAME}	${ZUSER}:operator" | tee -a /etc/devfs.conf ) > /dev/null 2>&1
	else
		"$VZVOL_SU_CMD" chown "${ZUSER}" "${ZVOL_NAME}"
		( echo "own	zvol/${ZROOT}/${VOLNAME}	${ZUSER}:operator" | "$VZVOL_SU_CMD" tee -a /etc/devfs.conf ) > /dev/null 2>&1
	fi
	"$VZVOL_SU_CMD" zfs set custom:fs=none "${ZROOT}/${VOLNAME}"
	if [ ! "${FSTYPE}" = DIE ]; then
		zvol_fs_type || return 1
	fi
	if [ ! "${IMPORTIMG}" = DIE ]; then
		vzvol_import_img || return 1
	fi
}