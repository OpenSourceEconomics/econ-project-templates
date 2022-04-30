.. _starting_a_new_project:

Starting A New Project
**********************


.. _dialogue:

A Completely Fresh Project
==========================

1. If you are on Windows, please open the Windows Powershell. On Mac or Linux, open a
   terminal.

   Navigate to the parent folder of your future project and type (i.e., copy & paste):

  .. code-block:: bash

    $ cookiecutter https://github.com/OpenSourceEconomics/econ-project-templates/archive/v0.5.1.zip

2. The dialogue will move you through the installation. **Make sure to keep this page
   side-by-side during the process because if something is invalid, the whole process
   will break off** (see :ref:`cookiecutter_trouble` on how to recover from there, but
   no need to push it).

  **author** -- Separate multiple authors by commas

  **email** -- Just use one in case of multiple authors

  **affiliation** -- Separate by commas for multiple authors with different affiliations

  **project_name** -- The title of your project as it should appear in papers /
  presentations. **Must not contain underscores** or anything that would be an invalid
  LaTeX title.

  **project_slug** -- This will become your project identifier (i.e., the directory will
  be called this way). The project slug **must** be a valid Python identifier, i.e., no
  spaces, hyphens, or the like. Just letters, numbers, underscores. Do not start with a
  number. There must not be a directory of this name in your current location.

  **project_short_description*** -- Briefly describe your project.

  **python_version** -- Default is 3.9. Please use python 3.8 or higher.

  **create_conda_environment_with_name** -- Just accept the default. If you don't, the
  same caveat applies as for the *project_slug*. If you really do not want a conda
  environment, type "x".

  **set_up_git** -- Set up a fresh Git repository.

  **git_remote_url** -- Paste your remote URL here if applicable.

  **make_initial_commit** -- Usually yes.

  **add_basic_pre_commit_hooks** -- Choose yes if you are using python. This implements
  black and some basic checks as `pre-commit hooks <https://pre-commit.com/>`_.
  Pre-commit hooks run before every commit and prohibit committing before they are
  resolved. For a full list of pre-commit hooks implemented here take a look at the
  :ref:`pre_commit`.

  **add_intrusive_pre_commit** -- adds `flake8 <http://flake8.pycqa.org/en/latest/>`_ to
  the pre-commit hooks. flake8 is a python code linting tool. It checks your code for
  style guide (PEP8) adherence.

  **example_to_install** -- This should be the dominant language you will use in your
  project. A working example will be installed in the language you choose; the easiest
  way to get going is simply to adjust the examples for your needs.

  **configure_running_matlab** -- Select "y" if and only if you intend to use Matlab in
  your project and the Matlab executable may be found on your path.

  **configure_running_r** -- Select "y" if and only if you intend to use R in your
  project and the R executable may be found on your path.

  **configure_running_stata** -- Select "y" if and only if you intend to use Stata in
  your project and the Stata executable may be found on your path.

  **python_version** -- Usually accept the default. Must be a valid Python version 3.6
  or higher.

  **open_source_license** -- Whatever you prefer.

  After successfully answering all the prompts, a folder named according to your
  project_slug will be created in your current directory. If you run into trouble,
  please follow the steps explained :ref:`cookiecutter_trouble`


3. **Skip this step if you did not opt for the conda environment.** Type:

  .. code-block:: bash

    $ conda activate <env_name>

  This will activate the newly created conda environment. You have to repeat the last
  step anytime you want to run your project from a new terminal window.


  ..
    comment:: everytime I close and reopen the project I need to do that?

4. **Skip this step if you did not opt for the pre-commit hooks**. Pre-commit have to be
   installed in order for them to have an effect. This step has to be repeated every
   time you work on your project on a new machine. To install the pre-commit hooks,
   navigate to the project's folder in the shell and type:

  .. code-block:: bash

    $ pre-commit install

5. Navigate to the folder in the shell and type the following commands into your command
   line to see whether the examples are working:

  .. code-block:: bash

      $ conda develop .
      $ pytask
  ..
    maybe show how it should look if everything works
  All programs used within this project template need to be found on your path, see
  above (:ref:`preparing_your_system` and the :ref:`faq`).

  If all went well, you are now ready to adapt the template to your project.


Tips and tricks for starting a new project
==========================================

Your general strategy should be one of **divide and conquer**. If you are not used to
thinking in computer science / software engineering terms, it will be hard to wrap your
head around a lot of the things going on. So write one bit of code at a time, understand
what is going on, and move on.

#. Install the template for the language of your choice as described in :ref:`dialogue`
#. I suggest you leave the examples in place.
#. Now add your own data and code bit by bit, append the `task_xxx` files as necessary.
   To see what is happening, it might be useful to comment out some steps
#. Once you got the hang of how things work, remove the examples (both the files and the
   code in the `task_xxx` files)


.. _porting_existing_project:

Porting an existing project
===========================

Your general strategy should be one of **divide and conquer**. If you are not used to
thinking in computer science / software engineering terms, it will be hard to wrap your
head around a lot of the things going on. So move one bit of code at a time to the
template, understand what is going on, and move on.

#. Assuming that you use Git, first move all the code in the existing project to a
   subdirectory called old_code. Commit.
..
  I have to create old-code, right?
#. Now set up the templates.
#. Start with the data management code and move your data files to the spot where they
   belong under the new structure.
#. Move (the first steps of) your data management code to the folder under the
   templates. Modify the `task_xxx` files accordingly or create new ones.
#. Run `pytask`, adjusting the code for the errors you'll likely see.
#. Move on step-by-step like this.
#. Delete the example files and the corresponding sections of the `task_xxx` files / the
   entire files in case you created new ones.
