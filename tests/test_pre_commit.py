import re
import subprocess

from test_cookie import basic_project_dict


def _check_pre_commit(result):
    c = subprocess.Popen(
        "pre-commit run -a",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=False,
        cwd=result.project,
    )
    output, error = c.communicate()

    assert (not re.search(r"Failed", str(output))) and (not error), "{}".format(
        str(error)
    )


def test_pre_commit_python(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_pre_commit(result)


def test_pre_commit_r(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    basic_project_dict["example_to_install"] = "R"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_pre_commit(result)


def test_pre_commit_stata(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    basic_project_dict["example_to_install"] = "Stata"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_pre_commit(result)


def test_pre_commit_julia(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    basic_project_dict[
        "example_to_install"
    ] = "Julia (Warning: You will need to fix a lot yourself! Patches welcome!)"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_pre_commit(result)


def test_pre_commit_matlab(cookies, basic_project_dict):
    basic_project_dict["set_up_git"] = "y"
    basic_project_dict["add_basic_pre_commit_hooks"] = "y"
    basic_project_dict["add_intrusive_pre_commit"] = "y"
    basic_project_dict["example_to_install"] = "Matlab"
    result = cookies.bake(extra_context=basic_project_dict)
    _check_pre_commit(result)
