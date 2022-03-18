import pandas as pd
import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import SRC
from {{cookiecutter.project_slug}}.data_management.clean_data import clean_data
from {{cookiecutter.project_slug}}.utilities import read_yaml


@pytask.mark.depends_on({"data_info": SRC / "data_management" / "data_info.yaml"})
@pytask.mark.produces(BLD / "data" / "data.csv")
def task_get_data(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(data_info["url"])
    data.to_csv(produces, index=False)


@pytask.mark.depends_on(
    {
        "data": BLD / "data" / "data.csv",
        "data_info": SRC / "data_management" / "data_info.yaml",
    }
)
@pytask.mark.produces(BLD / "data" / "data_clean.csv")
def task_clean_data(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(depends_on["data"])
    data = clean_data(data, data_info)
    data.to_csv(produces, index=False)
