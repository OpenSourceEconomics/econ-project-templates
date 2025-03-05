Contributions are always welcome. Everything ranging from small extensions of the
documentation to implementing new features is appreciated. Of course, the bigger the
change the more it is necessary to reach out to us in advance for an discussion. You can
post an issue or contact [hmgaudecker](https://github.com/hmgaudecker) via email.

To get acquainted with the code base, you can also check out our
[issue tracker](https://github.com/OpenSourceEconomics/econ-project-templates/issues)
for some immediate and clearly defined tasks.

**Please read the following steps carefully before contributing!**

1. Download [pixi](https://pixi.sh/latest/#installation).

1. Fork the
   [repository](https://github.com/OpenSourceEconomics/econ-project-templates/). This
   will create a copy of the repository where you have write access. Your fix will be
   implemented in your copy. After that, you will start a pull request (PR) which means
   a proposal to merge your changes into the project. If you plan to become a regular
   contributor we can give you push access to unprotected branches, which makes the
   process more convenient for you.

1. Clone the repository to your disk.

```{note}
We use `pixi` to manage the project. This means that you have to prepend all commands
with `pixi run`.
```

You can build the documentation using

```console
$ pixi run build-docs
```

The newly created documentation can be opened using (replace "browser" with your browser
of choice)

```console
$ browser docs_template/build/html/index.html
```

1. Implement the fix or new feature.

1. We validate contributions in three ways. First, we have a test suite to check the
   implementation of template_project. Second, we correct for stylistic errors in code
   and documentation using linters. Third, we test whether the documentation builds
   successfully.

   You can run the checks on template_project with `pytest` by running

   ```console
   $ pixi run pytest
   ```

   This will run the complete test suite.

   You should correct any errors displayed in the terminal.

   To correct stylistic errors, you can also install the linters as a pre-commit with

   ```console
   $ pixi global install pre-commit
   $ pre-commit install
   ```

   This installs the pre-commit tool globally and installs the hooks into the
   repository. Then, all the linters are executed before each commit and the commit is
   aborted if one of the check fails.

   You can also manually run the linters with

   ```console
   $ pre-commit run --all-files
   ```

1. If the tests pass, push your changes to your repository. Go to the Github page of
   your fork. A banner will be displayed asking you whether you would like to create a
   PR. Follow the link and the instructions of the PR template. Fill out the PR form to
   inform everyone else on what you are trying to accomplish and how you did it.

   The PR also starts a complete run of the test suite on a continuous integration
   server. The status of the tests is shown in the PR. Reiterate on your changes until
   the tests pass on the remote machine.

1. Ask one of the main contributors to review your changes. Include their remarks in
   your changes.

1. The final PR will be merged by one of the main contributors.
