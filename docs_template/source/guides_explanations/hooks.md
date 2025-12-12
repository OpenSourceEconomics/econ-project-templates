(pre_commit_hooks)=

# Pre-Commit Hooks

Pre-commit hooks are checks and syntax formatters that run upon every commit. If one of
the hooks fails, the commit is aborted and you have to commit again after you resolved
the issues raised by the hooks. Pre-commit hooks are defined in the
*.pre-commit-config.yaml*. The template project includes a selected set of hooks that
help maintain code quality and consistency. You can find additional hooks in the
[pre-commit documentation](https://pre-commit.com/index.html).

## Python and Jupyter

- **[ruff](https://docs.astral.sh/ruff/)**: A fast Python linter and formatter that
  combines the functionality of many tools (flake8, black, isort, etc.). It formats your
  code consistently and catches common errors automatically.
- **check-ast**: Verifies that Python files parse as valid Python syntax.
- **check-docstring-first**: Ensures docstrings are placed before code in Python files.
- **debug-statements**: Detects debugging statements (like `breakpoint()` or `pdb`) that
  shouldn't be committed.
- **[nbstripout](https://github.com/kynan/nbstripout)**: Removes output and metadata
  from Jupyter notebooks before committing, preventing large diffs and merge conflicts.

## File Formatting

- **[yamlfix](https://github.com/lyz-code/yamlfix)**: Formats YAML files consistently
  (line length, quotes, indentation).
- **[yamllint](https://github.com/adrienverge/yamllint)**: Validates YAML syntax and
  style.
- **[mdformat](https://github.com/executablebooks/mdformat)**: Formats Markdown files
  consistently. The template uses it for both standard Markdown (README.md) and MyST
  Markdown (documentation and paper).
- **check-yaml**: Validates YAML file syntax.
- **check-toml**: Validates TOML file syntax (e.g., pyproject.toml).
- **end-of-file-fixer**: Ensures files end with a newline.
- **trailing-whitespace**: Removes trailing whitespace from lines.
- **mixed-line-ending**: Enforces Unix-style (LF) line endings.
- **fix-byte-order-marker**: Removes UTF-8 byte order marks from text files.

## Repository Hygiene

- **check-added-large-files**: Prevents accidentally committing files larger than 25KB.
- **check-case-conflict**: Detects files that would conflict on case-insensitive
  filesystems.
- **check-merge-conflict**: Detects merge conflict markers that weren't resolved.
- **check-vcs-permalinks**: Ensures GitHub/GitLab links use permalinks rather than
  branch references.
- **forbid-submodules**: Prevents adding git submodules.
- **name-tests-test**: Ensures test files follow pytest naming conventions.

## Spell Checking

- **[codespell](https://github.com/codespell-project/codespell)**: Detects and fixes
  common misspellings in source code and documentation.

## Options

If you want to run the pre-commit hooks manually on all files (not just the ones that
have changed), you can run:

```console
$ pre-commit run --all-files
```

If you want to skip the pre-commit hooks for a particular commit, you can run:

```console
$ git commit -am <your commit message> --no-verify
```

But don't let errors grow large this way!
