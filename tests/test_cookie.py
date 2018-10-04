import subprocess
import os

def test_bake_project(cookies):
    result = cookies.bake(extra_context = {"project_slug": "research_project"})

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project.basename == "research_project"
    assert result.project.isdir()


def test_project_slug_assertion(cookies):
    result = cookies.bake(extra_context={"project_slug": "-"})
    assert result.exit_code == -1


def test_environment_name_assertion(cookies):
    result = cookies.bake(extra_context={"create_environment_with_name": "1- a"})
    assert result.exit_code == -1


def test_install_Stata_example(cookies):
    result = cookies.bake(extra_context={"install_example": "Stata"})
    src_estimation_do = result.project.join("src/analysis/first_stage_estimation.do")
    assert result.exit_code == 0
    assert src_estimation_do.check(exists=1)


def test_run_stata_from_waf(cookies):
    result = cookies.bake(extra_context={"run_stata_from_waf": "y"})
    wscript = result.project.join("wscript").read()
    assert 'ctx.load("run_do_script")' in wscript
    assert 'ctx(features="write_project_paths", target="project_paths.do")' in wscript

# def test_waf(cookies):
#
#     result = cookies.bake(extra_context={"project_slug": "research_project"})
#     #log_configure = subprocess.check_output(['python','{}'.format(result.project.join("waf.py")),'configure'])
#     #log_build = subprocess.check_output(['python', '{}'.format(result.project.join("waf.py"))])
#
#     assert "Error" not in subprocess.check_output(['python', '{}'.format(result.project.join("waf.py")),'configure'])
#     assert subprocess.call(['python', '{}'.format(result.project.join("waf.py"))]) is not None


# def test_anaconda_environment_creation(cookies):
#     result = cookies.bake(extra_context={"create_environment_with_name": "reproducible_research_template"})
#     env = subprocess.check_output(['conda','env', 'list']).decode()
#
#     assert 'template_for_reproducible_research' in env


def test_remove_downloader(cookies):
    result = cookies.bake(extra_context={"add_downloader": "n"})

    downloader = result.project.join("prepare_data_for_project.py")

    assert result.exit_code == 0
    assert downloader.check(exists=0)


def test_remove_formatter(cookies):
    result = cookies.bake(extra_context={"add_formatter": "n"})

    formatter = result.project.join("format_python_files.py")
    pyproject = result.project.join("pyproject.toml")

    assert result.exit_code == 0
    assert formatter.check(exists=0)
    assert pyproject.check(exists=0)
    
