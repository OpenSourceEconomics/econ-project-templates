import subprocess

import pytest


@pytest.fixture
def basic_project_dict():
    return {
        "author": "abc",
        "email": "x@y.z",
        "affiliation": "Universität Hintertupfingen",
        "project_name": "Research Project",
        "project_slug": "research_project",
        "project_short_description": "Nothing, really",
        "create_conda_environment_with_name": "x",
        "set_up_git": "n",
        "make_initial_commit": "n",
        "git_remote_url": "",
        "make_initial_commit": "n",
        "example_to_install": "Python",
        "configure_running_python_from_waf": "y",
        "configure_running_matlab_from_waf": "n",
        "configure_running_r_from_waf": "n",
        "configure_running_stata_from_waf": "n",
        "configure_running_julia_from_waf": "n",
        "configure_running_sphinx_from_waf": "n",
        "add_basic_pre_commit_hooks": "n",
        "add_intrusive_pre_commit": "n",
        "open_source_license": "n",
        "_copy_without_render": [
            ".mywaflib",
            "*.bib",
            "src_matlab/library/matlab-json/*",
            "src_stata/library/stata/ado_ext/*",
        ],
    }


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


def test_install_run_stata_from_waf(cookies, basic_project_dict):
    basic_project_dict["configure_running_stata_from_waf"] = "y"
    result = cookies.bake(extra_context=basic_project_dict)
    wscript = result.project.join("wscript").read()
    assert 'ctx.load("run_do_script")' in wscript
    assert 'ctx(features="write_project_paths", target="project_paths.do")' in wscript


def test_remove_formatter(cookies, basic_project_dict):
    basic_project_dict["add_python_code_formatter_to_project"] = "n"
    result = cookies.bake(extra_context=basic_project_dict)
    formatter = result.project.join("format_python_files.py")
    pyproject = result.project.join("pyproject.toml")

    assert result.exit_code == 0
    assert formatter.check(exists=0)
    assert pyproject.check(exists=0)


def test_template_without_sphinx(cookies, basic_project_dict):
    basic_project_dict["configure_running_sphinx_from_waf"] = "n"
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
    result = cookies.bake(extra_context=basic_project_dict)
    env = subprocess.check_output(["conda", "env", "list"]).decode()
    # Make sure to remove environment again!
    subprocess.run(
        """conda remove --name test_of_reproducible_research_template --all""",
        shell=True,
    )
    assert "test_of_reproducible_research_template" in env
