Some guidelines and tips for development.

## git

Feel free to [fork](https://help.github.com/articles/fork-a-repo) this repository and [create a pull request](https://help.github.com/articles/creating-a-pull-request). Before making a large change, please open an issue to discuss it.

Make descriptive, granular commits. No need to squash them for the pull request.

If you drift too far from the master branch, please [merge](https://help.github.com/articles/syncing-a-fork) rather than rebasing. This will preserve the commit history that shows the context in which the code was written.

## style

- Tabs for indenting. Spaces for alignment.
- Wrap discrete chunks of code in functions. This makes writing tests easier.
- See [.editorconfig](.editorconfig) for more specifics and exceptions.
- Follow the style you see in the code that's already here.

## testing

Have [bats](https://github.com/sstephenson/bats#readme) installed.

Groups of tests are in `.bats` files in the repository root. You can [run tests manually](https://github.com/sstephenson/bats#running-tests) or use the `./watch` script (requires [`entr`](https://github.com/clibs/entr)) to automatically run them when any file is changed.

Discrete chunks of code should have a discrete set of tests. If possible, tests should call the relevant function rather than running the whole script.

Write test names so that they tell a story for a test group, and indent each test.

For anything that involves touching the file system, use `setup()` & `teardown()` functions to create a temporary directory:

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