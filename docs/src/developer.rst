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

    3.2 Seperately creating an example project and activating the environment.

    All other OS are tested via Azure CI.

4. Check that the documentation is correctly build by navigating to the docs folder and executing waf.

Releasing the template
-----------------------

1. Go to the branch with the template version to be released

2. If you want to release the version of an older commit, use git checkout followed by the commit hash to point the current *HEAD* to it

3. Create a tag with a *name* and a *description*:

.. code-block:: bash

    $ git tag -a name -m "description"

4. Push the tag to your remote git repository

.. code-block:: bash

    $ git push origin name-of-tag

5. The release will be available `here <https://github.com/hmgaudecker/econ-project-templates/releases>`_

6. Check that the documentation is correctly build by readthedocs.

How to compile the documentation in windows
---------------------------------------------

1. Install Imagemagick. Upon installing check the box "Install legacy components (convert.exe etc)"

2. Add Imagemagick to PATH.

3. Go to the folder which contains Imagemagick and rename the convert executable to imgconvert.

4. Now you can compile the documentation by navigating in the docs folder and running waf.

