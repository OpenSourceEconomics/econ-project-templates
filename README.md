# Templates for Reproducible Research Projects in Economics

![MIT license](https://img.shields.io/github/license/OpenSourceEconomics/econ-project-templates)
[![image](https://zenodo.org/badge/14557543.svg)](https://zenodo.org/badge/latestdoi/14557543)
[![Documentation Status](https://readthedocs.org/projects/econ-project-templates/badge/?version=stable)](https://econ-project-templates.readthedocs.io/en/stable/)
[![image](https://github.com/OpenSourceEconomics/econ-project-templates/actions/workflows/main.yml/badge.svg)](https://github.com/OpenSourceEconomics/econ-project-templates/actions/workflows/main.yml)
[![image](https://codecov.io/gh/OpenSourceEconomics/econ-project-templates/branch/main/graph/badge.svg)](https://codecov.io/gh/OpenSourceEconomics/econ-project-templates)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/OpenSourceEconomics/econ-project-templates/main.svg)](https://results.pre-commit.ci/latest/github/OpenSourceEconomics/econ-project-templates/main)
[![image](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

This project aims to provide a project template for economists that makes it easy to
produce reproducible research using one or more of the most frequently used programming
languages in economics (i.e Python, R, Julia, Stata).

> [!NOTE]
> While the underlying architecture supports all of the listed programming languages,
> the template project currently only implements a Python and R version.

Users and curious visitors please take a look at the
[documentation](https://econ-project-templates.readthedocs.io/en/stable/).

## Usage

To get started, create and activate the environment with

```console
$ conda/mamba env create
$ conda activate template_project
```

To build the template project, type

```console
$ pytask
```

### Transferring your own project

Open an editor and look for the template project name `"template_project"`. Replace this
with the name of your project.

You can now add new files to the project and remove the template files.

## Contributing

We welcome suggestions on anything: improving the documentation, bug reports, feature
requests. Please open an
[issue](https://github.com/OpenSourceEconomics/econ-project-templates/issues) in these
cases.

If you want to work on a specific feature, we are more than happy to get you started!
Please [get in touch briefly](https://www.wiwi.uni-bonn.de/gaudecker), this is a small
team so there is no need for a detailed formal process.

### Contributors

@hmgaudecker @timmens @tobiasraabe @mj023

### Former Contributors

@janosg @PKEuS @philippmuller @julienschat @raholler
