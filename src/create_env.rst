.. _create_env:

***************
Creating and Updating Environments
***************


Why have environments at all?
=============================

Often when you are involved in multiple research projects, those come with different requirements in terms of software and package specifications. It can be frustrating to manually change your installed version of some package to the required one only to later restore that change for a different task.

For that reason it makes sense to have isolated environments for each of these projects containing the required packages and their correct versions. This will also benefit collaborating on a project since a lot of errors can be avoided by using consistent software environments.


Basic steps
===========

The repository comes with a script which handles creating, activating and updating of environments. After cloning you can run

      source set-env.sh install

in your terminal to create a new environment. The script will look at *conda_versions.txt* for conda packages and *requirements.txt* for pip packages and install those in the newly created python environment. You can also run this script without arguments to simply activate your environment:

      source set-env.sh

The name of the environment will automatically be chosen to be the name of the folder that contains the project. You can update the packages in your environment by running the script with the update argument, i.e.

      source set-env.sh update

Note this is brute force to update all packages because this is not easy to do in pip. If you want to update a single package, use conda or pip directly: These steps:

#. conda update [package] or pip install -U [package]
#. picky --update


We employ *Picky* to save the  package version state after updating in the respective files to avoid version conflicts and maintain environment coherence in a project with multiple collaborators.


Installing additional packages
==============================

If you want to add a package to your environment, run


#. conda install [package] or pip install [package]
#. picky --update

*Picky* will then add your package to the spec. Be careful though as packages are not available on some OS's...


Choosing between *conda* and *pip*
=================================

Generally it is recommended to use *conda* whenever possible (necessity for most scientific packages). As some packages are not available there we fall back on *pip* for those