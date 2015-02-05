.. _faq:

***********************************************
Frequently Answered Questions / Troubleshooting
***********************************************

LaTeX & Waf
===========

``'error when calling biber, check xxx.blg for errors'``
--------------------------------------------------------

  This is a well-known bug in biber that occurs occasionally. Nicely explained `here <http://tex.stackexchange.com/questions/140814/biblatex-biber-fails-with-a-strange-error-about-missing-recode-data-xml-file>`_.

  Short excerpt from LaTeX Stack Exchange for the fix: 

      You need to delete the relevant cache folders and compile your document again. You can find the location of the cache folder by looking at the .blg file, or by using the command::

          biber --cache

      On Linux and Mac, this can be combined to delete the offending folder in one command::

          rm -rf `biber --cache`

  In my experience, it helps to run waf on only one core for the first time you compile multiple LaTeX documents (once Biber's cache is built correctly, you can do this in parallel again)::

      python waf.py -j1


Biber on 64-bit MikTeX
----------------------

  There have been mulitple issues of with biber on Windows, sometimes leading to strange error messages from Python's subprocess module (e.g., "file not found" errors). Apparently, current 64-bit MikTeX distributions do not contain Biber. Two possible fixes:

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

Sometimes it is helpful to debug your build code directly. As the wscript files are just pure Python code Spyder can handle them in principle. The tricky bit is to make Spyder recognise the them as Python scripts -- usually it just uses the extension ``.py`` to infer that fact. As you cannot simply add this extension to wscript files, you must tell Spyder inside the wscript file using a so-called "shebang". Simply add the following line as the first thing to all your wscripts::

    #! python

You can then set breakpoints inside your wscript files and debug them by running waf.py from inside spyder (just make sure you ran ``python waf.py configure`` beforehand).


Setting the PYTHONPATH
-----------------------

The machinery of the imports in Python scripts requires the PYTHONPATH environmental variable to include the project root; you will need to add the project root directory to the PYTHONPATH when debugging files in Spyder as well.

In order to do so, first create a Spyder project in the directory where you want your research to be (click "Yes" on the question "The following directory is not empty: ... Do you want to continue?"). Then right-click on the project's root folder and select "Add to PYTHONPATH".

   .. image:: examples/spyder_pythonpath.png
       :width: 18cm

Any ``ImportErrors`` are likely due to this not being done correctly. Note that you **must** set the run configuration (F6 or select "Run" from the menu bar and then "Configure") to "Execute in a new dedicated Python console".
