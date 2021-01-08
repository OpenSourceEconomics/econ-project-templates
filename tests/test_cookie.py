import subprocess


def test_bake_project(cookies, basic_project_dict):

    print(cookies.bake(extra_context=basic_project_dict))
    result = cookies.bake(extra_context=basic_project_dict)

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project.basename == "research_project"
    assert result.project.isdir()


def test_project_slug_assertion(cookies, basic_project_dict):
    basic_project_dict["project_slug"] = "-"
    result = cookies.bake(extra_context=basic_project_dict)
    assert result.exit_code == 0


def test_install_Stata_example(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Stata"
    result = cookies.bake(extra_context=basic_project_dict)
    src_estimation_do = result.project.join("src/analysis/first_stage_estimation.do")
    assert result.exit_code == 0
    assert src_estimation_do.check(exists=1)


def test_install_Julia_example(cookies, basic_project_dict):
    basic_project_dict[
        "example_to_install"
    ] = "Julia (Warning: You will need to fix a lot yourself! Patches welcome!)"
    result = cookies.bake(extra_context=basic_project_dict)
    get_simulation_draws_jl = result.project.join(
        "src/data_management/get_simulation_draws.jl"
    )
    assert result.exit_code == 0
    assert get_simulation_draws_jl.check(exists=1)


def test_install_run_stata(cookies, basic_project_dict):
    basic_project_dict["configure_running_stata"] = "y"
    result = cookies.bake(extra_context=basic_project_dict)
    wscript = result.project.join("wscript").read()
    assert 'ctx.load("run_do_script")' in wscript
    assert 'ctx(features="write_project_paths", target="project_paths.do")' in wscript


def test_template_without_sphinx(cookies, basic_project_dict):
    basic_project_dict["configure_running_sphinx"] = "n"
    result = cookies.bake(extra_context=basic_project_dict)

    documentation_folder = result.project.join("src/documentation")
    wscript = result.project.join("src/wscript").read()
    assert result.exit_code == 0
    assert documentation_folder.check(exists=0)
    assert "ctx.recurse('documentation')" not in wscript


def test_template_with_git_setup(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["make_initial_commit"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    result = cookies.bake(extra_context=basic_project_dict)
    assert result.exit_code == 0
    assert result.project.join(".git").check(exists=1)


def test_conda_environment_creation(cookies, basic_project_dict):
    basic_project_dict[
        "create_conda_environment_with_name"
    ] = "test_of_reproducible_research_template"
    subprocess.run("conda deactivate", shell=True)
    _ = cookies.bake(extra_context=basic_project_dict)
    env = subprocess.check_output(["conda", "env", "list"]).decode()
    # Make sure to remove environment again!
    subprocess.run(
        """conda remove --name test_of_reproducible_research_template --all""",
        shell=True,
    )
    assert "test_of_reproducible_research_template" in env
