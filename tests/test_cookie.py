import subprocess


def check_cookies_basics(cookies_result):
    assert cookies_result.exit_code == 0
    assert cookies_result.exception is None
    assert cookies_result.project_path.name == "research_project"
    assert cookies_result.project_path.is_dir()


def test_bake_project(cookies, basic_project_dict):
    print(cookies.bake(extra_context=basic_project_dict))
    result = cookies.bake(extra_context=basic_project_dict)
    check_cookies_basics(cookies_result=result)


def test_install_python_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Python"
    result = cookies.bake(extra_context=basic_project_dict)
    schelling = result.project_path / "src" / "analysis" / "task_schelling.py"
    check_cookies_basics(cookies_result=result)
    assert schelling.exists()


def test_install_matlab_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Matlab"
    result = cookies.bake(extra_context=basic_project_dict)
    schelling = result.project_path / "src" / "analysis" / "schelling.m"
    check_cookies_basics(cookies_result=result)
    assert schelling.exists()


def test_project_slug_hyphen_okay(cookies, basic_project_dict):
    basic_project_dict["project_slug"] = "-"
    result = cookies.bake(extra_context=basic_project_dict)
    assert result.exit_code == 0


def test_install_stata_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Stata"
    result = cookies.bake(extra_context=basic_project_dict)
    src_estimation_do = (
        result.project_path / "src" / "analysis" / "first_stage_estimation.do"
    )
    assert result.exit_code == 0
    assert src_estimation_do.exists()


def test_install_r_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "R"
    result = cookies.bake(extra_context=basic_project_dict)
    src_estimation_r = (
        result.project_path / "src" / "analysis" / "first_stage_estimation.r"
    )
    assert result.exit_code == 0
    assert src_estimation_r.exists()


def test_template_with_git_setup(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["make_initial_commit"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    result = cookies.bake(extra_context=basic_project_dict)
    repo = result.project_path / ".git"
    assert result.exit_code == 0
    assert repo.exists()


def _check_conda_environment_creation(cookies, basic_project_dict):
    subprocess.run("conda deactivate", shell=True)
    _ = cookies.bake(extra_context=basic_project_dict)
    env = subprocess.check_output(["conda", "env", "list"]).decode()
    # import pdb; pdb.set_trace()
    # Make sure to remove environment again!
    subprocess.run(
        """conda remove --name test_of_reproducible_research_template --all""",
        shell=True,
    )
    assert "test_of_reproducible_research_template" in env


def test_conda_environment_creation(cookies, basic_project_dict):
    basic_project_dict[
        "create_conda_environment_with_name"
    ] = "test_of_reproducible_research_template"
    _check_conda_environment_creation(cookies, basic_project_dict)


def test_conda_environment_creation_r(cookies, basic_project_dict):
    basic_project_dict[
        "create_conda_environment_with_name"
    ] = "test_of_reproducible_research_template"
    basic_project_dict["configure_running_r"] = ("y",)
    _check_conda_environment_creation(cookies, basic_project_dict)


def test_conda_environment_creation_matlab(cookies, basic_project_dict):
    basic_project_dict[
        "create_conda_environment_with_name"
    ] = "test_of_reproducible_research_template"
    basic_project_dict["configure_running_matlab"] = ("y",)
    _check_conda_environment_creation(cookies, basic_project_dict)


def test_conda_environment_creation_stata(cookies, basic_project_dict):
    basic_project_dict[
        "create_conda_environment_with_name"
    ] = "test_of_reproducible_research_template"
    basic_project_dict["configure_running_stata"] = ("y",)
    _check_conda_environment_creation(cookies, basic_project_dict)
