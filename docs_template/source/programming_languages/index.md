(programming_languages)=

# Programming Languages

The templates support a variety of programming languages. Python and R are
pre-configured in the template, you can create your own task functions by adjusting
those.

Julia and Stata basically work like R, but are not pre-configured in the template. See
tiny examples below, and the links to the respective pytask plugins for more
information.

## Julia

The following is copied from [pytask-julia](https://github.com/pytask-dev/pytask-julia).

To create a task which runs a Julia script, define a task function with the
`@mark.julia` decorator. The `script` keyword provides an absolute path or path relative
to the task module to the Julia script.

```python
from pathlib import Path
from pytask import mark, task


@task(kwargs={"path": Path("out.csv")})
@mark.julia(script="script.jl")
def task_run_jl_script():
    pass
```

## Stata

The following is copied from [pytask-stata](https://github.com/pytask-dev/pytask-stata).

To create a task which runs a Stata script, define a task function with the
`@mark.stata` decorator. The `script` keyword provides an absolute path or path relative
to the task module to the Stata script.

```python
import pytask


@task(kwargs={"path": Path("auto.dta")})
@mark.stata(script="script.do")
def task_run_do_file():
    pass
```
