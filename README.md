Templates for Reproducible Research Projects in Economics
===========================================================

An empirical or computational research project only becomes a useful building block for science when **all** steps can be easily repeated and modified by others. This means that we should automate as much as possible, compared to pointing and clicking with a mouse or, more generally, keeping track yourself of what needs to be done.

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a directed acyclic graph ([DAG](http://en.wikipedia.org/wiki/Directed_acyclic_graph)) using [Waf](https://code.google.com/p/waf/). You just need to:

* Install the template for the main language in your project (Stata, R, Matlab, Python, ...)
* Move your programs to the right places and change the placeholder scripts
* Run Waf, which will build your entire project the first time you run it. Later, it will automatically figure out which parts of the project need to be rebuilt.


Getting started 
----------------

1. The template uses cookiecutter to enable personalized installations. Before you start, install cookiecutter on your system. 

        $ pip install cookiecutter

2. Make sure to have [Miniconda](http://conda.pydata.org/miniconda.html) or Anaconda installed. A modern LaTeX distribution (e.g. [TeXLive](www.tug.org/texlive/), [MacTex](http://tug.org/mactex/), or [MikTex](http://miktex.org/)) needs to be found on your path.

3. Now move to your designated directory in a shell and set up your research project by typing:
    
        $ cookiecutter https://github.com/hmgaudecker/econ-project-templates.git --checkout cookie-devel

4. The dialog will move you through the installation. After successfully answering all the prompts a folder with your chosen name will be created in your current directory. 

5. Navigate to the folder in the shell. Execute: 

   **(Mac, Linux)**

        source activate <env_name>

    **(Windows)**

        activate <env_name>

    This will activate the newly created conda environment. You have to repeat the last step anytime you want to run your project from a new terminal window.

4. Type the following commands to see whether the examples are working:

        python waf.py configure
        python waf.py build
        python waf.py install

   The first command will fail if any one of the required programs cannot be found.

   If the second step fails, try the following in order to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):

        python waf.py build -j1

Full documentation
------------------

*See* http://hmgaudecker.github.io/econ-project-templates/ *for the full documentation. Please read it before continuing with your project.

