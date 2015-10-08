#!/usr/bin/env bats

source lib/batslib.bash

assert() {
	assert_equal $2 $4
}

@test 'assert works' {
	assert that 1 = 1
}

source deploy.sh --source-only

repo=https://secret@github.com/user/repo.git

@test 'filter filters repo' {
	assert that `echo $repo | filter` = '$repo'
}

@test 'filter filters repo embedded in string' {
	assert that `echo 1$repo2 | filter` = '1$repo2'
}

@test 'filter filters repo multiple times' {
	assert that `echo 1$repo2$repo3 | filter` = '1$repo2$repo3'
}
