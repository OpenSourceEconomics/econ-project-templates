.. _developers:

For Developers
===============

This part is only for developers of the project template.

Pre-Release Tasks/Checks
--------------------------

1. Attach version numbers to the packages in environment.yml.

2. Update all pre-commit hooks to their newest version.

3. Check whether template works with the most current conda version on Windows by

    3.1 Running the tests after updating conda.

    3.2 Separately creating an example project and activating the environment.

    All other OS are tested via Azure CI.

4. Check that the documentation is correctly build by navigating to the docs folder and executing waf.

Releasing the template
-----------------------

1. Checkout the branch / commit with the template version to be released and create a tag with a *version* and a *Description*:

.. code-block:: bash

    $ git tag -a version -m "Description"

4. Push the tag to your remote git repository

.. code-block:: bash

    $ git push origin version

5. The release will be available `here <https://github.com/OpenSourceEconomics/econ-project-templates/releases>`__

6. Check that the documentation is correctly build by readthedocs.

How to compile the documentation in windows
---------------------------------------------

1. Install Imagemagick. Upon installing check the box "Install legacy components (convert.exe etc)"

2. Add Imagemagick to PATH.

3. Go to the folder which contains Imagemagick and rename the convert executable to imgconvert.

4. Now you can compile the documentation by navigating in the docs folder and running waf.
