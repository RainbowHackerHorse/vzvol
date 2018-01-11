#!/bin/sh
zvol_type_select() {
	errorfunc='zvol_type_select'
	if [ "$VOLTYPE" = raw ]; then
		zvol_type_raw
	elif [ "$VOLTYPE" = virtualbox ]; then
		zvol_type_virtualbox
	fi
}
zvol_type_virtualbox() {
	errorfunc='zvol_type_virtualbox'
	zvol_create || return 1
	vmdk_create || return 1
	echo "Please use ${HOME}/VBoxdisks/${VOLNAME}.vmdk as your VM Disk"
}
zvol_type_raw() {
	errorfunc='zvol_type_raw'
	zvol_create || return 1
	echo "You can find your zvol at: /dev/zvol/${ZROOT}/${VOLNAME}"
}