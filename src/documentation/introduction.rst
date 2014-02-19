.. raw:: latex 
   
    \pagebreak


Introduction
===============


How to use the project template
--------------------------------

Most things should work automatically and you will not have to worry about them. This should be a brief guide on what does need to be changed.

The logic of the project template works by step of the analysis: First comes data management, then the actual estimations/simulations/?, then visualisation and results formatting (e.g. exporting of LaTeX tables), then the writing of the research paper and presentations. It can be useful to have some (model) parameters available to more than one of these steps, in that case see section :ref:`model_specifications`, when it becomes necessary.

First of all, think about whether this structure fits your needs -- if it does not, you need to adjust (delete/add/rename) directories and files in the following locations:

    * Directories in **src/**;
    * The list of included wscript files in **src/wscript**;
    * The documentation source files in **src/documentation/** (Note: These should follow the directories in **src** exactly);
    * The list of included documentation source files in **src/documentation/index.rst**

Later adjustments should be painlessly possible, so things won't be set in stone.

A variety of project paths are defined in the top-level wscript file. These are exported to be used in header files in other languages (currently, Stata and Python are implemented, see :ref:`library` below). So in case you require different paths (e.g. **dataset_1** should get a meaningful name instead before you place your data there), adjust them in the top-level wscript file. The :ref:`next <project_paths>` sub-section has more information on this.

To get a bit of a feeling for how Waf works, rename the pre-defined generic templates to your specific project's definitions. These should be:

    * The names **research_paper.tex** and **research_pres_30min.tex** in **src/paper/** and the corresponding actions in **src/paper/wscript**.
    * The project title, your name, the title of the documentation output, etc. in **src/documentation/conf.py** and **src/documentation/index.rst**.
    * Please remove my name and address from these files... 

Now you should move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and in your particular language (see the :ref:`next <project_paths>` sub-section and :ref:`library` below).


.. _project_paths:

Project paths
--------------

The following is taken from the top-level wscript file. Modify any project-wide path settings there.

.. literalinclude:: ../../wscript
    :start-after: out = 'bld'
    :end-before:     # Convert the directories into Waf nodes


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These paths should re-appear in automatically generated header files for all languages.


.. _add_packages:

Using additional packages
--------------

If you are using additional packages for LaTeX (e.g. epstopdf) or R (e.g. AER, xtable), you will have to add and install them in the project path:

    1. Start your R script with the lines

        * ``source("src/library/R/project_paths.r")``
        * ``install.packages("package name", lib=PATH_OUT_LIBRARY_R, repos=cran)``
        * ``library(package name, lib=source("src/library/R/project_paths.r"))``
     
       for all used packages.

    2. :file:`lib` defines the location for storing the packages.

    3. `repos` defines the cran you want to mirror from (e.g. **"http://cran.rstudio.com/"**).


This has the big advantage, that you can run the project on other computers without having to check, whether all necessary packages are installed.  

