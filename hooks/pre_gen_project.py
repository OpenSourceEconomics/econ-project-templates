import re


MODULE_REGEX = r"^[-_a-zA-Z0-9]*$"
ENVIRON_REGEX = r"^[-_a-zA-Z0-9]*$"
PYTHONVERSION_REGEX = r"^(3)\.[6-9]$"

module_name = "{{ cookiecutter.project_slug}}"

if not re.match(MODULE_REGEX, module_name):
    raise ValueError(
        f"""

ERROR: The project slug ({module_name}) is not a valid name.

Please do not use anything other than letters, numbers, underscores '_',
and minus signs '-'.

"""
    )

environment_name = "{{ cookiecutter.create_conda_environment_with_name }}"

if not re.match(ENVIRON_REGEX, environment_name):
    raise ValueError(
        f"""

ERROR: The project slug ({module_name}) is not a valid name.

Please do not use anything other than letters, numbers, underscores '_',
and minus signs '-'.

"""
    )

python_version = "{{ cookiecutter.python_version }}"

if not re.match(PYTHONVERSION_REGEX, python_version):
    raise ValueError(
        """

        ERROR: The python version must be >= 3.6

        """
    )
