.. _introduction:


************
Introduction
************

Documentation on the rationale, Waf, and more background is at http://hmgaudecker.github.io/econ-project-templates/ in the context of the Python version of this template. 

Most of the things mentioned there are valid for the Stata version of the template as well, only the example is different. In particular, we use Albouy's :cite:`Albouy12` replication study of Acemoglu, Johnson, and Robinson's :cite:`AcemogluJohnsonRobinson01` classic 2001 paper.



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

Once you have done that, move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and how to use the auto-generated files in the language you are using particular language (see the section on :ref:`project_paths`).


.. _dag:

DAG of the project
==================

See :download:`this pdf document </../../bld/src/documentation/dependency_graph.pdf>`. It should be helpful to get an idea of the overall structure of the example.


.. raw:: latex
    
    \vspace*{2ex}

    Forget about the previous sentence in the context of this pdf document because in LaTeX, we can include the pdf directly as a graphic:\\[2ex]
    \includegraphics{../dependency_graph.pdf}

For the sake of simplicity, the dependency graph does not include the second stage estimation that ends up in Table 3. It would work in exactly the same way as the first stage estimation is outlined in the graph. Same for the figures. The overlapping nodes stand for all five model specifications, only the baseline specification is actually written out (of course, there should be five edges as well, in principle).


.. _calling_stata:

Calling Stata do-files from Waf
===============================

* Stata is always started in the ``bld``-directory. Keep that in mind and use the `project_paths`_-machinery.
* Do-files will be called by Waf with the name of the do-file as its first argument. This is helpful for keeping log-files, see the top of any do-file in this project as examples.
* You can pass additional arguments by using the ``append``-keyword of the Stata builder. See ``analysis/first_stage_estimation.do`` and the corresponding wscript-file for an example.


.. _project_paths:

Project paths
=============

A variety of project paths are defined in the top-level wscript file. These are exported to be used in header files in other languages. So in case you require different paths (e.g. if you have many different datasets, you may want to have one path to each of them), adjust them in the top-level wscript file.

The following is taken from the top-level wscript file. Modify any project-wide path settings there.

.. literalinclude:: ../../wscript
    :start-after: out = "bld"
    :end-before:     # Convert the directories into Waf nodes

As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These will re-appear in automatically generated header files by calling the ``write_project_paths`` task generator (just use an output file with the correct extension for the language you need -- ``.py``, ``.r``, ``.m``, ``.do``).

By default, these header files are generated in the top-level build directory, i.e. ``bld``. Since this is where Stata is launched, you can just get globals with the project paths by adding a line ``include project_paths`` at the top of you do-files.

To see what these variables are, here is the content of *bld/project_paths.do*:
    
.. literalinclude:: ../../bld/project_paths.do

.. note::

    Note the changes to Stata's built-in system paths. **These changes imply that Stata will not find any packages you installed system-wide anymore.** It is desired behaviour; see the next section on :ref:`stata_packages` for an explanation and for how to add packages to your project.


.. _stata_packages:

Stata packages
==============

Note that when you include (or input) the file ``project_paths.do`` in your Stata script, the system directories get changed. **This means that Stata will not find any packages you installed system-wide anymore.** This is desired behaviour to ensure that you (and your coauthors) run the same versions of different packages that you installed via ``ssc`` or the like. The project template comes with a few of them, see *src/library/stata/ado_ext*.


Adding additional Stata packages to a project
---------------------------------------------

#. Open a Stata command line session and change to the project root directory
#. Type ``include bld/project_paths``
#. Type ``sysdir`` and make sure that the ``PLUS`` and ``PERSONAL`` directories point to subdirectories of the project.
#. Install your package via ssc, say ``ssc install tabout``
