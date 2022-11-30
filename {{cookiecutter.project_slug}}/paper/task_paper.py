import shutil
import sys

import pytask
{% if cookiecutter.is_ci == 'no' %}
from pytask_latex import compilation_steps as cs
{% endif %}

from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import PAPER_DIR

sys.stdout.write(f"""\n\n\ntask_paper: Checking for latexmk: {shutil.which("latexmk")}\n\n\n""")
sys.stdout.write(f"""\n\n\ntask_paper: Checking for sys.path: {sys.path}\n\n\n""")



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

    {% elif cookiecutter.is_ci == 'yes' %}
    @pytask.mark.depends_on(
        [
            PAPER_DIR / "refs.bib",
            {% if cookiecutter.add_python_example == 'yes' %}
            BLD / "python" / "figures" / "smoking_by_marital_status.png",
            BLD / "python" / "tables" / "estimation_results.tex",
            {% endif %}
        ]
    )
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
