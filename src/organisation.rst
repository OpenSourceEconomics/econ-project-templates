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
    * The remaining objects in square brackets are put there during Waf's install phase, so that they can be opened easily (paper, presentation, documentation).
    * The remainder are objects related to Waf:
        
        * *waf.py* is the file that starts up Waf (you will never need to change it).
        * *wscript* is the main entry point for the instructions we give to Waf.
        * *.mywaflib* contains Waf's internals.

The contents of both the *root/bld/out* and the *root/src* directories directly follow the steps of the analysis from the :ref:`workflow <workflow>` section (you can usually ignore the *root/bld/src* directory, except when you need to take a look at LaTeX log-files).

The idea is that everything that needs to be run during the, say, **analysis** step, is specified in *root/src/analysis* and all its output is placed in *root/bld/out/analysis*. Etc.

Some differences:

    * Because they are accessed frequently, the *figures* and *tables* get extra directories in *root/bld/out* next to *final*
    * The directory *root/src* contains many more subdirectories:
        
        * *original_data* is the place to store the data in its raw form, as downloaded / transcribed / ... This should never be changed.
        * *model_code* contains source files that might differ by model and that are potentially used at various steps of the analysis.
        * *model_specs* contains `JSON <http://www.json.org/>`_ files with model specifications. The choice of JSON is motivated by the attempt to be language-agnostic: JSON is quite expressive and there are parsers for nearly all languages (for Stata there is a converter in the *wscript* file)
        * *library* provides code that may be used by different steps of the analysis. Little code snippets for input / output or stuff that is not directly related to the model would go here. The distinction from the *model_code* directory is a bit arbitrary, but I have found it useful in the past.


As an example of how things look further down in the hierarchy, consider the *analysis* step that was described :ref:`here <waf_analysis>`:

.. figure:: ../bld/src/examples/project_hierarchies_analysis.png
   :width: 30em

Remember that the script *root/src/analysis/schelling.py* is run with an argument *baseline* or *max_moves_2*. The code then accesses the respective file in *root/src/model_specs*, *root/src/model_code/agent.py*, and *bld/out/data/initial_locations.npy* (not shown). These are many different locations to keep track of; your project organisation will change as your project evolves and typing in entire paths at various locations is cumbersome. The next sections shows how this is solved in the project template.


.. _project_paths:

Project paths
--------------

The first question to ask is whether we should be working with absolute or relative paths. Let us first consider the pros and cons of each. 

    * **Relative paths** (e.g., *..\model_code\agent.py* or *../model_code/agent.py*)
    
        * **Pro**: Portable across machines
        * **Con**: Paths are relative to where your program / interpreter started (e.g., Stata starts in some default directory, Python where you launched the interpreter, ...). This introduces *state*, which is bad for maintainability and reproducibility.
    
    * **Absolute paths** (e.g., *C:\projects\schelling\src\model_code\agent.py* or */Users/xxx/projects/schelling/src/model_code/agent.py*)
    
        * **Pro**: Any file or directory is unambiguously specified.
        * **Con**: Not portable across machines.

The project template combines the best of both worlds by requiring you to specify relative paths for all often-accessed locations in the main *wscript* file. These are then used throughout the project template -- both in the *wscript* files and in any substantial code. The next sections show how to specify them and how to use them in different circumstances.


Specifying project paths in the main *wscript* file
---------------------------------------------------


The following is taken from the top-level wscript file. Modify any project-wide path settings there.


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the *src* directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These paths should re-appear in automatically generated header files for all languages.

