.. _create_env:

***************
Creating and Updating Environments
***************


Why? You will generally have different research projects, depend on different versions of programs, ... 

Solution: Have isolated environments...



Basic steps
===========

The repository comes with a script which handles creating, activating and updating of the environment. After pulling you can run

      source set-env.sh

in your terminal to create a new environment. The script will look at *conda_versions.txt* for conda packages and *requirements.txt* for pip packages and install those in the newly created environment. You can also run this script in the future to activate your environment.

You can update the packages in your environment by running the script with the update argument, i.e.

      source set-env.sh update

Note this is brute force to update all because this is not easy to do in pip. If you want to update a single package, use conda or pip directly: These steps:

#. conda update [package] or pip install -u [package] (CHECK SYNTAX!!!)
#. picky --update



We employ picky to save the state package versions after updating in the respective files to avoid version conflicts and maintain environment coherence, for example in a project with multiple collaborators.


Installing additional packages
==============================

These steps:

#. conda install or pip install
#. picky --update

Careful if packages are not available on some OS's... 


Choosing between conda and pip
=================================

Generally conda (necessity for most scientific packages), if not available: use pip.