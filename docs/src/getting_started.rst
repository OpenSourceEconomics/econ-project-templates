.. _getting_started:

***************
Getting started
***************

Basic steps
===========

Follow the guide listed in the Readme file inlcuded at the :ref:`beginning readme`.


Starting a new project
======================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in computer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So write one bit of code at a time, understand what is going on, and move on.


#. I suggest you leave the examples in place.
#. Now add your own data and code bit by bit, append the wscript files as necessary. To see what is happening, it might be useful to comment out some steps by
#. Once you got the hang of how things work, remove the examples (both the files and the code in the wscript files)


Porting an existing project
===========================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in computer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So move one bit of code at a time to the template, understand what is going on, and move on.

* Assuming that you use git, first move all the code in the existing project to a subdirectory called old_code. Commit.
* Now move the code from the econ-project-templates over into this project, as described in the basic steps above. Make sure the examples work. Commit.
* Decide on which steps you'll likely need / use (e.g., in a simulation exercise you probably won't need any data management). Delete the directories you do not need from ``src`` and the corresponding ``ctx.recurse()`` calls in ``src/wscript``. Commit.
* Start with the data management code. To do so, comment out everything except for the recursions to the library and data_management directories from src/wscript
* Move your data files to the right new spot. Delete the ones from the template.
* Copy & paste the body of (the first steps of) your data management code to the example files, keeping the basic machinery in place. E.g., in case of the Stata template: In the ``src/data_management/clean_data.do`` script, keep the top lines (inclusion of project paths and opening of the log file). Paste your code below that and adjust the last lines saving the dta file.
* Adjust the ``src/data_management/wscript`` file with the right filenames.
* Run waf, adjusting the code for the errors you'll likely see.
* Move on step-by-step like this.



Feedback welcome!
=================

I have had a lot of feedback from former students who found this helpful. But in-class exposure to material is always different than reading up on it and I am sure that there are difficult-to-understand parts. I would love to hear about them! Please `drop me a line <mailto:hmgaudecker@gmail.com>`_ or, if you have concrete suggestions, `file an issue <https://github.com/hmgaudecker/econ-project-templates/issues>`_ on GitHub.
