// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace

// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list

