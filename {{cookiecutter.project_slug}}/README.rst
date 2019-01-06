{% for _ in cookiecutter.project_name %}={% endfor %}
{{ cookiecutter.project_name }}
{% for _ in cookiecutter.project_name %}={% endfor %}


{{ cookiecutter.project_short_description }}

Todo
----

- [ ] Work on the Readme

Managing the environment
------------------------

The framework relies on ``conda`` to manage the environment. If you work with the full Anaconda distribution, jump to the commands for executing the project.

If you don't have the necessary conda environment installed you can create it from the file environment.yml. Use the command:

.. code-block:: bash

    $ conda env create -n <env-name> -f environment.yml


The environment needs to be activated before you can execute waf. Run

.. code-block:: bash

    $ conda activate <env-name>


To delete the environment, type

.. code-block:: bash

    $ conda env remove -n <env-name>


Executing the project
---------------------

If you are a Windows user use the Anaconda prompt unless you know what you are doing.

The following commands are used to run the project:

.. code-block:: bash

    $ python waf.py configure
    $ python waf.py
    $ python waf.py install


Features
--------

