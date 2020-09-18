import pytask
from src.config import BLD
from src.config import SRC


@pytask.mark.latex(
    ["--pdf", "--interaction=nonstopmode", "--synctex=1", "--cd", "--quiet"]
)
@pytask.mark.parametrize(
    "depends_on, produces",
    [
        (
            [
                SRC / "paper" / f"{document}.tex",
                SRC / "paper" / "refs.bib",
                SRC / "paper" / "formulas" / "decision_rule.tex",
                BLD / "figures" / "schelling_baseline.png",
                BLD / "figures" / "schelling_max_moves_2.png",
            ],
            BLD / "paper" / f"{document}.pdf",
        )
        for document in ["research_paper", "research_pres_30min"]
    ],
)
def task_compile_documents():
    pass
