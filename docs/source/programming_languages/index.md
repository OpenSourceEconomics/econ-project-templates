(programming_languages)=

# Programming Languages

The templates support a variety of programming languages.

- Python
- R
- Julia
- Stata

The base language is Python, which works out-of-the-box. In this section we show you how
to use the other languages and explain some language specific caveats.

```{note} When selecting a language in the cookiecutter {ref}`cookiecutter_dialogue` we
install all the necessary software needed to use that language for you. 
```

```{note} The usage of pytask with your chosen language should be illustrated in the
example project that was downloaded. At the moment the example project is not
implemented for R, Julia and Stata (but under more or less active development, help
appreciated!). This is why we clarify the basics here. 
```

```{warning} The use of pytask with Python differs from the other languages. While in
Python you do certain manipulations of your objects inside a task-file, in the other
languages you only specify dependencies and outputs. 
```

## R

The following is copied from [pytask-r](https://github.com/pytask-dev/pytask-r).

To create a task which runs a R script, define a task function with the `@pytask.mark.r`
decorator. The `script` keyword provides an absolute path or path relative to the task
module to the R script.

```python
import pytask


@pytask.mark.r(script="script.r")
@pytask.mark.produces("out.rds")
def task_run_r_script():
    pass
```

## Julia

The following is copied from [pytask-julia](https://github.com/pytask-dev/pytask-julia).

To create a task which runs a Julia script, define a task function with the
`@pytask.mark.julia` decorator. The `script` keyword provides an absolute path or path
relative to the task module to the Julia script.

```python
import pytask


@pytask.mark.julia(script="script.jl")
@pytask.mark.produces("out.csv")
def task_run_jl_script():
    pass
```

## Stata

The following is copied from [pytask-stata](https://github.com/pytask-dev/pytask-stata).

To create a task which runs a Stata script, define a task function with the
`@pytask.mark.stata` decorator. The `script` keyword provides an absolute path or path
relative to the task module to the Stata script.

```python
import pytask


@pytask.mark.stata(script="script.do")
@pytask.mark.produces("out.dta")
def task_run_do_script():
    pass
```
