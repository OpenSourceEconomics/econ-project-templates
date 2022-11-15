import shutil

import pytask
from pytask_latex import compilation_steps as cs

from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import PAPER_DIR


documents = ["{{cookiecutter.project_slug}}", "{{cookiecutter.project_slug}}_pres"]

for document in documents:


    {% if cookiecutter.is_ci == 'no' %}
    @pytask.mark.latex(
        script=PAPER_DIR / f"{document}.tex",
        document=BLD / "latex" / f"{document}.pdf",
        compilation_steps=cs.latexmk(
                options=("--pdf", "--interaction=nonstopmode", "--synctex=1", "--cd")
        )
    )
    @pytask.mark.task(id=document)
    def task_compile_documents():
        pass
    {% endif %}

    {% if cookiecutter.is_ci == 'yes' %}
    @pytask.mark.latex(
        script=PAPER_DIR / f"{document}.tex",
        document=BLD / "latex" / f"{document}.pdf",
    )
    @pytask.mark.task(id=document)
    def task_compile_documents():
        pass
    {% endif %}

    kwargs = {
        "depends_on": BLD / "latex" / f"{document}.pdf",
        "produces": BLD.parent.resolve() / f"{document}.pdf",
    }
    @pytask.mark.task(id=document, kwargs=kwargs)
    def task_copy_to_root(depends_on, produces):
        shutil.copy(depends_on, produces)
