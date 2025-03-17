(faq)=

# FAQ

(windows_user)=

(path_windows)=

## PATH environmental variable in Windows

In Windows, one has to oftentimes add the programs manually to the *PATH* environmental
variable in the Advanced System Settings. See
[here](https://www.computerhope.com/issues/ch000549.htm) for a detailed explanation of
how to do that.

(path_mac)=

## Adding directories to the PATH: MacOS and Linux

Open the program **Terminal**. First, you will need to determine the shell you are
using:

```zsh
echo $SHELL
```

The output will be something like `/bin/bash` or `/bin/zsh`. Depending on the output,
the below applies either to the file `.bashrc` or `.zshrc`. Both of them live in your
home directory and are read every time you open a new terminal.

I will now provide a step-by-step guide of how to create / adjust the file `.zshrc`
using the editor [VS Code](https://code.visualstudio.com/), which you can typically
start from a shell by typing `code`. If you are familiar with editing text files, just
use your editor of choice. If you are using a `bash` shell, replace `.zshrc` with
`.bashrc` in the following.

1. Open a Terminal and type

   ```zsh
   code ~/.zshrc
   ```

   If `.zshrc` already existed, you will see some text at this point. If so, use the
   arrow keys to scroll all the way to the bottom of the file.

1. Add the following line at the end of the file

   ```zsh
   export PATH="${PATH}:/path/to/program/inside/package"
   ```

   You will need to follow the same steps as before. Example for Stata:

   ```zsh
   # Stata directory
   export PATH="${PATH}:/Applications/Stata/StataMP.app/Contents/MacOS/"
   ```

   In `/Applications/Stata/StataMP.app`, you may need to replace bits and pieces as
   appropriate for your installation (e.g. you might not have StataMP but StataSE).

   Similarly for Matlab or the likes.

1. Press `Return` and then `ctrl+o` (= WriteOut = save) and `Return` once more.

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
