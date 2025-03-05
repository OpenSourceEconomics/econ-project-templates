Once you've created a new repository from the template, you can begin customising it to
meet your specific needs.

### First step: Rename the project

Open the entire directory in VS Code. Search for `template_project` in the entire
codebase and replace it with `new_project_name`, i.e., a concise version of your
project's name (often called a "slug"). Rename the folder `src/template_project` to
`src/<new_project_name>`!

```{warning}
Your project slug `new_project_name` must be a valid Python identifier, i.e., it must
consist of letters, numbers, and underscores only. Do not start with a number. There
must not be any spaces, hyphens, or the like in the slug.
```

### Running the project

Prior to modifying anything but the slug, confirm that the template can be executed on
your system. This step is essential to ensure that any subsequent issues can be
attributed to changes you make rather than the original template.

1. Open a terminal and navigate to the project root

   ```console
   $ cd /to/root/of/template_project
   ```

1. Install the pre-commit hooks

   ```console
   $ pixi global install pre-commit
   $ pre-commit install
   ```

   ```{note}
   Installation of pre-commit hooks is mandatory for their functionality. Repeat this
   step on each new machine where you work on the project.
   ```

1. Run the project

   ```console
   $ pixi run pytask
   ```

   All programs used within this project template need to be found on your path, see
   above ({ref}`preparing_your_system` and the {ref}`faq`).

If all went well, you are now ready to adapt the template to your project.

### Customising the template

#### Removing auxiliary files

Before proceeding, delete the following items as they correspond to the meta project and
not the template itself.

- `docs_template` folder
- `.github` folder
- `CHANGES_template.md` file
- `tests/test_template.py` file

#### Find and replace placeholders

Now, search for and replace the following placeholders in the entire codebase.

| Placeholder                                                   | Replacement                                       |
| ------------------------------------------------------------- | ------------------------------------------------- |
| JANE DOE                                                      | Your full name                                    |
| EXAMPLE PROJECT                                               | Your project's name                               |
| EXAMPLE UNIVERSITY                                            | Your university's name                            |
| DOE2024                                                       | Your project's citation identifier                |
| https://github.com/OpenSourceEconomics/econ-project-templates | The GitHub repo URL corresponding to your project |

#### Review and update project details

Once you are done with the replacement of placeholders, you can update the contents of
the following files.

| File             | What to do                                                                                                                                                           |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `README.md`      | Remove the entire content and replace it with a README for your project                                                                                              |
| `pyproject.toml` | Update the project description and add any dependencies you will need                                                                                                |
| `LICENSE`        | Update the year and name with the current year and your name                                                                                                         |
| `.gitignore`     | 1. Remove the part that is not relevant to your project, that includes all lines that start with `docs_template`<br> 2. Add any files you need to be ignored by git. |

#### Changing tool options

Finally, you can update options of the included tools. The pre-commit hooks (specified
in `.pre-commit-config.yaml`) may require adjustments to align with your project's
needs. Refer to the {ref}`pre_commit_hooks` section for more details.

### Next steps

Depending on what your needs are, move on with the section on
{ref}`starting_from_scratch` or on {ref}`porting_existing_project`.
