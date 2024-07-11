Pre-commit hooks are checks and syntax formatters that run upon every commit. If one of
the hooks fails, the commit is aborted and you have to commit again after you resolved
the issues raised by the hooks. Pre-commit hooks are defined in the
*.pre-commit-config.yaml*. template_project contains most hooks you will need. Below we
present three common hooks. Note that some hooks are programming language agnostic while
others work on a specific language. You can find a list of most hooks in the
[pre-commit documentation](https://pre-commit.com/index.html) under Supported hooks.

- [ruff](https://docs.astral.sh/ruff/): Formats your Python code and checks for errors.
  Ruff-formatted code looks the same regardless of the project you're reading. Having
  ruff as a hook allows you to focus on the content while writing code and let the
  formatting along with catching of many errors be done automatically before each
  commit.
- [check-yaml](https://github.com/pre-commit/pre-commit-hooks): Checks whether all .yaml
  and .yml files within your project are valid yaml files. Similarly, having check-yaml
  as a hook allows you to focus on the content while writing yaml files. If you
  accidentally use a wrong syntax this hook will tell you before you commit.
- [codespell](https://github.com/codespell-project/codespell): Fixes common misspellings
  in text files. It's designed primarily for checking misspelled words in source code,
  but it can be used with other files as well.

If you want to skip the pre-commit hooks for a particular commit, you can run:

```console
$ git commit -am <your commit message> --no-verify
```
