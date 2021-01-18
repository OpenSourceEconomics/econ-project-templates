import pytask

from src.config import BLD
from src.config import SRC


@pytask.mark.latex(
    [
        "--pdf",
        "--interaction=nonstopmode",
        "--synctex=1",
        "--cd",
        "--quiet",
        "--shell-escape",
    ]
)
@pytask.mark.parametrize(
    "depends_on, produces",
    [
        (
            [SRC / "paper" / f"{document}.tex", SRC / "paper" / "refs.bib"],
            BLD / "paper" / f"{document}.pdf",
        )
        for document in ["research_paper", "research_pres_30min"]
    ],
)
def task_compile_documents():
    pass
