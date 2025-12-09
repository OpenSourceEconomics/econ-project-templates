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
    """Compile the paper from MyST Markdown to PDF."""
    # MyST can be built using jupyter-book or myst CLI
    # Try myst build first, fallback to jupyter-book if needed
    try:
        subprocess.run(
            ("myst", "build", str(depends_on), "--pdf", str(produces)),
            check=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        # Fallback to jupyter-book build
        subprocess.run(
            ("jupyter-book", "build", str(depends_on.parent), "--builder", "pdfhtml"),
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
    depends_on=DOCUMENTS / "presentation.md",
    produces=BLD / "documents" / "presentation.pdf",
):
    """Compile the presentation from Slidev Markdown to PDF."""
    # Slidev export command - need to run from documents directory
    subprocess.run(
        ("slidev", "export", depends_on.name, "--output", str(produces)),
        cwd=depends_on.parent,
        check=True,
    )


@pytask.task(id="presentation")
def task_copy_presentation_to_root(
    depends_on=BLD / "documents" / "presentation.pdf",
    produces=ROOT / "presentation.pdf",
):
    """Copy the presentation to the root directory for easier retrieval."""
    shutil.copy(depends_on, produces)
