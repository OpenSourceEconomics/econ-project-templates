Contributions are always welcome. Everything ranging from small extensions of the
documentation to implementing new features is appreciated. Of course, the bigger the
change the more it is necessary to reach out to us in advance for an discussion. You can
post an issue or contact [hmgaudecker](https://github.com/hmgaudecker) via email.

To get acquainted with the code base, you can also check out our
[issue tracker](https://github.com/OpenSourceEconomics/econ-project-templates/issues)
for some immediate and clearly defined tasks.

**Please read the following steps carefully before contributing!**

1. Fork the
   [repository](https://github.com/OpenSourceEconomics/econ-project-templates/). This
   will create a copy of the repository where you have write access. Your fix will be
   implemented in your copy. After that, you will start a pull request (PR) which means
   a proposal to merge your changes into the project. If you plan to become a regular
   contributor we can give you push access to unprotected branches, which makes the
   process more convenient for you.

1. Clone the repository to your disk. Set up the project environment with conda. The
   commands for this are (in a terminal in the root of your local econ-project-templates
   repo):

   ```console
   $ conda env create -f environment.yml
   $ conda activate cp
   ```

1. Implement the fix or new feature. If you work on the *inner project* please read
   about our recommend workflow in the next section. There we also explain what the
   *inner project* is.

1. We validate contributions in three ways. First, we have a test suite to check the
   implementation the templates. Second, we correct for stylistic errors in code and
   documentation using linters. Third, we test whether the documentation builds
   successfully.

   You can run all checks with `pytest` by running

   ```console
   $ pytest
   ```

   This will run the complete test suite.

   Correct any errors displayed in the terminal.

   To correct stylistic errors, you can also install the linters as a pre-commit with

   ```console
   $ pre-commit install
   ```

   Then, all the linters are executed before each commit and the commit is aborted if
   one of the check fails. You can also manually run the linters with

   ```console
   $ pre-commit run -a
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

## Working on the inner project

We differentiate between the *inner project*, which is the example project located in
template_project, and the *outer project*, which is everything else.

To work on the inner project we recommend the following workflow:

1. Use `cookiecutter econ-project-templates` locally to create an example project

1. Create a conda environment in this local example project

1. Make sure that pytask builds the example project and that the tests run

1. Apply changes to the example project

1. Repeat step 3

1. Transfer changes to the official repository by changing example names to
   template_project etc.
