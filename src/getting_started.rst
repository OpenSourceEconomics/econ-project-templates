.. _getting_started:

***************
Getting started
***************

Basic steps
===========

The basic steps are very easy:

    #. If you are familiar with Git, clone the `econ-project-templates repository <https://github.com/hmgaudecker/econ-project-templates>`_ and switch to the branch named after the main language in your project.

       Else, you can use these links:

       * `Template for Python-based projects <https://github.com/hmgaudecker/econ-project-templates/archive/python.zip>`_
       * `Template for Matlab-based projects <https://github.com/hmgaudecker/econ-project-templates/archive/matlab.zip>`_
       * `Template for Stata-based projects <https://github.com/hmgaudecker/econ-project-templates/archive/stata.zip>`_
       * `Template for R-based projects <https://github.com/hmgaudecker/econ-project-templates/archive/R.zip>`_
      
       In case you want to mix languages, you can always check the examples from a different template.
    #. Follow the steps in the *README.md* file in the root directory of the project template that you downloaded. This will make sure that the basic setup is working on your machine.


Starting a new project
======================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in conputer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So write one bit of code at a time, understand what is going on, and move on.


#. I suggest you leave the examples in place.
#. Now add your own data and code bit by bit, append the wscript files as necessary. To see what is happening, it might be useful to commment out some steps by 
#. Once you got the hang of how things work, remove the examples (both the files and the code in the wscript files)


Porting an existing project
===========================

Your general strategy should be one of **divide and conquer**. If you are not used to thinking in conputer science / software engineering terms, it will be hard to wrap your head around a lot of the things going on. So move one bit of code at a time to the template, understand what is going on, and move on.

* Assuming that you use git, first move all the code in the existing project to a directory called old_code. Commit.
* Now move the code from the exon-project-templates over, as described … Commit.
* Decide on which steps you'll likely need / use and delete the other directories from src and the corresponding ctx.recurse() calls in src/wscript (e.g., documentation)
* Start with the data management code. To do so, comment out everything except for the recursions to the library and data_management directories from src/wscript
* Move your data files to the right new spot. Delete the ones from the template.
* Now copy & paste the body of (the first steps of) your data management code to the src/data_management/clean_data.do script. Keep the top lines (inclusion of project paths and opening of the log file and adjust the last lines saving the dta file.
* Adjust the src/data_management/wscript file with the right filenames. 
* Run waf, adjusting the code for the errors you'll likely see.



Feedback welcome!
=================

I have had a lot of feedback from former students who found this helpful. But in-class exposure to material is always different than reading up on it and I am sure that there are difficult-to-understand parts. I would love to hear about them! Please `drop me a line <mailto:hmgaudecker@gmail.com>`_ or, if you have concrete suggestions, `file an issue <https://github.com/hmgaudecker/econ-project-templates/issues>`_ on GitHub.
