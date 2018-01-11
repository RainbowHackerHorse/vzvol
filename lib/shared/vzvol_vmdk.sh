#!/bin/sh
vmdk_create() {
	errorfunc='vmdk_create'
	if [ ! -d "${HOME}"/VBoxdisks/ ]; then
		mkdir -p "${HOME}"/VBoxdisks/
	fi
	if [ ! -e "${HOME}"/VBoxdisks/"${VOLNAME}".vmdk ]; then
		echo "Creating ${HOME}/VBoxdisks/${VOLNAME}.vmdk"
		sleep 3
		VBoxManage internalcommands createrawvmdk \
		-filename "${HOME}"/VBoxdisks/"${VOLNAME}".vmdk \
		-rawdisk /dev/zvol/"${ZROOT}/${VOLNAME}"
	else
		echo "${HOME}/VBoxdisks/${VOLNAME}.vmdk" already exists.
		return 1
	fi
}