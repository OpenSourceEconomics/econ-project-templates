# Econ Project Templates: Modern, Reproducible Research in Economics

![MIT license](https://img.shields.io/github/license/OpenSourceEconomics/econ-project-templates)
[![Documentation Status](https://readthedocs.org/projects/econ-project-templates/badge/?version=stable)](https://econ-project-templates.readthedocs.io/en/stable/)
[![image](https://github.com/OpenSourceEconomics/econ-project-templates/actions/workflows/main.yml/badge.svg)](https://github.com/OpenSourceEconomics/econ-project-templates/actions/workflows/main.yml)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/OpenSourceEconomics/econ-project-templates/main.svg)](https://results.pre-commit.ci/latest/github/OpenSourceEconomics/econ-project-templates/main)

This project provides a "batteries-included" template for economists to produce fully
reproducible research. It replaces fragile, manual workflows with a robust, automated
pipeline.

## Why Reproducibility?

Reproducibility is about **your peace of mind**. It means knowing that if you find a
mistake in your raw data three days before submission, you can re-run your entire
project—tables, figures, and paper—with a single command. It means your future self (and
your co-authors) can understand and run your code on a new machine without spending a
week fighting dependency hell.

## Quick Start (The "Magic" Moment)

Experience the reproducibility of this template in less than five minutes:

1. **Install [Pixi](https://pixi.sh/)** (our only prerequisite).
1. **Clone this repository**.
1. **Run and view the results**:

```bash
# View the research paper in your browser
pixi run view-paper

# View the presentation slides
pixi run view-pres
```

These commands automatically handle environment setup, data cleaning, analysis, and
launching the output servers.

## Documentation

Full documentation is available at
[econ-project-templates.readthedocs.io](https://econ-project-templates.readthedocs.io/).

## Contributing

We welcome suggestions on anything from improving the documentation to reporting bugs
and requesting new features. Please open an
[issue](https://github.com/OpenSourceEconomics/econ-project-templates/issues) in these
cases.

### Contributors

@hmgaudecker @timmens

### Former Contributor and Creator of pytask

@tobiasraabe
