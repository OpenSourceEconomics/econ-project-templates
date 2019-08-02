.. _final:

************************************
Visualisation and results formatting
************************************


Documentation of the code in *src/final*.

.. note::

    Some of these steps seem to fail on Linux because apparently Stata is not capable of saving png-figures in batch mode. Just do a search for "png" in the *src/final* directory and replace all occurences by "eps". Make sure that you allow LaTeX to call external commands (shell escape needs to be enabled).


Figure 1 - Expropriation risk plotted against log mortality
=======================================================================

.. include:: ../final/figure_mortality.do
    :start-after: /*
    :end-before: */

Table 2 - First stage estimation of expropriation risk on log mortality
=======================================================================

.. include:: ../final/table_first_stage_est.do
    :start-after: /*
    :end-before: */


Table 3 - Second stage estimation of GDP on expropriation risk
==============================================================

.. include:: ../final/table_second_stage_est.do
    :start-after: /*
    :end-before: */
