"""Utilities used in various parts of the project."""

from pathlib import Path

import yaml


def read_yaml(path: Path):
    """Read a YAML file.

    Args:
        path: Path to file.

    Returns:
        dict: The parsed YAML file.

    """
    with path.open() as stream:
        try:
            out = yaml.safe_load(stream)
        except yaml.YAMLError as error:
            info = (
                "The YAML file could not be loaded. Please check that the path points "
                "to a valid YAML file."
            )
            raise ValueError(info) from error
    return out
