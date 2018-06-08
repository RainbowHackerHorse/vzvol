#!/bin/sh
set -x
set -e
txt2man -t vzvol -s 8 -r "vzvol Version 0.7.0" -v "FreeBSD System Manager\\'s Manual" VZVOL\(8\).txt > ../man/freebsd/vzvol.8
txt2man -t vzvol -s 8 -r "vzvol Version 0.7.0" -v "System Manager\\'s Manual" VZVOL\(8\).txt > ../man/linux/vzvol.8
exit
