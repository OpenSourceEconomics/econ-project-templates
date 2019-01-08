.. _introduction:


************
Introduction
************

Documentation on the rationale, Waf, and more background is at http://hmgaudecker.github.io/econ-project-templates/

The Python version of the template uses a modified version of Stachurski's and Sargent's code accompanying their Online Course :cite:`StachurskiSargent13` for Schelling's (1969, :cite:`Schelling69`) segregation model as the running exmaple.


.. _getting_started:

Getting started
===============

**This assumes you have completed the steps in the** `README.md file <https://github.com/hmgaudecker/econ-project-templates/>`_ **and everything worked.**

The logic of the project template works by step of the analysis: 

1. Data management
2. The actual estimations / simulations / ?
3. Visualisation and results formatting (e.g. exporting of LaTeX tables)
4. Research paper and presentations. 

It can be useful to have code and model parameters available to more than one of these steps, in that case see sections :ref:`model_specifications`, :ref:`model_code`, and :ref:`library`.

First of all, think about whether this structure fits your needs -- if it does not, you need to adjust (delete/add/rename) directories and files in the following locations:

    * Directories in **src/**;
    * The list of included wscript files in **src/wscript**;
    * The documentation source files in **src/documentation/** (Note: These should follow the directories in **src** exactly);
    * The list of included documentation source files in **src/documentation/index.rst**

Later adjustments should be painlessly possible, so things won't be set in stone.

Once you have done that, move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and how to use the auto-generated files in the language you are using particular language (see the section :ref:`project_paths` below).


.. _project_paths:

Project paths
=============

A variety of project paths are defined in the top-level wscript file. These are exported to header files in other languages. So in case you require different paths (e.g. if you have many different datasets, you may want to have one path to each of them), adjust them in the top-level wscript file.

The following is taken from the top-level wscript file. Modify any project-wide path settings there.

.. literalinclude:: ../../wscript
    :start-after: out = "bld"
    :end-before:     # Convert the directories into Waf nodes


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These will re-appear in automatically generated header files by calling the ``write_project_paths`` task generator (just use an output file with the correct extension for the language you need -- ``.py``, ``.r``, ``.m``, ``.do``)

By default, these header files are generated in the top-level build directory, i.e. ``bld``. The Python version defines a dictionary ``project_paths`` and a couple of convencience functions documented below. You can access these by adding a line::

    from bld.project_paths import XXX

at the top of you Python-scripts. Here is the documentation of the module:

    **bld.project_paths**

    .. automodule:: bld.project_paths
        :members:
