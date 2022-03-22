import pandas as pd
import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import GROUPS
from {{cookiecutter.project_slug}}.config import SRC
from {{cookiecutter.project_slug}}.final import plot_regression_over_age
from {{cookiecutter.project_slug}}.utilities import read_yaml


common_dependencies = pytask.mark.depends_on(
    {
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": BLD / "data" / "data_clean.csv",
    }
)

for group in GROUPS:

    kwargs = {
        "group": group,
        "depends_on": {"predictions": BLD / "predictions" / f"{group}-predicted.csv"},
        "produces": BLD / "figures" / f"{group}-figure.png",
    }

    @common_dependencies
    @pytask.mark.task(id=group, kwargs=kwargs)
    def task_plot_regression(depends_on, group, produces):
        data_info = read_yaml(depends_on["data_info"])
        data = pd.read_csv(depends_on["data"])
        predictions = pd.read_csv(depends_on["predictions"])
        fig = plot_regression_over_age(data, data_info, predictions, group)
        fig.write_image(produces)
