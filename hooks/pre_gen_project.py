"""Hooks which are executed before the template is rendered."""
import re

MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]*$"
ENVIRON_REGEX = r"^[-_a-zA-Z0-9]*$"
PYTHON_VERSION_REGEX = r"^(3)\.(11)"
PYTHON_VERSION_MIN = "3.11"


class InvalidModuleNameError(Exception):
    """Raised when the module name is invalid."""

    def __init__(self: Exception, module_name: str) -> None:
        """Initialize the exception."""
        self.message = f"""

The project slug ({module_name}) is not a valid Python module name.

Please do not use anything other than letters, numbers, and underscores '_'.
The first character must not be a number.

"""
        super().__init__(self.message)


class InvalidEnvironmentNameError(Exception):
    """Raised when the environment name is invalid."""

    def __init__(self: Exception, environment_name: str) -> None:
        """Initialize the exception."""
        self.message = f"""
ERROR: The environment name ({environment_name}) is not a valid conda environment name.

Please do not use anything other than letters, numbers, underscores '_',
and minus signs '-'.
"""
        super().__init__(self.message)


class InvalidPythonVersionError(Exception):
    """Raised when the Python version not supported."""

    def __init__(self: Exception, python_version: str) -> None:
        """Initialize the exception."""
        self.message = f"""
ERROR: The python version must be >= {PYTHON_VERSION_MIN}, got {python_version}.
"""
        super().__init__(self.message)


def main() -> None:
    """Apply pre-generation hooks."""
    module_name = "{{ cookiecutter.project_slug }}"
    if not re.match(MODULE_REGEX, module_name):
        raise InvalidModuleNameError(module_name)

    environment_name = "{{ cookiecutter.conda_environment_name }}"
    if not re.match(ENVIRON_REGEX, environment_name):
        raise InvalidEnvironmentNameError(environment_name)

    python_version = "{{ cookiecutter.python_version }}"
    if not re.match(PYTHON_VERSION_REGEX, python_version):
        raise InvalidPythonVersionError(python_version)


if __name__ == "__main__":
    main()
