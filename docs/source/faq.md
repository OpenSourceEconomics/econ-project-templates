(faq)=

# FAQ

(windows_user)=

## Tips and Tricks for Windows Users

**Anaconda Installation Notes for Windows Users**

Please follow these steps unless you know what you are doing.

1. Download the [Graphical Installer](https://www.anaconda.com/distribution/#windows)
   for Python 3.x.

1. Start the installer and click yourself through the menu. If you have administrator
   privileges on your computer, it is preferable to install Anaconda for all users.
   Otherwise, you may run into problems when running python from your powershell.

1. Make sure to (only) tick the following box:

   - ''Register Anaconda as my default Python 3.x''. Finish installation.

1. Navigate to the folder containing your Anaconda distribution. This folder contains
   multiple subfolders. Please add the path to the folder called `condabin` to your
   *PATH* environmental variable. This path should end in `Anaconda3/condabin`. You can
   add paths to your *PATH* by following these
   [instructions](https://www.computerhope.com/issues/ch000549.htm).

1. Please start Windows Powershell in administrator mode, and execute the following:

   ```bash
   $ set-executionpolicy remotesigned
   ```

1. Now (re-)open Windows Powershell and initialize it for full conda use by running

   ```bash
   $ conda init
   ```

```{warning} If you still run into problems when running conda and python from
powershell, it is advisable to use the built-in Anaconda Prompt instead. 
```

(git_windows)=

### Integrating git tab completion in Windows Powershell

Powershell does not support tab completion for git automatically. However, there is a
nice utility called [posh-git](https://github.com/dahlbyk/posh-git). We advise you to
install this as this makes your life easier.

(path_windows)=

### PATH environmental variable in Windows

In Windows, one has to oftentimes add the programs manually to the *PATH* environmental
variable in the Advanced System Settings. See
[here](https://www.computerhope.com/issues/ch000549.htm) for a detailed explanation of
how to do that.

(path_mac)=

### Adding directories to the PATH: MacOS and Linux

Open the program **Terminal**. You will need to add a line to the file `.bash_profile`
and potentially create the file. This file lives in your home directory, in the Finder
it is hidden from your view by default.

**Linux users**: For most distributions, everything here applies to the file `.bashrc`
instead of `.bash_profile`.

I will now provide a step-by-step guide of how to create / adjust this file using the
editor called `code`. If you are familiar with editing text files, just use your editor
of choice.

1. Open a Terminal and type

   ```bash
   code ~/.bash_profile
   ```

   If you use an editor other than [VS Code](https://code.visualstudio.com/), replace
   `code` by the respective editor.

   If `.bash_profile` already existed, you will see some text at this point. If so, use
   the arrow keys to scroll all the way to the bottom of the file.

1. Add the following line at the end of the file

   ```bash
   export PATH="${PATH}:/path/to/program/inside/package"
   ```

   You will need to follow the same steps as before. Example for Stata:

   ```bash
   # Stata directory
   export PATH="${PATH}:/Applications/Stata/StataMP.app/Contents/MacOS/"
   ```

   In `/Applications/Stata/StataMP.app`, you may need to replace bits and pieces as
   appropriate for your installation (e.g. you might not have StataMP but StataSE).

   Similarly for Matlab or the likes.

1. Press `Return` and then `ctrl+o` (= WriteOut = save) and `Return` once more.

(cookiecutter_trouble)=

### When cookiecutter exits with an error

If cookiecutter fails, you will get a lengthy error message. It is important that you
work through this and try to understand the error (the language used might seem funny,
but it is precise...).

Then type:

```bash
$ code ~/.cookiecutter_replay/econ-project-templates-0.5.1.json
```

If you are not using VS Code as your editor of choice, adjust the line accordingly.

This command should open your editor and show you a json file containing your answers to
the previously filled out dialogue. You can fix your faulty settings in this file. If
you have spaces or special characters in your path, you need to adjust your path.

When done, launch a new shell if necessary and type:

```bash
$ cookiecutter --replay https://github.com/OpenSourceEconomics/econ-project-templates/archive/v0.5.1.zip
```

(stata_failure_check_erase_log_file)=

### Stata failure: FileNotFoundError

The following failure:

```
FileNotFoundError: No such file or directory: '/Users/xxx/econ/econ project templates/bld/add_variables.log'
```

has a simple solution: **Get rid of all spaces in the path to the project.** (i.e.,
`econ-project-templates` instead of `econ project templates` in this case). To do so, do
**not** rename your user directory, that will cause havoc. Rather move the project
folder to a different location.

I have not been able to get Stata working with spaces in the path in batch mode, so this
has nothing to do with Python or pytask. If anybody finds a solution, please let me
know.

### Stata failure: missing file

If you see an error like this one:

```
-> missing file: '/Users/xxx/econ/econ-project/templates/bld/add_variables.log'
```

check that you have a license for the Stata version that is found (the Stata tool just
checks availability top-down, i.e., MP-SE-IC, in case an MP-Version is found and you
just have a license for SE, Stata will silently refuse to start up).

The solution is to remove all versions of Stata from its executable directory (e.g.,
/usr/local/stata) that cost more than your license did.
