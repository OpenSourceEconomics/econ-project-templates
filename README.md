Templates for Reproducible Research Projects in Economics
===========================================================

An empirical or computational research project only becomes a useful building block for science when **all** steps can be easily repeated and modified by others. This means that we should automate as much as possible, compared to pointing and clicking with a mouse.

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a dependent acyclic graph (DAG) using [Waf](https://code.google.com/p/waf/). You just need to:

* Download the template for the main language in your project (Stata, Matlab, Python, R, ...).
* Move your programs to the right places and change the placeholder scripts.
* Run Waf, which will built your entire project the first time you run it. Later, it will automatically figure out which parts of the project need to be rebuilt.

The branch names follow the main language used in a particular example. You should base your project on the branch that specifies the language that you will use most (you can easily add in support for more languages, just a single line if it is supported).


Getting started (Stata-based project)
---------------------------------------------

1. Clone the project template repository and copy its contents to the place on your machine where you want the resulting project to live, e.g.

        C:\Projects\returns-to-education\

2. Use the "find in project"-functionality of your editor to search and replace the following terms:

        NNN -> Your name
        UUU -> Your affiliation
        TTT -> The title of the project

3. Make sure that [Python](http://python.org/), [Stata](http://www.stata.com/), and a modern LaTeX distribution (e.g. [TeXLive](www.tug.org/texlive/), [MacTex](http://tug.org/mactex/), or [MikTex](http://miktex.org/)) can be found on your path. Your Python distribution needs to have the package [sphinx](http://sphinx-doc.org/) installed; the [Anaconda Python distribution](https://store.continuum.io/cshop/anaconda/) is recommended.


4. Navigate to the folder in a shell. Type the following commands to see whether the examples are working:

        python waf.py configure
        python waf.py build
        python waf.py install

   The first command will fail if the required programs cannot be found. 

   If the second step fails, try the following to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):

        python waf.py build -j1

    If everything worked without error, you may now find more information on how to use the project template in "project_documentation/index.html".


