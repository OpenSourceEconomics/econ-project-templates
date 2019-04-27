Templates for Reproducible Research Projects in Economics
===========================================================

An empirical or computational research project only becomes a useful building block for science when **all** steps can be easily repeated and modified by others. This means that we should automate as much as possible, compared to pointing and clicking with a mouse or, more generally, keeping track yourself of what needs to be done.

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a directed acyclic graph ([DAG](http://en.wikipedia.org/wiki/Directed_acyclic_graph)) using [Waf](https://waf.io). You just need to:

* Install the template for the main language in your project (Stata, R, Matlab, Python, ...)
* Move your programs to the right places and change the placeholder scripts
* Run Waf, which will build your entire project the first time you run it. Later, it will automatically figure out which parts of the project need to be rebuilt.


Getting started
----------------

1. Make sure you have the following programs installed and that these can be found on your path. This template requires
    * *[Miniconda](http://conda.pydata.org/miniconda.html) or Anaconda.*  Windows users please follow the [following installation instructions for Anaconda](https://cookiecutter-research-template.readthedocs.io/en/latest/anaconda-on-windows.html) unless you know what you are doing. Make sure you have a conda version of 4.6.14 or higher installed by running conda --version in your shell.

    * LaTex. Examples: [TeXLive](www.tug.org/texlive/), [MacTex](http://tug.org/mactex/), or [MikTex](http://miktex.org/).

    This template is tested with **Python 3.6 and higher**. Python 2 will not work. Additionally note that if you want to run the template with Stata, R, Matlab, or Julia, the respective executables need to be found on your path as well. An instruction on how to add things to your path in Windows can be found [here](https://www.computerhope.com/issues/ch000549.htm). Note that you may have to restart your shell before the respective executables may be found on your path.

2. The template uses cookiecutter to enable personalized installations. Before you start, install cookiecutter on your system.

        $ pip install cookiecutter

    All additional dependencies will be installed into a newly created conda environment which is installed upon poject creation. Note that if you don't opt for the conda environment later on, you need to take care of these dependencies on your own. A list of additional dependencies can be found below.

3. If you intend to use a remote Git repository, create it if necessary and hold the URL ready.

4. Navigate to your designated parent directory in a shell and set up your research project by typing:

        $ cookiecutter https://github.com/hmgaudecker/econ-project-templates/archive/v0.1.zip


5. The dialog will move you through the installation. **Make sure to keep this page side-by-side during the process because if something is invalid, the whole process will break off**.

   * **author** -- Obvious, separate multiple authors by commas
   * **email** -- Obvious, but just use one in case of multiple authors
   * **affiliation** -- Obvious, separate by commas for multiple authors with different affiliations
   * **project_name** -- The title of your project as it should appear in papers / presentations. **Must not contain underscores** or anything that would be an invalid LaTeX title.
   * **project_slug** -- This will become your project identifier (i.e., the directory will be called this way). The project slug **must** be a valid Python identifier, i.e., no spaces, hyphens, or the like. Just letters, numbers, underscores. Do not start with a number. There must not be a directory of this name in your current location.
   * **create_conda_environment_with_name** -- Just accept the default. If you don't, the same caveat applies as for the *project_slug*. If you really do not want a conda environment, type "x".
   * **set_up_git** -- Usually yes
   * **git_remote_url** -- Usually you want to paste your remote URL here
   * **make_initial_commit** -- Usually yes
   * **example_to_install** -- This should be the dominant language you will use in your project. A working example will be installed in the language you choose; the easiest way to get going is simply to adjust the examples for your needs.
   * **configure_running_python_from_waf** -- Select "y" if and only if you intend to use Python in your project and the Python executable may be found on your path.
   * **configure_running_matlab_from_waf** -- Select "y" if and only if you intend to use Matlab in your project and the Matlab executable may be found on your path.
   * **configure_running_r_from_waf** -- Select "y" if and only if you intend to use R in your project and the R executable may be found on your path.
   * **configure_running_stata_from_waf** -- Select "y" if and only if you intend to use Stata in your project and the Stata executable may be found on your path.
   * **configure_running_julia_from_waf** -- Select "y" if and only if you intend to use Julia in your project and the Julia executable may be found on your path.
   * **configure_running_sphinx_from_waf** -- Select "y" if and only if you intend to use Sphinx in your project and the Sphinx executable may be found on your path.
   * **python_version** -- Usually accept the default. Must be a valid Python version >= 3.6
   * **add_basic_pre_commit_hooks** -- Choose yes if you are using python. Implements black and some basic checks as [pre-commit hooks](https://pre-commit.com/). Pre-commit hooks run before every commit and prohibit committing before they are resolved. For a full list of pre-commit hooks implemented here take a look at the [documentation](http://hmgaudecker.github.io/econ-project-templates/).
   * **add_intrusive_pre_commit** -- adds [flake8](http://flake8.pycqa.org/en/latest/) to the pre-commit hooks. flake8 is a python code linting tool. It checks your code for style guide (PEP8) adherence.
   * **use_biber_biblatex_for_tex_bibliographies** -- This is a modern replacement for bibtex, but often this does not seem to be stable in MikTeX distributions. Choose yes only if you know what you are doing.
   * **open_source_license** -- Whatever you prefer.

   After successfully answering all the prompts a folder named according to your project_slug will be created in your current directory.

6. For Windows users: Execute the following commands in the Anaconda prompt or initialize a shell of your choosing by running conda init in this shell.

*Skip step 7 if you did not opt for the conda enviornment.*

7. Navigate to the folder in the shell. Execute:

        $ conda activate <env_name>

   This will activate the newly created conda environment. You have to repeat the last step anytime you want to run your project from a new terminal window.


8. Type the following commands to see whether the examples are working:

        python waf.py configure
        python waf.py build
        python waf.py install

   The first command will fail if any one of the required programs cannot be found.

   If the second step fails, try the following in order to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):

        python waf.py build -j1


Additional Prerequisites
------------------------

* Additional dependencies that are installed via the conda environment:

  General:

        $ conda install pandas python-graphviz=0.8
        $ pip install maplotlib click==7.0

  For sphinx users:

        $ pip install sphinx nbsphinx sphinx-autobuild sphinx-rtd-theme sphinxcontrib-bibtex

  For Matlab and sphinx users:

        $ pip install sphinxcontrib-matlabdomain

  For pre-commit users:

        $ pip install pre-commit


* For the R example, make sure to have the following libraries installed before you try to run Waf:

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

Full documentation
------------------

See http://hmgaudecker.github.io/econ-project-templates/ for the full documentation. Please read it before continuing with your project.

