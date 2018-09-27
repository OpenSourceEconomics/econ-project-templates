def test_bake_project(cookies):
    result = cookies.bake(extra_context={"project_slug": "helloworld"})

    assert result.exit_code == 0
    assert result.exception is None
    assert result.project.basename == "helloworld"
    assert result.project.isdir()

def test_project_slug_assertion(cookies):
    result = cookies.bake(extra_context={"project_slug": "-"})
    assert result.exit_code == -1

def test_environment_name_assertion(cookies):
    result = cookies.bake(extra_context={"create_environment_with_name": "1- a"})
    assert result.exit_code == -1

def test_install_Stata_example(cookies):
    result = cookies.bake(extra_context={"install_example": "Matlab"})
    src_estimation_do = result.project.join("src/first_stage_estimation.do")
    assert result.exit_code == 0
    assert src_estimation_do.check(exists=0)



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
    
