.. _getting_started:

Getting Started
===============

Here, we first describe in :ref:`preparing_your_system` how you need to set up your
computer so that everything plays well together. In :ref:`dialogue`, you will find
detailed explanations on what you may want to choose when configuring the templates for
your needs. Once you are done with that, you may want to check the
:ref:`starting_a_new_project` section. We also provide more detailed explainations
of :ref:`environments` and :ref:`pre_commit_hooks`. You can click through the pages or jump
straight to the corresponding sections:

.. toctree::
    :maxdepth: 1

    starting
    environments
    hooks


So, ...

* If you want to first get an idea of whether this is the right thing for you, start by
  reading through the :ref:`introduction` and the :ref:`python_section` or the
  :ref:`r_section` section, whichever is most relevant for you.
* If you are hooked already and want to try it out, continue right here with
  :ref:`preparing_your_system`.
* If you have done this before, you can jump directly to :ref:`dialogue`.


.. _preparing_your_system:

Preparing your system
*********************


1.  Make sure you have the following programs installed and that these can be found on
    your path. This template requires

  * `Miniconda <http://conda.pydata.org/miniconda.html>`_ or Anaconda. Windows users:
    please consult :ref:`windows_user`

    .. note::

        This template is tested with python 3.6 and higher and conda version 4.7.12 and
        higher. Use conda 4.6-4.7.11 at your own risk; conda versions 4.5 and below will
        not work under any circumstances.

  * a modern LaTeX distribution (e.g. `TeXLive <www.tug.org/texlive/>`_, `MacTex
    <http://tug.org/mactex/>`_, or `MikTex <http://miktex.org/>`_)

  * `Git <https://git-scm.com/downloads>`_, windows users please also consult
    :ref:`git_windows`

  * The text editor `VS Code <https://code.visualstudio.com/>`_, unless you know what
    you are doing.


2. If you are on Windows, please open the Windows Powershell. On Mac or Linux, open a
   terminal. As everything will be started from the Powershell/Terminal, you need to
   make sure that all programmes you need in your project (for sure Anaconda Python,
   Git, and LaTeX; potentially VS Code, Stata, R, Matlab) can be found on your *PATH*.
   That is, these need to be accessible from your shell. This often requires a bit of
   manual work, in particular on Windows.

   - To see which programmes can be found in your path, type (leave out the leading
     dollar sign, this is just standard notation for a command line prompt):

     Windows

       .. code-block:: powershell

         $ echo $env:path

     Mac/Linux

       .. code-block:: bash

         $ echo $PATH

     This gives you a list of directories that are available on your *PATH*.

    ..
      comment:: Example output? Maybe example on how you added e.g. VS Code to the path

    - Check that this list contains the path to the programs you want to use in your
      project, in particular, Anaconda (this contains your Python distribution), a LaTeX
      distribution, the text editor VS Code, Git, and any other program that you need
      for your project (Stata, R, Matlab). Otherwise add them by looking up their paths
      on your computer and follow the steps described here :ref:`path_windows` or
      :ref:`path_mac`.
    ..
      comment:: does this mean, just look if it says Anaconda somewhere?


    - If you added any directory to *PATH*, you need to close and reopen your shell, so
      that this change is implemented.

    - To be on the safe side regarding your paths, you can check directly whether you
      can launch the programmes. For Python, type:

        .. code-block:: text

            $ python
            >>> exit()

      This starts python in your shell and exits from it again. The top line should
      indicate that you are using a Python distribution provided by Anaconda. Here is an
      example output obtained using Windows PowerShell:

        .. code-block:: text

            Python 3.9.9 | packaged by conda-forge | (main, Dec 20 2021, 02:40:17)
            [GCC 9.4.0] on linux
            Type "help", "copyright", "credits" or "license" for more information.

     For Git, type:

        .. code-block:: bash

             $ git status

     Unless you are in a location where you expect a Git repository, this should yield
     the output:
        ..
          comment:: what if there is a git repository?


        .. code-block:: bash

            fatal: not a git repository (or any of the parent directories): .git

     To start and exit pdflatex.

         .. code-block:: bash

           $ pdflatex
           $ X
      ..
        comment:: So this converts an existing .tex file to a pdf? Why needed here?

     An editor window should open after typing:

         .. code-block:: bash

           $ code

      ..
        comment:: Does not work for me.


     If required, do the same for Stata, R, or Matlab — see :ref:`here
     <starting_programs_from_the_command_line>` for the precise commands you may need.

3. In the Powershell/Terminal, navigate to the parent folder of your future project.

   ..
     comment:: that this is done with 'cd' is probably clear?


   Now type ``pwd``, which prints the absolute path to your present working directory.
   **There must not be any spaces or special characters in the path** (for instance ä,
   ü, é, Chinese or Kyrillic characters).

   If you have any spaces or special characters on your path, change to a folder that
   does not have these special characters (e.g., on Windows, create a directory
   ``C:\projects``. Do **not** rename your home directory).

   Type ``git status``, this should yield the output:
      ..
        comment:: as one should not be in a git repository

      .. code-block:: bash

          fatal: not a git repository (or any of the parent directories): .git


4. The template uses `cookiecutter <https://cookiecutter.readthedocs.io/en/latest/>`_ to
   enable personalized installations. Before you start, install cookiecutter on your
   system.

  .. code-block:: bash

    $ pip install cookiecutter

  All additional dependencies will be installed into a newly created conda environment
  which is installed upon project creation.


  ..
    comment:: don't understand 'which is installed upon project creation', maybe just
    without that part?

  .. warning::

    If you do not opt for the conda environment later on, you need to take care of these
    dependencies by yourself. A list of additional dependencies can be found under
    :ref:`dependencies`.

5. If you intend to use a remote Git repository, create it if necessary and hold the URL
   ready.
