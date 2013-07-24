#!/usr/bin/env bash
set -e #abort if any command fails

deploy_directory=dist
deploy_branch=gh-pages

commit_title=`git log -n 1 --format="%s" HEAD`
commit_hash=`git log -n 1 --format="%H" HEAD`

previous_branch=`git rev-parse --abbrev-ref HEAD`
if [[ $previous_branch = "HEAD" ]]; then
	previous_branch=$commit_hash
fi

if ! ( git diff --exit-code --quiet \
    && git diff --exit-code --quiet --cached ); then
	echo Aborting due to uncommitted changes
	exit 1
fi

git --work-tree $deploy_directory checkout $deploy_branch --force
git --work-tree $deploy_directory add --all

if git diff --exit-code --quiet HEAD; then
	git --work-tree $deploy_directory commit -m \
		"publish: $commit_title"$'\n\n'"generated from commit $commit_hash"
	git push -n $deploy_branch
else
	echo No changes to files in $deploy_directory. Skipping commit.
fi

git checkout $previous_branch --force
