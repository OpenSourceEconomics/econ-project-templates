"""Tasks for compiling the paper and presentation(s)."""

import shutil
import subprocess
import sys

import pytask

from template_project.config import DOCUMENTS, ROOT


@pytask.task(id="paper")
def task_compile_paper(
    paper_md=DOCUMENTS / "paper.md",
    myst_yml=DOCUMENTS / "myst.yml",
    refs=DOCUMENTS / "refs.bib",
    figure=DOCUMENTS / "public" / "smoking_by_marital_status.png",
    table=DOCUMENTS / "tables" / "estimation_results.md",
    produces=ROOT / "paper.pdf",
):
    """Compile the paper from MyST Markdown to PDF using Jupyter Book 2.0."""
    # Jupyter Book 2.0 uses myst.yml and builds from the project directory
    # The export is defined in myst.yml, so we build from the documents directory
    subprocess.run(
        (
            "jupyter",
            "book",
            "build",
            "--pdf",
        ),
        check=True,
        cwd=DOCUMENTS.absolute(),
    )
    # Jupyter Book creates PDF in _build/exports/paper.pdf or _build/temp/*/paper.pdf
    # Find and copy to produces location
    build_pdf = DOCUMENTS / "_build" / "exports" / "paper.pdf"
    shutil.copy(build_pdf, produces)


@pytask.task(id="presentation")
def task_compile_presentation(
    pres_md=DOCUMENTS / "presentation.md",
    table=DOCUMENTS / "tables" / "estimation_results.md",
    figure=DOCUMENTS / "public" / "smoking_by_marital_status.png",
    produces=ROOT / "presentation.pdf",
):
    """Compile the presentation from Slidev Markdown to PDF."""
    if sys.platform == "win32":
        shell = True
    else:
        shell = False
    subprocess.run(
        (
            "npx",
            "slidev",
            "export",
            pres_md.absolute(),
            "--output",
            produces.absolute(),
        ),
        check=True,
        shell=shell,
    )
