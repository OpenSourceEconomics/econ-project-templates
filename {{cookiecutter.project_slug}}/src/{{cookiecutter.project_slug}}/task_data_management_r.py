import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import SRC


info = SRC / "data_management" / "data_info.yaml"
prod = BLD / "data" / "data_clean_r.csv"

@pytask.mark.r(script="data_management/clean_data_r.r")
@pytask.mark.depends_on(info)
@pytask.mark.produces(prod)
def task_clean_data():
    pass