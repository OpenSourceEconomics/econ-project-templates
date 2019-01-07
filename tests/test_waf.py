import subprocess
import os
import shutil
import pytest

from test_cookie import basic_project_dict


PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_dir(dirpath):
    shutil.rmtree(os.path.join(PROJECT_DIRECTORY, dirpath))


def _check_configure(result):
    try:
        log_configure = subprocess.check_output(
            ["python", "{}".format(result.project.join("waf.py")), "configure"]
        )
    except subprocess.CalledProcessError as e:
        log_configure = e.output
        print(log_configure)

    assert "'configure' finished successfully" in str(log_configure)


def _check_build(result):
    try:
        log_configure = subprocess.check_output(
            ["python", "{}".format(result.project.join("waf.py")), "build"]
        )
    except subprocess.CalledProcessError as e:
        log_configure = e.output
        print(log_configure)

    assert "'build' finished successfully" in str(log_configure)


def _check_configure_build(result):
    try:
        log_configure = subprocess.check_output(
            ["python", "{}".format(result.project.join("waf.py")), "configure", "build"]
        )
    except subprocess.CalledProcessError as e:
        log_configure = e.output
        print(log_configure)
    assert "'configure' finished successfully" in str(log_configure)
    assert "'build' finished successfully" in str(log_configure)


def test_waf_configure_python(cookies, basic_project_dict):
    result = cookies.bake(extra_context=basic_project_dict)
    _check_configure(result)


def test_waf_configure_build_python(cookies, basic_project_dict):
    result = cookies.bake(extra_context=basic_project_dict)
    _check_configure_build(result)


@pytest.mark.xfail
def test_waf_configure_r(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "R"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_configure(result)


@pytest.mark.xfail
def test_waf_configure_stata(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Stata"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_configure(result)


@pytest.mark.xfail
def test_waf_configure_matlab(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Matlab"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_configure(result)


@pytest.mark.xfail
def test_waf_configure_julia(cookies, basic_project_dict):
    basic_project_dict[
        "example_to_install"
    ] = "Julia (Warning: You will need to fix a lot yourself! Patches welcome!)"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_configure(result)


@pytest.mark.xfail
def test_waf_build_matlab(cookies, basic_project_dict):
    basic_project_dict["example_to_install"] = "Matlab"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_build(result)
