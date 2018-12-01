import subprocess
import os
import shutil
import pytest
PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)

def remove_dir(dirpath):
    shutil.rmtree(os.path.join(PROJECT_DIRECTORY, dirpath))

def test_waf_configure_python(cookies):
    result = cookies.bake(extra_context={"configure_running_python_from_waf": "y",
                                         "configure_running_matlab_from_waf": "n",
                                         "configure_running_r_from_waf": "n",
                                         "configure_running_stata_from_waf": "n",
                                         "configure_running_julia_from_waf": "n",
                                         "project_slug": "research_project"})

    try:
        log_configure = subprocess.check_output(['python','{}'.format(result.project.join("waf.py")),'configure'])
    except subprocess.CalledProcessError as e:
        log_configure = e.output

    print(log_configure)
    assert "finished successfully" in str(log_configure) #to make pytest print stderr


def test_waf_configure_r(cookies):
    result = cookies.bake(extra_context = {"example_to_install":"R",
                                           "configure_running_python_from_waf": "n",
                                           "configure_running_matlab_from_waf": "n",
                                           "configure_running_r_from_waf": "y",
                                           "configure_running_stata_from_waf": "n",
                                           "configure_running_julia_from_waf": "n",
                                           "project_slug": "research_project"})

    try:
        log_configure = subprocess.check_output(['python','{}'.format(result.project.join("waf.py")),'configure'])
    except subprocess.CalledProcessError as e:
        log_configure = e.output

    print(log_configure)
    assert "finished successfully" in str(log_configure) #to make pytest print stderr


def test_waf_configure_stata(cookies):
    result = cookies.bake(extra_context = {"example_to_install":"Stata",
                                           "configure_running_python_from_waf": "n",
                                           "configure_running_matlab_from_waf": "n",
                                           "configure_running_r_from_waf": "n",
                                           "configure_running_stata_from_waf": "y",
                                           "configure_running_julia_from_waf": "n",
                                           "project_slug": "research_project"})

    try:
        log_configure = subprocess.check_output(['python','{}'.format(result.project.join("waf.py")),'configure'])
    except subprocess.CalledProcessError as e:
        log_configure = e.output

    print(log_configure)
    assert "finished successfully" in str(log_configure) #to make pytest print stderr


def test_waf_configure_matlab(cookies):
    result = cookies.bake(extra_context = {"example_to_install":"Matlab",
                                           "configure_running_python_from_waf": "n",
                                           "configure_running_matlab_from_waf": "y",
                                           "configure_running_r_from_waf": "n",
                                           "configure_running_stata_from_waf": "n",
                                           "configure_running_julia_from_waf": "n",
                                           "project_slug": "research_project"})

    try:
        log_configure = subprocess.check_output(['python','{}'.format(result.project.join("waf.py")),'configure'])
    except subprocess.CalledProcessError as e:
        log_configure = e.output

    print(log_configure)
    assert "finished successfully" in str(log_configure) #to make pytest print stderr



def test_waf_configure_without_cookies_pytest():

    template = subprocess.check_output(['cookiecutter','.','--no-input',
                                        'configure_running_stata_from_waf=n',
                                        'configure_running_matlab_from_waf=n',
                                        'configure_running_r_from_waf=n',
                                        'configure_running_julia_from_waf=n'])

    output = None
    try:
        output = subprocess.check_output(['python','the_general_theory_of_relativity/waf.py','configure'])
    except subprocess.CalledProcessError as e:
        output = e.output

    print(output)
    assert "success" in str(output) #just to make pytest print the stderr
    remove_dir("the_general_theory_of_relativity")
