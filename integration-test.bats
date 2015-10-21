#!/usr/bin/env bats

setup() {
	tmp=`mktemp --tmpdir --directory deploy_test.XXXX`
	pushd "$tmp"
}
teardown() {
	popd
	rm -rf "$tmp"
}

create_repo() {
	git init
	[[ `git config user.name`  ]] || git config user.name  test
	[[ `git config user.email` ]] || git config user.email test

	touch test
	git add test
	git commit --message=test
}

source deploy.sh --source-only

@test 'setup and deployment succeed' {
	create_repo
	git remote add origin . # just 'deploy' to this repo itself, for easy testing

	mkdir dist
	touch dist/test.min

	main --setup

	[[ `git rev-parse --abbrev-ref HEAD` = master ]]
	git checkout gh-pages
	[[ -f test.min ]] # test.min is a normal file
	[[ ! -e test ]] # test does not exist
	
	
	git checkout master
	mv dist/test.min dist/test2.min

	main

	[[ `git rev-parse --abbrev-ref HEAD` = master ]]
	git checkout gh-pages
	[[ -f test2.min ]]
	[[ ! -e test.min ]]
}
