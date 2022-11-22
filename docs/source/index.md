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
2. A pre-configured instance of [pytask](https://pytask-dev.readthedocs.io), which
   facilitates the reproducibility of your research findings from the beginning to the
   end by letting the computer handle the project's workflow.

The first should lure you in quickly. The second should convince you to stick to the
tools in the long run – unless you have fought with large research projects before, at
this point you nay think that all of this is overkill and far more difficult than
necessary. It is not. *\[although I am always* [happy to hear](https://www.wiwi.uni-bonn.de/gaudecker/) *about easier alternatives\]*

The templates support a variety of programming languages already. They can be easily
extended to cover others. Everything is tied together by [pytask](https://pytask-dev.readthedocs.io), which is written in [Python](http://www.python.org/). You do not need to know a lot of Python to use these tools,
though.

## Navigating this Documentation

```{eval-rst}
.. todo::

   Complete
```

If you are a complete novice, you should read carefully through the entire documents. We
suggest starting with the section {ref}`getting_started`. Once you've finished that we
recommend reading the {ref}`background` section.

```{toctree}
:maxdepth: 1

getting_started/index
background/index
guides_explanations/index
programming_languages/index
faq
development/index
zreferences
```
