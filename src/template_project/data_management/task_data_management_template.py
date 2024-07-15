"""Tasks for managing the data."""

import pandas as pd
import pytask
import yaml

from template_project.config import BLD, SRC
from template_project.data_management.clean_data_template import clean_data


def task_clean_data(
    script=SRC / "data_management" / "clean_data_template.py",
    data_info=SRC / "data_management" / "data_info_template.yaml",
    data=SRC / "data" / "data_template.csv",
    produces=BLD / "data" / "data_clean.pickle",
):
    """Clean the data."""
    with data_info.open() as file:
        data_info = yaml.safe_load(file)
    data = pd.read_csv(data)
    data = clean_data(data, data_info)
    data.to_pickle(produces)


@pytask.mark.r(
    script=SRC / "data_management" / "clean_data_template.r",
    serializer="yaml",
)
def task_clean_data_r(
    data_info=SRC / "data_management" / "data_info_template.yaml",
    data=SRC / "data" / "data_template.csv",
    produces=BLD / "data" / "data_clean.rds",
):
    """Clean the data (R version)."""
