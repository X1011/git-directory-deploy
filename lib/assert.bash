#!/usr/bin/env bash
set -o errexit

source lib/batslib.bash

assert() {
	[[ $1 = that ]] && shift
	
	case $@ in
		*' = '*) assert_equal "$1" "${*:3}" ;;
		'output contains '*) assert_output -p "${*:3}" ;;
		'output does not contain '*) refute_output -p "${*:5}" ;;
		*) fail invalid assertion: $@
	esac
}
