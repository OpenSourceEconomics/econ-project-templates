(directory_structure)=

## Directory Structure

### The big picture

The following graph shows the contents of template_project root directory after
executing `pytask`

```{figure} ../figures/generated/root_bld_src.png
---
width: 45em
---
```

Files and directories in yellow are constructed by pytask; those with a bluish
background are added directly by the researcher. You immediately see the **separation of
inputs** and outputs (one of our guiding principles) at work:

- All source code is in the src directory
- All outputs are constructed in the bld directory

```{note} The paper and presentation are copied to the root so they can be opened easily

```

The contents of both the root/bld and the root/src directories directly follow the steps
of the analysis from the workflow section.

The idea is that everything that needs to be run during the, say, **analysis** step, is
specified in root/src/analysis and all its output is placed in root/bld/analysis.

Some differences:

- Because they are accessed frequently, figures and the like get extra directories in
  root/bld

- The directory root/src contains many more subdirectories and files:

### Zooming in

Lets go one step deeper and consider the root/src directory in more detail:

```{figure} ../figures/generated/src.png
---
width: 40em
---
```

It is imperative that you do all the task handling inside the `task_xxx.py`-scripts,
using the [pathlib](https://realpython.com/python-pathlib/) library. This ensures that
your project can be used on different machines and it minimises the potential for
cross-platform errors.

For running Python source code from pytask, simply include `depends_on` and `produces`
as inputs to your function.

For running scripts in other languages, pass all required files (inputs, log files,
outputs) as arguments to the `@pytask.mark.[x]`-decorator. You can then read them in.
Check the sections on different programming languages for examples.
