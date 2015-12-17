Some guidelines and tips for development.

### git

1. [Fork](https://help.github.com/articles/fork-a-repo/) this repository.
2. Make changes on a branch of your choice. Atomic commits are better than clobbering commits.
3. [Sync your fork](https://help.github.com/articles/syncing-a-fork/) and keep your branch up to date with [master](https://github.com/X1011/git-directory-deploy/tree/master).
4. [Create a pull request](https://help.github.com/articles/creating-a-pull-request/) to this repository.

Once a pull request is opened, be careful with `git commit --amend` and `git rebase`. No need to squash a branch into multiple commits, either. When in doubt, preserve your history.

### syntax & style

- Tabs for indenting. Spaces for alignment.
- Wrap discrete chunks of code in functions. This makes writing test easier.
- See [.editorconfig](.editorconfig) for more specifics and exceptions.
- Follow the style you see in the code that's already here.

### testing

Have [bats](https://github.com/sstephenson/bats#readme) installed.

Groups of tests are in `.bats` files in the repository root. You can [run tests manually](https://github.com/sstephenson/bats#running-tests) or use the `./watch` script (requires [`entr`](https://github.com/clibs/entr)) to automatically run them when any file is changed.

Discrete chunks of code should have a discrete set of tests. If possible, tests should call the relevant function rather than running the whole script.

Write test names so that they tell a story for a test group, and indent each test 

For anything that involves touching the file system, use `setup()` & `teardown()` functions for the `.bats` file that make the tests run in a temporary folder:

```bash
setup() {
	run mktemp -dt deploy_test.XXXX
	assert_success
	tmp=$output
	pushd "$tmp" >/dev/null
}
```

```bash
teardown() {
	popd >/dev/null
	rm -rf "$tmp"
}
```

Finally, make sure the `.bats` files are in a path that's accounted-for in [`circle.yml`](circle.yml).