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


Updating packages
-----------------

Make sure you activated the environment by ``conda activate <env_name>``. Then use conda
or pip directly:

``conda update [package]`` or ``pip install -U [package]``

For updating conda all packages, replace ``[package]`` by ``--all``.


..
  comment:: I would leave that part out, here one does not know yet what kind of package one could install


Installing additional packages
------------------------------

To list installed packages, type

.. code:: console

    $ conda list

If you want to add a package to your environment, run

..
  comment:: where can I find the options for packages I would like to install?

.. code:: console

    $ conda install [package]

or

.. code:: console

    $ pip install [package]

**Choosing between conda and pip**

Generally it is recommended to use *conda* whenever possible (necessary for most
scientific packages, they are usually not pure-Python code and that is all that pip can
handle, roughly speaking). For pure-Python packages, we sometimes fall back on *pip*.


Information about your conda environments
-----------------------------------------

For listing your installed conda environments, type

.. code:: console

    $ conda info --envs

The currently activated one will be marked.
