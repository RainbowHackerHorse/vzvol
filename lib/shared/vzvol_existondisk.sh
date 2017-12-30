#!/bin/sh
vzvol_existondisk() {
	eval set -- "$1"; [ -e "$1" ];
}