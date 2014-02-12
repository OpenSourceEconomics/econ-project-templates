/*** This file computes the estimates for table 1 and stores them 
in "table1_main_variables_temp_i.dta" ***/

// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'_`2'.log"', replace


// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list


# delimit ;
set more off ;
set trace on;


use `"${PATH_IN_DATASET_1}/ajrcomment"', replace ;


foreach i of varlist logmort0 risk loggdp {;

reg `i' campaign slave, robust ;
mat `i'_est = [_b[campaign] \ _se[campaign] \ _b[slave] \ _se[slave] \ e(r2)] ;

predict `i'_r, resid ;
	corr logmort0 `i';
	estadd scalar full_`i'=r(rho);
	if `i'==logmort0 local logmort0_r = `i'_r;
	corr logmort0_r `i'_r;
	estadd scalar partial_`i'=r(rho);
mat `i'_corr = [e(full_`i') \ e(partial_`i')];

};

mat E = [logmort0_est, risk_est, loggdp_est] ;
mat C = [logmort0_corr, risk_corr, loggdp_corr] ;


/*** Export data to files ***/

svmat E, names(E_) ;
drop if E_1==. ;
format E_1 E_2 E_3 %5.2f ;
	gen id = _n ;
	sort id ;
	gen str E_colstring = "Campaign indicator" if id==1 ;
	replace E_colstring = "Laborer indicator" if id==3 ;
	replace E_colstring = "R squared" if id==5 ;
	
keep E_colstring E_1 E_2 E_3 ;
save `"${PATH_OUT_DATA}/table1_main_variables_temp_est"',replace ;

svmat C, names(C_) ;
drop if C_1==. ;
format C_1 C_2 C_3 %5.2f ;
	gen id2 = _n ;
	sort id2 ;
	gen str C_colstring = "Full" if id2==1;
	replace C_colstring = "Partial" if id2==2 ;

keep C_colstring C_1 C_2 C_3 ;
save `"${PATH_OUT_DATA}/table1_main_variables_temp_corr"',replace ;


