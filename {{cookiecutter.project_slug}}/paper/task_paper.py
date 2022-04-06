import shutil
import pytask

from pytask_latex import compilation_steps as cs

from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import PAPER_DIR


documents = ["research_paper", "research_pres_30min"]

compilation_options = (
        "--pdf",
        "--interaction=nonstopmode",
        "--synctex=1",
        "--cd",
        "--quiet",
        "--shell-escape",
        )

for document in documents:

    kwargs_compile = {
        "depends_on": PAPER_DIR / f"{document}.tex",
        "produces": BLD / f"{document}.pdf",
    }

    kwargs_copy = {
        "depends_on": BLD / f"{document}.pdf",
        "produces": BLD.parent.resolve() / f"{document}.pdf",
    }

    @pytask.mark.latex(compilation_steps=cs.latexmk(options=compilation_options))
    @pytask.mark.task(id=document, kwargs=kwargs_compile)
    def task_compile_documents():
        pass

    @pytask.mark.task(id=document, kwargs=kwargs_copy)
    def task_copy_to_root(depends_on, produces):
        shutil.copy(depends_on, produces)