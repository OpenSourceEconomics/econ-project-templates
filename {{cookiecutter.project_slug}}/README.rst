{% for _ in cookiecutter.project_name %}={% endfor %}
{{ cookiecutter.project_name }}
{% for _ in cookiecutter.project_name %}={% endfor %}

{% if cookiecutter.add_pyup == 'y' %}
.. image:: https://travis-ci.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}.svg?branch=master
    :target: https://travis-ci.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}
{% endif %}

{% if cookiecutter.add_pyup == 'y' %}
.. image:: https://pyup.io/repos/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/shield.svg
    :target: https://pyup.io/repos/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/
    :alt: Updates
{% endif %}

{% if cookiecutter.add_readthedocs == 'y' %}
.. image:: https://readthedocs.org/projects/{{ cookiecutter.project_slug | replace("_", "-") }}/badge/?version=latest
    :target: https://{{ cookiecutter.project_slug | replace("_", "-") }}.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status
{% endif %}

{% if cookiecutter.add_formatter == 'y' %}
.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
    :target: https://github.com/ambv/black
{% endif %}

{{ cookiecutter.project_short_description }}

Todo
----

- [ ] Make this project better

Managing the environment
------------------------

The framework relies on ``conda`` to manage the environment. To have support
for activation/deactivation with Powershell on Windows, type the following
command while staying in your base environment:

.. code-block:: bash

    $ conda install -c pscondaenvs pscondaenvs

You need ``conda`` to create the environment. Then, run

.. code-block:: bash

    $ conda env create -n <env-name> -f environment.yml

To activate the environment, type

.. code-block:: bash

    $ activate <env-name>

To delete the environment, type

.. code-block:: bash

    $ conda env remove -n <env-name>

Credits
-------

This package was created with Cookiecutter_ and the
`tobiasraabe/cookiecutter-research-template`_ project template.

.. _Cookiecutter: https://github.com/audreyr/cookiecutter
.. _`tobiasraabe/cookiecutter-research-template`:
   https://github.com/tobiasraabe/cookiecutter-research-template
