import subprocess


def test_pytask_python(cookies, basic_project_dict):

    cookie_result = cookies.bake(extra_context=basic_project_dict)
    pytask_result = subprocess.run(
        "conda develop . && pytask", shell=True, cwd=cookie_result.project
    )
    # import pdb; pdb.set_trace()

    assert pytask_result.returncode == 0
