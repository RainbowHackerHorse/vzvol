#!/bin/sh
zvol_check() {
	errorfunc='zvol_check'
	if [ "${VOLNAME}" = 'DIE' ]; then
		echo "Please provide a zvol name. See --help for more information."
		return 1
	fi
	( zfs list -t volume 2>/dev/null | awk '{print $1}' | grep -v "NAME" | grep -q "${ZROOT}/${VOLNAME}" )
	if [ $? = 0 ]; then
		NO_CREATE=YES
	fi
}