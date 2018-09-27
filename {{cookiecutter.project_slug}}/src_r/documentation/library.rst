.. _library:

************
Code library
************


The directory *src/library* provides code that may be used by different steps of the analysis. Little code snippets for input / output or stuff that is not directly related to the model would go here.

The distinction to the *model_code* directory is a bit arbitrary, but I have found it useful in the past.


.. _r_packages:

R packages
==========

We try to make sure that the code runs on any machine, regardless of the R libraries you have installed system-wide and regardless of write-permissions you may have. Thus, the project installs all nonstandard libraries using the ``install_required_lib``-function, which you may find in *src/library/R*:

.. include:: ../library/R/install_required_lib.r
    :start-after: '
    :end-before: '

See *src/library/R/wscript* for usage examples.
