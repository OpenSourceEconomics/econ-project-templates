import os
import shutil
import subprocess
import sys

import pytest


if _mamba := shutil.which("mamba"):
    conda_exe = _mamba
else:
    conda_exe = shutil.which("conda")


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
    readme = result.project_path.joinpath("README.md").read_text()

    assert result.exit_code == 0
    assert result.exception is None

    assert not rtd_config.exists()
    assert "readthedocs" not in readme


@pytest.mark.end_to_end
def test_remove_github_actions(cookies):
    result = cookies.bake(extra_context={"add_github_actions": "no"})

    ga_config = result.project_path.joinpath(".github", "workflows", "main.yml")
    readme = result.project_path.joinpath("README.md").read_text()

    assert result.exit_code == 0
    assert result.exception is None

    assert not ga_config.exists()
    assert "github/workflow/status" not in readme


@pytest.mark.end_to_end
def test_remove_license(cookies):
    result = cookies.bake(extra_context={"open_source_license": "Not open source"})

    license_ = result.project_path.joinpath("LICENSE")

    assert result.exit_code == 0
    assert result.exception is None

    assert not license_.exists()


TEST_CONTEXT = [
    ("all_examples", {}),
    (
        "only_python",
        {
            "add_r_example": "no",
            "add_julia_example": "no",
            "add_stata_example": "no",
        },
    ),
    (
        "only_r",
        {
            "add_python_example": "no",
            "add_julia_example": "no",
            "add_stata_example": "no",
        },
    ),
]


@pytest.mark.end_to_end
@pytest.mark.parametrize("name, test_context", TEST_CONTEXT)
def test_check_conda_environment_creation_for_all_examples_and_run_all_checks(
    cookies, name, test_context
):
    """Test that the conda environment is created and pre-commit passes."""

    env_name = f"__test__{name}__"
    extra_context = {
        "conda_environment_name": env_name,
        "make_initial_commit": "yes",
        "create_conda_environment_at_finish": "yes",
    }
    result = cookies.bake(extra_context={**extra_context, **test_context})

    assert result.exit_code == 0
    assert result.exception is None

    if sys.platform != "win32":
        # Switch branch before pre-commit to prevent failure due to being on 'main'.
        subprocess.run(
            ("git", "checkout", "-b", "test"), cwd=result.project_path, check=True
        )

        # Check linting, but not on the first try since formatters fix stuff.
        subprocess.run(
            (conda_exe, "run", "-n", env_name, "pre-commit", "run", "--all-files"),
            cwd=result.project_path,
            check=False,
            env={},
        )
        subprocess.run(
            (conda_exe, "run", "-n", env_name, "pre-commit", "run", "--all-files"),
            cwd=result.project_path,
            check=True,
            env={},
        )

    subprocess.run(
        (conda_exe, "run", "-n", env_name, "pytask", "-x"),
        cwd=result.project_path,
        check=True,
    )

    # Remove environment only on non-CI machines.
    if not os.environ.get("CI"):
        subprocess.run(
            (conda_exe, "env", "remove", "-n", env_name),
            check=True,
        )
