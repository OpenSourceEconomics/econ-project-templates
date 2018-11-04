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


    for example in ["julia","matlab","python","stata","r"]:
        if example != "{{ cookiecutter.example_to_install }}".lower():

            remove_dir("src_{}".format(example))
        else:
            rename("src_{}".format(example),"src")

    if "{{ cookiecutter.configure_running_python_from_waf }}" != "y":
        pass

    if "{{ cookiecutter.create_author_file }}" != "y":
        remove_file("AUTHORS.rst")


    if "{{ cookiecutter.create_history_file }}" != "y":
        remove_file("HISTORY.rst")


    if "{{ cookiecutter.create_conda_environment_with_name }}" != "x":
        environment_name = "{{ cookiecutter.create_conda_environment_with_name }}"
        subprocess.call("conda env create --name {} --file environment.yml".format(environment_name),shell=True)


    if "{{ cookiecutter.set_up_git }}" == "y":

        subprocess.call(['git','init'])

        if "{{ cookiecutter.git_remote_url }}" != "":
            subprocess.call(['git','remote','add','origin','{{ cookiecutter.git_remote_url }}'])

        if "{{ cookiecutter.make_initial_commit }}" == "y":
            subprocess.call(['git','commit','-m','"Initial commit"'])

    if "{{ cookiecutter.add_pytest_to_project }}" != "y":
        # TODO
        pass

    if "{{ cookiecutter.add_formatter_to_project }}" != "y":
        remove_file("format_python_files.py")
        remove_file("pyproject.toml")

    if "{{ cookiecutter.configure_running_sphinx_from_waf }}" != "y":
        remove_dir("src/documentation")
