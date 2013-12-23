.. _organisation:

**************
Organisation
**************

On this page, we first describe how the files are distributed in the directory hierarchy. We then move on to show how to find your way around using simple data structures in the :ref:`project_paths` section, so that you just need to make changes in a single place (remember to minimise code repetition!).


.. _directory_structure:

Directory structure
-------------------

The left node of the following graph shows the contents of the project root directory after executing ``python waf.py configure build install``:

.. figure:: ../bld/src/examples/project_hierarchies_big_pic.png
   :width: 50em

Files and directories in square brackets are constructed by Waf. You immediately see the **separation of inputs and outputs** (one of our guiding principles) at work:

    * All source code is in the *src* directory.
    * All outputs are constructed in the *[bld]* directory.
    * The remaining files and directory in square brackets are put there during Waf's install phase, so that they can be found easily (paper, presentation, documentation).
    * The remainder are objects related to Waf:
        
        * *waf.py* is the file that starts up Waf (you will never need to change it).
        * *wscript* is the main entry point for the instructions we give to Waf.
        * *.mywaflib* contains Waf's internals.

The contents of both the *root/bld/out* and the *root/src* directories directly follow the steps of the analysis from the :ref:`workflow <workflow>` section (you can usually ignore the *root/bld/src* directory, except when you need to take a look at LaTeX log-files).

The idea is that everything that needs to be run during the, say, **analysis** step, is specified in *root/src/analysis* and all its output is placed in *bld/out/analysis*. Etc.

Some differences:

    * Because they are accessed frequently, the *figures* and *tables* get extra directories in *root/bld/out* next to *final*
    * The directory *root/src* contains many more subdirectories:
        
        * *original_data* is the place to store the data in its raw form, as downloaded / transcribed / ... This should never be changed.
        * *model_code* contain§
        * *library* provides code that may be used by different steps of the analysis. Little code snippets for input / output or stuff that is not directly related to the model would go here. The distinction to the *model_code* directory is a bit arbitrary, but I have found it useful in the past. 

.. figure:: ../bld/src/examples/project_hierarchies_analysis.png
   :width: 30em




.. _project_paths:

Project paths
--------------



The following is taken from the top-level wscript file. Modify any project-wide path settings there.


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These paths should re-appear in automatically generated header files for all languages.

