import re
import sys

MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]+$"

module_name = "{{ cookiecutter.project_slug}}"

if not re.match(MODULE_REGEX, module_name):
    print(
        "ERROR: The project slug (%s) is not a valid Python module name. "
        "Please do not use anything other than letters, numbers and _".format(
            module_name
        )
    )

    # Exit to cancel project
    sys.exit(1)

environment_name = "{{ cookiecutter.create_conda_environment_with_name }}"
environ_regex = r"^[_a-zA-Z][_a-zA-Z0-9]+$"

if not re.match(environ_regex,environment_name):
    print("ERROR: The environment name {} is not valid. )"
          "Please do not use anything other than letters, numbers and _").format(environment_name)
    sys.exit(1)

