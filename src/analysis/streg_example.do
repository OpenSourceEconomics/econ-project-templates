/*

Estimate a simple survival time model.

Important: The code requires a number of model parameters to be defined;
           this will generally happen automatically by Waf.

*/


// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'_`2'.log"', replace
// The model specification
include `"${PATH_OUT_MODELS}/`2'"'

use `"${PATH_OUT_DATA}/streg_example_data"', clear

streg ${EXPL_VAR}, dist(${DISTRIBUTION}) ${OTHER_STREG_OPTIONS}


// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list
