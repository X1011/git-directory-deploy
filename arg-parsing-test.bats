#!/usr/bin/env bats

source lib/assert.bash
source deploy.sh --source-only

setup() {
	run mktemp -dt deploy_test.XXXX
	assert_success
	tmp=$output
	pushd "$tmp" >/dev/null
}

teardown() {
	popd >/dev/null
	rm -rf "$tmp"
}

set_env_vars() {
	# Set environment variables.
	export GIT_DEPLOY_APPEND_HASH=env-var
}

write_env_file() {
	# Write a '.env' file to override environment variables.
	cat <<-EOF > .env
		GIT_DEPLOY_APPEND_HASH=env-file
	EOF
}

write_conf_file() {
	# Write a config-file to override '.env'.
	cat <<-EOF > conf
		GIT_DEPLOY_APPEND_HASH=conf-file
	EOF
}

@test 'Arg-parsing defaults to in-script values.' {
	parse_args
	assert that "$append_hash" = "true"
}

@test '        overrides script defaults with environment variables.' {
	set_env_vars

	parse_args
	assert that "$append_hash" = "env-var"
}

@test '        overrides environment variables with .env file.' {
	set_env_vars
	write_env_file

	parse_args
	assert that "$append_hash" = "env-file"
}

@test '        overrides .env with a file specified on the command-line.' {
	set_env_vars
	write_env_file
	write_conf_file

	parse_args --config-file conf
	assert that "$append_hash" = "conf-file"
}

@test '        overrides everything with a command-line option.' {	
	set_env_vars
	write_env_file
	write_conf_file

	parse_args --config-file conf --no-hash
	assert that "$append_hash" = "false"
}

