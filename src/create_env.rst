.. _create_env:

***************
Creating and Updating Environments
***************

Basic steps
===========

The repository comes with a script which handles creating, activating and updating of the environment. After pulling you can run

      source set-env.sh

in your terminal to create a new environment. The script will look at *conda_versions.txt* for conda packages and *requirements.txt* for pip packages and install those in the newly created environment. You can also run this script in the future to activate your environment.

You can update the packages in your environment by running the script with the update argument, i.e.

      source set-env.sh update

We employ picky to save the state package versions after updating in the respective files to avoid version conflicts and maintain environment coherence, for example in a project with multiple collaborators.