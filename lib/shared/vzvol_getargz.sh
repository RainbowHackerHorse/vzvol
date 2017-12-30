#!/bin/sh
vzvol_getargz() {
	errorfunc='getargz'
	while :; do
		case $1 in
			-h|--help)
				vzvol_showhelp
				exit
			;;
			-s|--size)
				if [ "$2" ]; then
					SIZE="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a size!"
					return 1
				fi
			;;
			-u|--user)
				if [ "$2" ]; then
					ZUSER="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a username!"
					return 1
				fi
			;;
			-v|--volume)
				if [ "$2" ]; then
					VOLNAME="${2}"
					# Add input check to ensure proper syntax
					shift
				else
					echo "Please provide a zvol name!"
					return 1
				fi
			;;
			-p|--pool)
				if [ "$2" ]; then
					ZROOT="${2}"
					shift
				else
					echo "Please provide a pool name!"
					return 1
				fi
			;;
			-t|--type)
				if [ "$2" ]; then
					VOLTYPE="${2}"
					if [ "$VOLTYPE" != "raw" -a "$VOLTYPE" != "virtualbox" ]; then
						echo "Error. Invalid type $VOLTYPE selected!"
						return 1
					fi
					shift
				else
					echo "Type not specified!"
					return 1
				fi
			;;
			--file-system)
				if [ "$2" ]; then
					if [ ! "${IMPORTIMG}" = "DIE" ]; then
						echo "--file-system is incompatible with --import."
						return 1
					fi
					FSTYPE="${2}"
					vzvol_fscheck "${FSTYPE}"
					FORMAT_ME="${ZROOT}/${VOLNAME}"
				fi
				shift
			;;
			--import)
				if [ ! "${FSTYPE}" = "DIE" ]; then
						echo "--import is incompatible with --file-system."
						return 1
				fi
				if [ "$2" ]; then
					if [ ! -f "${2}" ]; then
						echo "Error. ${2} does not exist or has incorrect permissions, and can not be imported"
						return 1
					fi
					IMPORTIMG="${2}"
				fi
				shift
			;;
			-p)
				if pkg -N info | grep -vq pv; then
					echo "Error! You need to install sysutils/pv first, or don't use -p"
					return 1
				fi
				VZVOL_PROGRESS_FLAG="YES"
				shift
			;;
			--delete)
				if [ $( zfs list -t volume | awk '{print $1}' | grep -v "NAME" | grep -vq "${2}" ) ]; then
					echo "Error, zvol ${2} does not exist."
					echo "Try running vzvol --list or zfs list -t volume to see the available zvols on the system."
					return 1
				else
					DELETE_ME="${2}"
					DELETE_VMDK="${HOME}/VBoxDisks/${2}.vmdk"
					vzvol_delete || exit 1
					exit
				fi
			;;
			--list)
				vzvol_list
				exit
			;;
			--format)
				( zfs list -t volume | awk '{print $1}' | grep -v "NAME" | grep -q "${3}" )
				if [ $? = 1 ]; then
					echo "Error, zvol ${3} does not exist."
					echo "Try running vzvol --list or zfs list -t volume to see the available zvols on the system."
					return 1
				else
					if [ ! "$3" ]; then
						echo "Error, please select a zvol to format"
						return 1
					else
						FSTYPE="${2}"
						FORMAT_ME="${3}"
						VOLNAME="${FORMAT_ME}"
						vzvol_fscheck
						zvol_fs_type || exit 1
						exit
					fi
				fi
			;;
			*)
				break
		esac
		shift
	done
}