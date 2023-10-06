1. If you are on Windows, please open the Windows Powershell. On Mac or Linux, open a
   terminal.

   Navigate to the parent folder of your future project and type (i.e., copy & paste):

   ```console
   $ cookiecutter https://github.com/OpenSourceEconomics/econ-project-templates/archive/v0.6.5.zip
   ```

1. The dialogue will move you through the installation. **Make sure to keep this page
   side-by-side during the process because if something is invalid, the whole process
   will break off** (see {ref}`cookiecutter_trouble` on how to recover from there, but
   no need to push it). *Note that if you don't know how to answer a question, it's
   usually best to accept the default.*

   **author** -- Separate multiple authors by commas.

   **email** -- Just use one in case of multiple authors.

   **affiliation** -- Separate by commas for multiple authors with different
   affiliations.

   **project_name** -- The title of your project as it should appear in papers /
   presentations. **Must not contain underscores** or anything that would be an invalid
   LaTeX title.

   **project_slug** -- This will become your project identifier (i.e., the directory
   will be called this way). The project slug **must** be a valid Python identifier,
   i.e., no spaces, hyphens, or the like. Just letters, numbers, underscores. Do not
   start with a number. There must not be a directory of this name in your current
   location.

   **project_description** -- Briefly describe your project.

   **github_username** -- Your GitHub username.

   **github_email** -- The email linked to your GitHub account.

   **git_remote_url** -- Paste your remote URL here if applicable.

   **make_initial_commit** -- Whether we should make the first commit for you.

   **version** -- The version of your project.

   **python_version** -- The python version, min 3.10, tested with 3.10 - 3.11.

   **conda_environment_name** -- Name of your conda environment. This should not be too
   long, since you need to type it often. Typically just the same as *project_slug*.

   **create_conda_environment_at_finish** -- You can do so for convenience, but often it
   is useful to add packages to the environment file first so that it will serve your
   needs.

   **add_python_example** -- Whether to set up the example project in the Python
   programming language.

   **add_r_example** -- Whether to set up the example project in the R programming
   language.

   ```{warning} The R example project is a very recent addition and has not been
   battle-tested. Feedback is greatly appreciated!
   ```

   **add_julia_example** -- Whether to set up the example project in the Julia
   programming language.

   ```{warning} The Julia example project is not implemented yet. Help is appreciated,
   see [Issue #123](https://github.com/OpenSourceEconomics/econ-project-templates/issues/123)!
   Selecting this option only installs pytask-Julia to the environment.
   ```

   **add_stata_example** -- Whether to set up the example project in the Stata
   programming language.

   ```{warning} The Stata example project is not implemented yet. Help is appreciated,
   see [Issue #124](https://github.com/OpenSourceEconomics/econ-project-templates/issues/124)!
   Selecting this option only installs pytask-Stata to the environment.
   ```

   **add_linters** -- Whether to add tools to pre-commit hook that check your code
   quality, but cannot fix your code automatically. Not recommended for inexperienced
   programmers.

   **add_github_actions** -- Whether to add GitHub actions configuration files.

   **create_changelog** -- Whether to create a CHANGES file where contributors note
   their changes made to the project.

   **open_source_license** -- Whatever you prefer.

   After successfully answering all the prompts, a folder named according to your
   project_slug will be created in your current directory. If you run into trouble,
   please follow the steps explained {ref}`cookiecutter_trouble`

1. **Skip this step if you did not opt for the conda environment.** Type:

   ```console
   $ conda activate <conda_environment_name>
   ```

   This will activate the newly created conda environment. You have to repeat the last
   step anytime you want to run your project from a new terminal window.

1. Pre-commit hooks have to be installed in order for them to have an effect. This step
   has to be repeated every time you work on your project **on a new machine**. To
   install the pre-commit hooks, navigate to the project's folder in the shell and type:

   ```console
   $ pre-commit install
   ```

1. Navigate to the folder in the shell and type the following commands into your command
   line to see whether the examples are working:

   ```console
   $ pytask
   ```

   % maybe show how it should look if everything works

   All programs used within this project template need to be found on your path, see
   above ({ref}`preparing_your_system` and the {ref}`faq`).

   If all went well, you are now ready to adapt the template to your project.

Depending on what your needs are, move on with the section on
{ref}`starting a project from scratch <starting_from_scratch>` or on
{ref}`porting an existing project <porting_existing_project>`.
