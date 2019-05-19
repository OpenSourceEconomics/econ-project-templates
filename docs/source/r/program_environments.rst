.. _create_env:

*************************************
Project-specific Program Environments
*************************************

Progams change. Nothing is as frustrating as coming back to a project after a long time and spending the first {hours, days} updating your code to work with a new version of your favourite data analysis library. The same holds for debugging errors that occur only because your coauthor uses a slightly different setup.

The solution is to have isolated environments on a per-project basis. `Conda environments <http://conda.pydata.org/docs/using/envs.html>`_ allow you to do precisely this. This page describes them a little bit and explains the scripts that come as part of the templates in order to install them in an automated way.


Setting up a new environment
============================

The templates come with a script which handles creating, activating and updating of environments. After cloning and changing to the project directory, you can run

**(Mac, Linux)**

.. code:: console

    $ source set-env.sh

or **(Windows)**

.. code:: console

    $ set-env.bat

in your shell to create a new environment with the same name as your project folder.

The script will look at the *.environment.[OS].yml* file, where 'OS' is your current operating system :math:`\in\;\{\text{linux, osx, windows}\}` , for conda and pip packages and install those in the newly created Python environment.


Using the environment
=====================

Every time you go back to the project, activate the project in the same way before running Waf. That is, go to the project root directory, run:

**(Mac, Linux)**

.. code:: console

    $ source set-env.sh

or **(Windows)**

.. code:: console

    $ set-env.bat

Updating packages
=================

Make sure you activated the environment by ``source set-env.sh`` / ``set-env.bat``. Then use conda or pip directly:

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

After updating or changing your environment you should save the status in the respective *.environment.OS.yml* file to avoid version conflicts and maintain coherent environments in a project with multiple collaborators. Just make sure your environment is activated and run the following in the project's root directory:

**(Linux)**

.. code:: console

    $ conda env export -f .environment.linux.yml

**(Mac)**

.. code:: console

    $ conda env export -f .environment.osx.yml

**(Windows)**

.. code:: console

    $ conda env export -f .environment.windows.yml

After exporting, manually delete the last line in the environment file, as it is system specific.


Information about your conda environments
=========================================

For listing your installed conda environments, type

.. code:: console

    $ conda info --envs

The currently activated one will be marked.


