#!/usr/bin/env python
import os
import shutil
import subprocess

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_file(filepath):
    os.remove(os.path.join(PROJECT_DIRECTORY, filepath))


def remove_dir(dirpath):
    shutil.rmtree(os.path.join(PROJECT_DIRECTORY, dirpath))


def rename(filepath, new_filepath):
    os.rename(
        os.path.join(PROJECT_DIRECTORY, filepath),
        os.path.join(PROJECT_DIRECTORY, new_filepath),
    )


if __name__ == "__main__":

    specified_example = "{{ cookiecutter.example_to_install }}".lower()
    raw_examples = {"matlab", "python", "stata", "r"}
    assert specified_example in raw_examples

    for example in raw_examples:
        if example != specified_example:
            remove_dir(f"src_{example}")
        else:
            rename(f"src_{example}", "src")

    if "{{ cookiecutter.create_conda_environment_with_name }}" == "x":
        environment_name = None
    else:
        environment_name = "{{ cookiecutter.create_conda_environment_with_name }}"
        subprocess.run(["conda", "env", "create"])

    if "{{ cookiecutter.set_up_git }}" == "y":

        subprocess.run(["git", "init"])

        if "{{ cookiecutter.git_remote_url }}" != "":
            subprocess.run(
                ["git", "remote", "add", "origin", "{{ cookiecutter.git_remote_url }}"]
            )

        if "{{ cookiecutter.make_initial_commit }}" == "y":
            subprocess.run(["git", "add", "."])
            subprocess.run(
                [
                    "git",
                    "commit",
                    "-m",
                    "'Initial commit with template from "
                    "https://github.com/OpenSourceEconomics/econ-project-templates'",
                ]
            )
    if "{{ cookiecutter.add_basic_pre_commit_hooks }}" == "n":
        remove_file(".pre-commit-config.yaml")
