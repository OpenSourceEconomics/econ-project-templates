.. _faq:

***********************************************
Frequently Answered Questions / Troubleshooting
***********************************************

LaTeX & Waf
===========

* ``'error when calling biber, check xxx.blg for errors'``

  This is a well-known bug in biber that occurs occasionally. Nicely explained `here <http://tex.stackexchange.com/questions/140814/biblatex-biber-fails-with-a-strange-error-about-missing-recode-data-xml-file>`_.

  Short excerpt from LaTeX Stack Exchange for the fix: 

      You need to delete the relevant cache folders and compile your document again. You can find the location of the cache folder by looking at the .blg file, or by using the command::

          biber --cache

      On Linux and Mac, this can be combined to delete the offending folder in one command::

          rm -rf `biber --cache`

  In my experience, it helps to run waf on only one core for the first time you compile multiple LaTeX documents (once Biber's cache is built correctly, you can do this in parallel again)::

      python waf.py -j1


* **Biber on 64-bit MikTeX**

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