"""Tasks for compiling the paper and presentation(s)."""

import shutil
import subprocess
import sys
from pathlib import Path

import pytask

from template_project.config import DOCUMENTS, ROOT

for fmt, produces in {
    "pdf": ROOT / "paper.pdf",
    "html": ROOT / "_build" / "html" / "index.html",
}.items():

    @pytask.task(id=f"paper-{fmt}")
    def task_compile_paper(
        paper_md: Path = DOCUMENTS / "paper.md",
        myst_yml: Path = ROOT / "myst.yml",
        refs: Path = DOCUMENTS / "refs.bib",
        figure: Path = DOCUMENTS / "public" / "smoking_by_marital_status.png",
        table: Path = DOCUMENTS / "tables" / "estimation_results.md",
        produces: Path = produces,
    ) -> None:
        """Compile the paper from MyST Markdown using Jupyter Book 2.0."""
        fmt = produces.suffix.lstrip(".")
        subprocess.run(
            ("jupyter", "book", "build", f"--{fmt}"),
            check=True,
            cwd=ROOT.absolute(),
        )
        if fmt == "pdf":
            build_pdf = ROOT / "_build" / "exports" / "paper.pdf"
            shutil.copy(build_pdf, produces)


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
