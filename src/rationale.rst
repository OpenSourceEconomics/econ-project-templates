.. _rationale:

****************
Design rationale
****************

To fix ideas, say you embark on a research project that has three different **models** for the moment:

1. Replicate the findings of a paper that you build on
2. Compute your baseline specification
3. Check robustness against a particular alternative (probably more to follow as the project matures)

For each model, you need to perform various steps:
1. Manage the data ("cleaning" in empirical work, drawing a sample in computational work) 
2. Run the actual estimations/simulations/?, 
3. Visualisation and format the results (e.g. export of LaTeX tables)
4. Finally, you need to pull everything together in whatever you use to dissemninate your findings: A paper and a presentation, usually.

It is usually very useful to explictly distinguish between steps 2. and 3. because often computation time in 2. becomes an issue: If you just want to change the layout of a table or the color of a line in a graph, you do not want to wait for days. Not even for 3 minutes.


How to organise the workflow?
-----------------------------

A naïve way to ensure reproducibility is to have a **master-script** (do-file, m-file, ...) that runs each file one after the other. One way to implement that for the above setup, would be to have code for each step of the analysis and a loop over the three specifications:
   
.. figure:: ../bld/src/examples/steps_only_full.png
   :width: 25em
   
   *Organising the workflow --- By step of the analysis?*

Equivalently, you may have code that runs one step after the other for each model:

.. figure:: ../bld/src/examples/model_steps_full.png
   :width: 25em
   
   *Organising the workflow --- By model?*

Ideally though, you want to be more fine-grained: ... 


.. figure:: ../bld/src/examples/model_steps_select.png
   :width: 25em
   
   *Organising the workflow --- By step of the analysis and model!*


The problem is that when you set your *master-script* to run, you will run the entire code, from beginning to end, for each model. This is a bit too much when you change just one parameter in a single model. 


Directed Acyclic Graphs (DAGs)
------------------------------

A serious example is the DAG for an early version of :cite:`Gaudecker14`:

.. figure:: examples/pfefficiency.jpg
   :width: 25em
   
   *Organising the workflow --- By model?*


