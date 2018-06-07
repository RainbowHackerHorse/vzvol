#!/bin/sh
set -x
set -e
txt2man -t vzvol -s 8 -v "FreeBSD System Manager\\'s Manual" VZVOL\(8\).txt > vzvol.freebsd.man
txt2man -t vzvol -s 8 -v "System Manager\\'s Manual" VZVOL\(8\).txt > vzvol.linux.man
exit
