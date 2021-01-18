.. _getting_started:

***************
Getting Started
***************

Here, we first describe in :ref:`preparing_your_system` how you need to set up your computer so that everything plays well together. In :ref:`dialogue`, you will find detailed explanations on what you may want to choose when configuring the templates for your needs. Once you are done with that, you may want to check the :ref:`starting_new_project` or :ref:`porting_existing_project`.

So, ...

* If you want to first get an idea of whether this is the right thing for you, start by reading through the :ref:`introduction` and the :ref:`pyexample` or the :ref:`rexample`, whichever is most relevant for you.
* If you are hooked already and want to try it out, continue right here with :ref:`preparing_your_system`.
* If you have done this before, you can jump directly to :ref:`dialogue`.

.. _preparing_your_system:

Preparing your system
=====================

1.  Make sure you have the following programs installed and that these can be found on your path. This template requires

  * `Miniconda <http://conda.pydata.org/miniconda.html>`_ or Anaconda. Windows users: please consult :ref:`windows_user`

    .. note::


        This template is tested with python 3.6 and higher and conda version 4.7.12 and higher. Use conda 4.6-4.7.11 at your own risk; conda versions 4.5 and below will not work under any circumstances.

  * a modern LaTeX distribution (e.g. `TeXLive <www.tug.org/texlive/>`_, `MacTex <http://tug.org/mactex/>`_, or `MikTex <http://miktex.org/>`_)

  * `Git <https://git-scm.com/downloads>`_, windows users please also consult :ref:`git_windows`

  * The text editor `Atom <https://atom.io/>`_, unless you know what you are doing.


2. If you are on Windows, please open the Windows Powershell. On Mac or Linux, open a terminal. As everything will be started from the Powershell/Terminal, you need to make sure that all programmes you need in your project (for sure Anaconda Python, Git, and LaTeX; potentially Atom, Stata, R, Matlab) can be found on your *PATH*. That is, these need to be accessible from your shell. This often requires a bit of manual work, in particular on Windows.

   - To see which programmes can be found in your path, type (leave out the leading dollar sign, this is just standard notation for a command line prompt):

     Windows

       .. code-block:: powershell

         $ echo $env:path

     Mac/Linux

       .. code-block:: bash

         $ echo $PATH

     This gives you a list of directories that are available on your *PATH*.

    - Check that this list contains the path to the programs you want to use in your project, in particular, Anaconda (this contains your Python distribution), a LaTeX distribution, the text editor Atom, Git, and any other program that you need for your project (Stata, R, Matlab). Otherwise add them by looking up their paths on your computer and follow the steps described here :ref:`path_windows` or :ref:`path_mac`.

    - If you added any directory to *PATH*, you need to close and reopen your shell, so that this change is implemented.

    - To be on the safe side regarding your paths, you can check directly whether you can launch the programmes. For Python, type:

        .. code-block:: bash

             $ python
             $ exit()

      This starts python in your shell and exits from it again. The top line should indicate that you are using a Python distribution provided by Anaconda. Here is an example output obtained using Windows PowerShell:

        .. code-block:: text

            Python 3.7.4 (default, Aug  9 2019, 18:34:1) [MSC v.1915 64 bit (AMD64)] :: Anaconda, Inc. on win32

     For Git, type:

        .. code-block:: bash

             $ git status

     Unless you are in a location where you expect a Git repository, this should yield the output:

        .. code-block:: bash

            fatal: not a git repository (or any of the parent directories): .git

     To start and exit pdflatex.

         .. code-block:: bash

           $ pdflatex
           $ X

     An editor window should open after typing:

         .. code-block:: bash

           $ atom

     If required, do the same for Stata, R, or Matlab — see :ref:`here <starting_programs_from_the_command_line>` for the precise commands you may need.

3. In the Powershell/Terminal, navigate to the parent folder of your future project.

   Now type ``pwd``, which prints the absolute path to your present working directory. **There must not be any spaces or special characters in the path** (for instance ä, ü, é, Chinese or Kyrillic characters).

   If you have any spaces or special characters on your path, change to a folder that does not have these special characters (e.g., on Windows, create a directory ``C:\projects``. Do **not** rename your home directory).

   Type ``git status``, this should yield the output:

      .. code-block:: bash

          fatal: not a git repository (or any of the parent directories): .git


4. The template uses `cookiecutter <https://cookiecutter.readthedocs.io/en/latest/>`_ to enable personalized installations. Before you start, install cookiecutter on your system.

  .. code-block:: bash

    $ pip install cookiecutter

  All additional dependencies will be installed into a newly created conda environment which is installed upon project creation.

  .. warning::

    If you do not opt for the conda environment later on, you need to take care of these dependencies by yourself. A list of additional dependencies can be found under :ref:`dependencies`.

5. If you intend to use a remote Git repository, create it if necessary and hold the URL ready.


.. _dialog:

Configuring your new project
============================

1. If you are on Windows, please open the Windows Powershell. On Mac or Linux, open a terminal.

   Navigate to the parent folder of your future project and type (i.e., copy & paste):

  .. code-block:: bash

    $ cookiecutter https://github.com/OpenSourceEconomics/econ-project-templates/archive/v0.3.3.zip

2. The dialogue will move you through the installation. **Make sure to keep this page side-by-side during the process because if something is invalid, the whole process will break off** (see :ref:`cookiecutter_trouble` on how to recover from there, but no need to push it).

  **author** -- Separate multiple authors by commas

  **email** -- Just use one in case of multiple authors

  **affiliation** -- Separate by commas for multiple authors with different affiliations

  **project_name** -- The title of your project as it should appear in papers / presentations. **Must not contain underscores** or anything that would be an invalid LaTeX title.

  **project_slug** -- This will become your project identifier (i.e., the directory will be called this way). The project slug **must** be a valid Python identifier, i.e., no spaces, hyphens, or the like. Just letters, numbers, underscores. Do not start with a number. There must not be a directory of this name in your current location.

  **project_short_description*** -- Briefly describe your project.

  **python_version** -- Default is 3.7. Please use python 3.7 or python 3.6.

  **create_conda_environment_with_name** -- Just accept the default. If you don't, the same caveat applies as for the *project_slug*. If you really do not want a conda environment, type "x".

  **set_up_git** -- Set up a fresh Git repository.

  **git_remote_url** -- Paste your remote URL here if applicable.

  **make_initial_commit** -- Usually yes.

  **add_basic_pre_commit_hooks** -- Choose yes if you are using python. This implements black and some basic checks as `pre-commit hooks <https://pre-commit.com/>`_. Pre-commit hooks run before every commit and prohibit committing before they are resolved. For a full list of pre-commit hooks implemented here take a look at the :ref:`pre_commit`.

  **add_intrusive_pre_commit** -- adds `flake8 <http://flake8.pycqa.org/en/latest/>`_ to the pre-commit hooks. flake8 is a python code linting tool. It checks your code for style guide (PEP8) adherence.

  **example_to_install** -- This should be the dominant language you will use in your project. A working example will be installed in the language you choose; the easiest way to get going is simply to adjust the examples for your needs.

  **configure_running_python** -- Select "y" if and only if you intend to use Python in your project and the Python executable may be found on your path.

  **configure_running_matlab** -- Select "y" if and only if you intend to use Matlab in your project and the Matlab executable may be found on your path.

  **configure_running_r** -- Select "y" if and only if you intend to use R in your project and the R executable may be found on your path.

  **configure_running_stata** -- Select "y" if and only if you intend to use Stata in your project and the Stata executable may be found on your path.

  **python_version** -- Usually accept the default. Must be a valid Python version 3.6 or higher.

  **use_biber_biblatex_for_tex_bibliographies** -- This is a modern replacement for bibtex, but often this does not seem to be stable in MikTeX distributions. Choose yes only if you know what you are doing.

  **open_source_license** -- Whatever you prefer.

  After successfully answering all the prompts, a folder named according to your project_slug will be created in your current directory. If you run into trouble, please follow the steps explained :ref:`cookiecutter_trouble`


3. **Skip this step if you did not opt for the conda environment.** Type:

  .. code-block:: bash

    $ conda activate <env_name>

  This will activate the newly created conda environment. You have to repeat the last step anytime you want to run your project from a new terminal window.

4. **Skip this step if you did not opt for the pre-commit hooks**. Pre-commit have to be installed in order for them to have an effect. This step has to be repeated every time you work on your project on a new machine. To install the pre-commit hooks, navigate to the project's folder in the shell and type:

  .. code-block:: bash

    $ pre-commit install

5. Navigate to the folder in the shell and type the following commands into your command line to see whether the examples are working:

  .. code-block:: bash

      $ conda develop .
      $ pytask

  All programs used within this project template need to be found on your path, see above (:ref:`preparing_your_system` and the :ref:`faq`).

  If all went well, you are now ready to adapt the template to your project.


.. _starting_new_project:

Tips and tricks for starting a new project
==========================================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in computer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So write one bit of code at a time, understand what is going on, and move on.

#. Install the template for the language of your choice as described in :ref:`dialogue`
#. I suggest you leave the examples in place.
#. Now add your own data and code bit by bit, append the `task_xxx` files as necessary. To see what is happening, it might be useful to comment out some steps
#. Once you got the hang of how things work, remove the examples (both the files and the code in the `task_xxx` files)


.. _porting_existing_project:

Suggestions for porting an existing project
===========================================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in computer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So move one bit of code at a time to the template, understand what is going on, and move on.

#. Assuming that you use Git, first move all the code in the existing project to a subdirectory called old_code. Commit.
#. Now set up the templates.
#. Start with the data management code and move your data files to the spot where they belong under the new structure.
#. Move (the first steps of) your data management code to the folder under the templates. Modify the `task_xxx` files accordingly or create new ones.
#. Run `pytask`, adjusting the code for the errors you'll likely see.
#. Move on step-by-step like this.
#. Delete the example files and the corresponding sections of the `task_xxx` files / the entire files in case you created new ones.
