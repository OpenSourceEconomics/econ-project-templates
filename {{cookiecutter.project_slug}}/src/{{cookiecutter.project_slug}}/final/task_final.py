import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import GROUPS
from {{cookiecutter.project_slug}}.config import SRC
{% if cookiecutter.add_python_example == 'yes' %}
import pandas as pd
from {{cookiecutter.project_slug}}.final import plot_regression_by_age
from {{cookiecutter.project_slug}}.utilities import read_yaml
from {{cookiecutter.project_slug}}.analysis.model import load_model


for group in GROUPS:

    kwargs = {
        "group": group,
        "depends_on": {"predictions": BLD / "python" / "predictions" / f"{group}-predicted.csv"},
        "produces": BLD / "python" / "figures" / f"{group}-figure.png",
    }

    @pytask.mark.depends_on(
        {
            "data_info": SRC / "data_management" / "data_info.yaml",
            "data": BLD / "python" / "data" / "data_clean.csv",
        }
    )
    @pytask.mark.task(id=group, kwargs=kwargs)
    def task_plot_regression_python(depends_on, group, produces):
        data_info = read_yaml(depends_on["data_info"])
        data = pd.read_csv(depends_on["data"])
        predictions = pd.read_csv(depends_on["predictions"])
        fig = plot_regression_by_age(data, data_info, predictions, group)
        fig.write_image(produces)


@pytask.mark.depends_on(BLD / "python" / "models" / "model.pickle")
@pytask.mark.produces(BLD / "python" / "tables" / "estimation_table.tex")
def task_create_estimation_table_python(depends_on, produces):
    model = load_model(depends_on)
    table = model.summary().as_latex()
    with open(produces, 'w') as f:
        f.writelines(table)
{% endif %}

{% if cookiecutter.add_r_example == 'yes' %}
for group in GROUPS:

    kwargs = {
        "group": group,
        "depends_on": {"predictions": BLD / "r" / "predictions" / f"{group}-predicted.csv"},
        "produces": BLD / "r" / "figures" / f"{group}-figure.png",
    }

    @pytask.mark.depends_on(
        {
            "data_info": SRC / "data_management" / "data_info.yaml",
            "data": BLD / "r" / "data" / "data_clean.csv",
        }
    )
    @pytask.mark.task(id=group, kwargs=kwargs)
    @pytask.mark.r(script=SRC / "final" / "plot_regression.r", serializer="yaml")
    def task_plot_regression_r():
        pass


@pytask.mark.depends_on({"model": BLD / "r" / "models" / "model.rds", "SRC": SRC})
@pytask.mark.produces(BLD / "r" / "tables" / "estimation_table.tex")
@pytask.mark.r(script=SRC / "final" / "create_estimation_table.r", serializer="yaml")
def task_create_estimation_table_r():
    pass
{% endif %}