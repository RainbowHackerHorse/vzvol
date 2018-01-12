#!/bin/sh
vzvol_permissions() {
	
	chown "${ZUSER}" "${ZVOL_NAME}"
	( echo "own	zvol/${ZROOT}/${VOLNAME}	${ZUSER}:operator" | tee -a /etc/devfs.conf ) > /dev/null 2>&1

	zfs set custom:fs=none "${ZROOT}/${VOLNAME}"
	if [ ! "${FSTYPE}" = DIE ]; then
		zvol_fs_type || return 1
	fi
	if [ ! "${IMPORTIMG}" = DIE ]; then
		vzvol_import_img || return 1
	fi
}