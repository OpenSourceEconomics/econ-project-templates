import shutil
from pathlib import Path

import pytask
import pytest
from _pytask.outcomes import ExitCode

from template_project import config
from template_project.config import ROOT


def test_pytask_build(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    # Copy project files to temp directory
    shutil.copytree(ROOT / "documents", tmp_path / "documents")
    shutil.copytree(ROOT / "src", tmp_path / "src")
    shutil.copy(ROOT / "myst.yml", tmp_path / "myst.yml")
    shutil.copy(ROOT / "package.json", tmp_path / "package.json")
    shutil.copytree(ROOT / "node_modules", tmp_path / "node_modules")

    monkeypatch.setattr(config, "ROOT", tmp_path)
    monkeypatch.setattr(config, "BLD", tmp_path / "bld")
    monkeypatch.setattr(config, "DOCUMENTS", tmp_path / "documents")
    monkeypatch.setattr(config, "SRC", tmp_path / "src" / "template_project")

    session = pytask.build(
        config=ROOT / "pyproject.toml",
        force=True,
    )
    assert session.exit_code == ExitCode.OK
