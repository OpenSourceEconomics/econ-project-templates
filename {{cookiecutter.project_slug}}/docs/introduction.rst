.. _introduction:


************
Introduction
************

You can find the documentation on the rationale, pytask, and more background at https://econ-project-templates.readthedocs.io/en/stable/.

The Python version of the template uses a modified version of Stachurski's and Sargent's code accompanying their Online Course :cite:`StachurskiSargent13` for Schelling's (1969, :cite:`Schelling69`) segregation model as the running example.


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
    * The documentation source files in **src/documentation/** (Note: These should follow the directories in **src** exactly);
    * The list of included documentation source files in **src/documentation/index.rst**

Later adjustments should be painlessly possible, so things won't be set in stone.

Once you have done that, move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to specify the tasks for `pytask`.
