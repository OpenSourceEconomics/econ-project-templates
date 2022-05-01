.. _second_machine:

How to get started on a second machine
**************************************


If you already have the templates running on your computer and hosted on GitHub, it is
very easy to invite a collaborator or to use a second machine. Importantly you do not
need to go through the cookiecutter dialogue etc.

On the second machine prepare the system and open a terminal on Max/Linux or the
Anaconda prompt on Windows. Then type


.. code-block:: console

    $ git clone <url_of_your_repository>
    $ cd <name_of_your_project>
    $ conda env create -f environment.yml
    $ conda activate <conda_environment_name>
    $ pre-commit install


Now your're all set!