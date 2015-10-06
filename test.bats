#!/usr/bin/env bats

setup() {
	tmp=`mktemp --tmpdir --directory deploy_test.XXXX`
	deploy="`pwd`/deploy.sh"
	pushd "$tmp"
}

@test setup succeeds {
	git init
	[ `git config user.name`  ] || git config user.name  test
	[ `git config user.email` ] || git config user.email test
	git remote add origin .

	touch test
	git add test
	git commit --message=test

	mkdir dist
	touch dist/test.min

	"$deploy" --setup

	[[ `git rev-parse --abbrev-ref HEAD` = master ]]
}

teardown() {
	popd
	rm -rf "$tmp"
}
