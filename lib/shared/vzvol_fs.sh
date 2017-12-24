#!/bin/sh
zvol_create_fs_zfs() {
	errorfunc='zvol_create_fs_zfs'
	echo "Creating ZFS Filesystem on /dev/zvol/${FORMAT_ME}"
	zpool create "${VOLNAME}" /dev/zvol/"${FORMAT_ME}" || return 1
}
zvol_create_fs_ufs() {
	errorfunc='zvol_create_fs_ufs'
	echo "Creating UFS Filesystem on /dev/zvol/${FORMAT_ME}"
	newfs -E -J -O 2 -U /dev/zvol/"${FORMAT_ME}" || return 1
}
zvol_create_fs_fat32_freebsd() {
	newfs_msdos "$@"
}
zvol_create_fs_fat32_linux() {
	mkfs.fat "$@"
}
zvol_create_fs_ext2() {
	errorfunc='zvol_create_fs_ext2'
	echo "Creating ext2 Filesystem on /dev/zvol/${FORMAT_ME}"
	mke2fs -t ext2 /dev/zvol/"${FORMAT_ME}" || return 1
}
zvol_create_fs_ext3() {
	errorfunc='zvol_create_fs_ext3'
	echo "Creating ext3 Filesystem on /dev/zvol/${FORMAT_ME}"
	mke2fs -t ext3 /dev/zvol/"${FORMAT_ME}" || return 1
}
zvol_create_fs_ext4() {
	errorfunc='zvol_create_fs_ext4'
	echo "Creating ext4 Filesystem on /dev/zvol/${FORMAT_ME}"
	mke2fs -t ext4 /dev/zvol/"${FORMAT_ME}" || return 1
}
zvol_create_fs_xfs() {
	errorfunc='zvol_create_fs_xfs'
	echo "Creating XFS Filesystem on /dev/zvol/${FORMAT_ME}"
	mkfs.xfs /dev/zvol/"${FORMAT_ME}" || return 1
}