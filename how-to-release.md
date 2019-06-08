Pre-Release Tasks/Checks
========================

1. Attach version numbers to the packages in environment.yml.

2. Update all pre-commit hooks to their newest version.

3. Check whether template works with the most current conda version (on Windows) by

    3.1 Running the tests after updating conda.
    
    3.2 Seperately creating one example project and activating the environment.
    
4. Run tests. 

Releasing the template
======================

1. Go to the branch with the template version to be released 

2. If you want to release the version of an older commit, use git checkout followed by the commit hash to point the current *HEAD* to it

3. Create a tag with a *name* and a *description*:
    
        git tag -a name -m "description"

4. Push the tag to your remote git repository
        
        git push origin name-of-tag

5. The release will be available [here](https://github.com/hmgaudecker/econ-project-templates/releases)

