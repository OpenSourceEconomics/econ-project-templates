"""Tasks running the results formatting (tables, figures)."""

import pandas as pd
import pyreadr
import pytask
import yaml

from template_project.analysis.model_template import load_model
from template_project.config import BLD, SRC, TEMPLATE_GROUPS
from template_project.final.plot_template import plot_regression_by_age

for language in ["python", "r"]:
    extension = "pickle" if language == "python" else "rds"

    for group in TEMPLATE_GROUPS:

        @pytask.task(id=f"{group}_{language}")
        def task_plot_results_by_age(
            script=SRC / "final" / "plot_template.py",
            language=language,
            group=group,
            predictions_path=BLD / "predictions" / f"{group}.{extension}",
            data_info=SRC / "data_management" / "data_info_template.yaml",
            data_path=BLD / "data" / f"data_clean.{extension}",
            produces=BLD / "figures" / f"smoking_by_{group}_using_{language}.png",
        ):
            """Plot the regression results by age."""
            with data_info.open() as file:
                data_info = yaml.safe_load(file)

            if language == "python":
                data = pd.read_pickle(data_path)
                predictions = pd.read_pickle(predictions_path)
            else:
                data = pyreadr.read_r(data_path)[None]
                predictions = pyreadr.read_r(predictions_path)[None]

            fig = plot_regression_by_age(data, data_info, predictions, group)
            fig.write_image(produces)


def task_create_results_table(
    script=SRC / "final" / "plot_template.py",
    model_path=BLD / "models" / "model.pickle",
    produces=BLD / "tables" / "estimation_results.tex",
):
    """Store a table in LaTeX format with the estimation results)."""
    model = load_model(model_path)
    table = model.summary().as_latex()
    with produces.open("w") as f:
        f.writelines(table)
