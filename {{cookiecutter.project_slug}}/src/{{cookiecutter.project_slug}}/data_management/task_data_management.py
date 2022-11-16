import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import SRC
{% if cookiecutter.add_python_example == 'python' %}
import pandas as pd
from {{cookiecutter.project_slug}}.data_management import clean_data
from {{cookiecutter.project_slug}}.utilities import read_yaml


@pytask.mark.depends_on(
    {
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": SRC / "data" / "data.csv",
    }
)
@pytask.mark.produces(BLD / "data" / "data_clean.csv")
def task_clean_data(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(depends_on["data"])
    data = clean_data(data, data_info)
    data.to_csv(produces, index=False)
{% endif %}

{% if cookiecutter.add_r_example == 'r' %}
@pytask.mark.r(script=SRC / "data_management" / "task_clean_data.r", serializer="yaml")
@pytask.mark.depends_on(
    {
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": SRC / "data" / "data.csv",
    }
)
@pytask.mark.produces(BLD / "data" / "data_clean.csv")
def task_clean_data():
    pass
{% endif %}