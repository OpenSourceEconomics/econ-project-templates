"""Tasks for managing the data."""

from pathlib import Path

import pandas as pd

from template_project.config import BLD, SRC
from template_project.data_management.stats4schools_smoking_template import (
    clean_stats4schools_smoking,
)


def task_clean_stats4schools_smoking_data(
    script: Path = SRC / "data_management" / "stats4schools_smoking_template.py",
    data: Path = SRC / "data" / "stats4schools_smoking_template.csv",
    produces: Path = BLD / "data" / "stats4schools_smoking.pickle",
) -> None:
    """Clean the stats4schools smoking data set."""
    df = pd.read_csv(data)
    df = clean_stats4schools_smoking(df)
    df.to_pickle(produces)
