"""Tasks running the results formatting (tables, figures)."""

from pathlib import Path

import pandas as pd
import pytask

from example_project.analysis.model import load_model
from example_project.config import BLD, GROUPS, SRC
from example_project.final.plot import plot_regression_by_age
from example_project.utilities import read_yaml

for group in GROUPS:
    deps = {
        "predictions": BLD / "python" / "predictions" / f"{group}.csv",
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": BLD / "python" / "data" / "data_clean.csv",
    }

    @pytask.task(id=group)
    def task_plot_results_by_age_python(
        group=group,
        depends_on=deps,
        produces=BLD / "python" / "figures" / f"smoking_by_{group}.png",
    ):
        """Plot the regression results by age (Python version)."""
        data_info = read_yaml(depends_on["data_info"])
        data = pd.read_csv(depends_on["data"])
        predictions = pd.read_csv(depends_on["predictions"])
        fig = plot_regression_by_age(data, data_info, predictions, group)
        fig.write_image(produces)


def task_create_results_table_python(
    depends_on=BLD / "python" / "models" / "model.pickle",
    produces=BLD / "python" / "tables" / "estimation_results.tex",
):
    """Store a table in LaTeX format with the estimation results (Python version)."""
    model = load_model(depends_on)
    table = model.summary().as_latex()
    with produces.open("w") as f:
        f.writelines(table)


for group in GROUPS:

    @pytask.task(id=group)
    @pytask.mark.r(script=SRC / "final" / "plot_regression.r", serializer="yaml")
    def task_plot_results_by_age_r(
        group: str = group,
        data_info: Path = SRC / "data_management" / "data_info.yaml",
        data: Path = BLD / "r" / "data" / "data_clean.csv",
        predictions: Path = BLD / "r" / "predictions" / f"{group}.csv",
        produces: Path = BLD / "r" / "figures" / f"smoking_by_{group}.png",
    ):
        """Plot the regression results by age (R version)."""


@pytask.mark.r(script=SRC / "final" / "create_estimation_table.r", serializer="yaml")
def task_create_results_table_r(
    model: Path = BLD / "r" / "models" / "model.rds",
    produces: Path = BLD / "r" / "tables" / "estimation_results.tex",
):
    """Store a table in LaTeX format with the estimation results (R version)."""
