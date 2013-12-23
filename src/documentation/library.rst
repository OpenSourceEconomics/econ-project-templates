.. _library:

Code library
===============

The directory *src.library* provides code that may be used by different steps of the analysis. Little code snippets for input / output or stuff that is not directly related to the model would go here.

The distinction to the :ref:`model_code` directory is a bit arbitrary, but I have found it useful in the past. 


.. _project_paths:

Project paths
--------------

A variety of project paths are defined in the top-level wscript file. These are exported to be used in header files in other languages. So in case you require different paths (e.g. if you have many different datasets, you may want to have one path to each of them), adjust them in the top-level wscript file.

The following is taken from the top-level wscript file. Modify any project-wide path settings there.

.. literalinclude:: ../../wscript
    :start-after: out = 'bld'
    :end-before:     # Convert the directories into Waf nodes


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These will re-appear in automatically generated header files by calling the ``write_project_paths`` task generator (just use an output file with the correct extension for the language you need -- ``.py``, ``.r``, ``.m``, ``.do``)

Here's what comes out for Python, to be imported from ``bld.src.library.project_paths``:

.. automodule:: bld.src.library.project_paths
    :members:
