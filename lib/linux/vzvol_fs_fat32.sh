#!/bin/sh
zvol_create_fs_fat32() {
	errorfunc='zvol_create_fs_fat32'
	echo "Creating FAT32 Filesystem on /dev/zvol/${FORMAT_ME}"
	zvol_create_fs_fat32_linux -F32 /dev/zvol/"${FORMAT_ME}" || return 1
}