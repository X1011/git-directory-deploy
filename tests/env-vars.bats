#!/usr/bin/env bats

source lib/assert.bash
source deploy.sh --source-only

setup() {
	export GIT_DEPLOY_USERNAME=env-username
	export GIT_DEPLOY_EMAIL=env-email
	export GIT_DEPLOY_DIR=env-dir
	export GIT_DEPLOY_BRANCH=env-branch
	export GIT_DEPLOY_REPO=env-repo
	export GIT_DEPLOY_APPEN_HASH=false
}

@test 'environment variable: DEFAULT_USERNAME' {
	assert that `parse_args && echo $default_username` = "env-username"
}
@test 'environment variable: DEFAULT_EMAIL' {
	assert that `parse_args && echo $default_email` = "env-email"
}
@test 'environment variable: GIT_DEPLOY_DIR' {
	assert that `parse_args && echo $deploy_directory` = "env-dir"
}
@test 'environment variable: GIT_DEPLOY_BRANCH' {
	assert that `parse_args && echo $deploy_branch` = "env-branch"
}
@test 'environment variable: GIT_DEPLOY_REPO' {
	assert that `parse_args && echo $repo` = "env-repo"
}
@test 'environment variable: GIT_DEPLOY_APPEND_HASH' {
	assert that `parse_args && echo $append_hash` = "false"
}

