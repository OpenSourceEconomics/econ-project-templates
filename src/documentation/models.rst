.. _model_specifications:


Model specifications
======================

The directory **src.models** contains JSON files with model specifications. These can be automatically converted to Stata .do-files, although currently only a very limited functionality is supported.


The general workflow for using this is as follows:

    #. Write model specifications in JSON -- currently you must provide a single dictionary with strings or numbers as elements.
    #. Create a task based on the function **convert_model_json_to_stata** (or eventually a task generator) to convert them to Stata or any language you want (similar to what happens in the **write_project_paths** task generator).
    #. In the **data_management** / **analysis** / **final** directories, use Waf to generate a new file, which runs the main code like a function.
    
    A typical Stata file would look like::
    
        // Automatically generated file. Never change.
        // Change contents in:
        //   src/models/baseline.do
        //   src/analysis/streg_example.do

        do /path/to/project/bld/models/baseline.do
        do /path/to/project/bld/analysis/streg_example.do

    
    A typical Python file might look like (not tested)::

        """Automatically generated file. Never change.
        
        Change contents in:
          src/models/baseline.json
          src/analysis/streg_example.py
        
        """
        
        import json
        from src.library import project_paths_join

        model_pars = json.load(open(project_paths_join('IN_MODELS', baseline.json)))
        from src.analysis.streg_example import main
        
        main(model_pars)
    
    
    #. Run the resulting file (which you would presumably call **baseline_streg_example.do** (**.py**)) using the usual task generators.
    
Another alternative would be to call the scripts in 4. with the appropriate model configuration file as a command-line option. But this would require a major change of the task generators; it does not scale well to a larger number of files; it is a nightmare to parse options in Stata; and it becomes more difficult to run the scripts in "debug mode", i.e. directly from Stata / Eclipse.
