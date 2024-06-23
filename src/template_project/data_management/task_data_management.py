"""Tasks for managing the data."""

from pathlib import Path

import pandas as pd
import pytask

from template_project.config import BLD, SRC
from template_project.data_management.clean_data import clean_data
from template_project.utilities import read_yaml


def task_clean_data_python(
    script: Path = SRC / "data_management" / "clean_data.py",
    data_info: Path = SRC / "data_management" / "data_info.yaml",
    data: Path = SRC / "data" / "data.csv",
    produces: Path = BLD / "python" / "data" / "data_clean.csv",
):
    """Clean the data (Python version)."""
    data_info = read_yaml(data_info)
    data = pd.read_csv(data)
    data = clean_data(data, data_info)
    data.to_csv(produces, index=False)


@pytask.mark.r(script=SRC / "data_management" / "clean_data.r", serializer="yaml")
def task_clean_data_r(
    data_info: Path = SRC / "data_management" / "data_info.yaml",
    data: Path = SRC / "data" / "data.csv",
    produces: Path = BLD / "r" / "data" / "data_clean.csv",
):
    """Clean the data (R version)."""
