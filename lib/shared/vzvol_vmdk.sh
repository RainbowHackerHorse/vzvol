#!/bin/sh
vmdk_create() {
	ZUSERHOME=$( awk -F ":" '/${ZUSER}/{print $6}' < /etc/passwd )
	errorfunc='vmdk_create'
	if [ ! -d "${ZUSERHOME}"/VBoxdisks/ ]; then
		mkdir -p "${ZUSERHOME}"/VBoxdisks/
	fi
	if [ ! -e "${ZUSERHOME}"/VBoxdisks/"${VOLNAME}".vmdk ]; then
		echo "Creating ${ZUSERHOME}/VBoxdisks/${VOLNAME}.vmdk"
		sleep 3
		VBoxManage internalcommands createrawvmdk \
		-filename "${ZUSERHOME}"/VBoxdisks/"${VOLNAME}".vmdk \
		-rawdisk /dev/zvol/"${ZROOT}/${VOLNAME}"
	else
		echo "${ZUSERHOME}/VBoxdisks/${VOLNAME}.vmdk" already exists.
		return 1
	fi
}