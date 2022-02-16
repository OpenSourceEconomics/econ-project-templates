import os
import subprocess
import sys

import pytest


@pytest.mark.end_to_end
def test_bake_project(cookies):
    major, minor = sys.version_info[:2]
    python_version = f"{major}.{minor}"

    result = cookies.bake(
        extra_context={"project_slug": "helloworld", "python_version": python_version}
    )

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project_path.name == "helloworld"
    assert result.project_path.is_dir()


@pytest.mark.end_to_end
def test_remove_readthedocs(cookies):
    result = cookies.bake(extra_context={"add_readthedocs": "no"})

    rtd_config = result.project_path.joinpath(".readthedocs.yaml")
    readme = result.project_path.joinpath("README.rst").read_text()

    assert result.exit_code == 0
    assert result.exception is None

    assert not rtd_config.exists()
    assert "readthedocs" not in readme


@pytest.mark.end_to_end
def test_remove_github_actions(cookies):
    result = cookies.bake(extra_context={"add_github_actions": "no"})

    ga_config = result.project_path.joinpath(".github", "workflows", "main.yml")
    readme = result.project_path.joinpath("README.rst").read_text()

    assert result.exit_code == 0
    assert result.exception is None

    assert not ga_config.exists()
    assert "github/workflow/status" not in readme


@pytest.mark.end_to_end
def test_remove_tox(cookies):
    result = cookies.bake(extra_context={"add_tox": "no"})

    ga_config = result.project_path.joinpath(".github", "workflows", "main.yml")
    tox = result.project_path.joinpath("tox.ini")

    assert result.exit_code == 0
    assert result.exception is None

    assert not ga_config.exists()
    assert not tox.exists()


@pytest.mark.end_to_end
def test_remove_license(cookies):
    result = cookies.bake(extra_context={"open_source_license": "Not open source"})

    license_ = result.project_path.joinpath("LICENSE")

    assert result.exit_code == 0
    assert result.exception is None

    assert not license_.exists()


@pytest.mark.end_to_end
@pytest.mark.skipif(os.environ.get("CI") is None, reason="Run only in CI.")
def test_check_conda_environment_creation_and_run_all_checks(cookies):
    """Test that the conda environment is created and pre-commit passes."""
    result = cookies.bake(
        extra_context={
            "conda_environment_name": "__test__",
            "make_initial_commit": "yes",
            "create_conda_environment_at_finish": "yes",
        }
    )

    assert result.exit_code == 0
    assert result.exception is None

    if sys.platform != "win32":
        # Switch branch before pre-commit because otherwise failure because on main
        # branch.
        subprocess.run(
            ("git", "checkout", "-b", "test"), cwd=result.project_path, check=True
        )

        # Check linting, but not on the first try since formatters fix stuff.
        subprocess.run(
            ("conda", "run", "-n", "__test__", "pre-commit", "run", "--all-files"),
            cwd=result.project_path,
            check=False,
        )
        subprocess.run(
            ("conda", "run", "-n", "__test__", "pre-commit", "run", "--all-files"),
            cwd=result.project_path,
            check=True,
        )

        # Test building documentation
        subprocess.run(
            ("conda", "run", "-n", "__test__", "pip", "install", "-e", "."),
            cwd=result.project_path,
            check=True,
        )
        subprocess.run(
            ("conda", "run", "-n", "__test__", "make", "html"),
            cwd=result.project_path / "docs",
            check=True,
        )
