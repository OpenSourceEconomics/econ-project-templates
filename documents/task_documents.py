"""Tasks for compiling the paper and presentation(s)."""

import shutil
import subprocess

import pytask

from template_project.config import BLD, DOCUMENTS, ROOT


@pytask.task(id="paper")
def task_compile_paper(
    depends_on=DOCUMENTS / "paper.md",
    produces=BLD / "documents" / "paper.pdf",
):
    """Compile the paper from MyST Markdown to PDF using Jupyter Book."""
    # Ensure output directory exists
    produces.parent.mkdir(parents=True, exist_ok=True)
    # Jupyter Book requires a _toc.yml file and _config.yml for the build
    # Build PDF directly to the produces path
    subprocess.run(
        (
            "jupyter",
            "book",
            "build",
            depends_on.absolute(),
            "--pdf",
            "--output",
            produces.absolute(),
        ),
        check=True,
    )


@pytask.task(id="paper")
def task_copy_paper_to_root(
    depends_on=BLD / "documents" / "paper.pdf",
    produces=ROOT / "paper.pdf",
):
    """Copy the paper to the root directory for easier retrieval."""
    shutil.copy(depends_on, produces)


@pytask.task(id="presentation")
def task_compile_presentation(
    pres_md=DOCUMENTS / "presentation.md",
    figure=DOCUMENTS / "public" / "smoking_by_marital_status.svg",
    produces=BLD / "documents" / "presentation.pdf",
):
    """Compile the presentation from Slidev Markdown to PDF."""
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
    )


@pytask.task(id="presentation")
def task_copy_presentation_to_root(
    depends_on=BLD / "documents" / "presentation.pdf",
    produces=ROOT / "presentation.pdf",
):
    """Copy the presentation to the root directory for easier retrieval."""
    shutil.copy(depends_on, produces)
