/*
The file "regression_on_indicators.do" computes the regression estimates
of the main indicators (mortality, expropriation risk and GDP) on the
indicators for campaigning soldiers and laborers, as well as
the correlations of the main indicators with log mortality.
The results are then plotted in the corresponding file in
the final folder "table1_reg_on_indicators.do"
*/


// Header do-file with path definitions, those end up in global macros.
include project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace


use `"${PATH_OUT_DATA}/ajrcomment_all"', replace


foreach i of varlist logmort0 risk loggdp {

    reg `i' campaign slave, robust
    mat `i'_est = [_b[campaign] \ _se[campaign] \ _b[slave] \ _se[slave] \ e(r2)]

    predict `i'_r, resid
    corr logmort0 `i'
    estadd scalar full_`i' = r(rho)
    if `i' == logmort0 local logmort0_r = `i'_r
    corr logmort0_r `i'_r
    estadd scalar partial_`i'=r(rho)
    mat `i'_corr = [e(full_`i') \ e(partial_`i')]

}

mat E = [logmort0_est, risk_est, loggdp_est]
mat C = [logmort0_corr, risk_corr, loggdp_corr]


// Export estimates to files

svmat E, names(E_)
drop if E_1==.
format E_1 E_2 E_3 %5.2f
gen id = _n
sort id
gen str E_colstring = "Campaign indicator" if id==1
replace E_colstring = "Laborer indicator" if id==3
replace E_colstring = "\$R^2\$" if id==5

keep E_colstring E_1 E_2 E_3
save `"${PATH_OUT_ANALYSIS}/regression_on_indicators_est"', replace

svmat C, names(C_)
drop if C_1==.
format C_1 C_2 C_3 %5.2f
gen id2 = _n
sort id2
gen str C_colstring = "Full" if id2==1
replace C_colstring = "Partial" if id2==2

keep C_colstring C_1 C_2 C_3
save `"${PATH_OUT_ANALYSIS}/regression_on_indicators_corr"', replace
