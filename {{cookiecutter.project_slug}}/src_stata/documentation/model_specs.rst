.. _model_specifications:

********************
Model specifications
********************

The directory *src/model_specs* contains `JSON <http://www.json.org/>`_ files with model specifications. The choice of JSON is motivated by the attempt to be language-agnostic: JSON is quite expressive and there are parsers for nearly all languages ... except for ... Stata. [#]_ Thus, there is a converter in  *src/model_specs/wscript*. 

Because Stata macros are not all that expressive, it can only handle a limited set of JSON files. See the docstring of the **convert_model_json_to_stata**-function in *src/model_specs/wscript*. You can call it like any other task generator::

    ctx(
        rule=convert_model_json_to_stata,
        source='baseline.json',
        target='baseline.do',
    )

The best way to use this is to save a model as ``[model_name].json``, convert it to ``[model_name].do``,  and then pass ``[model_name]`` to your code using the ``append`` keyword of the ``run_do_script`` task generator.

.. [#] Note that there is `insheetjson <http://ideas.repec.org/c/boc/bocode/s457407.html>`_, but that will read a JSON file into the data set rather than into macros, which is what we need here.
