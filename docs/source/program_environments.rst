.. _create_env:

*************************************
Project-specific Program Environments
*************************************

Progams change. Nothing is as frustrating as coming back to a project after a long time and spending the first {hours, days} updating your code to work with a new version of your favourite data analysis library. The same holds for debugging errors that occur only because your coauthor uses a slightly different setup.

The solution is to have isolated environments on a per-project basis. `Conda environments <https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>`_ allow you to do precisely this. This page describes them a little bit and explains their use.

The following commands can either be executed in a terminal or the Anaconda prompt (Windows).


Using the environment
=====================

In the installation process of the template a new environment was created if it was not explicitly declined. It took its specification from the environment.yml file in your projects root folder.

To activate it, execute:

.. code:: console

    $ conda activate <env_name>

Repeat this step every time you want to run your project from a new terminal window.


Updating packages
=================

Make sure you activated the environment by ``conda activate <env_name>``. Then use conda or pip directly:

``conda update [package]`` or ``pip install -U [package]``

For updating conda all packages, replace ``[package]`` by ``--all``.


Installing additional packages
==============================

To list installed packages, type

.. code:: console

    $ conda list

If you want to add a package to your environment, run

.. code:: console

    $ conda install [package]

or

.. code:: console

    $ pip install [package]

**Choosing between conda and pip**

Generally it is recommended to use *conda* whenever possible (necessary for most scientific packages, they are usually not pure-Python code and that is all that pip can handle, roughtly speaking). For pure-Python packages, we sometimes fall back on *pip*.


Saving your environment
=======================

After updating or changing your environment you should save the status in the *environment.yml* file to avoid version conflicts and maintain coherent environments in a project with multiple collaborators. Just make sure your environment is activated and run the following in the project's root directory:

.. code:: console

    $ conda env export -f environment.yml

After exporting, manually delete the last line in the environment file, as it is system specific.


Setting up a new environment
============================

If you want to create a clean environment, execute:

.. code:: console

    $ conda create --name myenv

For setting up an environment from a specification file (like environment.yml), type:

.. code:: console

    $ conda create --name <myenv> -f <filename>


Information about your conda environments
=========================================

For listing your installed conda environments, type

.. code:: console

    $ conda info --envs

The currently activated one will be marked.


