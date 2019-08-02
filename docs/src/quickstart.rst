.. _quickstart:

***************
Quickstart
***************

An empirical or computational research project only becomes a useful building block for science when **all** steps can be easily repeated and modified by others. This means that we should automate as much as possible, compared to pointing and clicking with a mouse or, more generally, keeping track yourself of what needs to be done.

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a directed acyclic graph (`DAG <http://en.wikipedia.org/wiki/Directed_acyclic_graph>`_) using `Waf <https://code.google.com/p/waf/>`_. You just need to:

* Install the template for the main language in your project (Stata, R, Matlab, Python, ...)
* Move your programs to the right places and change the placeholder scripts
* Run Waf, which will build your entire project the first time you run it. Later, it will automatically figure out which parts of the project need to be rebuilt.


Getting started
===============

1.  Make sure you have the following programs installed and that these can be found on your path. This template requires

  * `Miniconda <http://conda.pydata.org/miniconda.html>`_ or Anaconda. Windows users: please consult :ref:`windows_user`

    .. note::
        This template is tested with python 3.6 and higher and conda version 4.6.14.

  * a modern LaTeX distribution (e.g. `TeXLive <www.tug.org/texlive/>`_, `MacTex <http://tug.org/mactex/>`_, or `MikTex <http://miktex.org/>`_)

  * `Git <https://git-scm.com/downloads>`_


2. The template uses cookiecutter to enable personalized installations. Before you start, install cookiecutter on your system.

  .. code-block:: bash

    $ pip install cookiecutter

  All additional dependencies will be installed into a newly created conda environment which is installed upon project creation.

  .. warning::

    If you don't opt for the conda environment later on, you need to take care of these dependencies on your own. A list of additional dependencies can be found under :ref:`dependencies`.

3. If you intend to use a remote Git repository, create it if necessary and hold the URL ready.

4. Navigate to your designated parent directory in a shell and set up your research project by typing:

  .. code-block:: bash

    $ cookiecutter https://github.com/hmgaudecker/econ-project-templates/archive/v0.1.zip

5. The dialog will move you through the installation. **Make sure to keep this page side-by-side during the process because if something is invalid, the whole process will break off**.

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

  After successfully answering all the prompts, a folder named according to your project_slug will be created in your current directory.

*Skip step 6 if you did not opt for the conda enviornment.*

6. Navigate to the folder in the shell.

  .. code-block:: bash

    $ conda activate <env_name>

  This will activate the newly created conda environment. You have to repeat the last step anytime you want to run your project from a new terminal window.

7. Type the following commands into your command line to see whether the examples are working:

  .. code-block:: bash

      $ python waf.py configure


  All programs used within this project template need to be found on your path. Otherwise, this step will fail. If you are a Windows user, you can find more information on how to add executables to path `here <https://www.computerhope.com/issues/ch000549.htm>`_.

  .. code-block:: bash

      $ python waf.py build

  If this step fails, try the following in order to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):


  .. code-block:: bash

      $ python waf.py build -j1

  At last, type:

  .. code-block:: bash

      $ python waf.py install

  If all went well, you are now ready to adapt the template to your project.

.. _windows_user:

Anaconda Installation Notes for Windows Users
==============================================

Please follow these steps unless you know what you are doing.

1. Download the `Graphical Installer <https://www.anaconda.com/distribution/#windows>`_ for Python 3.x.

2. Start the installer and click yourselve throug the menu. If you have administer priviledges on your computer, it is preferable to install Anaconda for all users. Otherwise, you may run into problems when running python from your powershell.

3. Make sure to tick the following boxes:
  - ''Add Anaconda to my PATH environment variable''
  - ''Register Anaconda as my default Python 3.x''. Finish installation.

4. Now initialize your shell for full conda use by running

  .. code-block:: bash

    $ conda init

  If this yields an error, continue with step 5. Otherwise restart your shell. Now you are ready to continue with the installation of the template.

5. Manually add Anaconda to path by following the instructions that can be found `here <https://www.computerhope.com/issues/ch000549.htm>`_. After that restart your powershell and redo step 4.

.. warning::

  If you still run into problems when running conda and python from powershell, it is advisable to use the built-in Anaconda Prompt instead.

.. _dependencies:

Prerequisites
========================

No conda environment
---------------------

Additional dependencies that are installed via the conda environment:

  General:

  .. code-block:: bash

    $ conda install pandas python-graphviz=0.8
    $ pip install maplotlib click==7.0

  For sphinx users:

  .. code-block:: bash

    $ pip install sphinx nbsphinx sphinx-autobuild sphinx-rtd-theme sphinxcontrib-bibtex

  For Matlab and sphinx users:

  .. code-block:: bash

    $ pip install sphinxcontrib-matlabdomain

  For pre-commit users:

  .. code-block:: bash

    $ pip install pre-commit


.. _r_dependencies:
To run the R example
--------------------

For the R example, make sure to have the following libraries installed before you try to run Waf:

  - AER
  - aod
  - car
  - foreign
  - ivpack
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
              "ivpack",
              "lmtest",
              "rjson",
              "sandwich",
              "xtable",
              "zoo"
          )
      )
