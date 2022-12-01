### Program installation

1. Make sure you have the following programs installed and that these can be found on
   your path. This template requires

- [Miniconda](https://docs.conda.io/en/latest/miniconda.html) or Anaconda. Windows
  users: please consult {ref}`windows_user`

  ```{note} This template is tested with python 3.9 and higher and conda version 22.9
  ```

- a modern LaTeX distribution (e.g. [TeXLive](https://tug.org/texlive/),
  [MacTex](https://tug.org/mactex/), or [MikTex](https://miktex.org/))

- [Git](https://git-scm.com/downloads), Windows users please also consult
  {ref}`git_windows`

- The text editor [VS Code](https://code.visualstudio.com/), unless you know what you
  are doing.

### Validating the installation paths

2. If you are on Windows, please open the Windows Powershell. On Mac or Linux, open a
   terminal. As everything will be started from the Powershell/Terminal, you need to
   make sure that all programmes you need in your project (for sure Anaconda Python,
   Git, and LaTeX; potentially VS Code, R, Julia, Stata) can be found on your *PATH*.
   That is, these need to be accessible from your shell. This often requires a bit of
   manual work, in particular on Windows.

- To see which programmes can be found on your path, type (leave out the leading dollar
  sign, this is just standard notation for a command line prompt):

  Windows

  ```powershell
  $ echo $env:path
  ```

  Mac/Linux

  ```console
  $ echo $PATH
  ```

  This gives you a list of directories that are available on your *PATH*.

- Check that this list contains the path to the programs you want to use in your
  project, in particular, Anaconda (this contains your Python distribution), a LaTeX
  distribution, the text editor VS Code, Git, and any other program that you need for
  your project (R, Julia, Stata). Otherwise add them by looking up their paths on your
  computer and follow the steps described here {ref}`path_windows` or {ref}`path_mac`.

- If you added any directory to *PATH*, you need to close and reopen your shell, so that
  this change is implemented.

- To be on the safe side regarding your paths, you can check directly whether you can
  launch the programmes. For Python, type:

  ```console
  $ python
  >>> exit()
  ```

  This starts python in your shell and exits from it again. The top line should indicate
  that you are using a Python distribution provided by Anaconda. Here is an example
  output obtained using Windows PowerShell:

  ```text
  Python 3.9.9 | packaged by conda-forge | (main, Dec 20 2021, 02:40:17)
  [GCC 9.4.0] on linux
  Type "help", "copyright", "credits" or "license" for more information.
  ```

  For Git, type:

  ```console
  $ git status
  ```

  Unless you are in a location where you expect a Git repository, this should yield the
  output:

  ```console
  fatal: not a git repository (or any of the parent directories): .git
  ```

  If a Git repository is present, delete it or go to another directory before starting
  cookiecutter below.

  To start and exit pdflatex.

  ```console
  $ pdflatex
  $ X
  ```

  An editor window should open after typing:

  ```console
  $ code
  ```

  If required, do the same for R, Julia, or Stata.

### Validating Git

3. In the Powershell/Terminal, navigate to the parent folder of your future project.

   Now type `pwd`, which prints the absolute path to your present working directory.
   **There must not be any spaces or special characters in the path** (for instance ä,
   ü, é, Chinese or Cyrillic characters).

   If you have any spaces or special characters on your path, change to a folder that
   does not have these special characters (e.g., on Windows, create a directory
   `C:\projects`. Do **not** rename your home directory).

   Type `git status` , this should yield the output:

   ```console
   fatal: not a git repository (or any of the parent directories): .git
   ```

### Installing cookiecutter

4. The template uses [cookiecutter](https://cookiecutter.readthedocs.io/en/latest/) to
   enable personalized installations. Before you start, install cookiecutter on your
   system.

   ```console
   $ pip install cookiecutter
   ```

   All additional dependencies will be installed into a newly created conda environment
   upon project creation.

   ```{warning} If you do not opt for the conda environment later on, you need to take
   care of these dependencies by yourself.
   ```
