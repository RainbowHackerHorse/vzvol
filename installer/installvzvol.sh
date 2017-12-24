#!/bin/sh
# Install vzvol

PREFIX=/usr/local

if [ "$1" = "--prefix" ]; then
	PREFIX="${2}"
fi

if [ -d "${PREFIX}"/bin ]; then
	mkdir -p "${PREFIX}"/bin
fi
mv ../bin/vzvol "${PREFIX}"/bin/vzvol
chmod +x "${PREFIX}"/bin/vzvol
if [ -d "${PREFIX}"/lib/vzvol ]; then
	mkdir "${PREFIX}"/lib/vzvol
fi
mv ../lib "${PREFIX}"/lib/vzvol/
echo "vzvol is now installed to ${PREFIX}/bin"
exit