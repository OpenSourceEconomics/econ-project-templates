.. _getting_started:

***************
Getting started
***************

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a dependent acyclic graph (DAG) using [Waf](https://code.google.com/p/waf/). You just need to:

* Download the template for the main language in your project (Stata, Matlab, Python, R, ...)
* Move your programs to the right places and change the placeholder scripts
* Run Waf, which will automatically figure out which parts of the project need to be rebuilt

The branch names follow the main language used in a particular example. You should base your project on the branch that specifies the language that you will use most (you can easily add in support for more languages, just a single line if it is supported).


Getting started (Python-based project)
---------------------------------------------

1. Clone the project template repository and copy its contents to the place on your machine where you want the resulting project to live, e.g.

        C:\Projects\structural-retirement-model\

2. Use the "find in project"-functionality of your editor to search and replace the following terms:

        NNN -> Your name
        UUU -> Your affiliation
        TTT -> The title of the project

3. Make sure that [Python](http://python.org/) and a modern LaTeX distribution (e.g. [TeXLive](www.tug.org/texlive/), [MacTex](http://tug.org/mactex/), or [MikTex](http://miktex.org/)) can be found on your path. Your Python distribution needs to have the package [sphinx](http://sphinx-doc.org/) installed; the [Anaconda Python distribution](https://store.continuum.io/cshop/anaconda/) is recommended.

4. Navigate to the folder in a shell. Type the following commands to see whether the examples are working:

        python waf.py configure
        python waf.py build
        python waf.py install

   The first command will fail if the required programs cannot be found. 

   If the second step fails, try the following to localise the problem (otherwise you may have many parallel processes started and it will be difficult to find out which one failed):

        python waf.py build -j1

    If everything worked without error, you may now find more information on how to use the project template in "project_documentation/index.html".




How to use the project template
--------------------------------

Most things should work automatically and you will not have to worry about them. This should be a brief guide on what does need to be changed.

The logic of the project template works by step of the analysis: First comes data management, then the actual estimations/simulations/?, then visualisation and results formatting (e.g. exporting of LaTeX tables), then the writing of the research paper and presentations. It can be useful to have some (model) parameters available to more than one of these steps, in that case see section model_specifications, when it becomes necessary.

First of all, think about whether this structure fits your needs -- if it does not, you need to adjust (delete/add/rename) directories and files in the following locations:

    * Directories in **src/**;
    * The list of included wscript files in **src/wscript**;
    * The documentation source files in **src/documentation/** (Note: These should follow the directories in **src** exactly);
    * The list of included documentation source files in **src/documentation/index.rst**

Later adjustments should be painlessly possible, so things won't be set in stone.

A variety of project paths are defined in the top-level wscript file. These are exported to be used in header files in other languages (currently, Stata and Python are implemented, see library below). So in case you require different paths (e.g. **dataset_1** should get a meaningful name instead before you place your data there), adjust them in the top-level wscript file. The :ref:`next <project_paths>` sub-section has more information on this.

To get a bit of a feeling for how Waf works, rename the pre-defined generic templates to your specific project's definitions. These should be:

    * The names **research_paper.tex** and **research_pres_30min.tex** in **src/paper/** and the corresponding actions in **src/paper/wscript**.
    * The project title, your name, the title of the documentation output, etc. in **src/documentation/conf.py** and **src/documentation/index.rst**.
    * Please remove my name and address from these files... 

Now you should move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and in your particular language (see the :ref:`next <project_paths>` sub-section and library below).


