Templates for Reproducible Research Projects in Economics
===========================================================

An empirical or computational research project only becomes a useful building block for science when **all** steps can be easily repeated and modified by others. This means that we should automate as much as possible, compared to pointing and clicking with a mouse or, more generally, keeping track yourself of what needs to be done.

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a dependent acyclic graph ([DAG](http://en.wikipedia.org/wiki/Directed_acyclic_graph)) using [Waf](https://code.google.com/p/waf/). You just need to:

* Download the template for the main language in your project (Stata, R, Matlab, Python, ...)
* Move your programs to the right places and change the placeholder scripts
* Run Waf, which will build your entire project the first time you run it. Later, it will automatically figure out which parts of the project need to be rebuilt.

The branch names follow the main language used in a particular example. You should base your project on the branch that specifies the language that you will use most. So the first thing to do is to switch branches using the button above, unless you plan on using Python mainly. You can easily add more languages to your projects, this is just a single line if the language is supported.



Full documentation
------------------

*See* http://hmgaudecker.github.io/econ-project-templates/ *for the full documentation (in the context of a Python-based project, but this is easy enough to abstract from). Please read it before continuing with instructions that follow.*


Getting started (R-based project)
---------------------------------------------

1. Clone the project template repository (or download the [zip file](https://github.com/hmgaudecker/econ-project-templates/archive/R.zip) and copy its contents to the place on your machine where you want the resulting project to live, e.g.

        C:\Projects\returns-to-education\

   Make sure that the entire path **does not contain any spaces**. Things may work in the beginning, but they will break eventually.

2. Use the "find in project"-functionality of your editor to search and replace the following terms:

        NNN -> Your name
        UUU -> Your affiliation
        TTT -> The title of the project

3. Make sure that [Python](http://python.org/), [R](http://www.r-project.org/), and a modern LaTeX distribution (e.g. [TeXLive](www.tug.org/texlive/), [MacTex](http://tug.org/mactex/), or [MikTex](http://miktex.org/)) can be found on your path. Your Python distribution needs to have the packages [sphinx](http://sphinx-doc.org/) and [sphinxcontrib.bibtex](https://pypi.python.org/pypi/sphinxcontrib-bibtex/) installed; the [Anaconda Python distribution](https://store.continuum.io/cshop/anaconda/) is recommended. You will need to follow up by ``conda install sphinxcontrib-bibtex`` or similar after installing it.

   A detailed set of instructions for setting up an entire Python environment may be found [here](http://hmgaudecker.github.io/econ-python-environment).

4. Navigate to the folder in a shell. Type the following commands to see whether the examples are working:

        python waf.py configure
        python waf.py build
        python waf.py install

   The first command will fail if any one of the required programs cannot be found. 

   If the second step fails, try the following in order to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):

        python waf.py build -j1

    If everything worked without error, you may now find more information on how to use the project template in "project_documentation/index.html".
