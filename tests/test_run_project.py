import subprocess

from test_cookies import check_cookies_basics


def test_python(cookies, basic_project_dict):

    cookies_result = cookies.bake(extra_context=basic_project_dict)
    check_cookies_basics(cookies_result=cookies_result)
    pytask_result = subprocess.run(
        "conda develop . && pytask", shell=True, cwd=cookies_result.project
    )
    # import pdb; pdb.set_trace()

    assert pytask_result.returncode == 0


def test_r(cookies, basic_project_dict):

    basic_project_dict["example_to_install"] = "R"
    cookies_result = cookies.bake(extra_context=basic_project_dict)
    check_cookies_basics(cookies_result=cookies_result)
    pytask_result = subprocess.run(
        "conda develop . && pytask -s", shell=True, cwd=cookies_result.project
    )
    # import pdb; pdb.set_trace()

    assert pytask_result.returncode == 0


def test_stata(cookies, basic_project_dict):

    basic_project_dict["example_to_install"] = "Stata"
    cookies_result = cookies.bake(extra_context=basic_project_dict)
    check_cookies_basics(cookies_result=cookies_result)
    pytask_result = subprocess.run(
        "conda develop . && pytask -s", shell=True, cwd=cookies_result.project
    )
    # import pdb; pdb.set_trace()

    assert pytask_result.returncode == 0
