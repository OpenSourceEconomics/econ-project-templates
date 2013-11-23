/*

Estimate a simple survival time model.

Important: The do-file requires two arguments to be passed
           
    1. the name of the file itself (for keeping the log)
    2. the name of a file in ${OUT_MODELS} containing globals
       definitions for a model (this will generally be derived
       from a json-file in ${IN_MODELS})

*/


// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'_`2'.log"', replace

// The model specification
include `"${PATH_OUT_MODELS}/`2'"'

// Read in the data
use `"${PATH_OUT_DATA}/streg_example_data"', clear

// Run a regression as detailed in the model specification
streg ${EXPL_VAR}, dist(${DISTRIBUTION}) ${OTHER_STREG_OPTIONS}

// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list
