.. _model_specifications:

********************
Model specifications
********************

The directory *src.model_specs* contains `JSON <http://www.json.org/>`_ files with model specifications. The choice of JSON is motivated by the attempt to be language-agnostic: JSON is quite expressive and there are parsers for nearly all languages. [#]_

The best way to use this is to save a model as ``[model_name].json`` and then pass ``[model_name]`` to your code using the ``append`` keyword of the ``run_py_script`` task generator.

 .. [#] Stata is the only execption I know of. You find a  converter in the wscript file of the Stata branch. Note that there is `insheetjson <http://ideas.repec.org/c/boc/bocode/s457407.html>`_, but that will read a JSON file into the data set rather than into macros, which is what we need here.
 