#!/usr/bin/env bats

setup() {
	tmp=`mktemp --tmpdir --directory deploy_test.XXXX`
	pushd "$tmp"
	create_repo
}
teardown() {
	popd
	rm -rf "$tmp"
}

create_repo() {
	git init
	
	[[ `git config user.name`  ]] || git config user.name  test
	[[ `git config user.email` ]] || git config user.email test
	git commit --allow-empty --message=empty
	
	git remote add origin . # just "deploy" to this repo itself, for easy testing
	mkdir dist
	touch dist/file
}

source deploy.sh --source-only

@test "script creates branch and deploys file" {

	main

	git cat-file -e gh-pages:file # `file` exists on gh-pages
}

@test "       deploys file to existing branch" {
	git branch gh-pages

	main

	git cat-file -e gh-pages:file # `file` exists on gh-pages
}

@test "       doesn't clobber files in deploy directory" {
	echo source > file
	echo dist > dist/file
	git add file
	git commit --message=file

	main
	
	[[ `cat dist/file` = dist ]]
	[[ `git cat-file gh-pages:file` = dist ]]
}

@test "       doesn't deploy source file" {
	touch source
	git add source
	git commit --message='source file'
	
	main
	
	[[ -z `ls --almost-all dist 2> /dev/null` ]] # no files in dist
	! git cat-file -e gh-pages:source # `source` does not exist on gh-pages
}
