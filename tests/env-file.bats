#!/usr/bin/env bats

source lib/assert.bash
source deploy.sh --source-only

envfile_backup=.env.bats-bak

setup() {
	export GIT_DEPLOY_USERNAME=env-username
	export GIT_DEPLOY_EMAIL=env-email
	export GIT_DEPLOY_DIR=env-dir
	export GIT_DEPLOY_BRANCH=env-branch
	export GIT_DEPLOY_REPO=env-repo
	export GIT_DEPLOY_APPEND_HASH=env-hash

	if [ -e .env ]; then
		mv .env $envfile_backup
	fi

	cat <<-EOF > .env
		GIT_DEPLOY_USERNAME=dotenv-username
		GIT_DEPLOY_EMAIL=dotenv-email
		GIT_DEPLOY_DIR=dotenv-dir
		GIT_DEPLOY_BRANCH=dotenv-branch
		GIT_DEPLOY_REPO=dotenv-repo
		GIT_DEPLOY_APPEND_HASH=dotenv-hash
	EOF
}

teardown() {
	rm .env
	if [ -e "$envfile_backup" ]; then
		mv $envfile_backup .env
	fi
}

@test 'dotenv variable: DEFAULT_USERNAME' {
	assert that `parse_args && echo $default_username` = "dotenv-username"
}
@test 'dotenv variable: DEFAULT_EMAIL' {
	assert that `parse_args && echo $default_email` = "dotenv-email"
}
@test 'dotenv variable: GIT_DEPLOY_DIR' {
	assert that `parse_args && echo $deploy_directory` = "dotenv-dir"
}
@test 'dotenv variable: GIT_DEPLOY_BRANCH' {
	assert that `parse_args && echo $deploy_branch` = "dotenv-branch"
}
@test 'dotenv variable: GIT_DEPLOY_REPO' {
	assert that `parse_args && echo $repo` = "dotenv-repo"
}
@test 'dotenv variable: GIT_DEPLOY_APPEND_HASH' {
	assert that `parse_args && echo $append_hash` = "dotenv-hash"
}

