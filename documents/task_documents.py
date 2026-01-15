"""Tasks for compiling the paper and presentation(s)."""

import shutil
import subprocess
import sys
from pathlib import Path

import pytask

from template_project.config import DOCUMENTS, ROOT


@pytask.task(id="paper-pdf")
def task_compile_paper_pdf(
    paper_md: Path = DOCUMENTS / "paper.md",
    myst_yml: Path = DOCUMENTS / "myst.yml",
    refs: Path = DOCUMENTS / "refs.bib",
    figure: Path = DOCUMENTS / "public" / "smoking_by_marital_status.png",
    table: Path = DOCUMENTS / "tables" / "estimation_results.md",
    produces: Path = ROOT / "paper.pdf",
) -> None:
    """Compile the paper from MyST Markdown to PDF using Jupyter Book 2.0."""
    subprocess.run(
        ("jupyter", "book", "build", "--pdf"),
        check=True,
        cwd=DOCUMENTS.absolute(),
    )
    build_pdf = DOCUMENTS / "_build" / "exports" / "paper.pdf"
    shutil.copy(build_pdf, produces)


@pytask.task(id="paper-html")
def task_compile_paper_html(
    paper_md: Path = DOCUMENTS / "paper.md",
    myst_yml: Path = DOCUMENTS / "myst.yml",
    refs: Path = DOCUMENTS / "refs.bib",
    figure: Path = DOCUMENTS / "public" / "smoking_by_marital_status.png",
    table: Path = DOCUMENTS / "tables" / "estimation_results.md",
    produces: Path = DOCUMENTS / "_build" / "html" / "paper.html",
) -> None:
    """Compile the paper from MyST Markdown to HTML using Jupyter Book 2.0."""
    subprocess.run(
        ("jupyter", "book", "build", "--html"),
        check=True,
        cwd=DOCUMENTS.absolute(),
    )


@pytask.task(id="presentation")
def task_compile_presentation(
    pres_md: Path = DOCUMENTS / "presentation.md",
    table: Path = DOCUMENTS / "tables" / "estimation_results.md",
    figure: Path = DOCUMENTS / "public" / "smoking_by_marital_status.png",
    produces: Path = ROOT / "presentation.pdf",
) -> None:
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
