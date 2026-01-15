"""Tasks running the results formatting (tables, figures)."""

from pathlib import Path

import pandas as pd
import plotly.io as pio
import pytask

from template_project.config import BLD, DOCUMENTS, SRC, TEMPLATE_GROUPS
from template_project.final.plot_template import plot_regression_by_age

for group in TEMPLATE_GROUPS:

    @pytask.task(id=group)
    def task_plot_results_by_age(
        script: Path = SRC / "final" / "plot_template.py",
        group: str = group,
        predictions_path: Path = BLD / "predictions" / f"{group}.pickle",
        data_path: Path = BLD / "data" / "stats4schools_smoking.pickle",
        produces: Path = DOCUMENTS / "public" / f"smoking_by_{group}.png",
    ) -> None:
        """Plot the regression results by age."""
        data = pd.read_pickle(data_path)
        predictions = pd.read_pickle(predictions_path)

        fig = plot_regression_by_age(data, predictions, group)
        pio.get_chrome()
        fig.write_image(produces)


def task_create_results_table(
    script: Path = SRC / "final" / "plot_template.py",
    model_path: Path = BLD / "estimation_results" / "baseline.pickle",
    produces: Path = DOCUMENTS / "tables" / "estimation_results.md",
) -> None:
    """Store a table in Markdown format with the estimation results."""
    model = pd.read_pickle(model_path)
    # Get summary as DataFrame
    summary = model.summary()
    coef_table = summary.tables[1]

    coef_df = pd.DataFrame(coef_table.data[1:], columns=coef_table.data[0]).set_index(
        ""
    )

    # Escape special Markdown characters in column names and index
    for char in "|", "[", "]":
        escaped = f"\\{char}"
        coef_df.columns = coef_df.columns.str.replace(char, escaped, regex=False)
        coef_df.index = coef_df.index.str.replace(char, escaped, regex=False)

    # Write as markdown table using pandas to_markdown
    with produces.open("w") as f:
        f.write(coef_df.to_markdown(index=True))
