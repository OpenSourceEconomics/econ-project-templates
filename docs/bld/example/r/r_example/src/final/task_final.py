import pytask

from src.config import BLD
from src.config import SRC


data = BLD / "data" / "ajrcomment_all.csv"
prod = BLD / "figures" / "risk_mort.png"


@pytask.mark.r([str(x.resolve()) for x in [data, prod]])
@pytask.mark.depends_on(["figure_mortality.r", data])
@pytask.mark.produces(prod)
def task_figure_mortality():
    pass


deps = [
    SRC / "model_specs" / "baseline.json",
    BLD / "analysis" / "first_stage_estimation_baseline.csv",
    SRC / "model_specs" / "rmconj.json",
    BLD / "analysis" / "first_stage_estimation_rmconj.csv",
]
prod = BLD / "tables" / "table_first_stage_est.tex"


@pytask.mark.r([str(x.resolve()) for x in [*deps, prod]])
@pytask.mark.depends_on(["table_first_stage_est.r", *deps])
@pytask.mark.produces(prod)
def task_table_first_stage_est():
    pass


deps = [
    SRC / "model_specs" / "baseline.json",
    BLD / "analysis" / "second_stage_estimation_baseline.csv",
    SRC / "model_specs" / "rmconj.json",
    BLD / "analysis" / "second_stage_estimation_rmconj.csv",
]
prod = BLD / "tables" / "table_second_stage_est.tex"


@pytask.mark.r([str(x.resolve()) for x in [*deps, prod]])
@pytask.mark.depends_on(["table_second_stage_est.r", *deps])
@pytask.mark.produces(prod)
def task_table_second_stage_est():
    pass
