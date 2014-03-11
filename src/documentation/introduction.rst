.. _introduction:


************
Introduction
************

Documentation on the rationale, Waf, and more background is at http://hmgaudecker.github.io/econ-project-templates/ in the context of the Python version of this template. 

Most of the things mentioned there are valid for the R version of the template as well, only the example is different. In particular, we use Albouy's :cite:`Albouy12` replication study of Acemoglu, Johnson, and Robinson's :cite:`AcemogluJohnsonRobinson01` classic 2001 paper.



.. _getting_started:

Getting started
===============

**This assumes you have completed the steps in the** `README.md file <https://github.com/hmgaudecker/econ-project-templates/tree/R#templates-for-reproducible-research-projects-in-economics>`_ **and everything worked.**

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

Once you have done that, move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and how to use the auto-generated files in the language you are using particular language (see the section :ref:`project_paths` in the code library).


.. _dag:

DAG of the project
==================

See :download:`this pdf document </../../bld/src/documentation/dependency_graph.pdf>`. It should be helpful to get an idea of the overall structure of the example.

.. raw:: latex
    
    \vspace*{2ex}

    Forget about the previous sentence in the context of this pdf document. In LaTeX, we can include the pdf directly as a graphic:\\[2ex]
    \includegraphics{../dependency_graph.pdf}
