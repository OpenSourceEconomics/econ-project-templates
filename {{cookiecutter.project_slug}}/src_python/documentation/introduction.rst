.. _introduction:


************
Introduction
************

You can find the documentation on the rationale, Waf, and more background at https://econ-project-templates.readthedocs.io/en/stable/

The Python version of the template uses a modified version of Stachurski's and Sargent's code accompanying their Online Course :cite:`StachurskiSargent13` for Schelling's (1969, :cite:`Schelling69`) segregation model as the running exmaple.


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

Once you have done that, move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and how to use the auto-generated files in the language you are using particular language (see the section :ref:`project_paths` below).


.. _project_paths:

Project paths
=============

Shortcuts for project paths are created in the configuration file of the project which is a simple module called ``config.py``.

.. code-block:: python

    from pathlib import Path


    SRC = Path(__file__).parent
    BLD = SRC.parent.joinpath("bld")
