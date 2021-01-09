import subprocess


def test_bake_project(cookies, basic_project_dict):

    print(cookies.bake(extra_context=basic_project_dict))
    result = cookies.bake(extra_context=basic_project_dict)

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project.basename == "research_project"
    assert result.project.isdir()


def test_install_python_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Python"
    result = cookies.bake(extra_context=basic_project_dict)
    schelling = result.project.join("src/analysis/task_schelling.py")
    assert result.exit_code == 0
    assert schelling.check(exists=1)


def test_install_matlab_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Matlab"
    result = cookies.bake(extra_context=basic_project_dict)
    schelling = result.project.join("src/analysis/schelling.m")
    assert result.exit_code == 0
    assert schelling.check(exists=1)


def test_project_slug_assertion(cookies, basic_project_dict):
    basic_project_dict["project_slug"] = "-"
    result = cookies.bake(extra_context=basic_project_dict)
    assert result.exit_code == 0


def test_install_stata_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Stata"
    result = cookies.bake(extra_context=basic_project_dict)
    src_estimation_do = result.project.join("src/analysis/first_stage_estimation.do")
    assert result.exit_code == 0
    assert src_estimation_do.check(exists=1)


def test_install_r_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "R"
    result = cookies.bake(extra_context=basic_project_dict)
    src_estimation_r = result.project.join("src/analysis/first_stage_estimation.r")
    assert result.exit_code == 0
    assert src_estimation_r.check(exists=1)


def test_template_with_git_setup(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["make_initial_commit"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    result = cookies.bake(extra_context=basic_project_dict)
    assert result.exit_code == 0
    assert result.project.join(".git").check(exists=1)


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
