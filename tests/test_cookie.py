import subprocess
import os
import pytest

@pytest.fixture
def basic_project_dict():
    return {
        "configure_running_python_from_waf": "y",
        "configure_running_matlab_from_waf": "n",
        "configure_running_r_from_waf": "n",
        "configure_running_stata_from_waf": "n",
        "configure_running_julia_from_waf": "n",
    }


def test_bake_project(cookies,basic_project_dict):

    result = cookies.bake(extra_context = {**basic_project_dict,**{"project_slug": "research_project"}})

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project.basename == "research_project"
    assert result.project.isdir()


def test_project_slug_assertion(cookies,basic_project_dict):
    result = cookies.bake(extra_context={**basic_project_dict,**{"project_slug": "-"}})
    assert result.exit_code == -1


def test_install_Stata_example(cookies,basic_project_dict):
    result = cookies.bake(extra_context={**basic_project_dict,**{"example_to_install": "Stata"}})
    src_estimation_do = result.project.join("src/analysis/first_stage_estimation.do")
    assert result.exit_code == 0
    assert src_estimation_do.check(exists=1)


def test_install_Julia_example(cookies,basic_project_dict):
    result = cookies.bake(extra_context={**basic_project_dict,**{"example_to_install": "Julia"}})
    schelling_py = result.project.join("src/analysis/schelling.py")
    assert result.exit_code == 0
    assert schelling_py.check(exists=1)


def test_install_run_stata_from_waf(cookies,basic_project_dict):
    result = cookies.bake(extra_context={**basic_project_dict,**{"configure_running_stata_from_waf": "y"}})
    wscript = result.project.join("wscript").read()
    assert 'ctx.load("run_do_script")' in wscript
    assert 'ctx(features="write_project_paths", target="project_paths.do")' in wscript




def test_remove_formatter(cookies,basic_project_dict):
    result = cookies.bake(extra_context={**basic_project_dict,**{"add_formatter_to_project": "n"}})

    formatter = result.project.join("format_python_files.py")
    pyproject = result.project.join("pyproject.toml")

    assert result.exit_code == 0
    assert formatter.check(exists=0)
    assert pyproject.check(exists=0)


def test_template_without_sphinx(cookies, basic_project_dict):
    result = cookies.bake(extra_context={**basic_project_dict,**{"configure_running_sphinx_from_waf": "n"}})

    documentation_folder = result.project.join("src/documentation")
    wscript = result.project.join("src/wscript").read()
    assert result.exit_code == 0
    assert documentation_folder.check(exists=0)
    assert "ctx.recurse('documentation')" not in wscript


# def test_anaconda_environment_creation(cookies):
#     result = cookies.bake(extra_context={"create_conda_environment_with_name": "reproducible_research_template"})
#     env = subprocess.check_output(['conda','env', 'list']).decode()
#
#     assert 'template_for_reproducible_research' in env


# def test_environment_name_assertion(cookies,basic_project_dict):
#     result = cookies.bake(extra_context={**basic_project_dict,**{"create_conda_environment_with_name": "1- a"}})
#     assert result.exit_code == -1
