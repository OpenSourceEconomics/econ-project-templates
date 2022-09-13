import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import SRC
{% if cookiecutter.example_language == 'python' %}
import pandas as pd
from {{cookiecutter.project_slug}}.data_management import clean_data
from {{cookiecutter.project_slug}}.utilities import read_yaml

@pytask.mark.depends_on({"data_info": SRC / "data_management" / "data_info.yaml"})
@pytask.mark.produces(BLD / "data" / "data.csv")
def task_get_data(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(data_info["url"])
    data.to_csv(produces, index=False)


@pytask.mark.depends_on(
    {
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": BLD / "data" / "data.csv",
    }
)
@pytask.mark.produces(BLD / "data" / "data_clean.csv")
def task_clean_data(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(depends_on["data"])
    data = clean_data(data, data_info)
    data.to_csv(produces, index=False)
{% endif %}

{% if cookiecutter.example_language == 'r' %}
@pytask.mark.r(script=SRC / "task_data_management.r", serializer="yaml")
@pytask.mark.task(kwargs={"task": "get_data"})
@pytask.mark.depends_on({"data_info": SRC / "data_management" / "data_info.yaml"})
@pytask.mark.produces(BLD / "data" / "data.csv")
def task_get_data():
    pass


@pytask.mark.r(script=SRC / "task_data_management.r", serializer="yaml")
@pytask.mark.task(kwargs={"task": "clean_data"})
@pytask.mark.depends_on(
    {
        "data_info": SRC / "data_management" / "data_info.yaml",
        "data": BLD / "data" / "data.csv",
    }
)
@pytask.mark.produces(BLD / "data" / "data_clean.csv")
def task_clean_data():
    pass
{% endif %}
