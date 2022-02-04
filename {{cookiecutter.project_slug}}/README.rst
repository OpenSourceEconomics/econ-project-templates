{{ cookiecutter.project_name }}
{% for _ in cookiecutter.project_name %}={% endfor %}

{% if cookiecutter.add_github_actions == "yes" %}.. image:: https://img.shields.io/github/workflow/status/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/main/main
    :target: https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/actions?query=branch%3Amain
{% endif %}
{% if cookiecutter.add_readthedocs == "yes" %}.. image:: https://readthedocs.org/projects/{{ cookiecutter.project_slug | replace("_", "-") }}/badge/?version=latest
    :target: https://{{ cookiecutter.project_slug | replace("_", "-") }}.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status
{% endif %}
{% if cookiecutter.add_codecov == "yes" %}.. image:: https://codecov.io/gh/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/branch/main/graph/badge.svg
    :target: https://codecov.io/gh/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}
{% endif %}
.. image:: https://results.pre-commit.ci/badge/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/main.svg
    :target: https://results.pre-commit.ci/latest/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/main
    :alt: pre-commit.ci status

.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
    :target: https://github.com/ambv/black


Usage
-----

To get started, create the environment with

.. code-block:: console

    $ conda/mamba env create

To build the project, type

.. code-block:: console

    $ pytask


Credits
-------

This project was created with `cookiecutter <https://github.com/audreyr/cookiecutter>`_
and the `econ-project-templates
<https://github.com/OpenSourceEconomics/econ-project-templates>`_.
