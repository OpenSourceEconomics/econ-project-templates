#!/usr/bin/env python
import os
import subprocess
import shutil

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_file(filepath):
    os.remove(os.path.join(PROJECT_DIRECTORY, filepath))

def remove_dir(dirpath):
    shutil.rmtree(os.path.join(PROJECT_DIRECTORY, dirpath))

def rename(filepath,new_filepath):
    os.rename(os.path.join(PROJECT_DIRECTORY,filepath),os.path.join(PROJECT_DIRECTORY,new_filepath))

if __name__ == "__main__":


    for example in ["Julia","Matlab","Python","Stata","R"]:
        if example != "{{ cookiecutter.install_example }}":

            remove_dir("src_{}".format(example))
        else:
            rename("src_{}".format(example),"src")

    if "{{ cookiecutter.run_python_from_waf }}" != "y":
        pass

    if "{{ cookiecutter.create_author_file }}" != "y":
        remove_file("AUTHORS.rst")
        remove_file("src/documentation/authors.rst")

    if "{{ cookiecutter.create_history_file }}" != "y":
        remove_file("HISTORY.rst")
        remove_file("src/documentation/history.rst")

    if "{{ cookiecutter.create_environment_with_name }}" != "x":
        environment_name = "{{ cookiecutter.create_environment_with_name }}"
        subprocess.call("conda env create --name {} --file environment.yml".format(environment_name),shell=True)

    if "{{ cookiecutter.add_pytest }}" != "y":
        # TODO
        remove_file("tests/__init__.py")

    if "{{ cookiecutter.add_pyup }}" != "y":
        remove_file(".pyup.yml")

    if "{{ cookiecutter.add_tox }}" != "y":
        remove_file("tox.ini")

    if "{{ cookiecutter.add_travis }}" != "y":
        remove_file(".travis.yml")

    if "{{ cookiecutter.add_downloader }}" != "y":
        remove_file("prepare_data_for_project.py")

    if "{{ cookiecutter.add_cleaner }}" != "y":
        remove_file("clean.py")

    if "{{ cookiecutter.add_debugger }}" != "y":
        remove_file("debug.ps1")

    if "{{ cookiecutter.add_formatter }}" != "y":
        remove_file("format_python_files.py")
        remove_file("pyproject.toml")
