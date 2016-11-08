.. _create_env:

*************************************
Project-specific Program Environments
*************************************

Progams change. Nothing is as frustrating as coming back to a project after a long time and spending the first {hours, days} updating your code to work with the new version. Same for debugging errors because your coauthor uses a slightly different setup.

The solution is to have isolated environments on a per-project basis. `Conda environments <http://conda.pydata.org/docs/using/envs.html>`_ allow you to do precisely this. This page describes them a little bit and explains the scripts that come as part of the templates in order to install them in an automated way.


Basic steps
===========

The templates come with a script which handles creating, activating and updating of environments. After cloning and changing to the project directory, you can run **(Mac, Linux)**::

    source set-env.sh

or **(Windows)**::

	set-env.bat

in your shell to create a new environment with the same name as your project folder.

The script will look at *conda_versions.txt* for conda packages and *requirements.txt* for pip packages and install those in the newly created python environment. Once created, you activate your environment in the same way: **(Mac, Linux)**::

      source set-env.sh

or **(Windows)**::

	set-env.bat


Updating packages
=================

Make sure you activated the environment by ``source set-env.sh`` / ``set-env.bat``. Then use conda or pip directly: 

#. ``conda update [package]`` or ``pip install -U [package]``
#. ``picky --update``

For updaing conda all packages, replace ``[package]`` by ``--all``.

We employ `Picky <http://picky.readthedocs.org/>`_ to save the  package version state after updating in the respective files to avoid version conflicts and maintain environment coherence in a project with multiple collaborators.


Installing additional packages
==============================

If you want to add a package to your environment, run


#. ``conda install [package]`` or ``pip install [package]``
#. ``picky --update``

`Picky <http://picky.readthedocs.org/>`_ will then add your package to the spec. Be wary of suprises on other operating systems, some packages might not be available on all of them. If it is not a crucial package, just remove it manually from ``conda_versions.txt``.


**Choosing between conda and pip**

Generally it is recommended to use *conda* whenever possible (necessary for most scientific packages, they are usually not pure-Python code and that is all that pip can handle, roughtly speaking). For pure-Python packages, we sometimes fall back on *pip*.
