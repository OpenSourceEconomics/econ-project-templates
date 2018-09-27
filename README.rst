.. raw:: html

    | <b><a href="https://github.com/tobiasraabe/cookiecutter-research-template#installation">Installation</a></b>
    | <b><a href="https://github.com/tobiasraabe/cookiecutter-research-template#features">Features</a></b>
    | <b><a href="https://cookiecutter-research-template.readthedocs.io/en/latest/index.html">Documentation</a></b>
    |

    <h1>cookiecutter-research-template</h1>

.. image:: https://travis-ci.com/tobiasraabe/cookiecutter-research-template.svg?branch=master
    :target: https://travis-ci.com/tobiasraabe/cookiecutter-research-template

.. image:: https://pyup.io/repos/github/tobiasraabe/cookiecutter-research-template/shield.svg
    :target: https://pyup.io/repos/github/tobiasraabe/cookiecutter-research-template/
    :alt: Updates

.. image:: https://readthedocs.org/projects/cookiecutter-research-template/badge/?version=latest
    :target: https://cookiecutter-research-template.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
    :target: https://github.com/ambv/black


Introduction
------------

This repository lays out the structure for a reproducible research project
based on the Waf framework.

It is derived from https://github.com/hmgaudecker/econ-project-templates and
the authors of this project deserve all the credit for the implementation of
Waf as a framework for reproducible research. My contribution is to add
several helpers around the project which are common in software engineering
and should help researchers to write better code.


Installation
------------

This is a `Cookiecutter <https://github.com/audreyr/cookiecutter>`_ template.
To use it, you need to install ``cookiecutter`` by running

.. code-block:: bash

    $ pip install cookiecutter

After that, you can quickly set up a new research project with this template by
typing

.. code-block:: bash

    $ cookiecutter https://github.com/tobiasraabe/cookiecutter-research-template.git

Answer all the prompts and a folder ``cookiecutter-research-template`` is
created in your current directory. Rename the folder initialize a repository.
Happy research!


Features
--------

The template offers several features:

Automatic dependency updates with `pyup <https://pyup.io>`_
    Connect your Github repository with pyup.io and you get automatic PRs if
    one of your dependency is outdated.

Automatic testing with `Travis <https://travis-ci.com>`_
    Connect your Github repository with travis-ci.com and the master branch and
    PRs are automatically tested and you can see the results online.

Testing with `tox <https://github.com/tox-dev/tox>`_
    Tox is a framework which allows you to define tests and run them in
    isolated environments. To run all tests defined in ``tox.ini``, hit

    .. code-block:: bash

        $ tox

Code Formatting with `black <https://github.com/ambv/black>`_ and `isort <https://github.com/timothycrosley/isort>`_
    Both tools will quickly improve the code quality of your project. Just run

    .. code-block:: bash

        $ python format_python_files.py

    and black will improve your code whereas isort will change the order of
    imports in a more readable way.

Linting
    Linting is the process of checking the syntax in code or documentation
    files. This template offers three ways to lint your project.

    ``flake8`` and its extensions check your Python files for potential errors,
    violations of naming conventions, ``TODO`` directives, etc.. Run this
    selection of tests by using the ``-e`` flag and type

    .. code-block:: bash

        $ tox -e flake8


    To check your documentation files and other ``.rst`` files in your project,
    run

    .. code-block:: bash

        $ tox -e docs

    To test whether the documentation is built successfully, run

    .. code-block:: bash

        $ tox -e sphinx

Customizing matplotlib
    If you are tired to set the same old options like ``figsize=(12, 8)`` for
    every graph, you are lucky. There is a solution called ``matplotlibrc``
    (`predefined template <https://github.com/tobiasraabe/cookiecutter-
    research-template/blob/master/%7B%7Bcookiecutter.project_slug%7D%7D/src/
    figures/matplotlibrc>`_). This is a configuration file for matplotlib which
    lets you define the your personal defaults. The file resides in
    ``src/figures/matplotlibrc`` and is copied over to ``bld`` as this is the
    root directory of the Python interpreter running your project. The
    ``matplotlibrc`` and its settings are automatically picked up. (`More
    information <https://matplotlib.org/users/customizing.html>`_.)

Downloading data for the project
    Data cannot be committed to the repository because the files are big and
    changing or because of confidentiality. ``prepare_data_for_project.py``
    offers a way to download files, resume downloads and validate downloaded
    files. Add the file to ``FILES`` with the filename on the disk as the key
    and the url as the first element of the list and the hash value as the
    second. Hashes are needed to validate that the downloaded file is identical
    the source. This seems unnecessarily nit-picky, but it takes ages to
    recognize that your source files are corrupt when you are debugging your
    project and look for typical mistakes.

Cleaning the project
    ``clean.py`` offers a way to clean your project from artifacts and unused
    files. Running

    .. code-block:: bash

        $ python clean.py

    performs a dry-run, so you can be sure that only useless files are deleted.
    Then, run

    .. code-block:: bash

        $ python clean.py --force

    to actually delete the files.

Visualization of the DAG
    A graphic of the DAG is compiled at the end of the build process and serves
    just as a nice picture of the complexity of the project or allows for
    visual debugging.

    .. raw:: html

        <p align="center">
            <img src="_static/dag.png">
        </p>

Others
    - `Waf Tips and Trick <https://github.com/tobiasraabe/cookiecutter-
      research-template/blob/master/%7B%7Bcookiecutter.project_slug%7D%7D/
      WAF.rst>`_
    - Writing documentation with Jupyter notebooks (`nbsphinx
      <https://github.com/spatialaudio/nbsphinx>`_ )
    - Auxiliary scripts for figures in ``src/figures/auxiliaries.py``.
