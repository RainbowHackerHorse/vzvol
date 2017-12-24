#!/bin/sh
vzvol_permissions() {
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