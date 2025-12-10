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
            "jupyter-book",
            "build",
            str(depends_on),
            "--pdf",
            "--output",
            str(produces),
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
    depends_on=DOCUMENTS / "presentation.md",
    produces=BLD / "documents" / "presentation.pdf",
):
    """Compile the presentation from Slidev Markdown to PDF."""
    # Slidev export command - need to run from documents directory
    # Use npx to run slidev if not globally installed
    subprocess.run(
        ("npx", "slidev", "export", depends_on.name, "--output", str(produces)),
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
