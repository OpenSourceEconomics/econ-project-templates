FAQ
===

.. _windows_user:

Tips and Tricks for Windows Users
---------------------------------

**Anaconda Installation Notes for Windows Users**

Please follow these steps unless you know what you are doing.

1. Download the `Graphical Installer <https://www.anaconda.com/distribution/#windows>`_ for Python 3.x.

2. Start the installer and click yourself through the menu. If you have administrator privileges on your computer, it is preferable to install Anaconda for all users. Otherwise, you may run into problems when running python from your powershell.

3. Make sure to (only) tick the following box:

  - ''Register Anaconda as my default Python 3.x''. Finish installation.

4. Navigate to the folder containing your Anaconda distribution. This folder contains multiple subfolders. Please add the path to the folder called `condabin` to your *PATH* environmental variable. This path should end in `Anaconda3/condabin`. You can add paths to your *PATH* by following these `instructions <https://www.computerhope.com/issues/ch000549.htm>`_.

5. Please start Windows Powershell in administrator mode, and execute the following:

  .. code-block:: bash

    $ set-executionpolicy remotesigned

6. Now (re-)open Windows Powershell and initialize it for full conda use by running

  .. code-block:: bash

    $ conda init

.. warning::

  If you still run into problems when running conda and python from powershell, it is advisable to use the built-in Anaconda Prompt instead.

.. _git_windows:

**Integrating git tab completion in Windows Powershell**

Powershell does not support tab completion for git automatically. However, there is a nice utility called `posh-git <https://github.com/dahlbyk/posh-git>`_. We advise you to install this as this makes your life easier.

.. _path_windows:

**PATH environmental variable in Windows**

In Windows, one has to oftentimes add the programs manually to the *PATH* environmental variable in the Advanced System Settings. How to exactly do that see `here <https://www.computerhope.com/issues/ch000549.htm>`_

.. _path_mac:

**Adding directories to the PATH: MacOS and Linux**

Open the program **Terminal**. You will need to add a line to the file ``.bash_profile`` and potentially create the file. This file lives in your home directory, in the Finder it is hidden from your view by default.

**Linux users**: For most distributions, everything here applies to the file ``.bashrc`` instead of ``.bash_profile``.

I will now provide a step-by-step guide of how to create / adjust this file using the editor called ``code``. If you are familiar with editing text files, just use your editor of choice.

#. Open a Terminal and type

  .. code-block:: bash

      code ~/.bash_profile

   If you use an editor other than `VS Code <https://code.visualstudio.com/>`_, replace ``code`` by the respective editor.

   If ``.bash_profile`` already existed, you will see some text at this point. If so, use the arrow keys to scroll all the way to the bottom of the file.


#. Add the following line at the end of the file

  .. code-block:: bash

      export PATH="${PATH}:/path/to/program/inside/package"

   You will need to follow the same steps as before. Example for Stata::

      # Stata directory
      export PATH="${PATH}:/Applications/Stata/StataMP.app/Contents/MacOS/"

   In ``/Applications/Stata/StataMP.app``, you may need to replace bits and pieces as appropriate for your installation (e.g. you might not have StataMP but StataSE).

   Similarly for Matlab or the likes.

#. Press ``Return`` and then ``ctrl+o`` (= WriteOut = save) and ``Return`` once more.


.. _cookiecutter_trouble:

**When cookiecutter exits with an error**

If cookiecutter breaks off, you will get a lengthy error message. It is important that you work through this and try to understand the error (the language used might seem funny, but it is precise...).

Then type:

  .. code-block:: bash

    $ code ~/.cookiecutter_replay/econ-project-templates-0.5.1.json
.. comment:: Do I type this no matter what the error message says?
If you are not using VS Code as your editor of choice, adjust the line accordingly.
 .. comment:: How do I adjust?
This command should open your editor and show you a json file containing your answers to the previously filled out dialogue. You can fix your faulty settings in this file. If you have spaces or special characters in your path, you need to adjust your path.

When done, launch a new shell if necessary and type:

  .. code-block:: bash

    $ cookiecutter --replay https://github.com/OpenSourceEconomics/econ-project-templates/archive/v0.5.1.zip



.. _starting_programs_from_the_command_line:

**Starting stats/maths programmes from the shell**

`pytask` needs to be able to start your favourite (data) analysis programme from the command line, it might be worthwile trying that out yourself, too. These are the programme names that `pytask` looks for:

* R: ``RScript``, ``Rscript``
* Stata

  * Windows: ``StataMP-64``, ``StataMP-ia``, ``StataMP``, ``StataSE-64``, ``StataSE-ia``, ``StataSE``, ``Stata-64``, ``Stata-ia``, ``Stata``, ``WMPSTATA``, ``WSESTATA``, ``WSTATA``

  * MacOS: ``Stata64MP``, ``StataMP``, ``Stata64SE``, ``StataSE``, ``Stata64``, ``Stata``
  * Linux: ``stata-mp``, ``stata-se``, ``stata``

* Matlab: ``matlab``

Remember that Mac/Linux are case-sensitive and Windows is not. If you get errors that the programme is not found for **all** of the possibilities on your platform, the most likely cause is that your path is not set correctly yet. You may check that by typing ``echo $env:path`` (Windows) or ``echo $PATH`` (Mac/Linux). If the path to the programme you need is not included, you can adjust it as detailed above (:ref:`Windows <path_windows>`, :ref:`Mac/Linux <path_mac>`).

If the name of your programme is not listed among the possibilities above, please `open an issue on Github <https://github.com/OpenSourceEconomics/econ-project-templates/issues>`_



.. _stata_failure_check_erase_log_file:

**Stata failure: FileNotFoundError**

The following failure::

.. code:: pytb

    FileNotFoundError: No such file or directory: '/Users/xxx/econ/econ-project templates/bld/add_variables.log'

has a simple solution: **Get rid of all spaces in the path to the project.** (i.e., ``econ-project-templates`` instead of ``econ-project templates`` in this case). To do so, do **not** rename your user directory, that will cause havoc. Rather move the project folder to a different location.

I have not been able to get Stata working with spaces in the path in batch mode, so this has nothing to do with Python/Pytask. If anybody finds a solution, please let me know.


**Stata failure: missing file**

If you see an error like this one::

    -> missing file: '/Users/xxx/econ/econ-project/templates/bld/add_variables.log'

check that you have a license for the Stata version that is found (the Stata tool just checks availability top-down, i.e., MP-SE-IC, in case an MP-Version is found and you just have a license for SE, Stata will silently refuse to start up).

The solution is to remove all versions of Stata from its executable directory (e.g., /usr/local/stata) that cost more than your license did.
