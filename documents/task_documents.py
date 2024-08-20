"""Tasks for compiling the paper and presentation(s)."""

import shutil

import pytask
from pytask_latex import compilation_steps as cs

from template_project.config import BLD, DOCUMENTS, ROOT

documents = ["paper", "presentation"]

for document in documents:

    @pytask.mark.latex(
        script=DOCUMENTS / f"{document}.tex",
        document=BLD / "documents" / f"{document}.pdf",
        compilation_steps=cs.latexmk(
            options=("--pdf", "--interaction=nonstopmode", "--synctex=1", "--cd"),
        ),
    )
    @pytask.task(id=document)
    def task_compile_document():
        """Compile the document specified in the latex decorator."""

    kwargs = {
        "depends_on": BLD / "documents" / f"{document}.pdf",
        "produces": ROOT / f"{document}.pdf",
    }

    @pytask.task(id=document, kwargs=kwargs)
    def task_copy_to_root(depends_on, produces):
        """Copy a document to the root directory for easier retrieval."""
        shutil.copy(depends_on, produces)
