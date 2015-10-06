#!/usr/bin/env bats

[ `git config user.name`  ] || git config user.name  test
[ `git config user.email` ] || git config user.email test

@test setup succeeds {
	local tmp=`mktemp --tmpdir --directory deploy_test.XXXX`
	local deploy="`pwd`/deploy.sh"
	pushd "$tmp"

	git init
	git remote add origin .
	touch test
	git add test
	git commit --message=test

	mkdir dist
	touch dist/test.min

	"$deploy" --setup

	popd
	rm -rf "$tmp"

	[[ `git rev-parse --abbrev-ref HEAD` = master ]]
}
