{{ cookiecutter.project_name }}
{% for _ in cookiecutter.project_name %}={% endfor %}

{% if cookiecutter.add_github_actions == "yes" %}[![image](https://img.shields.io/github/workflow/status/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/main/main)](https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/actions?query=branch%3Amain)
{% endif %}
{% if cookiecutter.add_codecov == "yes" %}[![image](https://codecov.io/gh/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/branch/main/graph/badge.svg)](https://codecov.io/gh/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }})
{% endif %}
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/main.svg)](https://results.pre-commit.ci/latest/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/main)
[![image](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/ambv/black)


Usage
-----

To get started, create and activate the environment with

.. code-block:: console

    $ conda/mamba env create
    $ conda activate {{ cookiecutter.conda_environment_name }}

Now you can build the project using

.. code-block:: console

    $ pytask


Credits
-------

This project was created with [cookiecutter](https://github.com/audreyr/cookiecutter)
and the
econ-project-templates](https://github.com/OpenSourceEconomics/econ-project-templates).