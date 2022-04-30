[The pictures are a little outdated, but you get the idea]

The left node of the following graph shows the contents of the project root directory
after executing ``pytask``:

.. figure:: ../../figures/project_hierarchies_big_pic.png
   :width: 50em

Files and directories in brownish colours are constructed by pytask; those with a bluish
background are added directly by the researcher. You immediately see the **separation of
inputs and outputs** (one of our guiding principles) at work:

    * All source code is in the *src* directory.
    * All outputs are constructed in the *bld* directory.
    * The paper and presentation are put there so they can be opened easily.

The contents of both the *root/bld* and the *root/src* directories directly follow the
steps of the analysis from the :ref:`workflow <workflow>` section.

The idea is that everything that needs to be run during the, say, **analysis** step, is
specified in *root/src/analysis* and all its output is placed in *root/bld/analysis*.

Some differences:

* Because they are accessed frequently, *figures* and *tables* get extra directories
  in *root/bld*
* The directory *root/src* contains many more subdirectories:

    * *original_data* is the place to store the data in its raw form, as downloaded
      / transcribed / ... The original data should **never** be modified and saved
      under the same name.
    * *model_code* contains source files that might differ by model and that are
      potentially used at various steps of the analysis.
    * *model_specs* contains `JSON <http://www.json.org/>`_ files with model
      specifications. The choice of JSON is motivated by the attempt to be
      language-agnostic: JSON is quite expressive and there are parsers for nearly all
      languages (for Stata there is a converter in *root/src/model_specs/task_models.py*
      file of the Stata version of the template)
    * *library* provides code that may be used by different steps of the analysis.
      Little code snippets for input / output or stuff that is not directly related to
      the model would go here. The distinction from the *model_code* directory is a bit
      arbitrary, but I have found it useful in the past.


As an example of how things look further down in the hierarchy, consider the *analysis*
step:

.. figure:: ../../figures/project_hierarchies_analysis.png
   :width: 30em

The same function (`task_schelling`) is run twice for the models `baseline` and
`max_moves_2`. All specification of files is done in pytask.

It is imperative that you do all the task handling inside the `task_xxx.py`-scripts,
using the `pathlib <https://realpython.com/python-pathlib/>`_ library. This ensures that
your project can be used on different machines and it minimises the potential for
cross-platform errors.

For running Python source code from pytask, simply include `depends_on` and `produces`
as inputs to your function.

For running scripts in other languages, pass all required files (inputs, log files,
outputs) as arguments to the `@pytask.mark.[x]`-decorator. You can then read them in.
Check the other templates for examples.
