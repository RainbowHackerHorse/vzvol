#!/bin/sh

if pkg info | grep -q sudo; then
			VZVOL_SU_CMD="sudo"
		else
			VZVOL_SU_CMD="su - root -c"
fi