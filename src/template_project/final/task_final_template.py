"""Tasks running the results formatting (tables, figures)."""

import shutil

import pandas as pd
import pytask

from template_project.config import BLD, DOCUMENTS, SRC, TEMPLATE_GROUPS
from template_project.final.plot_template import plot_regression_by_age

for group in TEMPLATE_GROUPS:
    svg = BLD / "figures" / f"smoking_by_{group}.svg"

    @pytask.task(id=group)
    def task_plot_results_by_age(
        script=SRC / "final" / "plot_template.py",
        group=group,
        predictions_path=BLD / "predictions" / f"{group}.pickle",
        data_path=BLD / "data" / "stats4schools_smoking.pickle",
        produces=svg,
    ):
        """Plot the regression results by age."""
        data = pd.read_pickle(data_path)
        predictions = pd.read_pickle(predictions_path)

        fig = plot_regression_by_age(data, predictions, group)
        fig.write_image(produces)

    @pytask.task(id=group)
    def task_copy_figure_for_presentation(
        depends_on=svg,
        produces=DOCUMENTS / "public" / svg.name,
    ):
        """Copy figure to public directory for Slidev presentation."""
        shutil.copy(depends_on, produces)


def task_create_results_table(
    script=SRC / "final" / "plot_template.py",
    model_path=BLD / "estimation_results" / "baseline.pickle",
    produces=BLD / "tables" / "estimation_results.tex",
):
    """Store a table in LaTeX format with the estimation results)."""
    model = pd.read_pickle(model_path)
    table = model.summary().as_latex()
    with produces.open("w") as f:
        f.writelines(table)
