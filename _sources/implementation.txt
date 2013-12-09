.. _implementation:

**************
Implementation
**************

(TBD)

.. _project_paths:

Project paths
--------------



The following is taken from the top-level wscript file. Modify any project-wide path settings there.


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These paths should re-appear in automatically generated header files for all languages.

