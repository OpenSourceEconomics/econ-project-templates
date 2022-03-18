import pandas as pd
import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import SRC
from {{cookiecutter.project_slug}}.final.plot import plot_regression_over_age
from {{cookiecutter.project_slug}}.task_analysis import GROUPS
from {{cookiecutter.project_slug}}.utilities import read_yaml


@pytask.mark.parametrize(
    "group, depends_on, produces",
    [
        (
            group,
            BLD / "predictions" / f"{group}-predicted.csv",
            BLD / "figures" / f"{group}-figure.png",
        )
        for group in GROUPS
    ],
)
def task_plot_regression(group, depends_on, produces):
    data_info = read_yaml(SRC / "data_management" / "data_info.yaml")
    data = pd.read_csv(BLD / "data" / "data_clean.csv")
    predictions = pd.read_csv(depends_on)
    fig = plot_regression_over_age(data, data_info, predictions, group)
    fig.write_image(produces)
