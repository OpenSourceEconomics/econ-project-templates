..
  comment:: Information that one needs to run them - pre-commit run

Pre-commit hooks are checks and syntax formatters that run upon every commit. If one of
the hooks fails, the commit is aborted and you have to commit again after you resolved
the issues raised by the hooks. Pre-commit hooks are defined in the
*.pre-commit-config.yaml*. If you opt for the basic pre-commits, the following checks
will be installed into your project:

- `reorder-python-imports <https://github.com/asottile/reorder_python_imports>`_: Reorders your python imports according to PEP8 guidelines.
- `check-yaml <https://github.com/pre-commit/pre-commit-hooks>`_: Checks whether all .yaml and .yml files within your project are valid yaml files.
   ..
     comment:: What makes it valid? General question: Does one need to know these details
- `check-added-large-files <https://github.com/pre-commit/pre-commit-hooks>`_: Checks that all committed files do not exceed 100MB in size. This is the maximal file size allowed by Github.
- `check-byte-order-marker <https://github.com/pre-commit/pre-commit-hooks>`_: Fails if file has a UTF-8 byte-order marker.
- `check-json <https://github.com/pre-commit/pre-commit-hooks>`_: Checks whether all files that end with .json are indeed valid json files.
- `pyupgrade <https://github.com/asottile/pyupgrade>`_: Converts Python code to make use of newer syntax.
- `pretty-format-json <https://github.com/pre-commit/pre-commit-hooks>`_: Reformats your json files to be more readable.
- `trailing-whitespace <https://github.com/pre-commit/pre-commit-hooks>`_: Removes trailing whitespaces in all your text files.
- `black <https://github.com/ambv/black>`_: Runs the python code formatter black on all your committed python files.
   ..
     comment:: What does that mean?
- `blacken-docs <https://github.com/asottile/blacken-docs>`_: Formats python code (according to black's formatting style) that occurs within documentation files.

If you additionally opt for intrusive pre-commit hooks, then python syntax linter
`flake8 <https://gitlab.com/pycqa/flake8>`_ will be installed as pre-commit hook as
well. It is important to note that flake8 is quite strict regarding `PEP8 Style Guide
<https://www.python.org/dev/peps/pep-0008/>`_ adherence and -as opposed to black- it
only raises issues but does not automatically resolve them. You have to fix the issues
yourself.


If you want to skip the pre-commit hooks for a particular commit, you can run:

.. code-block:: console

   $ git commit -am <your commit message> --no-verify

For more advanced usages of pre-commit please consult its `website
<https://github.com/pre-commit/pre-commit-hooks>`_.


..
  comment:: (git commit) When would it make sense to ignore raised errors?
