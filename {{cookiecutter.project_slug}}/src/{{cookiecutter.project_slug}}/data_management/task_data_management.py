"""Tasks for managing the data."""

from pathlib import Path

{% if cookiecutter.add_python_example == 'yes' %}import pandas as pd
{% endif %}{% if cookiecutter.add_r_example == 'yes' %}import pytask
{% endif %}

from {{cookiecutter.project_slug}}.config import BLD, SRC{% if cookiecutter.add_python_example == 'yes' %}
from {{cookiecutter.project_slug}}.data_management import clean_data
from {{cookiecutter.project_slug}}.utilities import read_yaml

clean_data_deps = {
    "scripts": Path("clean_data.py"),
    "data_info": SRC / "data_management" / "data_info.yaml",
    "data": SRC / "data" / "data.csv",
}


def task_clean_data_python(
    depends_on=clean_data_deps,
    produces=BLD / "python" / "data" / "data_clean.csv"
):
    """Clean the data (Python version)."""
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(depends_on["data"])
    data = clean_data(data, data_info)
    data.to_csv(produces, index=False){% endif %}{% if cookiecutter.add_r_example == 'yes' %}


@pytask.mark.r(script=SRC / "data_management" / "clean_data.r", serializer="yaml")
@pytask.mark.depends_on(
    {
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": SRC / "data" / "data.csv",
    },
)
@pytask.mark.produces(BLD / "r" / "data" / "data_clean.csv")
def task_clean_data_r():
    """Clean the data (R version)."""{% endif %}
