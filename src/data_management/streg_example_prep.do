// Header do-file with path definitions, those end up in local macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace

sysuse cancer

stset studytime died

gen placebo = (drug==1)

keep studytime died placebo _*

// Demonstrate usage of save_signature
save_signature `"${PATH_OUT_DATA}/streg_example_data.signature"'
save `"${PATH_OUT_DATA}/streg_example_data"', replace

