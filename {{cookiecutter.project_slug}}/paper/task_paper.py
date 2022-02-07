import shutil
import pytask

from {{ cookiecutter.project_slug }}.config import BLD


documents = ["research_paper", "research_pres_30min"]


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
        (f"{document}.tex", BLD / f"{document}.pdf")
        for document in documents
    ],
)
def task_compile_documents():
    pass


@pytask.mark.parametrize(
    "depends_on, produces",
    [
        (BLD / f"{document}.pdf", BLD.parent.resolve() / f"{document}.pdf")
        for document in documents
    ],
)
def task_copy_to_root(depends_on, produces):
    shutil.copy(depends_on, produces)
