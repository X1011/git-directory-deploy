#!/usr/bin/env bats

setup() {
	tmp=`mktemp --tmpdir --directory deploy_test.XXXX`
	deploy="`pwd`/deploy.sh"
	pushd "$tmp"
}

@test 'setup and deployment succeed' {
	git init
	[[ `git config user.name`  ]] || git config user.name  test
	[[ `git config user.email` ]] || git config user.email test
	git remote add origin .

	touch test
	git add test
	git commit --message=test

	mkdir dist
	touch dist/test.min

	"$deploy" --setup

	[[ `git rev-parse --abbrev-ref HEAD` = master ]]

	"$deploy"

	[[ `git rev-parse --abbrev-ref HEAD` = master ]]
	git checkout gh-pages
	[ -f test.min ]
	[ ! -e test ]
}

teardown() {
	popd
	rm -rf "$tmp"
}
