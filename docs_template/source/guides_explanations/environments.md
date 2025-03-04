Progammes change. Few things are as frustrating as coming back to a project after a long
time and spending the first {hours, days} updating your code to work with a new version
of your favourite data analysis library. The same holds for debugging errors that occur
only because your coauthor uses a slightly different setup.

The solution is to have isolated environments on a per-project basis.
[Pixi environments](https://pixi.sh/latest/tutorials/python/) allow you to do precisely
this. This page describes them a little bit and explains their use.

The following commands can either be executed in a terminal or the Powershell (Windows).

### Using the environment

Pixi environments are created automatically when a command is run via `pixi run [...]`,
or when one manually runs `pixi install`. The environment is downloaded into the hidden
folder `.pixi` in your project root.

### Setting up a new environment

A pixi environment is always created on a per-project basis. That means, it only makes
sense to create a new environment, if you create a new project.

If you want to do this, you can simply follow the instructions in the
[template setup guide](../getting_started/template_setup.md).

### Updating packages

Make sure that you are in the project root and run

```console
$ pixi update
```

to update all packages, or run

```console
$ pixi update [package]
```

to update a specific `[package]`.

### Installing additional packages

To list installed packages, activate the environment and type

```console
$ pixi list
```

If you want to add a package to your environment, you can add the package to the
`[tool.pixi.dependencies]` section in the pyproject.toml file. Alternatively, you can
run

```console
$ pixi add [package]
```

You will notice that the pixi section in the pyproject.toml file is then also updated
with the added package.

**Choosing between conda-forge and PyPI**

Generally it is recommended to use *conda-forge* whenever possible. It is a necessity
for many scientific packages. These often are not pure-Python code and pip is built
mainly for that. For pure-Python packages, sometimes nobody bothered to set up a
conda-forge package and we use *pip*.

If you add a package under `[tool.pixi.dependencies]` in the pyproject.toml file, pixi
will try to install the package via conda-forge. If you add a package under
`[tool.pixi.pypi-dependencies]`, pixi will try to install the package from PyPI.
