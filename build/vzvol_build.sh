#!/bin/sh
vzvol_build_version="${1}"
vzvol_build_type="${2}"
vzvol_git_location="${3}"
maintainer_email="${4}"
fpm -s dir -t "${vzvol_build_type}" -n vzvol -v "${vzvol_build_version}" -C "${vzvol_git_location}" --license=BSD-2-Clause -d pv -d dialog -d dosfstools -d xfsprogs -a noarch -m "${maintainer_email}" --vendor=@hacker_horse --description="A zfs zvol management tool" --url="https://github.com/RainbowHackerHorse/vzvol" --prefix=/usr/local bin/vzvol=bin/vzvol lib/linux/=lib/vzvol/lib/linux/ lib/shared/=lib/vzvol/lib/shared/ LICENSE=docs/LICENSE
