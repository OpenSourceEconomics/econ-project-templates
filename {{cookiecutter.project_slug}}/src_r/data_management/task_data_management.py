import pytask

from src.config import BLD
from src.config import SRC

data = SRC / "original_data" / "ajrcomment.dta"
prod = BLD / "data" / "ajrcomment_all.csv"


@pytask.mark.r([str(x.resolve()) for x in [data, prod]])
@pytask.mark.depends_on(["add_variables.r", data])
@pytask.mark.produces(prod)
def task_ajr_comment_data():
    pass
