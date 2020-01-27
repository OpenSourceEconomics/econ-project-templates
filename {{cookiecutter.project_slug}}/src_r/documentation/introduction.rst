.. _introduction:


************
Introduction
************

You can find the documentation on the rationale, Waf, and more background at https://econ-project-templates.readthedocs.io/en/stable/.

Most of the things mentioned there are valid for the R version of the template as well, only the example is different. In particular, we use Albouy's :cite:`Albouy2012` replication study of Acemoglu, Johnson, and Robinson's :cite:`AcemogluJohnsonRobinson2001` classic 2001 paper.



.. _getting_started:

Getting started
===============

**This assumes you have completed the steps in the `Getting Started section of the documentation <https://econ-project-templates.readthedocs.io/en/stable/getting_started.html>`_ and **everything worked.**

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

These will re-appear in automatically generated header files by calling the ``write_project_paths`` task generator (just use an output file with the correct extension for the language you need -- ``.py``, ``.r``, ``.m``, ``.do``)

By default, these header files are generated in the top-level build directory, i.e. ``bld``. Since this is where R is launched, you can just get variables with the project paths by adding a line ``source("project_paths.r")`` at the top of you R-scripts.

To see what these variables are, here is the content of *bld/project_paths.r*:

.. literalinclude:: ../../bld/project_paths.r
