.. _analysis:

Main model estimations / simulations
=====================================

Documentation of the code in *src.analysis*. This is the core of the project. 

**Example for documenting Stata code**


Table 1 - Regression of main variables on indicators:

.. literalinclude:: ../analysis/regression_on_indicators.do
    :start-after: /*
    :end-before: */


Table 2 - First stage estimation of expropriation risk on log mortality:

.. literalinclude:: ../analysis/first_stage_estimation.do
    :start-after: /*
    :end-before: */    


Table 3 - Second stage estimation of GDP on expropriation risk:

.. literalinclude:: ../analysis/second_stage_estimation.do
    :start-after: /*
    :end-before: */     
    
**Storing data sets temporarily**

If you want to save and reuse a dataset in only one do-file without accessing it from any other file, it does not make sense to include these temporary files in the corresponding wscripts. But then you will have to store these temporary data sets as local tempfiles, otherwise waf cannot access them, because you did not specify a path. You might also consider saving datasets in matrices, if that is possible (e.g. no strings).

See for example the file `second_stage_estimation.do`. 