#!/bin/sh
vmdk_create() {
	errorfunc='vmdk_create'
	if [ ! -d /home/"${ZUSER}"/VBoxdisks/ ]; then
		mkdir -p /home/"${ZUSER}"/VBoxdisks/
	fi
	if [ ! -e /home/"${ZUSER}"/VBoxdisks/"${VOLNAME}".vmdk ]; then
		echo "Creating /home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk"
		sleep 3
		VBoxManage internalcommands createrawvmdk \
		-filename /home/"${ZUSER}"/VBoxdisks/"${VOLNAME}".vmdk \
		-rawdisk /dev/zvol/"${ZROOT}/${VOLNAME}"
	else
		echo "/home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk" already exists.
		return 1
	fi
}