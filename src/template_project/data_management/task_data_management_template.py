"""Tasks for managing the data."""

import pandas as pd
import pytask

from template_project.config import BLD, SRC
from template_project.data_management.stats4schools_smoking_template import (
    clean_smoking_stats4schools,
)


def task_clean_data(
    script=SRC / "data_management" / "stats4schools_smoking_template.py",
    data=SRC / "data" / "stats4schools_smoking_template.csv",
    produces=BLD / "data" / "stats4schools_smoking.pickle",
):
    """Clean the stats4schools smoking data set."""
    data = pd.read_csv(data)
    data = clean_smoking_stats4schools(data)
    data.to_pickle(produces)


@pytask.mark.r(
    script=SRC / "data_management" / "stats4schools_smoking_template.r",
    serializer="yaml",
)
def task_clean_data_r(
    data=SRC / "data" / "stats4schools_smoking_template.csv",
    produces=BLD / "data" / "stats4schools_smoking.rds",
):
    """Clean the stats4schools smoking data set (R version)."""
