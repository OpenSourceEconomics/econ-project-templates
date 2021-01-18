

`pytask <https://pytask-dev.readthedocs.io>`_ is our tool of choice to automate the dependency tracking via a DAG (directed acyclic graph) structure. It has been written by Uni Bonn alumnus `Tobias Raabe <https://github.com/tobiasraabe>`_ out of frustration with other tools.

pytask is inspired by pytest and leverages the same plugin system. If you are familiar with pytest, getting started with pytask should be a very smooth process.

pytask will look for Python scripts named `task_[specifier].py` in all subdirectories of your project. Within those scripts, it will execute functions that start with `task_`.

Have a look at its excellent `documentation <https://pytask-dev.readthedocs.io>`_. At present, there are additional plugins to run `R scripts <https://github.com/pytask-dev/pytask-r>`_, `Stata do-files <https://github.com/pytask-dev/pytask-stata>`_, and to compile `documents via LaTeX <https://github.com/pytask-dev/pytask-latex>`_.

We will have more to say about the directory structure in the :ref:`pyorganisation` section. For now, we note that a step towards achieving the goal of clearly separating inputs and outputs is that we specify a separate build directory. All output files go there (including intermediate output), it is never kept under version control, and it can be safely removed -- everything in it will be reconstructed automatically the next time you run `pytask`.

Pytask Overview
---------------

From a high-level perspective, pytask works in the following way:

  #. pytask reads your instructions and sets the build order.

      * Think of a dependency graph here.
      * It stops when it detects a circular dependency or ambiguous ways to build a target.
      * Both are major advantages over a *master-script*, let alone doing the dependency tracking in your mind.

  #. pytask decides which tasks need to be executed and performs the required actions.

      * Minimal rebuilds are a huge speed gain compared to a *master-script*.
      * These gains are large enough to make projects break or succeed.

We have just touched upon the tip of the iceberg here; pytask has many more goodies to offer. Its `documentation <https://pytask-dev.readthedocs.io>`_ is an excellent source.

Wanted: Feedback
----------------

This is very fresh; please let us know what you would like to see here and what needs better explanation.
