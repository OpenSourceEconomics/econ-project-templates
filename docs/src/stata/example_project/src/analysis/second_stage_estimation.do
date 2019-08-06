/* 
In the file "second_stage_estimation.do", we compute IV estimates for log GDP 
per capita with expropriation risk as the first stage dependent variable.

We also compute confidence intervals for a usual Wald statistic and confidence
intervals for the Anderson-Rubin (1949) statistic.

The file requires to be called with a model specification as the argument,
a corresponding do-file must exist in ${PATH_OUT_MODEL_SPECS}. That file needs
to define globals:
    
    * ${DEPVAR} - the dependent variable
    * ${INSTD} - the instrumented variable
    * ${INSTS} - the instrument
    * ${KEEP_CONDITION} - any sampling restrictions (full command)
    * ${DUMMIES} - additional dummy variables to be used as controls

The do-file loops over various specifications with geographic controls /
restrictions as defined in ${PATH_OUT_MODEL_SPECS}/geography.do. Finally, we
store a dataset with estimation results.

*/


// Header do-File with path definitions, those end up in global macros.
include project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace

// Read in the model controls
do `"${PATH_OUT_MODEL_SPECS}/`2'"'
do `"${PATH_OUT_MODEL_SPECS}/geography"'

// Define some temporary files
tempfile ci_base ci_1 ci_2 ci_3 ci_4 ci_5 ci_6 ci_7 tempdata


// The step is 0.01 in the original code accompanying Albouy (2012), 
// but 4000 regressions are a bit too much for demonstration purposes.
local range = "-20 (0.2) 20"

clear
set obs 1
gen beta = .
gen fstat = .
gen pval = .
gen inci = .

save `ci_base', replace


forvalues N = 1 / 7 {
        
    use `ci_base', replace
    save `ci_`N'', replace

    use `"${PATH_OUT_DATA}/ajrcomment_all"', replace
    ${KEEP_CONDITION}
    ${GEO_KEEP_CONDITION_`N'}

    local controls = " ${GEO_CONTROLS_`N'} ${DUMMIES} "

    reg ${INSTD} ${INSTS} `controls' , cluster(${INSTS})
    test ${INSTS}
    scalar firstf`N' = r(F)
    scalar firstt`N' = sqrt(firstf`N')

    ivreg ${DEPVAR} (${INSTD} = ${INSTS}) `controls', cluster(${INSTS})
    mat b = e(b)

    mat point`N' = _b[${INSTD}]
    mat se`N' = _se[${INSTD}]

    scalar betahat = b[1, 1]
    local j = e(N_clust)
    local n = e(N)
    local k = e(df_m)

    qui foreach V of varlist ${DEPVAR} ${INSTD} ${INSTS} {
        qui reg `V' `controls'
        qui predict `V'r, resid
    }

    keep ${DEPVAR} ${INSTD} ${INSTS} `controls' ${DEPVAR}r ${INSTD}r ${INSTS}r

    reg ${INSTD}r ${INSTS}r , cluster(${INSTS}r)
    test ${INSTS}r
    scalar firstfr`N' = r(F) * (`n' - `k' - 1) / (`n' - 1)

    save `tempdata', replace

    forvalues X = `range' {
        use `tempdata', replace

        scalar beta0 = `X'

        gen u = ${DEPVAR}r - beta0 * ${INSTD}r

        // Trick is to put controls here even though other variables are orthogonal
        reg u ${INSTS}r `controls' , cluster(${INSTS}r) noc
        test ${INSTS}
        scalar f = r(F)

        drop _all
        qui set obs 1
        gen fstat = f 
        gen beta = beta0
        gen pval = Ftail(1, `j'-1 , fstat)
        gen inci = pval>=0.05

        keep beta fstat pval inci
        append using `ci_`N'', keep(beta fstat pval inci)
        qui save `ci_`N'', replace
    }

    forvalues X = -10000 (20000) 10000 {
        use `tempdata', replace

        scalar beta0 = `X'
        gen u = ${DEPVAR}r - beta0*${INSTD}r

        reg u ${INSTS}r `controls' , cluster(${INSTS}r) noc
        test ${INSTS}
        scalar f = r(F)

        drop _all
        qui set obs 1
        // Adjustment needed since controls taken out
        gen fstat = f 
        gen beta = beta0
        gen pval = Ftail(1, `j'-1, fstat)
        gen inci = pval >= 0.05

        keep beta fstat pval inci
        append using `ci_`N'', keep(beta fstat pval inci)
        qui save `ci_`N'', replace
    }


    drop if missing(beta)
    compress
    sort beta

    scalar crit`N' = invFtail(1, `j'-1, 0.05)

    gen crit`N' = invFtail(1, `j'-1, 0.05)

    mat wlow`N' = point`N' - sqrt(crit`N') * se`N'
    mat whi`N' = point`N' + sqrt(crit`N') * se`N'

    noisily disp "`N'"

    scalar list firstt`N' firstf`N' firstfr`N'

    su fstat
    scalar maxf`N' = r(max)

    list fstat if abs(beta) == 10000
    su fstat if abs(beta) == 10000
    scalar asyf`N' = r(max)

    drop if abs(beta) > 5000

    mat stat`N' = ( crit`N' \ asyf`N' \ maxf`N' )

    keep if (inci[_n-1] == 0 & inci[_n] == 1) | (inci[_n-1] == 1 & inci[_n] == 0)
    set obs 2
    replace beta = 998 if missing(beta)
    replace beta = round(beta, .01)
    mkmat beta, mat(cilm`N')
    mat list cilm`N', format(%5.2f)
}

mat point = point1, point2, point3, point4, point5, point6, point7
mat coln point = 1 2 3 4 5 6 7
mat pointT = point'

mat se = se1, se2, se3, se4, se5, se6, se7
mat coln se = 1 2 3 4 5 6 7

mat wald = wlow1, wlow2, wlow3, wlow4, wlow5, wlow6, wlow7 \ whi1, whi2, whi3, whi4, whi5, whi6, whi7
mat rown wald = low_wald high_wald
mat coln wald = 1 2 3 4 5 6 7
mat waldT = wald'

mat cilm = cilm1, cilm2, cilm3, cilm4, cilm5, cilm6, cilm7
mat rown cilm = low_ar high_ar
mat coln cilm = 1 2 3 4 5 6 7
mat cilmT = cilm'

mat stat = stat1, stat2, stat3, stat4, stat5, stat6, stat7
mat rown stat = crit asy_f max_f
mat coln stat = 1 2 3 4 5 6 7
mat statT = stat'


// Construct strings for confidence intervals

svmat pointT, names(pointT_)
format pointT_1 %4.2f

svmat waldT, names(waldT_)
format waldT_1 %4.2f
format waldT_2 %4.2f
tostring waldT_1, generate(waldT_1_str) force u
tostring waldT_2, generate(waldT_2_str) force u
gen str waldT_ci = "[" + waldT_1_str + "," + waldT_2_str + "]"

svmat cilmT, names(cilmT_)
format cilmT_1 %4.2f
format cilmT_2 %4.2f
tostring cilmT_1, generate(cilmT_1_str) force u
tostring cilmT_2, generate(cilmT_2_str) force u
gen str cilmT_ci = ""

svmat statT, names(statT_)

replace cilmT_ci = "[" + cilmT_1_str + "," + cilmT_2_str + "]" if statT_1 < statT_2
replace cilmT_ci = "(-$\infty$,+$\infty$)" if statT_1 > statT_3 & statT_1 > statT_2 
replace cilmT_ci = "\begin{tabular}[c]{@{}c@{}}(-$\infty$," + cilmT_1_str + "] U \\\ [" + cilmT_2_str + ",+$\infty$)\end{tabular}" if statT_1 > statT_2 & statT_1 > statT_2 & statT_1 < statT_3 

keep pointT_1 waldT_ci cilmT_ci

save `"${PATH_OUT_ANALYSIS}/second_stage_estimation_`2'"', replace
log close
