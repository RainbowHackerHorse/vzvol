#!/bin/sh
# Debugging Stuff
#set -e 
#set -x
# 

ZROOT=$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[2] }')
ZUSER=$(whoami)
SIZE=10G
VOLNAME=DIE

if [ "$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[1] }')" = bootpool ]; then
	ZROOT=$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[2] }')
else
	ZROOT=$(zpool list | awk '{ zPools[NR-1]=$1 } END { print zPools[1] }')
fi

getargz() {
	while :; do
		case $1 in
			-h|--help)
				show_help
				exit
				;;
			-s|--size)
				if [ "$2" ]; then
					SIZE="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a size!"
					exit 1
				fi
				;;
			-u|--user)
				if [ "$2" ]; then
					ZUSER="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a username!"
					exit 1
				fi
				;;
			-v|--volume)
				if [ "$2" ]; then
					VOLNAME="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a zvol name!"
					exit 1
				fi
				;;
			-p|--pool)
				if [ "$2" ]; then
					ZROOT="${2}"
					shift
				else
					echo "Please provide a pool name!"
					exit 1
				fi
				;;

			*)
				break
		esac
		shift
	done
}

show_help() {
	cat << 'EOT'
	
	virtbox-zvol is a shell script designed to help automate the process of 
	creating a ZFS zvol for use as a storage unit to back a light .VMDK

	This script is released under the 2-clause BSD license.
	(c) 2017 RainbowHackerHorse

	-h | --help
	Shows this help

	-s | --size
	Allows you to set a size for the zvol.
	Size should be set using M or G.
	Example: --size 10G | -s 1024M
	Defaults to 10G if nothing specified.

	-u | --user
	Sets the user under which we grant permissions for the zvol.
	Defaults to your username if nothing is specified.

	-v | --volume
	MANDATORY OPTION!!
	Sets the zvol name. If nothing is specified or this option is left off,
	the command will FAIL!

	-p | --pool
	This flag will allow you to override the logic to choose the zpool you want
	your zvol on.
	By default, this script selects the first zpool available, unless your 
	first pool is "bootpool" (as with an encrypted system).
	If your first pool is "bootpool", this script will default to the second
	listed pool, usually "zroot" in a default install.
	
EOT
}

checkzvol() {
	if [ "${VOLNAME}" = 'DIE' ]; then
		echo "Please provide a zvol name. See --help for more information."
		exit 1
	fi 
}

create_zvol() {
	if [ ! -e /dev/zvol/"${ZROOT}"/"${VOLNAME}" ]; then
		sudo zfs create -V "${SIZE}" "${ZROOT}"/"${VOLNAME}"
	fi
	sudo chown "${ZUSER}" /dev/zvol/"${ZROOT}"/"${VOLNAME}"
	sudo echo "own	zvol/${ZROOT}/${VOLNAME}	${ZUSER}:operator" | sudo tee -a /etc/devfs.conf
}

create_vmdk() {
	if [ ! -d /home/"${ZUSER}"/VBoxdisks/ ]; then
		mkdir -p /home/"${ZUSER}"/VBoxdisks/
	fi
	if [ ! -e /home/"${ZUSER}"/VBoxdisks/"${VOLNAME}".vmdk ]; then
		echo "Creating /home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk"
		sleep 3
		VBoxManage internalcommands createrawvmdk \
		-filename /home/"${ZUSER}"/VBoxdisks/"${VOLNAME}".vmdk \
		-rawdisk /dev/zvol/"${ZROOT}"/"${VOLNAME}"
	else
		echo "/home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk" already exists.
		exit 1
	fi
}

getargz "$@" || exit 1
checkzvol || exit 1
create_vzol || exit 1
create_vmdk || exit 1
echo "Please use /home/${ZUSER}/VBoxdisks/${VOLNAME}.vmdk as your VM Disk"
