.. _library:

Code library
===============

The directory :mod:`library` provides code that may be used by different steps of the analysis. Little code snippets for input / output or stuff that is not directly related to the model would go here.

The distinction to the :ref:`model_code` directory is a bit arbitrary, but I have found it useful in the past. 


Matlab-JSON parser
-------------------

This package is provided by Kyamagu on GitHub_. It contains a Matlab class to serialize/decode Matlab objects into JSON format. Make sure to add the path to the directory containing ``+json`` in your Matlab script, and call ``json.startup``. The file :file:`schelling.m` in **src.analysis** requires this tool to load the JSON model specifications from **src.model_specs**.

.. _GitHub: https://github.com/kyamagu/matlab-json.git
