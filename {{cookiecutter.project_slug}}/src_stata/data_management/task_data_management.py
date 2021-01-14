import pytask

from src.config import BLD
from src.config import SRC

log = BLD / "data" / "log" / "add_variables.log"
data = SRC / "original_data" / "ajrcomment.dta"
prod = BLD / "data" / "ajrcomment_all.dta"


@pytask.mark.stata([log, data, prod])
@pytask.mark.depends_on(["add_variables.do", data])
@pytask.mark.produces([log, prod])
def task_ajr_comment_data():
    pass
