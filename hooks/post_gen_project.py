"""This module contains hooks which are executed after the template is rendered."""
from __future__ import annotations

import shutil
import subprocess
import warnings
from pathlib import Path


def remove_file(*filepath: str | Path) -> None:
    """Remove a file."""
    try:
        Path(*filepath).unlink()
    except FileNotFoundError:
        pass


def remove_directory(*filepath: str | Path) -> None:
    """Remove a directory."""
    try:
        path = Path(*filepath)
        shutil.rmtree(path)
    except FileNotFoundError:
        pass


def main() -> None:
    """Apply post generation hooks."""
    project_path = Path.cwd()

    example_language = "{{ cookiecutter.example_language }}"

    if "{{ cookiecutter.create_changelog }}" == "no":
        remove_file(project_path, "CHANGES.rst")

    if "{{ cookiecutter.open_source_license }}" == "Not open source":
        remove_file(project_path, "LICENSE")

    if "{{ cookiecutter.add_tox }}" == "no" or example_language != "python":
        remove_directory(project_path, ".github", "workflows")
        remove_file("tox.ini")

    if "{{ cookiecutter.add_github_actions }}" == "no":
        remove_directory(project_path, ".github", "workflows")

    if "{{ cookiecutter.add_readthedocs }}" == "no":
        remove_file(project_path, ".readthedocs.yaml")

    languages_to_remove = {"python", "julia", "r", "stata"}.difference(
        [example_language]
    )
    for language in languages_to_remove:
        suffix = {
            "python": "py",
            "julia": "jl",
            "r": "r",
            "stata": "do",
        }[language]

        for path in project_path.rglob(f"*.{suffix}"):
            if language == "python":
                if all(
                    [x not in path.name for x in ("task_", "config.py", "__init__.py")]
                ):
                    remove_file(path)
            else:
                remove_file(path)

    subprocess.run(("git", "init"), check=True, capture_output=True)

    if "{{ cookiecutter.make_initial_commit }}" == "yes":
        # Create an initial commit on the main branch and restore global default name.
        subprocess.run(
            ("git", "config", "user.name", "'{{ cookiecutter.github_username }}'"),
            check=True,
        )
        subprocess.run(
            ("git", "config", "user.email", "'{{ cookiecutter.github_email }}'"),
            check=True,
        )
        subprocess.run(("git", "add", "."), check=True)
        subprocess.run(
            ("git", "commit", "-m", "'Initial commit.'"),
            check=True,
            capture_output=True,
        )
        subprocess.run(("git", "branch", "-m", "main"), check=True)

    if "{{ cookiecutter.create_conda_environment_at_finish }}" == "yes":
        if shutil.which("mamba") is not None:
            conda_exe = shutil.which("mamba")
        else:
            conda_exe = shutil.which("conda")

        if conda_exe is None:
            warnings.warn(
                "conda environment could not be created since no conda or mamba "
                "executable was found."
            )
        else:
            subprocess.run((conda_exe, "env", "create"), check=True)


if __name__ == "__main__":
    main()
