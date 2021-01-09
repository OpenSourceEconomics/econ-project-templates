import subprocess


def test_pytask_python(cookies, basic_project_dict):

    result = cookies.bake(extra_context=basic_project_dict)
    subprocess.run("conda develop . && pytask", shell=True, cwd=result.project)

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project.basename == "research_project"
    assert result.project.isdir()
