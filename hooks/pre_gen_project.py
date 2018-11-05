import re


MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]*$"
ENVIRON_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]*$"

module_name = "{{ cookiecutter.project_slug}}"

if not re.match(MODULE_REGEX, module_name):
    raise ValueError(
        f"""

ERROR: The project slug ({module_name}) is not a valid Python module name. 

Please do not use anything other than letters, numbers and '_',
and do not start with a number.

"""
    )

environment_name = "{{ cookiecutter.create_conda_environment_with_name }}"

if not re.match(ENVIRON_REGEX, environment_name):
    raise ValueError(
        f"""

    ERROR: The project slug ({environment_name}) is not a valid Python module name. 

    Please do not use anything other than letters, numbers and '_',
    and do not start with a number.

    """
    )
