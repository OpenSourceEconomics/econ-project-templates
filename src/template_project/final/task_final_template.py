"""Tasks running the results formatting (tables, figures)."""

import pandas as pd
import pytask
import yaml

from template_project.analysis.model_template import load_model
from template_project.config import BLD, SRC, TEMPLATE_GROUPS
from template_project.final.plot_template import plot_regression_by_age

for group in TEMPLATE_GROUPS:
    deps = {
        "script": SRC / "final" / "plot_template.py",
        "predictions": BLD / "predictions" / f"{group}.pickle",
        "data_info": SRC / "data_management" / "data_info_template.yaml",
        "data": BLD / "data" / "data_clean.pickle",
    }

    @pytask.task(id=group)
    def task_plot_results_by_age(
        group=group,
        depends_on=deps,
        produces=BLD / "figures" / f"smoking_by_{group}.png",
    ):
        """Plot the regression results by age."""
        with depends_on["data_info"].open() as file:
            data_info = yaml.safe_load(file)
        data = pd.read_pickle(depends_on["data"])
        predictions = pd.read_pickle(depends_on["predictions"])
        fig = plot_regression_by_age(data, data_info, predictions, group)
        fig.write_image(produces)


def task_create_results_table(
    script=SRC / "final" / "plot_template.py",
    depends_on=BLD / "models" / "model.pickle",
    produces=BLD / "tables" / "estimation_results.tex",
):
    """Store a table in LaTeX format with the estimation results)."""
    model = load_model(depends_on)
    table = model.summary().as_latex()
    with produces.open("w") as f:
        f.writelines(table)
