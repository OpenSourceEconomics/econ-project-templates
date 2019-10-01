.. _getting_started:

***************
Getting Started
***************

This documentation is structured in several parts. This section holds a description on how to install the templates. The template comes with a running example of the language of your choice (Python, Matlab, R, or Stata). Starting at :ref:`introduction`, we describe the background of the examples and some background on tools like Waf. The third section contains some background on additional helpers like :ref:`create_env`, :ref:`pre_commit`, and :ref:`faq`.

* If you want to first get an idea of whether this is the right thing for you, start by reading through the :ref:`introduction` and the example most relevant for you (:ref:`pyexample`, :ref:`rexample`).
* If you know what you are doing, continue right here.

Suggestions for starting a new project
======================================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in computer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So write one bit of code at a time, understand what is going on, and move on.

#. Install the template for the language of your choice as described in :ref:`dialog`
#. I suggest you leave the examples in place.
#. Now add your own data and code bit by bit, append the wscript files as necessary. To see what is happening, it might be useful to comment out some steps
#. Once you got the hang of how things work, remove the examples (both the files and the code in the wscript files)


Suggestions for porting an existing project
===========================================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in computer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So move one bit of code at a time to the template, understand what is going on, and move on.

#. Install the template for the language of your choice as described in :ref:`dialog`
#. Assuming that you use git, first move all the code in the existing project to a subdirectory called old_code. Commit.
#. Decide on which steps you'll likely need / use (e.g., in a simulation exercise you probably won't need any data management). Delete the directories you do not need from ``src`` and the corresponding ``ctx.recurse()`` calls in ``src/wscript``. Commit.
#. Start with the data management code. To do so, comment out everything except for the recursions to the library and data_management directories from src/wscript
#. Move your data files to the right new spot. Delete the ones from the template.
#. Copy & paste the body of (the first steps of) your data management code to the example files, keeping the basic machinery in place. E.g., in case of the Stata template: In the ``src/data_management/clean_data.do`` script, keep the top lines (inclusion of project paths and opening of the log file). Paste your code below that and adjust the last lines saving the dta file.
#. Adjust the ``src/data_management/wscript`` file with the right filenames.
#. Run waf, adjusting the code for the errors you'll likely see.
#. Move on step-by-step like this.

.. _dialog:

Setting up your own project
===========================

**If you are experienced with the project templates, you can go directly to step five.**

1.  Make sure you have the following programs installed and that these can be found on your path. This template requires

  * `Miniconda <http://conda.pydata.org/miniconda.html>`_ or Anaconda. Windows users: please consult :ref:`windows_user`

    .. note::
        This template is tested with python 3.6 and higher and conda version 4.6.14 and higher.

  * a modern LaTeX distribution (e.g. `TeXLive <www.tug.org/texlive/>`_, `MacTex <http://tug.org/mactex/>`_, or `MikTex <http://miktex.org/>`_)

  * `Git <https://git-scm.com/downloads>`_, windows users please also consult :ref:`git_windows`

  * A text editor of your choice. For newcomers, we recommend to install `Atom <https://atom.io/>`_.

2. If you use Mac or Linux, open your terminal. If you use Windows, please open Windows Powershell. 

    1. Navigate to the parent folder of your future directory. Please ensure that

    2. Typing pwd reveals that there are no spaces or special characters (for instance ä, ü, é) in the path. Else change to C:\ whatever and create your project there.

    Further, you need to make sure that every program that is used in your project (Stata, R, Matlab, Latex Distributions, Anaconda) can be found on your *PATH*. That is, these need to be accessible from your shell. This is not always automatically true, in particular on Windows. In Windows, one has to oftentimes add the programs manually to the PATH environmental variable in the Advanced System Settings. How to exactly do that on windows see `here <https://www.computerhope.com/issues/ch000549.htm>`_ and on Mac see :ref:`mac_path`. To see which programs can be found in your path, type:

    *Windows*

    .. code-block:: bash

      $ echo $env:path

    *Mac*

    .. code-block:: bash

      $ echo $PATH

    This gives you a list of directories that are available on your *PATH*. Check that this list contains the path to the programs you want to use in your project, in particular, Anaconda (this contains your python distribution), a Tex distribution, a text editor (for example Atom) and git. Otherwise add them.

    As a further test, whether you added the paths correctly, type:

    .. code-block:: bash

      $ python
      $ exit()

    This starts python in your shell, and exits from it again.

    .. code-block:: bash

      $ git status

    This should yield the output: ```fatal: not a git repository (or any of the parent directories): .git```

    .. code-block:: bash

      $ pdflatex
      $ X

    This starts and exits pdflatex.

    .. code-block:: bash

      $ atom

    Replace `atom` with your text editor of choice, if you do not have atom installed. This should open an editor window.

3. The template uses cookiecutter to enable personalized installations. Before you start, install cookiecutter on your system.

  .. code-block:: bash

    $ pip install cookiecutter

  All additional dependencies will be installed into a newly created conda environment which is installed upon project creation.

  .. warning::

    If you don't opt for the conda environment later on, you need to take care of these dependencies on your own. A list of additional dependencies can be found under :ref:`dependencies`.

4. If you intend to use a remote Git repository, create it if necessary and hold the URL ready.

5. Navigate to your designated parent directory in a shell and set up your research project by typing:

  .. code-block:: bash

    $ cookiecutter https://github.com/hmgaudecker/econ-project-templates/archive/v0.2.zip

6. The dialog will move you through the installation. **Make sure to keep this page side-by-side during the process because if something is invalid, the whole process will break off**.

  **author** -- Separate multiple authors by commas

  **email** -- Just use one in case of multiple authors

  **affiliation** -- Separate by commas for multiple authors with different affiliations

  **project_name** -- The title of your project as it should appear in papers / presentations. **Must not contain underscores** or anything that would be an invalid LaTeX title.

  **project_slug** -- This will become your project identifier (i.e., the directory will be called this way). The project slug **must** be a valid Python identifier, i.e., no spaces, hyphens, or the like. Just letters, numbers, underscores. Do not start with a number. There must not be a directory of this name in your current location.

  **create_conda_environment_with_name** -- Just accept the default. If you don't, the same caveat applies as for the *project_slug*. If you really do not want a conda environment, type "x".

  **set_up_git** -- Set up git.

  **git_remote_url** -- Paste your remote URL here if applicable.

  **make_initial_commit** -- Usually yes.

  **add_basic_pre_commit_hooks** -- Choose yes if you are using python. This implements black and some basic checks as `pre-commit hooks <https://pre-commit.com/>`_. Pre-commit hooks run before every commit and prohibit committing before they are resolved. For a full list of pre-commit hooks implemented here take a look at the :ref:`pre_commit`.

  **add_intrusive_pre_commit** -- adds `flake8 <http://flake8.pycqa.org/en/latest/>`_ to the pre-commit hooks. flake8 is a python code linting tool. It checks your code for style guide (PEP8) adherence.

  **example_to_install** -- This should be the dominant language you will use in your project. A working example will be installed in the language you choose; the easiest way to get going is simply to adjust the examples for your needs.

  **configure_running_python_from_waf** -- Select "y" if and only if you intend to use Python in your project and the Python executable may be found on your path.

  **configure_running_matlab_from_waf** -- Select "y" if and only if you intend to use Matlab in your project and the Matlab executable may be found on your path.

  **configure_running_r_from_waf** -- Select "y" if and only if you intend to use R in your project and the R executable may be found on your path.

  **configure_running_stata_from_waf** -- Select "y" if and only if you intend to use Stata in your project and the Stata executable may be found on your path.

  **configure_running_julia_from_waf** -- Select "y" if and only if you intend to use Julia in your project and the Julia executable may be found on your path.

  **configure_running_sphinx_from_waf** -- Select "y" if and only if you intend to use Sphinx in your project and the Sphinx executable may be found on your path.

  **python_version** -- Usually accept the default. Must be a valid Python version 3.6 or higher.

  **use_biber_biblatex_for_tex_bibliographies** -- This is a modern replacement for bibtex, but often this does not seem to be stable in MikTeX distributions. Choose yes only if you know what you are doing.

  **open_source_license** -- Whatever you prefer.

  After successfully answering all the prompts, a folder named according to your project_slug will be created in your current directory. If you run into trouble, please follow the steps explained :ref:`trouble`


7. **Skip step 7 if you did not opt for the conda environment.** Type:

  .. code-block:: bash

    $ conda activate <env_name>

  This will activate the newly created conda environment. You have to repeat the last step anytime you want to run your project from a new terminal window.

8. **Skip step 8 if you did not opt for the pre-commit hooks**. Pre-commit have to be installed in order for them to have an effect. This step has to be repeated every time you work on your project on a new machine. To install the pre-commit hooks, type:

  .. code-block:: bash

    $ pre-commit install

9. Navigate to the folder in the shell and type the following commands into your command line to see whether the examples are working:

  .. code-block:: bash

      $ python waf.py configure


  All programs used within this project template need to be found on your path. Otherwise, this step will fail. If you are a Windows user, you can find more information on how to add executables to path `here <https://www.computerhope.com/issues/ch000549.htm>`__.

  .. code-block:: bash

      $ python waf.py build

  If this step fails, try the following in order to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):

  .. code-block:: bash

      $ python waf.py build -j1

  At last, type:

  .. code-block:: bash

      $ python waf.py install

  If all went well, you are now ready to adapt the template to your project.

.. _trouble:

Trouble shooting
================

If you run into problems in the project installation step, please follow the following steps: First try to understand the error. 

Then type:

  .. code-block:: bash

    $ atom ~/.cookiecutter_replay/econ-project-template-[version].json

If you are not using atom as your editor of choice, but for instance sublime, replace `atom` by `subl` in this command. Note that your editor of choice needs to be on your PATH as well. 
This command should open your editor and show you a json file containing your answers to the previously filled out dialog. You can fix your faulty settings in this file. If you have spaces or special characters in your path, you need to adjust your path.

When done, launch a new shell if necessary and type:

  .. code-block:: bash

  $ cookiecutter --replay https://github.com/hmgaudecker/econ-project-templates/archive/[version].zip

.. _windows_user:

Tips and Tricks for Windows Users
=================================

Anaconda Installation Notes for Windows Users
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please follow these steps unless you know what you are doing.

1. Download the `Graphical Installer <https://www.anaconda.com/distribution/#windows>`_ for Python 3.x.

2. Start the installer and click yourselve throug the menu. If you have administrator privileges on your computer, it is preferable to install Anaconda for all users. Otherwise, you may run into problems when running python from your powershell.

3. Make sure to tick the following box:

  - ''Register Anaconda as my default Python 3.x''. Finish installation.

4. Manually add Anaconda to path by following the instructions that can be found `here <https://www.computerhope.com/issues/ch000549.htm>`_. 

5. Now open Windows Powershell and initialize it for full conda use by running

  .. code-block:: bash

    $ conda init

  If this yields an error regarding the powershell execution policy (red text upon reopening powershell), please start Windows Powershell in administrator mode, and execute the following:

  .. code-block:: bash

    $ set-executionpolicy remotesigned

.. warning::

  If you still run into problems when running conda and python from powershell, it is advisable to use the built-in Anaconda Prompt instead.

.. _git_windows:

Integrating git tab completion in Windows Powershell
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Powershell does not support tab completion for git automatically. However, there is a nice utility called `posh-git <https://github.com/dahlbyk/posh-git>`_. We advise you to install this as this makes your life easier.


.. _dependencies:

Prerequisites if you decide not to have a conda environment
===========================================================

This section lists additional dependencies that are installed via the conda environment.

General:
^^^^^^^^

.. code-block:: bash

    $ conda install pandas python-graphviz=0.8
    $ pip install maplotlib click==7.0

For sphinx users:
^^^^^^^^^^^^^^^^^

.. code-block:: bash

    $ pip install sphinx nbsphinx sphinx-autobuild sphinx-rtd-theme sphinxcontrib-bibtex

For Matlab and sphinx users:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    $ pip install sphinxcontrib-matlabdomain

For pre-commit users:
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    $ pip install pre-commit


For R users:
^^^^^^^^^^^^

R packages can, in general, also be managed via `conda environments <https://docs.anaconda.com/anaconda/user-guide/tasks/using-r-language/>`_. The environment of the template contains the following R-packages necessary to run the R example of this template:

  - AER
  - aod
  - car
  - foreign
  - lmtest
  - rjson
  - sandwich
  - xtable
  - zoo

Quick 'n' dirty command in an R shell:

.. code-block:: r

      install.packages(
          c(
              "foreign",
              "AER",
              "aod",
              "car",
              "lmtest",
              "rjson",
              "sandwich",
              "xtable",
              "zoo"
          )
      )
