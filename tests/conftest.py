import pytest


@pytest.fixture()
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
        "configure_running_python": "y",
        "configure_running_matlab": "n",
        "configure_running_r": "n",
        "configure_running_stata": "n",
        "configure_running_sphinx": "n",
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
