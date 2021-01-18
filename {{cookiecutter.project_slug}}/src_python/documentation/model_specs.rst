.. _model_specifications:

********************
Model specifications
********************

The directory *src.model_specs* contains `JSON <http://www.json.org/>`_ files with model specifications. The choice of JSON is motivated by the attempt to be language-agnostic: JSON is quite expressive and there are parsers for nearly all languages. [#]_


.. [#] Stata is the only execption I know of. You find a  converter in the pytask file of the Stata branch. Note that there is `insheetjson <http://ideas.repec.org/c/boc/bocode/s457407.html>`_, but that will read a JSON file into the data set rather than into macros, which is what we need here.
