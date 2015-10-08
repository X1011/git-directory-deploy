#!/usr/bin/env bats

source deploy.sh --source-only

repo=https://secret@github.com/user/repo.git

@test 'filter filters repo' {
	[[ `echo $repo | filter` = '$repo' ]]
}

@test 'filter filters repo embedded in string' {
	[[ `echo 1$repo2 | filter` = '1$repo2' ]]
}

@test 'filter filters repo multiple times' {
	[[ `echo 1$repo2$repo3 | filter` = '1$repo2$repo3' ]]
}
