import shutil
import pytask

from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import PAPER_DIR


documents = ["{{cookiecutter.project_slug}}", "{{cookiecutter.project_slug}}_pres"]

for document in documents:
    
        
    @pytask.mark.depends_on(
        [
            BLD / "figures" / "marital_status-figure.png",
            PAPER_DIR / "refs.bib",
            BLD / "latex" / "estimation_table.tex",
        ]
    )
    @pytask.mark.latex(
        script=PAPER_DIR / f"{document}.tex",
        document=BLD / "latex" / f"{document}.pdf"
    )
    @pytask.mark.task(id=document)
    def task_compile_documents():
        pass

    kwargs = {
        "depends_on": BLD / "latex" / f"{document}.pdf",
        "produces": BLD.parent.resolve() / f"{document}.pdf",
    }
    @pytask.mark.task(id=document, kwargs=kwargs)
    def task_copy_to_root(depends_on, produces):
        shutil.copy(depends_on, produces)
        
