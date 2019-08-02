
The design of the project templates is guided by the following main thoughts:

    #. **Separation of logical chunks** A minimal requirement for a project to scale.
    #. **Only execute required tasks, automatically** Again required for scalability. It means that the machine needs to know what is meant by a "required task".
    #. **Re-use of code and data instead of copying and pasting** Else you will forget the copy & paste step at some point down the road. At best, this leads to errors; at worst, to misinterpreting the results.
    #. **Be as language-agnostic as possible** Make it easy to use the best tool for a particular task and to mix tools in a project.
    #. **Separation of inputs and outputs** Required to find your way around in a complex project.

I will not touch upon the last point until the :ref:`rorganisation` section below. The remainder of this page introduces an example and a general concept of how to think about the first four points.


Running example
---------------

To fix ideas, let's look at the example of Albouy's :cite:`Albouy2012` replication study of Acemoglu, Johnson, and Robinson's (AJR) :cite:`AcemogluJohnsonRobinson2001` classic 2001 paper. In his replication, Albouy :cite:`Albouy2012` raises two main issues: lack of appropriate clustering and measurement error in the instrument (settler's mortality) that is correlated with expropriation risk and GDP. To keep it simple, the example only replicates figure 1 and part of table 2 and table 3 of Albouy :cite:`Albouy2012`.

Figure 1 is supposed to visualize the relationship between expropriation risk and settler's mortality. In table 2, the first stage results are replicated (the effect of settler's mortality on expropriation risk). This is estimated using the original mortality rates of AJR (Panel A) and one alternative proposed by Albouy, namely using the conjectured mortality data (Panel B). For each panel, several specifications are supposed to be estimated using varying geographic controls. Table 3 contains the second stage estimates for Panel A and Panel B. For that, different standard error adjustments, as proposed by Albouy, are estimated additionally.

This replication exercise requires three main steps.

    1. Combine Albouy's (2012) and AJR's (2005) data (Data Management)
    2. Estimating the first and the second stage for each Panel and creating the figure. (Analysis, Final)

In this instruction, we will focus on the replication of the tables. Creating the figure is straightforward. For each Panel, one has to follow four steps:

    1. Compute the first stage estimates considering different geographic controls. (Analysis)
    2. Compute the second stage estimates considering different geographic controls and different standard error specifications (Analysis)
    3. Create nice tables for the results of 1 and 2 (Final)
    4. Including the figure and the tables in a final LaTeX document and writing some text. (Paper)

It is very useful to explicitly distinguish between steps 1./2. and 3. because computation time in 1. and 2. (the actual estimation) can become an issue: If you just want to change the layout of a table or the color of a line in a graph, you do not want to wait for days. Not even for 3 minutes or 30 seconds as in this example.


.. _rworkflow:

How to organize the workflow?
-----------------------------

A naïve way to ensure reproducibility is to have a *master-script* (do-file, m-file, ...) that runs each file one after the other. One way to implement that for the above setup would be to have code for each step of the analysis and a loop over the different subsamples within each step:

.. figure:: ../bld/example/r/steps_only_full.png
   :width: 25em

You will still need to manually keep track of whether you need to run a particular step after making changes, though. Or you run everything at once, all the time. Alternatively, you may have code that runs one step after the other for each mortality series/specification:

.. figure:: ../bld/example/r/model_steps_full.png
   :width: 25em

The equivalent comment applies here: Either keep track of which model needs to be run after making changes manually, or run everything at once.

Ideally though, you want to be even more fine-grained than this and only run individual elements. This is particularly true when your entire computations take some time. In this case, running all steps every time via the *master-script* simply is not an option. All my research projects ended up running for a long time, no matter how simple they were... The figure shows you that even in this simple example, there are now quite a few parts to remember:

.. figure:: ../bld/example/r/model_steps_select.png
   :width: 25em

This figure assumes that your data management is being done for all models at once, which is usually a good choice for me. Even with only two models, we need to remember 6 ways to start different programs and how the different tasks depend on each other. **This does not scale to serious projects!**


.. _rdag_s:

Directed Acyclic Graphs (DAGs)
------------------------------

The way to specify dependencies between data, code and tasks to perform for a computer is a directed acyclic graph. A graph is simply a set of nodes (files, in our case) and edges that connect pairs of nodes (tasks to perform). Directed means that the order of how we connect a pair of nodes matters, we thus add arrows to all edges. Acyclic means that there are no directed cycles: When you traverse a graph in the direction of the arrows, there may not be a way to end up at the same node again.

This is the dependency graph for a simplified version of the Albouy's replication study :cite:`Albouy2012` as implemented in the R example of the project template:

.. figure:: ../bld/example/r/ajrcomment_dependencies.png
   :width: 50em

To keep the dependency graph simple, we ignore the figure for now. The arrows have different colors in order to distinguish the steps of the analysis, from left to right:

    * Blue for data management (=combining the data sets in this case)
    * Orange for the main estimation
    * Teal for the visualization of results
    * Red for compiling the pdf of the paper

Bluish nodes are pure source files -- they do not depend on any other file and hence none of the edges originates from any of them. In contrast, brownish nodes are targets, they are generated by the code. Some may serve as intermediate targets only -- e.g. there is not much you would want to do with the ajrcomment.dta except for processing it further.

In a first run, all targets have to be generated, of course. In later runs, a target only needs to be re-generated if one of its direct **dependencies** changes. E.g. when we make changes to *baseline.json*, we will need to rerun *first_stage_estimation.r* and  *second_stage_estimation.r* using this subsample/specification. Then we will need to rerun *table_first_stage_est.r* and *table_second_stage_est.r* to renew *table_first_stage_est.tex* and *table_first_stage_est.tex*. Lastly, we need to re-compile the pdf as well. We will dissect this example in more detail in the next section. The only important thing at this point is to understand the general idea.

Of course this is overkill for a textbook example -- we could easily keep the code closer together than this. But such a strategy does not scale to serious papers with many different specifications. As a case in point, consider the DAG for an early version of :cite:`Gaudecker2015`:

.. figure:: r/pfefficiency.jpg
   :width: 35em

Do you want to keep those dependencies in your head? Or would it be useful to specify them once and for all in order to have more time for thinking about research? The next section shows you how to do that.
