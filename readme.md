This is a script for deploying generated files to a git branch, such as when building a single-page app using [Yeoman](http://yeoman.io) and deploying to [GitHub Pages](http://pages.github.com). Unlike the [git-subtree approach](http://yeoman.io/deployment.html), it does not require the generated files be committed to the source branch. It keeps a linear history on the deploy branch and does not make superfluous commits or deploys when the generated files do not change.

For an example of use, see [X1011/verge-mobile-bingo](https://github.com/X1011/verge-mobile-bingo).

## configuration
Edit these variables at the top of the script to fit your project:

- **deploy_directory**: root of the tree of files to deploy
- **deploy_branch**: branch to commit files to and push to origin
- **default_username**, **default_email**: identity to use for git commits if none is set already. Useful for CI servers.
- **repo**: (optional) repository to deploy to. Must be readable and writable. The default of "origin" will not work on Travis CI, since it uses the read-only git protocol. In that case, it is recommended to store a [GitHub token](https://help.github.com/articles/creating-an-access-token-for-command-line-use) in a [secure environment variable](http://about.travis-ci.org/docs/user/build-configuration/#Secure-environment-variables) and use it in an HTTPS URL like this: <code>repo=https://$GITHUB_TOKEN@github.com/<i>user</i>/<i>repo</i>.git</code>

## setup
This could be implemented in the script, but I don’t feel like doing it. Replace "dist" with your deploy_directory and "gh-pages" with your deploy_branch.

1. `git --work-tree dist checkout --orphan gh-pages`
   - this will disconnect the gh-pages branch’s history from the current commit
   - in my app, the project root and dist had no files in common. If yours do, be careful if you don’t want to overwrite any existing files in dist
2. `git --work-tree dist rm -r "*"`
   - remove the source files we just checked out; these aren’t the files we’re looking for
   - the quotes are required to prevent the shell from globbing in the current directory; we want git to glob in dist
3. `git --work-tree dist add --all`
4. `git --work-tree dist commit -m "initial publish"`

## run
1. check out the branch or commit of the source you want to use. The script will use this commit to generate a message when it makes its own commit on the deploy branch.
2. generate the files in `deploy_directory`
3. make sure you have no uncommitted changes in git's index. The script will abort if you do. (It's ok to have uncommitted files in the work tree, the script does not touch the work tree.)
4. if `deploy_directory` is a relative path (the default is), make sure you are in the directory you want to resolve against. (For the default, this means you should be in the project's root.)
5. run the script

### options
`-v`, `--verbose`: echo commands as they are executed. It is recommended to enable this when running on a CI server, so you can debug if something goes wrong.


> Written with [StackEdit](http://benweet.github.io/stackedit).
