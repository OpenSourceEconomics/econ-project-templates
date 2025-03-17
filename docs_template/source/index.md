# Templates for Reproducible Research: Documentation

(introduction)=

## Introduction

An empirical or computational research project only becomes a useful building block for
science and policy when all steps can be easily repeated and modified by others.

Hence, some actions should be absent as much as possible. This includes copying and
pasting, pointing and clicking with a mouse, or other forms of interactive input, which
are not stored as part of the project.

The idea behind these templates is that the researcher specifies a set of tasks, which
are executed in the correct order as required. The only input for (re-)producing results
will be the action setting this pipeline to run.

This code base aims to provide two stepping stones to assist you in achieving this goal:

1. A sensible directory structure. This will save you a bunch of thinking about this
   structure time and again, which typically happens when incrementally building up a
   new project. Put differently, instead of starting from scratch, you modify an example
   for your needs.
1. A pre-configured [computational environment](environments) including useful tools
   [pytask](https://pytask-dev.readthedocs.io/en/stable/) and
   [pre-commit hooks](pre_commit_hooks). These tools help you to automate the workflow
   of your project and to maintain a clean code base.

The first should lure you in quickly. The second should convince you to stick to the
tools in the long run – unless you have fought with large research projects before, at
this point you may think that all of this is overkill and far more difficult than
necessary. It is not. _\[although I am always_
[happy to hear](https://www.wiwi.uni-bonn.de/gaudecker/) _about easier alternatives\]_

The example uses Python code also for the "research part". However,
[pytask](https://pytask-dev.readthedocs.io/en/stable/) supports several popular
languages ([R](https://github.com/pytask-dev/pytask-r),
[Julia](https://github.com/pytask-dev/pytask-julia),
[Stata](https://github.com/pytask-dev/pytask-stata)). Since pytask does not require a
whole lot of Python knowledge, you may find the template useful in order to make your
pipeline reproducible in languages you are more comfortable with. It is also an easy
option in order to mix languages in your project. In fact, until
[version 0.9](https://econ-project-templates.readthedocs.io/en/v0.9.0/), the template
included its worked example in R, too. We dropped it purely for lack of resources to
maintain it.

## Navigating this Documentation

When starting freshly, go to the next section for finding out how to prepare your
machine and how to get started with the template. The {ref}`background` section explains
many of the design choices; feel free to skip if you worked with the templates before.
{ref}`guides_explanations` provides some tips and tricks for usage, depending on whether
you want to start a new project from scratch or port existing code into the structure
suggested in this project. The page also points you to some useful features of helper
programmes that come with the templates. The documentation follows the Python version of
the running example; see {ref}`programming_languages` for additional options.

```{toctree}
---
maxdepth: 1
---
getting_started/index
background/index
guides_explanations/index
programming_languages/index
faq
development/index
release_notes
zreferences
```
