import pytask

from src.config import BLD

log = BLD / "figures" / "log" / "figure_mortality.log"
data = BLD / "data" / "ajrcomment_all.dta"
prod = BLD / "figures" / "risk_mort.eps"


@pytask.mark.stata([str(x.resolve()) for x in [log, data, prod]])
@pytask.mark.depends_on(["figure_mortality.do", data])
@pytask.mark.produces([log, prod])
def task_figure_mortality():
    pass


log = BLD / "tables" / "log" / "table_first_stage_est.log"
deps = [
    BLD / "model_specs" / "baseline.do",
    BLD / "analysis" / "first_stage_estimation_baseline.dta",
    BLD / "model_specs" / "rmconj.do",
    BLD / "analysis" / "first_stage_estimation_rmconj.dta",
]
prod = BLD / "tables" / "table_first_stage_est.tex"


@pytask.mark.stata([str(x.resolve()) for x in [log, *deps, prod]])
@pytask.mark.depends_on(["table_first_stage_est.do", *deps])
@pytask.mark.produces([log, prod])
def task_table_first_stage_est():
    pass


log = BLD / "tables" / "log" / "table_second_stage_est.log"
deps = [
    BLD / "model_specs" / "geography.do",
    BLD / "model_specs" / "baseline.do",
    BLD / "analysis" / "second_stage_estimation_baseline.dta",
    BLD / "model_specs" / "rmconj.do",
    BLD / "analysis" / "second_stage_estimation_rmconj.dta",
]
prod = BLD / "tables" / "table_second_stage_est.tex"


@pytask.mark.stata([str(x.resolve()) for x in [log, *deps, prod]])
@pytask.mark.depends_on(["table_second_stage_est.do", *deps])
@pytask.mark.produces([log, prod])
def task_table_second_stage_est():
    pass
