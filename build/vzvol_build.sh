#!/bin/sh
vzvol_build_version="${1}"
vzvol_build_iteration="${2}"
# vzvol_build_type="${3}"
vzvol_git_location="${3}"
maintainer_email="${4}"

# General Debian/Ubuntu Package
fpm -s dir -t deb -n vzvol -v "${vzvol_build_version}" --iteration "${vzvol_build_iteration}" -C "${vzvol_git_location}" --license=BSD-2-Clause -d pv -d dialog -d dosfstools -d xfsprogs -d zfs-utils -a noarch -m "${maintainer_email}" --vendor=@hacker_horse --description="A zfs zvol management tool" --url="https://github.com/RainbowHackerHorse/vzvol" --prefix=/usr/local bin/vzvol=sbin/vzvol man/linux/vzvol.8=share/man/man8/vzvol.8 lib/linux/=lib/vzvol/lib/ lib/shared/=lib/vzvol/lib/ LICENSE=docs/LICENSE

# Ubuntu 14.04 Package
fpm -s dir -t deb -n vzvol -v "${vzvol_build_version}"-ubuntu1404 --iteration "${vzvol_build_iteration}" -C "${vzvol_git_location}" --license=BSD-2-Clause -d pv -d dialog -d dosfstools -d xfsprogs -d ubuntu-zfs -a noarch -m "${maintainer_email}" --vendor=@hacker_horse --description="A zfs zvol management tool" --url="https://github.com/RainbowHackerHorse/vzvol" --prefix=/usr/local bin/vzvol=sbin/vzvol man/linux/vzvol.8=share/man/man8/vzvol.8 lib/linux/=lib/vzvol/lib/ lib/shared/=lib/vzvol/lib/ LICENSE=docs/LICENSE

# RPM
fpm -s dir -t rpm -n vzvol -v "${vzvol_build_version}" --iteration "${vzvol_build_iteration}" -C "${vzvol_git_location}" --license=BSD-2-Clause -d pv -d dialog -d dosfstools -d xfsprogs -d zfs -d kernel-devel -a noarch -m "${maintainer_email}" --vendor=@hacker_horse --description="A zfs zvol management tool" --url="https://github.com/RainbowHackerHorse/vzvol" --prefix=/usr/local bin/vzvol=sbin/vzvol man/linux/vzvol.8=share/man/man8/vzvol.8 lib/linux/=lib/vzvol/lib/ lib/shared/=lib/vzvol/lib/ LICENSE=docs/LICENSE

