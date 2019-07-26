
`Waf <https://waf.io>`_ is our tool of choice to automate the dependency tracking via a DAG (directed acyclic graph) structure. Written in Python and originally designed to build software, it directly extends to our purposes. You find the program in the root folder of the project template (the file *waf.py* and the hidden folder *.mywaflib*). The settings for a particular project are controlled via files called *wscript*, which are kept in the root directory (required) and usually in the directories close to the tasks that need to be performed.

There are three phases to building a project:

  * **configure**: Set the project and build directories, find required programs on a particular machine
  * **build**: Build the targets (intermediate and final: cleaned datasets, graphs, tables, paper, presentation, documentation)
  * **install**: Copy a selection of targets to places where you find them more easily.

Additionally, there are two phases for cleanup which are useful to enforce a rebuild of the project:
  * **clean**: Cleans up project so that all tasks will be performed anew upon the next build.
  * **distclean**: Cleans up more thoroughly (by deleting the build directory), requiring configure again.

The project directory is always the root directory of the project, the build directory is usually called *bld*. This is how we implement it in the main *wscript* file:

.. literalinclude:: ../bld/example/r/r_example/wscript
    :start-after: import os
    :end-before: def set_project_paths

We will have more to say about the directory structure in the :ref:`rorganisation` section. For now, we note that a step towards achieving the goal of clearly separating inputs and outputs is that we specify a separate build directory. All output files go there (including intermediate output), it is never kept under version control, and it can be safely removed -- everything in it will be reconstructed automatically the next time Waf is run.


The configure phase
--------------------

The first time you fire up a project you need to invoke Waf by changing to the project root directory in a shell and typing

.. code:: console

    $ python waf.py configure

You only need to do this once, or whenever the location of the programs that your project requires changes (say, you installed a new version of LaTeX), you performed a distclean, or manually removed the entire build directory. Because of the ``configure`` argument Waf will call the function by the same name, which lives in the main *wscript* file:

.. literalinclude:: ../bld/example/r/r_example/wscript
    :start-after: return os.path.join(path_to_dir, args[-1])
    :end-before: def build

Let us dissect this function line-by-line:

  * ``ctx.env.PYTHONPATH = os.getcwd()`` sets the PYTHONPATH environmental variable to the project root folder so we can use hierarchical imports in our Python scripts
  * ``ctx.load('run_r_script')`` loads a little tool for running R scripts. Similar tools exist for Matlab, Stata, Python, and Perl. More can be easily created.
  * ``ctx.load('sphinx_build')`` loads the tool required to build the project's documentation.
  * ``ctx.load('write_project_headers')`` loads a tool for handling project paths. We postpone the discussion until the :ref:`section <project_paths>` by the same name.
  ``ctx.load('biber')`` loads a `modern replacement <http://biblatex-biber.sourceforge.net/>`_ for BibTeX and the entire LaTeX machinery with it.

Waf now knows everything about your computer system that it needs to know in order to perform the tasks you ask it to perform. Of course, other projects may require different tools, but you load them in the same way.

.. note::

  The ``ctx`` argument that is passed to all functions (configure, build, ...) in Waf is short for "context". It holds all kinds of methods and variables relevant for executing the task (configure, build, ...) at hand. See the Waf documentation (`here <http://docs.waf.googlecode.com/git/book_17/single.html>`_ or `here <http://docs.waf.googlecode.com/git/apidocs_17/index.html#>`_).


Specifying dependencies and the build phase
--------------------------------------------

Let us go step-by-step through the entire dependency graph of the project from the section on :ref:`DAG's <dag_s>`, which is reproduced here for convenience:

.. figure:: ../bld/example/r/ajrcomment_dependencies.png
   :width: 50em

Remember the colors of the edges follow the step of the analysis; we will split  our description along the same lines. First, we need to show how to keep the Waf code in separate directories (else it would become quickly unmanageable).


Distributing the dependencies by step of the analysis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Waf makes it easy to proceed in a step-wise manner by letting the user distribute *wscript* files across a directory hierarchy. This is an excerpt from the ``build`` function in the main *wscript* file:

.. code:: python

    def build(ctx):
        ctx.recurse('src')

When this function is called, it will descend into a subfolder *src*, look for a file called *wscript* and invoke the ``build`` function defined therein. If any of the three does not exist, it will fail. In the file *src/wscript*, you will find (among other calls), the following statements:

.. code:: python

    def build(ctx):
        ctx.recurse('data_management')
        ctx.recurse('analysis')
        ctx.recurse('final')
        ctx.recurse('paper')

The same comments as before apply to what the ``ctx.recurse`` calls do. Hence you can specify the dependencies separately for each step of the analysis.


The "data management" step
^^^^^^^^^^^^^^^^^^^^^^^^^^

The dependency structure at this step of the analysis is particularly simple, as we have one source, one dependency and one target:

.. figure:: ../bld/example/r/ajrcomment_dependencies_data_mgmt.png
   :width: 30em

This is the entire content of the file *src/data_management/wscript*:

.. literalinclude:: ../bld/example/r/r_example/src/data_management/wscript

The ``ctx()`` call is a shortcut for creating a **task generator**. We will be more specific about that below in the section :ref:`build_phase`. Let us look at the lines one-by-one again:

  * ``features='run_r_script'`` tells Waf what **action** it needs to perform. In this case, it should run a R script.
  * ``source='add_variables.r'`` tells Waf that it should perform the action on the file *add_variables.r* in the current directory.
  * ``target=[ctx.path_to(ctx, "OUT_DATA", "ajrcomment_all.txt")]`` tells Waf that the specified action will produce a file called *ajrcomment_all.txt* in a directory that is determined in the ``ctx.path_to()``. We will examine this in detail in the :ref:`organisation` section, for now we abstract from it beyond noting that the ``OUT_DATA`` keyword refers to the directory where output data are stored.
  * ``deps=[ctx.path_to(ctx, 'IN_DATA', 'ajrcomment.dta')]`` tells Waf that the execution of the R script depends on a file *ajrcomment.dta* which needs to be in a directory referenced by the keyword ``IN_DATA``.

And this is it! The rest are slight variations on this procedure and straightforward generalisations thereof.

.. _rwaf_analysis:

The "analysis" step
^^^^^^^^^^^^^^^^^^^^

We concentrate our discussion on the bottom left part of the graph, i.e. the second stage estimation using Panel A (Baseline). The lower part is the exact mirror image. We have the following structure:

.. figure:: ../bld/example/r/ajrcomment_dependencies_main.png
   :width: 40em

Note that instead of writing different srcipts for the estimation of the baseline (Panel A) and rmconj (Panel B), we write a general code that works for both and loop over the different specifications which are defined in baseline.json and rcomj.json. The loop is implemented via waf and thus **outside of the Rscript**. This will be further explained below.

To recap:

  * *baseline.json* is the file that contains the baseline model specification/sample (Panel A)
  * *geography.json* contains different sets of geographic controls to use for each Panel.
  * *ajrcomment_all.txt* is the file we produced before
  * *functions.r* contains functions to calculate the different standard errors
  * *second_stage_estimation.r* is the file that generates the iv estimates
  * *second_stage_estimation_baseline.txt* contains the results of the iv estimation of the baseline specification using varying sets of geographic controls.

We specify this dependency structure in the file *src/analysis/wscript*, which has the following contents:

.. literalinclude:: ../bld/example/r/r_example/src/analysis/wscript


Some points to note about this:

  * The loop over the different mortality rate specifications (Panel A and B) allows us to specify the code in one go; we focus on the case where the variable ``model`` takes on the value ``'baseline'`` and the ``stage`` is ``'second'``.
  * Note the difference between the ``source`` and the ``deps``: Even though the dependency graph above neglects the difference, Waf needs to know on which file it needs to run the task. This is done via the ``source`` keyword. The other files will only be used for setting the dependencies.
  * The first item in the list of ``deps`` is **exactly** the same as the target in the data management step.
  * Don't worry about the directories in the ``ctx.path_to()`` calls until the section ":ref:`organisation`" below
  * **Looping with waf via append**: The ``append`` keyword allows us to pass arguments to the R script. In particular, *second_stage_estimation.r* will be invoked as follows:

    .. code-block:: bash

        $ Rscript /path/to/project/src/analysis/second_stage_estimation.r baseline

    In *second_stage_estimation.r*, the model name is then read in using:

    .. code-block:: r

        model_name <- commandArgs(trailingOnly = TRUE)

    and we can load the correct model specification (i.e., *baseline.json*). This works similarly in other languages; see the respective project template as an example.


The "final" step
^^^^^^^^^^^^^^^^

Again, we concentrate on the baseline model.

.. figure:: ../bld/example/r/ajrcomment_dependencies_final.png
   :width: 40em

Let's take a look at the corresponding wscript.


.. literalinclude:: ../bld/example/r/r_example/src/final/wscript

There are two innovations in this *wscripts*. First, before specifying each task, we define functions that point to the relevant directory. Consider, for instance,

.. code-block:: python

    def out_data(*args):
        return ctx.path_to(ctx, "OUT_DATA", *args)

There is nothing complicated regarding this function.We use it to avoid that we havt to type ``ctx.path_to(ctx, "OUT_DATA", *args)`` several times and thus make the code more readable. For instance, if we want to specify the dependency *ajrcomment_all.txt* which lies in our *bld/out/data* folder, we now just have to call the above function using the argument "ajrcomment_all.txt", i.e. ``out_data("ajrcomment_all.txt")``. It then returns the ``ctx.path_to(ctx, "OUT_DATA", "ajrcomment_all.txt")`` object that we need to define the dependency.

The second innovation regards the creation of the dependency lists for the creation of table 2 and table 3. A more pythoninc way of creating dependency lists is employed which involves the creation of a dictionary and nested loops. The following part of the code creates a dictionary with keys *first_stage* and *second_stage*:

.. code-block:: python

    deps = {"first_stage": [], "second_stage": []}

Each key has a value assigned to it. In this case, the value corresponding to each key is an empty list ``[]``. This initializes our dependency list for each stage. In the next step we create a list containing the model names:

.. code-block:: python

    models = ["baseline", "rmconj"]

Now  we loop over models (``for m in models``) and over
the keys (``stage``) and values (``dep_list``) in our dictionary:

.. code-block:: python

      for m in models:
          for stage, deps_list in deps.items():
              deps_list.append(out_analysis("{}_estimation_{}.txt".format(stage, m)))

In each iteration of the loop, it appends a dependency to our formely empty dependency list. For instance, consider the first iteration where ``m`` takes on the value ``baseline`` and stage takes the value ``first_stage``. Then ``ctx.path_to(ctx, "OUT_ANALYSIS", first_stage_estimation_baseline.txt)`` is appended to our formerly empty dependency so that our intermediate dictionary looks like the following:

.. code-block:: python

    deps = {
        "first_stage": [
            ctx.path_to(ctx, "OUT_ANALYSIS", first_stage_estimation_baseline.txt)
        ],
        "second_stage": [],
    }

After creating the dictionary of dependency lists, we can access the respective list for the first_stage by typing ``deps["first_stage"]``.

In principle, the dependency lists could by created in a simpler but a bit lengthy way. You could just type in every dependency manually as we did before.

The "paper" step
^^^^^^^^^^^^^^^^

The pdf with the final "paper" depends on two additional files that were not shown in the full dependency graph for legibility reasons, a reference bibliography, and a LaTeX-file with the formula for the agents' decision rule (specified in a separate file so it can be re-used in the presentation, which is omitted from the graph as well):

.. figure:: ../bld/example/r/ajrcomment_dependencies_paper.png
   :width: 40em

The corresponding file *src/paper/wscript* is particularly simple:

.. literalinclude:: ../bld/example/r/r_example/src/paper/wscript
    :end-before: # Install to the project root.

Note that we only request Waf to execute the *tex* machinery for the source file (*research_paper.tex*).

The line ``prompt=1`` only tells Waf to invoke pdflatex in such a way that the log-file is printed to the screen. You can shut this off (it is often very long and obfuscates the remaining output from Waf) by setting it to 0.

So how does Waf know about the additional four dependencies? The *tex* tool is smart enough to find out by itself!

Invoking the build
^^^^^^^^^^^^^^^^^^

You start building the project by typing

.. code:: console

    $ python waf.py build

at a command prompt. Because this is the most frequent command to execute, you can leave out the ``build`` qualifier and use

.. code:: console

    $ python waf.py

as a shortcut; it has exactly the same effect.


The installation phase
------------------------

Some targets you want to have easily accessible. This is particularly true for the paper and the presentation. Instead of having to plow through lots of byproducts of the LaTeX compilation in *bld/src/paper*, it would be nice to have the two pdf's in the project root folder.

In order to achieve this, the following code is found in *src/paper/wscript* (still in the loop where ``s`` takes on the values ``'research_paper'`` or ``'research_pres_30min'``):

.. literalinclude:: ../bld/example/r/r_example/src/paper/wscript
    :start-after: # Install to the project root.

This installation of targets can be triggered by typing either of the following commands in a shell

.. code:: console

    $ python waf.py build install
    $ python waf.py install

Conversely, you can remove all installed targets by

.. code:: console

    $ python waf.py uninstall


.. _rbuild_phase:

A closer look at the build phase
---------------------------------

The following figure shows a little bit of how Waf works internally during the build phase:

    .. figure:: r/examples/waf_build_phase.png
       :width: 30em

       *The build phase of a project, reproduced from* Nagy (2013), *section 4.1.4*

The important part to remember is that there is a logical and temporal separation between

  * the execution of the functions we discussed above;
  * and Waf's execution of the tasks.

In between, it has to set the order in which it would execute the tasks and whether a target is up-to-date or not (hence the reading from and writing to an internal cache).

While developing your code, errors will usually show up in the last step: The task returns an error and Waf stops. However, the errors do not have anything to do with Waf, it simply runs the code you wrote on your behalf.

"Genuine" Waf errors will occur only if you made errors in writing the *wscript* files (e.g., syntax errors) or specify the dependencies in a way that is not compatible with a DAG (e.g., circular dependencies or multiple ways to build a target). A hybrid error will occur, for example, if a task did not produce one of the targets you told Waf about. Waf will stop with an error again and it lies in your best judgement of whether you misspecified things in your *wscript* file or in your research code.

By default, Waf will execute tasks in parallel if your computer is sufficiently powerful and if the dependency graphs allows for it. This often leads to a major speed gain, which comes as a free lunch. However, it can be annoying during the development phase because error messages from different tasks get into each others' way. You can force execution of a single task at a time by starting Waf with the ``-j1`` switch

.. code:: console

    $ python waf.py -j1

Other useful options are:

  * ``-v`` or ``-vv`` or ``-vvv`` for making Waf's output ever more **verbose** -- this is helpful for diagnosing problems with what you specified in your *wscript* files. Verbose output is especially useful when combined with the following options.
  * ``--zones=deps`` tells you about the dependencies that Waf finds for a particular task
  * ``--zones=task`` tells you why a target needs to be rebuilt (i.e. which dependency changed)


.. _rwaf_conclusions:

Concluding notes on Waf
------------------------

To conclude, Waf roughly works in the following way:

  #. Waf reads your instructions and sets the build order.

      * Think of a dependency graph here.
      * It stops when it detects a circular dependency or ambiguous ways to build a target.
      * Both are major advantages over a *master-script*, let alone doing the dependency tracking in your mind.

  #. Waf decides which tasks need to be executed based on the nodes' signatures and performs the required actions.

      * A signature roughly is a sufficient statistic for file contents.
      * Minimal rebuilds are a huge speed gain compared to a *master-script*.
      * These gains are large enought to make projects break or succeed.

We have just touched upon the tip of the iceberg here; Waf has many more goodies to offer. The Waf book :cite:`Nagy17` is an excellent source -- you just need to get used to the programmer jargon a little bit and develop a feeling for its background in building software.
