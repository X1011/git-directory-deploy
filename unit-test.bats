#!/usr/bin/env bats

source lib/batslib.bash

assert() {
	[[ $1 = that ]] && shift
	
	case $@ in
		*' = '*) assert_equal $1 "${*:3}" ;;
		'output contains '*) assert_output -p "${*:3}" ;;
		'output does not contain '*) refute_output -p "${*:5}" ;;
		*) fail invalid assertion: $@
	esac
}

@test 'assert asserts equality' {
	assert that 1 = 1
}
@test '       asserts output content' {
	run echo abc
	assert that output contains b
}
@test '       refutes output content' {
	run echo abc
	assert that output does not contain d
}

source deploy.sh --source-only

repo=https://secret@github.com/user/repo.git

@test 'filter filters repo' {
	assert that `echo $repo | filter` = '$repo'
}
@test '       filters repo embedded in string' {
	assert that `echo 1${repo}2 | filter` = '1$repo2'
}
@test '       filters repo multiple times' {
	assert that `echo 1${repo}2${repo}3 | filter` = '1$repo2$repo3'
}

@test 'sanitize sanitizes stdout' {
	assert that `sanitize echo $repo` = '$repo'
}
@test '         sanitizes stderr' {
	assert that `sanitize fail $repo 2>&1` = '$repo'
}
@test '         sanitizes xtrace' {
	skip
	assert that `(set -o xtrace && sanitize echo $repo)` = $'+ echo $repo\n $repo'
}
