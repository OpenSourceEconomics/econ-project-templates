/*
In the file "second_stage_estimation.do", we regress the expropriation risk
on log mortality.

We also compute confidence intervals for a usual Wald statistic and confidence
intervals for the Anderson-Rubin (1949) statistic.

The file requires to be called with a model specification as the argument,
a corresponding do-file must exist in ${PATH_OUT_MODEL_SPECS}. That file needs
to define globals:
    
    * ${INSTD} - the dependent variable (in the first stage)
    * ${INSTS} - the instrument
    * ${KEEP_CONDITION} - any sampling restrictions (full command)
    * ${DUMMIES} - additional dummy variables to be used as controls

The do-file loops over various specifications with geographic controls /
restrictions as defined in ${PATH_OUT_MODEL_SPECS}/geography.do. Finally, we
store a dataset with estimation results.

*/



// Header do-file with path definitions, those end up in global macros.
include project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace


// Read in the model controls
do `"${PATH_OUT_MODEL_SPECS}/`2'"'
do `"${PATH_OUT_MODEL_SPECS}/geography"'


forvalues N = 1 / 7 {

    use `"${PATH_OUT_DATA}/ajrcomment_all"', replace
    ${KEEP_CONDITION}
    ${GEO_KEEP_CONDITION_`N'}

    qui reg ${INSTD} ${INSTS} ${DUMMIES} ${GEO_CONTROLS_`N'} `if`N''
    est store F`N'
    qui reg ${INSTD} ${INSTS} ${DUMMIES} ${GEO_CONTROLS_`N'} `if`N'', robust cluster(${INSTS})
    est store F`N'C
    scalar b`N' = _b[${INSTS}]
    scalar se`N' = _se[${INSTS}]

    if inlist(`N', 2, 4, 5, 6, 7) {
        qui test ${GEO_CONTROLS_`N'}
        scalar f`N' = r(p)
        *qui hausman F`N'C F1C
        *scalar h`N' = r(p)
    }
    if inlist(`N', 1, 3) {
        scalar f`N'=0
        scalar h`N'=0
    }

    if inlist("${DUMMIES}", "") {
        qui test ${INSTS}
        scalar p`N' = r(p)
        disp "`N'"
    }
    else {
        qui test ${INSTS}
        scalar p`N' = r(p)
        qui test ${DUMMIES}
        scalar d`N' = r(p)
        scalar camp`N' = _b[campaign]
    }
}

estimates table F1 F2 F3 F4 F5 F6 F7, b(%5.2f) se(%5.2f) keep(${INSTS})
estimates table F1C F2C F3C F4C F5C F6C F7C, b(%5.2f) se(%5.2f) stat(N N_clust)


if inlist("${DUMMIES}", "") {
    mat F = [f1, f2, f3, f4, f5, f6, f7]
    mat rown F = Ftest_C
    mat coln F = 1 2 3 4 5 6 7
    mat panel = [ ///
        b1, b2, b3, b4, b5, b6, b7 \ ///
        se1, se2, se3, se4, se5, se6, se7 \ ///
        p1, p2, p3, p4, p5, p6, p7 \ ///
        f1, f2, f3, f4, f5, f6, f7 ///
    ]
}
else {
    mat D = [camp1, camp2, camp3, camp4, camp5, camp6, camp7]
    noi mat list D, f(%5.3f) title("Campaign dummies")
    mat F = [d1, d2, d3, d4, d5, d6, d7 \ f1, f2, f3, f4, f5, f6, f7]
    mat rown F = Ftest_D Ftest_C
    mat coln F = 1 2 3 4 5 6 7
    mat panel = [ ///
        b1, b2, b3, b4, b5, b6, b7 \ ///
        se1, se2, se3, se4, se5, se6, se7 \ ///
        p1, p2, p3, p4, p5, p6, p7 \ ///
        d1, d2, d3, d4, d5, d6, d7 \ ///
        f1, f2, f3, f4, f5, f6, f7 ///
    ]
}

svmat panel, names(coef_`2'_)
drop if coef_`2'_1==.
format coef_`2'_1 coef_`2'_2 coef_`2'_3 coef_`2'_4 coef_`2'_5 coef_`2'_6 coef_`2'_7 %5.2f
gen id = _n
sort id
gen str colstring = "Log mortality" if id==1
replace colstring = "heteroscedastic SE" if id==2
replace colstring = "p-value log mortality" if id==3
replace colstring = "p-value of controls" if id==4 & inlist("`2'", "baseline", "rmconj")
replace colstring = "p-value of indicators" if id==4 & inlist("`2'", "addindic", "rmconj_addindic", "newdata")
replace colstring = "p-value of controls" if id==5 & inlist("`2'", "addindic", "rmconj_addindic", "newdata")

keep colstring coef_`2'_1 coef_`2'_2 coef_`2'_3 coef_`2'_4 coef_`2'_5 coef_`2'_6 coef_`2'_7

save `"${PATH_OUT_ANALYSIS}/first_stage_estimation_`2'"', replace
