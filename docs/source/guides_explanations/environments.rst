Progammes change. Few things are as frustrating as coming back to a project after a long
time and spending the first {hours, days} updating your code to work with a new version
of your favourite data analysis library. The same holds for debugging errors that occur
only because your coauthor uses a slightly different setup.

The solution is to have isolated environments on a per-project basis. `Conda
environments
<https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>`_
allow you to do precisely this. This page describes them a little bit and explains their
use.

The following commands can either be executed in a terminal or the Anaconda prompt
(Windows).


Using the environment
---------------------

In the installation process of the template a new environment was created if it was not
explicitly declined. It took its specification from the environment.yml file in your
projects root folder.

To activate it, execute:

.. code:: console

    $ conda activate <env_name>

Repeat this step every time you want to run your project from a new terminal window.


Setting up a new environment
----------------------------

If you want to create a clean environment we recommended specifying it through an
environment.yml file. Below we show the contents of an example environment.yml file. A
detailed explanation is given in the `Conda documentation
<https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually>`_.

.. code:: yaml

    name: <env_name>

    channels:
      - conda-forge
      - defaults

    dependencies:
      - python=3.10
      - numpy
      - pandas
      - pip
      - pip:
        - black


If the environment.yml file exists you can create the environment using

.. code:: console

    $ conda create -f path/to/environment.yml


Updating packages
-----------------

Make sure you activated the environment by ``conda activate <env_name>``. Then run

.. code:: console

    $ conda update [package]


to update a specific ``[package]``, or run

.. code:: console

    $ conda update --all


to update all packages.


Installing additional packages
------------------------------

To list installed packages, activate the environment and type

.. code:: console

    $ conda list


If you want to add a package to your environment, add it to the environment.yml file.
Once you have edited the environment.yml file, run

.. code:: console

    $ conda env update -f environment.yml


**Choosing between conda and pip**

Generally it is recommended to use *conda* whenever possible. It is a necessity for many
scientific packages. These often are not pure-Python code and pip is built mainly for
that. For pure-Python packages, sometimes nobody bothered to set up a conda package and
we use *pip*.

If you add a package under ``dependencies:`` in the environment.yml file, conda will try
to install its own package. If you add a package under ``pip:``, conda will try to
install the package via pip.


Information about your conda environments
-----------------------------------------

For listing your installed conda environments, type

.. code:: console

    $ conda info --envs

The currently activated one will be marked.
