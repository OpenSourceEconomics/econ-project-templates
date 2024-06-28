Once you've created a new repository from the template, you can begin customising it to
meet your specific needs. This process may involve deleting certain files, renaming
others, and modifying the configuration settings.

### First step

Before changing anything else, you should rename the project. In your preferred editor
search for `"template_project"` and replace it with a concise version of your project's
name

```{warning}
This shortened project name must be a valid Python identifier, i.e., no spaces, hyphens,
or the like. Just letters, numbers, underscores. Do not start with a number.
```

### Running the project

Prior to modifying the template, confirm that the project functions correctly on your
system. This step is essential to ensure that any subsequent issues can be attributed to
changes you make rather than the original template.

1. Open a terminal, navigate to the project root, and install the necessary
   dependencies:

   ```console
   $ cd /to/root/of/template
   $ conda env create -f environment.yml
   ```

1. Activate the installed environment

   ```console
   $ conda activate template_project
   ```

   ```{note}
   Remember to activate the environment whenever you start a new terminal session.
   ```

1. Install the pre-commit hooks

   ```console
   $ pre-commit install
   ```

   ```{note}
   Installation of pre-commit hooks is mandatory for their functionality. Repeat this
   step on each new machine where you work on the project.
   ```

1. Run the project

   ```console
   $ pytask
   ```

All programs used within this project template need to be found on your path, see above
({ref}`preparing_your_system` and the {ref}`faq`).

If all went well, you are now ready to adapt the template to your project.

### Customising the template

#### File management

Before proceeding, delete the following items as they are not part of the essential
template:

- `docs` folder
- `.readthedocs.yml` file
- `CHANGES.md` file

#### Content updates

Review and update the following files to reflect your project's details. Replace
placeholder names, email addresses, and repository links with your own:

- `README.md`

- `pyproject.toml`

- `LICENSE`

- `environment.yml`

- `CITATION`

- `.gitignore`

  Here you can remove the part

  ```
  # documentation
  docs/build/
  docs/scripts/latex/*.png
  ```

  and add any file or folder that is specific to your project which should not be
  tracked by git.

#### Changing adjustments

The included pre-commit hooks (specified in `.pre-commit-config.yaml`) may require
adjustments to align with your project's needs. Refer to {ref}`pre_commit_hooks` for
more details.

### Next steps

Depending on what your needs are, move on with the section on
{ref}`starting_from_scratch` or on {ref}`porting_existing_project`.
