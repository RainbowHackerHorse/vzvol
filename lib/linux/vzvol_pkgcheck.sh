#!/bin/sh
vzvol_pkg_check_linux(){
	if [ -e /usr/bin/lsb_release ]; then
		vzvol_pkg_lsb
	else
		vzvol_pkg_distrocheck
	fi
}
vzvol_pkg_lsb() {
	case "$( lsb_release -i | awk '{print $3}' )" in
		Ubuntu)
			vzvol_pkg_DEB
		;;
		Debian)
			vzvol_pkg_DEB
		;;
	esac
}
vzvol_pkg_distrocheck() {
	if grep -q "Arch" /etc/*-release; then
		vzvol_pkg_Arch
	elif grep -q "CentOS" /etc/*-release; then
		vzvol_pkg_RHEL
	elif grep -q "Red Hat Enterprise Linux" /etc/*-release; then
		vzvol_pkg_RHEL
	else
		echo "Fatal Error"
		echo "vzvol doesn't support your distribution at this time."
		echo "vzvol currently supports:"
		echo "The FreeBSD Operating System, Arch Linux,"
		echo "Debian Linux, Ubuntu Linux, CentOS Enterprise Linux, and"
		echo "Red Hat Enterprise Linux."
		exit 1
	fi
}
vzvol_pkg_DEB() {
	if [ "${FSTYPE}" = "xfs" ]; then
		dpkg -l | grep -q xfsprogs
		if [ ! $? = 0 ]; then
			echo "Error! You need to install xfsprogs first!"
			echo "Run apt-get install xfsprogs"
			return 1
		fi
	fi
	if [ "${FSTYPE}" = "fat32" ]; then
		dpkg -l | grep -q dosfstools
		if [ ! $? = 0 ]; then
			echo "Error! You need to install dosfstools first!"
			echo "Run apt-get install dosfstools"
			return 1
		fi
	fi
}
vzvol_pkg_Arch() {
	if [ "${FSTYPE}" = "xfs" ]; then
		pacman -Q | grep -q xfsprogs
		if [ ! $? = 0 ]; then
			echo "Error! You need to install xfsprogs first!"
			echo "Run pacman -Sy xfsprogs"
			return 1
		fi
	fi
	if [ "${FSTYPE}" = "fat32" ]; then
		pacman -Q | grep -q dosfstools
		if [ ! $? = 0 ]; then
			echo "Error! You need to install dosfstools first!"
			echo "Run pacman -Sy dosfstools"
			return 1
		fi
	fi
}
vzvol_pkg_RHEL() {
	if [ "${FSTYPE}" = "xfs" ]; then
		rpm -qa | grep -q xfsprogs
		if [ ! $? = 0 ]; then
			echo "Error! You need to install xfsprogs first!"
			echo "Run yum install xfsprogs"
			return 1
		fi
	fi
	if [ "${FSTYPE}" = "fat32" ]; then
		rpm -qa | grep -q dosfstools
		if [ ! $? = 0 ]; then
			echo "Error! You need to install dosfstools first!"
			echo "Run yum install dosfstools"
			return 1
		fi
	fi
}