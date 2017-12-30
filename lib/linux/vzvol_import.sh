#!/bin/sh
vzvol_import_img() {
	errorfunc='vzvol_import_img'
	ZVOL_IMPORT=/dev/zvol/"${ZROOT}/${VOLNAME}"
	echo "Testing to ensure zvol exists"
	if [ ! -f "${ZVOL_IMPORT}" ]; then
		if [ -L "${ZVOL_IMPORT}" ]; then
			ZVOL_IMPORT=/dev/$( file "${ZVOL_IMPORT}" | awk -F "/" '{print $7}' )
		else
			echo "Error. ${ZVOL_IMPORT} not found"
			return 1
		fi
	fi
	if [ "${VZVOL_PROGRESS_FLAG}" = "YES" ]; then
		VZVOL_IMPORT_CMD="( pv -n ${IMPORTIMG} | of=${ZVOL_IMPORT} )2>&1 | dialog --gauge 'Importing...' 10 70 0"
	else
		VZVOL_IMPORT_CMD="dd if=${IMPORTIMG} of=${ZVOL_IMPORT} status=progress"
	fi
	echo "Now importing ${IMPORTIMG} to ${ZVOL_IMPORT}"
	echo "This will DESTROY all data on ${ZVOL_IMPORT}"
	read -r -p "Do you want to continue? [y/N]?" line </dev/tty
	case "$line" in
		y)
			echo "Beginning import..."
			"$VZVOL_SU_CMD" zfs set custom:fs=imported "${ZROOT}/${VOLNAME}"
			eval "$VZVOL_IMPORT_CMD"
		;;
		*)
			echo "Import cancelled!"
			return 1
		;;
	esac
}