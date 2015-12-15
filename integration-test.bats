#!/usr/bin/env bats

source lib/assert.bash
source deploy.sh --source-only

setup() {
	tmp=`mktemp -dt deploy_test.XXXX`
	pushd "$tmp" >/dev/null
	create_repo
}
teardown() {
	popd >/dev/null
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

@test "deploy creates branch and deploys file" {

	main

	git cat-file -e gh-pages:file # `file` exists on gh-pages
}

@test "       deploys new file to existing branch" {
	git branch gh-pages

	main

	git cat-file -e gh-pages:file # `file` exists on gh-pages
}

@test "       updates existing file" {
	main
	echo updated > dist/file

	main
	
	[[ `git cat-file blob gh-pages:file` = updated ]]
}

@test "       removes missing file" {
	main
	rm dist/file
	
	main --allow-empty

	! git cat-file -e gh-pages:file # `file` does not exist on gh-pages
}

@test "       doesn't clobber file in deploy directory" {
	# make sure that a source file doesn't overwrite a deploy file with the same name
	echo source > file
	echo dist > dist/file
	git add file
	git commit --message=file

	main
	
	[[ `cat dist/file` = dist ]]
	[[ `git cat-file blob gh-pages:file` = dist ]]
}

@test "       doesn't deploy source file" {
	touch source
	git add source
	git commit --message='source file'
	
	main
	
	assert that `ls --almost-all dist` = file
	! git cat-file -e gh-pages:source # `source` does not exist on gh-pages
}
