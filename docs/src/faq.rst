.. _faq:

***********************************************
Frequently Answered Questions / Troubleshooting
***********************************************

.. _windows_user:

Tips and Tricks for Windows Users
=================================

Anaconda Installation Notes for Windows Users
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please follow these steps unless you know what you are doing.

1. Download the `Graphical Installer <https://www.anaconda.com/distribution/#windows>`_ for Python 3.x.

2. Start the installer and click yourselve throug the menu. If you have administrator privileges on your computer, it is preferable to install Anaconda for all users. Otherwise, you may run into problems when running python from your powershell.

3. Make sure to tick the following box:

  - ''Register Anaconda as my default Python 3.x''. Finish installation.

4. Manually add Anaconda to path by following the instructions that can be found `here <https://www.computerhope.com/issues/ch000549.htm>`_.

5. Now open Windows Powershell and initialize it for full conda use by running

  .. code-block:: bash

    $ conda init

  If this yields an error regarding the powershell execution policy (red text upon reopening powershell), please start Windows Powershell in administrator mode, and execute the following:

  .. code-block:: bash

    $ set-executionpolicy remotesigned

.. warning::

  If you still run into problems when running conda and python from powershell, it is advisable to use the built-in Anaconda Prompt instead.

.. _git_windows:

Integrating git tab completion in Windows Powershell
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Powershell does not support tab completion for git automatically. However, there is a nice utility called `posh-git <https://github.com/dahlbyk/posh-git>`_. We advise you to install this as this makes your life easier.

.. _path_windows:

PATH environmental variable in Windows
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In Windows, one has to oftentimes add the programs manually to the *PATH* environmental variable in the Advanced System Settings. How to exactly do that see `here <https://www.computerhope.com/issues/ch000549.htm>`_


.. _mac_path:

Adding Excecutables to Path: Mac OS and Linux
=============================================

Open the program **Terminal** in the "Utilities" subfolder of your applications folder.

If you have never used the command line before, I recommend watching `this lecture <http://software-carpentry.org/4_0/shell/>`_ from the `Software Carpentry course <http://software-carpentry.org/4_0/>`_.


You will need to add a line to the file ``.bash_profile`` and potentially create the file. This file lives in your home directory and it is hidden from your view by default, to toggle that setting that you can download a neat little `program <http://download.cnet.com/Show-Hidden-Files/3000-2383_4-75415396.html>`_.

**Linux users**: For most distributions, everything here applies to the file ``.bashrc`` instead of ``.bash_profile``.

I will now provide a step-by-step guide of how to create / adjust this file using the editor called ``atom``, if you are familiar with editing text files, just use your editor of choice.

#. Open a Terminal and type

  .. code-block:: bash

      atom ~/.bash_profile

   If you use a different editor, replace atom by the respective editor.

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


LaTeX & Waf
===========

``'error when calling biber, check xxx.blg for errors'``
--------------------------------------------------------

    **This should occur only with older Biber versions, please update if possible.**

  This is a well-known bug in older versions of Biber that occurs occasionally. Nicely explained `here <http://tex.stackexchange.com/questions/140814/biblatex-biber-fails-with-a-strange-error-about-missing-recode-data-xml-file>`__.

  Short excerpt from LaTeX Stack Exchange for the fix:

      You need to delete the relevant cache folders and compile your document again. You can find the location of the cache folder by looking at the .blg file, or by using the command::

          biber --cache

      On Linux and Mac, this can be combined to delete the offending folder in one command::

          rm -rf `biber --cache`

  In my experience, it helps to run waf on only one core for the first time you compile multiple LaTeX documents (once Biber's cache is built correctly, you can do this in parallel again)::

      python waf.py -j1


Biber on 64-bit MikTeX
----------------------

  **This should occur only on older MikTeX versions, please update if possible.**

  There have been mulitple issues of with Biber on Windows, sometimes leading to strange error messages from Python's subprocess module (e.g., "file not found" errors). Apparently, current 64-bit MikTeX distributions do not contain Biber. Two possible fixes:

  * **Recommended:** In the main ``wscript`` file, replace the line::

        ctx.load('biber')

    by::

        ctx.load('tex')

    In ``src/paper/research_paper.tex`` and ``src/paper/research_pres_30min.tex``, replace::

        backend=biber

    by::

        backend=bibtex

  * **For the adventurous:** Download a 64-bit version of biber here: http://biblatex-biber.sourceforge.net/. Put the file *biber.exe* into the correct folder, typically that will be "C:\Program Files\MiKTeX 2.9\miktex\bin\x64", "C:\Program Files\MiKTeX 2.9\miktex\bin", or the like. Hat tip to Andrey Alexandrov, a student in my 2014 class at Bonn.


.. _spyder_waf:

Using Spyder with Waf
=====================

Spyder is a useful IDE for developing scientific Python code -- it has been specifically developed for this purpose and has first-class support for data structures like NumPy arrays and pandas dataframes.

In the context of these project templates, there are just two issues to consider.


Debugging wscript files
------------------------

Sometimes it is helpful to debug your build code directly. As the wscript files are just pure Python code Spyder can handle them in principle. The tricky bit is to make Spyder recognize the them as Python scripts -- usually it just uses the extension ``.py`` to infer that fact. As you cannot simply add this extension to wscript files, you must tell Spyder inside the wscript file using a so-called "shebang". Simply add the following line as the first thing to all your wscripts::

    #! python

You can then set breakpoints inside your wscript files and debug them by running waf.py from inside spyder (just make sure you ran ``python waf.py configure`` beforehand).


Setting the PYTHONPATH
-----------------------

The machinery of the imports in Python scripts requires the PYTHONPATH environmental variable to include the project root; you will need to add the project root directory to the PYTHONPATH when debugging files in Spyder as well.

In order to do so, first create a Spyder project in the directory where you want your research to be (click "Yes" on the question "The following directory is not empty: ... Do you want to continue?"). Then right-click on the project's root folder and select "Add to PYTHONPATH".

   .. image:: python/spyder_pythonpath.png
       :width: 18cm

Any ``ImportErrors`` are likely due to this not being done correctly. Note that you **must** set the run configuration (F6 or select "Run" from the menu bar and then "Configure") to "Execute in a new dedicated Python console".



.. _stata_packages:

Stata packages
==============

Note that when you include (or input) the file ``project_paths.do`` in your Stata script, the system directories get changed. **This means that Stata will not find any packages you installed system-wide anymore.** This is desired behaviour to ensure that you (and your coauthors) run the same versions of different packages that you installed via ``ssc`` or the like. The project template comes with a few of them, see *src/library/stata/ado_ext* in the Stata branch.


Adding additional Stata packages to a project
---------------------------------------------

#. Open a Stata command line session and change to the project root directory
#. Type ``include bld/project_paths``
#. Type ``sysdir`` and make sure that the ``PLUS`` and ``PERSONAL`` directories point to subdirectories of the project.
#. Install your package via ssc, say ``ssc install tabout``


.. _stata_failure_check_erase_log_file:

Stata failure: FileNotFoundError
================================

The following failure::

    [21/39] Running  [Stata] -e -q do src/data_management/add_variables.do add_variables
    Waf: Leaving directory `/Users/xxx/econ/econ-project templates/bld'
    Build failed
    Traceback (most recent call last):
      File "/Users/xxx/econ/econ-project templates/.mywaflib/waflib/Task.py", line 212, in process
        ret = self.run()
      File "/Users/xxx/econ/econ-project templates/.mywaflib/waflib/extras/run_do_script.py", line 140, in run
        ret, log_tail = self.check_erase_log_file()
      File "/Users/xxx/econ/econ-project templates/.mywaflib/waflib/extras/run_do_script.py", line 166, in check_erase_log_file
        with open(**kwargs) as log:
    FileNotFoundError: [Errno 2] No such file or directory: '/Users/xxx/econ/econ-project templates/bld/add_variables.log'

has a simple solution: **Get rid of all spaces in the path to the project.** (i.e., ``econ-project-templates`` instead of ``econ-project templates`` in this case). To do so, do **not** rename your user directory, that will cause havoc. Rather move the project folder to a different location.

I have not been able to get Stata working with spaces in the path in batch mode, so this has nothing to do with Python/Waf. If anybody finds a solution, please let me know.


Stata failure: missing file
================================

If you see this error::

    [21/39] Running  [Stata] -e -q do src/data_management/add_variables.do add_variables
    Waf: Leaving directory `/Users/xxx/econ/econ-project/templates/bld'
    Build failed
    -> missing file: '/Users/xxx/econ/econ-project/templates/bld/add_variables.log'

run ``python waf.py configure`` again and check that you have a license for the Stata version that is found (the Stata tool just checks availability top-down, i.e., MP-SE-IC, in case an MP-Version is found and you just have a license for SE, Stata will silently refuse to start up).

The solution is to remove all versions of Stata from its executable directory (e.g., /usr/local/stata) that cost more than your license did.
