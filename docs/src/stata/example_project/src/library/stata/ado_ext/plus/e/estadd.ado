*! version 2.3.3  28may2014  Ben Jann
*  1. estadd and helpers
*  2. estadd_local
*  3. estadd_scalar
*  4. estadd_matrix
*  5. estadd_mean
*  6. estadd_sd
*  7. estadd_beta
*  8. estadd_coxsnell
*  9. estadd_nagelkerke
* 10. estadd_ysumm
* 11. estadd_summ
* 12. estadd_vif
* 13. estadd_ebsd
* 14. estadd_expb
* 15. estadd_pcorr
* 16. estadd_lrtest
* 17. estadd_brent
* 18. estadd_fitstat
* 19. estadd_listcoef
* 20. estadd_mlogtest
* 21. estadd_prchange
* 22. estadd_prvalue
* 23. estadd_asprvalue
* 24. estadd_margins
* 99. copy of erepost.ado

* 1.
program estadd
    version 8.2
    local caller : di _caller()
    capt _on_colon_parse `0'
    if !_rc {
        local 0 `"`s(before)'"'
        local names `"`s(after)'"'
    }
    syntax anything(equalok id="subcommand") [if] [in] [fw aw iw pw] [, * ]
    if regexm(`"`anything'"',"^r\((.*)\)$") {  // check -estadd r(name)-
        capt confirm scalar `anything'
        if _rc {
            capt confirm matrix `anything'
            if _rc {
                di as err `"`anything' not found"'
                exit 111
            }
            else {
                local anything `"matrix `anything'"'
            }
        }
        else {
            local anything `"scalar `anything'"'
        }
    }
    gettoken subcommand : anything
    capt confirm name `subcommand'
    if _rc {
        di as err "invalid subcommand"
        exit 198
    }
    if `"`options'"'!="" local options `", `options'"'
    if `"`weight'`exp'"'!="" local wgtexp `"[`weight'`exp']"'

//expand estimates names and backup current estimates if necessary
    tempname rcurrent ecurrent
    capt _return drop `rcurrent'
    _return hold `rcurrent'
    capt noisily {
        local names: list retok names
        if "`names'"=="" {
            local names "."
            local qui
        }
        else local qui quietly
        foreach name of local names {
            if "`name'"=="." {
                capt est_expand "`name'"
                if _rc local enames "`enames'`name' "
                else local enames "`enames'`r(names)' "
            }
            else {
                est_expand "`name'" //=> error if estimates not found
                local enames "`enames'`r(names)' "
            }
        }
        local names: list uniq enames
        if "`names'"=="." local active
        else {
            capt est_expand .
            if _rc local active "."
            else local active "`r(names)'"
            if "`active'"=="." | `:list posof "`active'" in names'==0 {
                local active
                _est hold `ecurrent', restore estsystem nullok
            }
        }
    }
    if _rc {
        _return restore `rcurrent'
        exit _rc
    }
    _return restore `rcurrent', hold

// cases:
// - if active estimates not stored yet and "`names'"==".": simply execute
//   estadd_subcmd to active estimates
// - else if active estimates not stored yet: backup/restore active estimates
// - else if active estimates stored but not in `names': backup/restore active estimates
// - else if active estimates stored: no backup but restore at end

//loop over estimates names and run subcommand
    nobreak {
        foreach m of local names {
            if "`names'"!="." {
                if "`m'"=="." _est unhold `ecurrent'
                else {
                    capt confirm new var _est_`m' // fix e(sample)
                    if _rc qui replace _est_`m' = 0 if _est_`m' >=.
                    _est unhold `m'
                }
            }
            backup_estimates_name
            capt n break `qui' version `caller': estadd_`anything' `if' `in' `wgtexp' `options'
            local rc = _rc
            restore_estimates_name
            if "`names'"!="." {
                if "`m'"=="." _est hold `ecurrent', restore estsystem nullok
                else _est hold `m', estimates varname(_est_`m')
            }
            if `rc' continue, break
        }
        if "`active'"!="" estimates restore `active', noh
    }
    _return restore `rcurrent'
    if `rc' {
        if `rc' == 199 di as error "invalid subcommand"
        exit `rc'
    }
end

program define backup_estimates_name, eclass
    ereturn local _estadd_estimates_name `"`e(_estimates_name)'"'
    ereturn local _estimates_name ""
end
program define restore_estimates_name, eclass
    ereturn local _estimates_name `"`e(_estadd_estimates_name)'"'
    ereturn local _estadd_estimates_name ""
end

program confirm_new_ename
    capture confirm existence `e(`0')'
    if !_rc {
        di as err "e(`0') already defined"
        exit 110
    }
end

program confirm_esample
    local efun: e(functions)
    if `:list posof "sample" in efun'==0 {
        di as err "e(sample) information not available"
        exit 498
    }
end

program confirm_numvar
    args var
    local ts = index("`var'",".")
    confirm numeric variable `=substr("`var'",`ts'+1,.)'
end

program define added_macro
    args name
    di as txt %25s `"e(`name') : "' `""{res:`e(`name')'}""'
end

program define added_scalar
    args name label
    di as txt %25s `"e(`name') = "' " " as res e(`name') _c
    if `"`label'"'!="" {
        di as txt _col(38) `"(`label')"'
    }
    else di ""
end

program define added_matrix
    args name label
    capture {
        local r = rowsof(e(`name'))
        local c = colsof(e(`name'))
    }
    if _rc {
        tempname tmp
        mat `tmp' = e(`name')
        local r = rowsof(`tmp')
        local c = colsof(`tmp')
    }
    di as txt %25s `"e(`name') : "' " " ///
        as res "`r' x `c'" _c
    if `"`label'"'=="_rown" {
        local thelabel: rownames e(`name')
        local thelabel: list retok thelabel
        if `r'>1 {
            local thelabel: subinstr local thelabel " " ", ", all
        }
        di as txt _col(38) `"(`thelabel')"'
    }
    else if `"`label'"'!="" {
        di as txt _col(38) `"(`label')"'
    }
    else di ""
end

* 2.
* -estadd- subroutine: add local
program estadd_loc
    estadd_local `0'
end
program estadd_loca
    estadd_local `0'
end
program estadd_local, eclass
    version 8.2
    syntax anything(equalok) [, Prefix(name) Replace Quietly ]
    gettoken name def : anything , parse(" =:")
    if "`replace'"=="" {
        confirm_new_ename `prefix'`name'
    }
    ereturn local `prefix'`name'`def'
    di _n as txt "added macro:"
    added_macro `prefix'`name'
end

* 3.
* -estadd- subroutine: add scalar
program estadd_sca
    estadd_scalar `0'
end
program estadd_scal
    estadd_scalar `0'
end
program estadd_scala
    estadd_scalar `0'
end
program estadd_scalar, eclass
    version 8.2
    syntax anything(equalok) [, Prefix(name) Replace Quietly ]
    if regexm("`anything'","^r\((.*)\)$") {     // estadd scalar r(name)
        local name = regexs(1)
        capt confirm name `name'
        confirm scalar `anything'
        if _rc error 198
        local equ  "`anything'"
    }
    else {
        local isname 0
        gettoken name equ0: anything, parse(" =")
        capt confirm name `name'
        if _rc error 198
        else if `"`equ0'"'==""  {               // estadd scalar name
            local isname 1
            local equ  "scalar(`name')"
        }
        else {                                  // estadd scalar name [=] exp
            gettoken trash equ : equ0, parse(" =")
            if `"`trash'"'!="=" {
                local equ `"`equ0'"'
            }
        }
    }
    if "`replace'"=="" {
        confirm_new_ename `prefix'`name'
    }
    ereturn scalar `prefix'`name' = `equ'
    di _n as txt "added scalar:"
    added_scalar `prefix'`name'
end

* 4.
* -estadd- subroutine: add matrix
program estadd_mat
    estadd_matrix `0'
end
program estadd_matr
    estadd_matrix `0'
end
program estadd_matri
    estadd_matrix `0'
end
program estadd_matrix, eclass
    version 8.2
    syntax anything(equalok) [, Prefix(name) Replace Quietly ]
    if regexm("`anything'","^r\((.*)\)$") {     // estadd matrix r(name)
        local name = regexs(1)
        capt confirm name `name'
        if _rc error 198
        confirm matrix `anything'
        local equ  "`anything'"
    }
    else {
        local isname 0
        gettoken name equ0: anything, parse(" =")
        capt confirm name `name'
        if _rc error 198
        else if `"`equ0'"'==""  {               // estadd matrix name
            local isname 1
            local equ  "`name'"
        }
        else {                                  // estadd matrix name [=] exp
            gettoken trash equ : equ0, parse(" =")
            if `"`trash'"'!="=" {
                local equ `"`equ0'"'
            }
        }
    }
    if "`replace'"=="" {
        confirm_new_ename `prefix'`name'
    }
    tempname M
    mat `M' = `equ'
    ereturn matrix `prefix'`name' = `M'
    di _n as txt "added matrix:"
    added_matrix `prefix'`name'
end

* 5.
* -estadd- subroutine: means of regressors
program define estadd_mean, eclass
    version 8.2
    syntax [, Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'mean
//use aweights with -summarize-
    local wtype `e(wtype)'
    if "`wtype'"=="pweight" local wtype aweight
//subpop?
    local subpop "`e(subpop)'"
    if "`subpop'"=="" local subpop 1
//copy coefficients matrix and determine varnames
    tempname results
    mat `results' = e(b)
    local vars: colnames `results'
//loop over variables: calculate -mean-
    local j 0
    foreach var of local vars {
        local ++j
        capture confirm_numvar `var'
        if _rc mat `results'[1,`j'] = .z
        else {
            capt su `var' [`wtype'`e(wexp)'] if e(sample) & `subpop', meanonly
            mat `results'[1,`j'] = cond(_rc,.,r(mean))
        }
    }
//return the results
    ereturn matrix `prefix'mean = `results'
    di _n as txt "added matrix:"
    added_matrix `prefix'mean
end

* 6.
* -estadd- subroutine: standard deviations of regressors
program define estadd_sd, eclass
    version 8.2
    syntax [, noBinary Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'sd
//use aweights with -summarize-
    local wtype `e(wtype)'
    if "`wtype'"=="pweight" local wtype aweight
//subpop?
    local subpop "`e(subpop)'"
    if "`subpop'"=="" local subpop 1
//copy coefficients matrix and determine varnames
    tempname results
    mat `results' = e(b)
    local vars: colnames `results'
//loop over variables: calculate -mean-
    local j 0
    foreach var of local vars {
        local ++j
        capture confirm_numvar `var'
        if _rc mat `results'[1,`j'] = .z
        else {
            capture assert `var'==0 | `var'==1 if e(sample) & `subpop'
            if _rc | "`binary'"=="" {
                capt su `var' [`wtype'`e(wexp)'] if e(sample) & `subpop'
                mat `results'[1,`j'] = cond(_rc,.,r(sd))
            }
            else mat `results'[1,`j'] = .z
        }
    }
//return the results
    ereturn matrix `prefix'sd = `results'
    di _n as txt "added matrix:"
    added_matrix `prefix'sd
end

* 7.
* -estadd- subroutine: standardized coefficients
program define estadd_beta, eclass
    version 8.2
    syntax [, Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'beta
//use aweights with -summarize-
    local wtype `e(wtype)'
    if "`wtype'"=="pweight" local wtype aweight
//subpop?
    local subpop "`e(subpop)'"
    if "`subpop'"=="" local subpop 1
//copy coefficients matrix and determine varnames
    tempname results sddep
    mat `results' = e(b)
    local vars: colnames `results'
    local eqs: coleq `results', q
    local depv "`e(depvar)'"
//loop over variables: calculate -beta-
    local j 0
    local lastdepvar
    foreach var of local vars {
        local depvar: word `++j' of `eqs'
        if "`depvar'"=="_" local depvar "`depv'"
        capture confirm_numvar `depvar'
        if _rc mat `results'[1,`j'] = .z
        else {
            if "`depvar'"!="`lastdepvar'" {
                capt su `depvar' [`wtype'`e(wexp)'] if e(sample) & `subpop'
                scalar `sddep' = cond(_rc,.,r(sd))
            }
            capture confirm_numvar `var'
            if _rc mat `results'[1,`j'] = .z
            else {
                capt su `var' [`wtype'`e(wexp)'] if e(sample) & `subpop'
                mat `results'[1,`j'] = cond(_rc,.,`results'[1,`j'] * r(sd) / `sddep')
            }
        }
        local lastdepvar "`depvar'"
    }
//return the results
    ereturn matrix `prefix'beta = `results'
    di _n as txt "added matrix:"
    added_matrix `prefix'beta
end

* 8.
* -estadd- subroutine: Cox & Snell Pseudo R-Squared
program define estadd_coxsnell, eclass
    version 8.2
    syntax [, Prefix(name) Replace Quietly ]
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'coxsnell
//compute statistic
    tempname results
    scalar `results' = 1 - exp((e(ll_0)-e(ll))*2/e(N))  // = 1 - exp(e(ll_0)-e(ll))^(2/e(N))
//return the results
    *di as txt "Cox & Snell Pseudo R2 = " as res `results'
    ereturn scalar `prefix'coxsnell = `results'
    di _n as txt "added scalar:"
    added_scalar `prefix'coxsnell
end

* 9.
* -estadd- subroutine: Nagelkerke Pseudo R-Squared
program define estadd_nagelkerke, eclass
    version 8.2
    syntax [, Prefix(name) Replace Quietly ]
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'nagelkerke
//compute statistic
    tempname results
    scalar `results' = (1 - exp((e(ll_0)-e(ll))*2/e(N))) / (1 - exp(e(ll_0)*2/e(N)))
        // = (1 - exp(e(ll_0)-e(ll))^(2/e(N))) / (1 - exp(e(ll_0))^(2/e(N)))
//return the results
    *di as txt "Nagelkerke Pseudo R2 = " as res `results'
    ereturn scalar `prefix'nagelkerke = `results'
    di _n as txt "added scalar:"
    added_scalar `prefix'nagelkerke
end

* 10.
* -estadd- subroutine: summary statistics for dependent variable
program define estadd_ysumm, eclass
    version 8.2
    syntax [, MEan SUm MIn MAx RAnge sd Var cv SEMean SKewness ///
     Kurtosis MEDian p1 p5 p10 p25 p50 p75 p90 p95 p99 iqr q all ///
     Prefix(passthru) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//default prefix
    if `"`prefix'"'=="" local prefix y
    else {
        local 0 ", `prefix'"
        syntax [, prefix(name) ]
    }
//use aweights with -summarize-
    local wtype `e(wtype)'
    if "`wtype'"=="pweight" local wtype aweight
//subpop?
    local subpop "`e(subpop)'"
    if "`subpop'"=="" local subpop 1
//determine list of stats
    tempname results
    local Stats p99 p95 p90 p75 p50 p25 p10 p5 p1 kurtosis ///
     skewness var sd max min sum mean
    if "`all'"!="" {
        local stats `Stats'
        local range range
        local cv cv
        local semean semean
        local iqr iqr
        local sumtype detail
    }
    else {
        if "`q'"!="" {
            local p25 p25
            local p50 p50
            local p75 p75
        }
        if "`median'"!="" local p50 p50
        foreach stat of local Stats {
            if "``stat''"!="" {
                local stats: list stats | stat
            }
        }
        if "`stats'"=="" & "`range'"=="" & "`cv'"=="" & ///
         "`semean'"=="" & "`iqr'"=="" local stats sd max min mean
        local sumtype sum mean min max
        if "`:list stats - sumtype'"=="" & "`cv'"=="" & ///
         "`semean'"=="" & "`iqr'"=="" local sumtype meanonly
        else {
            local sumtype `sumtype' Var sd
            if "`:list stats - sumtype'"=="" & "`iqr'"=="" local sumtype
            else local sumtype detail
        }
    }
    local Stats: subinstr local stats "var" "Var"
    local nstats: word count `iqr' `semean' `cv' `range' `stats'
    if "`replace'"=="" {
        foreach stat in `iqr' `semean' `cv' `range' `stats' {
            confirm_new_ename `prefix'`=lower("`stat'")'
        }
    }
//calculate stats
    local var: word 1 of `e(depvar)'
    mat `results' = J(`nstats',1,.z)
    qui su `var' [`wtype'`e(wexp)'] if e(sample) & `subpop', `sumtype'
    local i 0
    if "`iqr'"!="" {
        mat `results'[`++i',1] = r(p75) - r(p25)
    }
    if "`semean'"!="" {
        mat `results'[`++i',1] = r(sd) / sqrt(r(N))
    }
    if "`cv'"!="" {
        mat `results'[`++i',1] = r(sd) / r(mean)
    }
    if "`range'"!="" {
        mat `results'[`++i',1] = r(max) - r(min)
    }
    foreach stat of local Stats {
        mat `results'[`++i',1] = r(`stat')
    }
//return the results
    local i 0
    di as txt _n "added scalars:"
    foreach stat in `iqr' `semean' `cv' `range' `stats' {
        local sname = lower("`stat'")
        ereturn scalar `prefix'`sname' = `results'[`++i',1]
        added_scalar `prefix'`sname'
    }
end

* 11.
* -estadd- subroutine: various summary statistics
program define estadd_summ, eclass
    version 8.2
    syntax [, MEan SUm MIn MAx RAnge sd Var cv SEMean SKewness ///
     Kurtosis MEDian p1 p5 p10 p25 p50 p75 p90 p95 p99 iqr q all ///
     Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//use aweights with -summarize-
    local wtype `e(wtype)'
    if "`wtype'"=="pweight" local wtype aweight
//subpop?
    local subpop "`e(subpop)'"
    if "`subpop'"=="" local subpop 1
//determine list of stats
    tempname results results2
    local Stats p99 p95 p90 p75 p50 p25 p10 p5 p1 kurtosis ///
     skewness var sd max min sum mean
    if "`all'"!="" {
        local stats `Stats'
        local range range
        local cv cv
        local semean semean
        local iqr iqr
        local sumtype detail
    }
    else {
        if "`q'"!="" {
            local p25 p25
            local p50 p50
            local p75 p75
        }
        if "`median'"!="" local p50 p50
        foreach stat of local Stats {
            if "``stat''"!="" {
                local stats: list stats | stat
            }
        }
        if "`stats'"=="" & "`range'"=="" & "`cv'"=="" & ///
         "`semean'"=="" & "`iqr'"=="" local stats sd max min mean
        local sumtype sum mean min max
        if "`:list stats - sumtype'"=="" & "`cv'"=="" & ///
         "`semean'"=="" & "`iqr'"=="" local sumtype meanonly
        else {
            local sumtype `sumtype' Var sd
            if "`:list stats - sumtype'"=="" & "`iqr'"=="" local sumtype
            else local sumtype detail
        }
    }
    local Stats: subinstr local stats "var" "Var"
    local nstats: word count `iqr' `semean' `cv' `range' `stats'
    if "`replace'"=="" {
        foreach stat in `iqr' `semean' `cv' `range' `stats' {
            confirm_new_ename `prefix'`=lower("`stat'")'
        }
    }
//copy coefficients matrix and determine varnames
    mat `results' = e(b)
    local vars: colnames `results'
    if `nstats'>1 {
        mat `results' = `results' \ J(`nstats'-1,colsof(`results'),.z)
    }
//loop over variables: calculate stats
    local j 0
    foreach var of local vars {
        local ++j
        capture confirm_numvar `var'
        if _rc mat `results'[1,`j'] = .z
        else {
            capt su `var' [`wtype'`e(wexp)'] if e(sample) & `subpop', `sumtype'
            local i 0
            if "`iqr'"!="" {
                mat `results'[`++i',`j'] = cond(_rc,.,r(p75) - r(p25))
            }
            if "`semean'"!="" {
                mat `results'[`++i',`j'] = cond(_rc,.,r(sd) / sqrt(r(N)))
            }
            if "`cv'"!="" {
                mat `results'[`++i',`j'] = cond(_rc,.,r(sd) / r(mean))
            }
            if "`range'"!="" {
                mat `results'[`++i',`j'] = cond(_rc,.,r(max) - r(min))
            }
            foreach stat of local Stats {
                mat `results'[`++i',`j'] = cond(_rc,.,r(`stat'))
            }
        }
    }
//return the results
    local i 0
    di as txt _n "added matrices:"
    foreach stat in `iqr' `semean' `cv' `range' `stats' {
        local sname = lower("`stat'")
        mat `results2' = `results'[`++i',1...]
        ereturn matrix `prefix'`sname' = `results2'
        added_matrix `prefix'`sname'
    }
end

* 12.
* -estadd- subroutine: variance inflation factors
program define estadd_vif, eclass
    version 8.2
    local caller : di _caller()
    syntax [, TOLerance SQRvif Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//check e()-names
    if "`replace'"=="" {
        confirm_new_ename `prefix'vif
        if "`tolerance'"!="" confirm_new_ename `prefix'tolerance
        if "`sqrvif'"!="" confirm_new_ename `prefix'sqrvif
    }
//copy coefficients matrix and set to .z
    tempname results results2 results3
    matrix `results' = e(b)
    forv j = 1/`=colsof(`results')' {
        mat `results'[1,`j'] = .z
    }
    if "`tolerance'"!="" mat `results2' = `results'
    if "`sqrvif'"!="" mat `results3' = `results'
//compute VIF and add to results vector
    capt n `quietly' version `caller': vif
    if _rc {
        if _rc == 301 di as err "-estadd:vif- can only be used after -regress-"
        exit _rc
    }
    local i 0
    local name "`r(name_`++i')'"
    while "`name'"!="" {
        local j = colnumb(`results',"`name'")
        if `j'<. {
            matrix `results'[1,`j'] = r(vif_`i')
            if "`tolerance'"!="" matrix `results2'[1,`j'] = 1 / r(vif_`i')
            if "`sqrvif'"!="" matrix `results3'[1,`j'] = sqrt( r(vif_`i') )
        }
        local name "`r(name_`++i')'"
    }
//return the results
    if "`sqrvif'"!="" | "`tolerance'"!="" di as txt _n "added matrices:"
    else di as txt _n "added matrix:"
    if "`sqrvif'"!="" {
        ereturn matrix `prefix'sqrvif = `results3'
        added_matrix `prefix'sqrvif
    }
    if "`tolerance'"!="" {
        ereturn matrix `prefix'tolerance = `results2'
        added_matrix `prefix'tolerance
    }
    ereturn matrix `prefix'vif = `results'
    added_matrix `prefix'vif
end

* 13.
* -estadd- subroutine: standardized factor change coefficients
program define estadd_ebsd, eclass
    version 8.2
    syntax [, Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'ebsd
//use aweights with -summarize-
    local wtype `e(wtype)'
    if "`wtype'"=="pweight" local wtype aweight
//subpop?
    local subpop "`e(subpop)'"
    if "`subpop'"=="" local subpop 1
//copy coefficients matrix and determine varnames
    tempname results
    mat `results' = e(b)
    local vars: colnames `results'
//loop over variables: calculate -mean-
    local j 0
    foreach var of local vars {
        local ++j
        capture confirm_numvar `var'
        if _rc mat `results'[1,`j'] = .z
        else {
            capt su `var' [`wtype'`e(wexp)'] if e(sample) & `subpop'
            mat `results'[1,`j'] = cond(_rc,.,exp( `results'[1,`j'] * r(sd)))
        }
    }
//return the results
    ereturn matrix `prefix'ebsd = `results'
    di _n as txt "added matrix:"
    added_matrix `prefix'ebsd
end

* 14.
* -estadd- subroutine: exponentiated coefficients
program define estadd_expb, eclass
    version 8.2
    syntax [, noCONStant Prefix(name) Replace Quietly ]
//check e()-names
    if "`replace'"=="" confirm_new_ename `prefix'expb
//copy coefficients matrix and determine names of coefficients
    tempname results
    mat `results' = e(b)
    local coefs: colnames `results'
//loop over coefficients
    local j 0
    foreach coef of local coefs {
        local ++j
        if `"`constant'"'!="" & `"`coef'"'=="_cons" {
            mat `results'[1,`j'] = .z
        }
        else {
            mat `results'[1,`j'] = exp(`results'[1,`j'])
        }
    }
//return the results
    ereturn matrix `prefix'expb = `results'
    di _n as txt "added matrix:"
    added_matrix `prefix'expb
end

* 15.
* -estadd- subroutine: partial and semi-partial correlations
program define estadd_pcorr, eclass
    version 8.2
    syntax [, semi Prefix(name) Replace Quietly ]
//check availability of e(sample)
    confirm_esample
//check e()-names
    if "`replace'"=="" {
        if "`semi'"!="" confirm_new_ename `prefix'spcorr
        confirm_new_ename `prefix'pcorr
    }
//copy coefficients matrix and set to .z
    tempname results results2
    matrix `results' = e(b)
    forv j = 1/`=colsof(`results')' {
        mat `results'[1,`j'] = .z
    }
    local eqs: coleq `results', quoted
    local eq: word 1 of `eqs'
    mat `results2' = `results'[1,"`eq':"]
    local vars: colnames `results2'
    foreach var of local vars {
        capt confirm numeric var `var'
        if !_rc local temp "`temp'`var' "
    }
    local vars "`temp'"
    if "`semi'"!="" mat `results2' = `results'
    else {
        mat drop `results2'
        local results2
    }
    local depv: word 1 of `e(depvar)'
//compute statistics and add to results vector
    local wtype `e(wtype)'
    if inlist("`wtype'","pweight","iweight") local wtype aweight
    _estadd_pcorr_compute `depv' `vars' [`wtype'`e(wexp)'] if e(sample), ///
     eq(`eq') results(`results') results2(`results2')
//return the results
    if "`semi'"!="" {
        di as txt _n "added matrices:"
        ereturn matrix `prefix'spcorr = `results2'
        added_matrix `prefix'spcorr
    }
    else di as txt _n "added matrix:"
    ereturn matrix `prefix'pcorr = `results'
    added_matrix `prefix'pcorr
end
program define _estadd_pcorr_compute // based on pcorr.ado by StataCorp
                                     // and pcorr2.ado by Richard Williams
    syntax varlist(min=1) [aw fw] [if], eq(str) results(str) [ results2(str) ]
    marksample touse
    tempname hcurrent
    _est hold `hcurrent', restore
    quietly reg `varlist' [`weight'`exp'] if `touse'
    if (e(N)==0 | e(N)>=.) error 2000
    local NmK = e(df_r)
    local R2 = e(r2)
    gettoken depv varlist: varlist
    foreach var of local varlist {
        quietly test `var'
        if r(F)<. {
            local s "1"
            if _b[`var']<0 local s "-1"
            local c = colnumb(`results',"`eq':`var'")
            mat `results'[1,`c'] = `s' * sqrt(r(F)/(r(F)+`NmK'))
            if "`results2'"!="" {
                mat `results2'[1,`c'] = `s' * sqrt(r(F)*((1-`R2')/`NmK'))
            }
        }
    }
end

* 16.
* -estadd- subroutine: Likelihood-ratio test
program define estadd_lrtest, eclass
    version 8.2
    local caller : di _caller()
    syntax anything(id="model") [, Name(name) Prefix(name) Replace Quietly * ]
    if "`name'"=="" local name lrtest_
//check e()-names
    if "`replace'"=="" {
        confirm_new_ename `prefix'`name'p
        confirm_new_ename `prefix'`name'chi2
        confirm_new_ename `prefix'`name'df
    }
//compute statistics
    `quietly' version `caller': lrtest `anything', `options'
//return the results
    ereturn scalar `prefix'`name'p = r(p)
    ereturn scalar `prefix'`name'chi2 = r(chi2)
    ereturn scalar `prefix'`name'df = r(df)
    di _n as txt "added scalars:"
    added_scalar `prefix'`name'p
    added_scalar `prefix'`name'chi2
    added_scalar `prefix'`name'df
end

* 17.
* -estadd- subroutine: support for -brant- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_brant, eclass
    version 8.2
    local caller : di _caller()
    syntax [ , Prefix(name) Replace Quietly * ]
    capt findfile brant.ado
    if _rc {
        di as error "fitstat.ado from the -spost9_ado- package by Long and Freese required"
        di as error `"type {stata "net from http://www.indiana.edu/~jslsoc/stata"}"'
        error 499
    }
// check names
    if "`replace'"=="" {
        foreach name in brant_chi2 brant_df brant_p brant {
            confirm_new_ename `prefix'`name'
        }
    }
// compute and return the results
    `quietly' version `caller': brant, `options'
    di as txt _n "added scalars:"
    foreach stat in chi2 df p {
        ereturn scalar `prefix'brant_`stat' = r(`stat')
        added_scalar `prefix'brant_`stat'
    }
    tempname mat
    matrix `mat' = r(ivtests)
    matrix `mat' = `mat''
    ereturn matrix `prefix'brant = `mat'
    di as txt _n "added matrix:"
    added_matrix `prefix'brant _rown
end

* 18.
* -estadd- subroutine: support for -fitstat- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_fitstat, eclass
    version 8.2
    local caller : di _caller()
    syntax [ , Prefix(name) Replace Quietly Bic * ]
    capt findfile fitstat.ado
    if _rc {
        di as error "fitstat.ado from the -spost9_ado- package by Long and Freese required"
        di as error `"type {stata "net from http://www.indiana.edu/~jslsoc/stata"}"'
        error 499
    }
    `quietly' version `caller': fitstat, `bic' `options'
    local stats: r(scalars)
    local allstats                                                  ///
        dev dev_df lrx2 lrx2_df lrx2_p r2_adj r2_mf r2_mfadj r2_ml  ///
        r2_cu r2_mz r2_ef v_ystar v_error r2_ct r2_ctadj aic aic_n  ///
        bic bic_p statabic stataaic n_rhs n_parm
    local stats: list allstats & stats
    if "`bic'"!="" {
        local bic aic aic_n bic bic_p statabic stataaic
        local stats: list bic & stats
    }


// check names
    if "`replace'"=="" {
        foreach stat of local stats {
            if inlist("`stat'", "bic", "aic") local rname `stat'0
            else local rname `stat'
            confirm_new_ename `prefix'`rname'
        }
    }

// return the results
    di as txt _n "added scalars:"
    foreach stat of local stats {
        if inlist("`stat'", "bic", "aic") local rname `stat'0
        else local rname `stat'
        ereturn scalar `prefix'`rname' = r(`stat')
        added_scalar `prefix'`rname'
    }
end

* 19.
* -estadd- subroutine: support for -listcoef- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_listcoef, eclass
    version 8.2
    local caller : di _caller()
    syntax [anything] [ , Prefix(name) Replace Quietly ///
     nosd gt lt ADJacent Matrix EXpand * ]

// handle some options and look for e(sample)
    if `"`matrix'"'!="" {
        local matrix matrix
    }
    if `"`e(cmd)'"'=="slogit" & "`expand'"!="" {
        di as err "-expand- option not supported"
        exit 198
    }
    confirm_esample

// set some constants
    local listcoef_matrices  "xs ys std fact facts pct pcts"
    if "`sd'"=="" local listcoef_matrices "`listcoef_matrices' sdx"

// run listcoef
    capt findfile listcoef.ado
    if _rc {
        di as error "-listcoef- from the -spost9_ado- package by Long and Freese required"
        di as error `"type {stata "net from http://www.indiana.edu/~jslsoc/stata"}"'
        error 499
    }
    `quietly' version `caller': listcoef `anything' , matrix `gt' `lt' `adjacent' `options'

// check existing e()'s
    if "`replace'"=="" {
        confirm_new_ename `prefix'pvalue
        foreach matrix of local listcoef_matrices {
            _estadd_listcoef_ChkEName b_`matrix', prefix(`prefix')
        }
    }

// grab r()-results and post in e()
    di as txt _n "added matrices:"
    if inlist(`"`e(cmd)'"',"mlogit","mprobit") {
        _estadd_listcoef_AddResToNomModl `listcoef_matrices', prefix(`prefix') `gt' `lt' `adjacent'
    }
    else {
        foreach matrix of local listcoef_matrices {
            _estadd_listcoef_AddMatToE `matrix', prefix(`prefix')
        }
    }
end
program define _estadd_listcoef_ChkEName
    syntax name [, prefix(str) ]
    capt confirm matrix r(`namelist')
    if _rc exit
    confirm_new_ename `prefix'`namelist'
end
program define _estadd_listcoef_AddMatToE, eclass
    syntax name [, prefix(str) ]
    capt confirm matrix r(b_`namelist')
    if _rc exit
    tempname tmp
    matrix `tmp' = r(b_`namelist')
    capt confirm matrix r(b2_`namelist')
    if _rc==0 {
        local eqnames: coleq e(b), quoted
        local eqnames: list uniq eqnames
        local eqname: word 1 of `eqnames'
        mat coleq `tmp' = `"`eqname'"'
        tempname tmp2
        matrix `tmp2' = r(b2_`namelist')
        local eqname: word 2 of `eqnames'
        mat coleq `tmp2' = `"`eqname'"'
        mat `tmp' = `tmp' , `tmp2'
        mat drop `tmp2'
    }
    ereturn matrix `prefix'b_`namelist' = `tmp'
    added_matrix `prefix'b_`namelist' _rown
end
program define _estadd_listcoef_AddResToNomModl, eclass
    syntax anything(name=listcoef_matrices) [, prefix(str) gt lt ADJacent ]
    if "`lt'"=="" & "`gt'"=="" {
        local lt lt
        local gt gt
    }
    local adjacent = "`adjacent'"!=""
    local lt = "`lt'"!=""
    local gt = "`gt'"!=""

// outcomes and labels
    tempname outcomes
    if `"`e(cmd)'"'=="mlogit" {
        if c(stata_version) < 9 local type cat
        else                    local type out
        mat `outcomes' = e(`type')
        local noutcomes = colsof(`outcomes')
        local eqnames `"`e(eqnames)'"'
        if (`:list sizeof eqnames'<`noutcomes') {
            local ibase = e(ibase`type')
        }
        else local ibase 0
        forv i = 1/`noutcomes' {
            if `i'==`ibase' {
                local outcomelab`i' `"`e(baselab)'"'
            }
            else {
                gettoken eq eqnames : eqnames
                local outcomelab`i' `"`eq'"'
            }
            if `"`outcomelab`i''"'=="" {
                local outcomelab`i': di `outcomes'[1,`i']
            }
        }
    }
    else if `"`e(cmd)'"'=="mprobit" {
        mat `outcomes' = e(outcomes)'
        local noutcomes = colsof(`outcomes')
        forv i = 1/`noutcomes' {
            local outcomelab`i' `"`e(out`i')'"'
        }
    }
    else {
        di as err `"`e(cmd)' not supported"'
        exit 499
    }

// collect vectors
    tempname stats
    mat `stats' = r(b) \ r(b_z) \ r(b_z) \ r(b_p)
    forv i = 1/`=colsof(`stats')' {
        mat `stats'[2,`i'] = `stats'[1,`i'] / `stats'[3,`i']
    }
    mat rown `stats' = "b" "se" "z" "P>|z|"
    local enames "b_raw b_se b_z b_p"
    foreach matrix of local listcoef_matrices {
        capt confirm matrix r(b_`matrix')
        if _rc continue
        mat `stats' = `stats' \ r(b_`matrix')
        local enames `"`enames' b_`matrix'"'
    }

// select/reorder contrasts of interest
    local contrast "r(contrast)"
    local ncontrast = colsof(`contrast')
    tempname stats0 temp
    matrix rename `stats' `stats0'
    forv i = 1/`noutcomes' {
        local out1 = `outcomes'[1, `i']
        local j 0
        forv j = 1/`noutcomes' {
            local out2 = `outcomes'[1, `j']
            if `out1'==`out2' continue
            if `adjacent' & abs(`i'-`j')>1 continue
            if `lt'==0 & `out1'<`out2' continue
            if `gt'==0 & `out1'>`out2' continue
            forv l = 1/`ncontrast' {
                if el(`contrast',1,`l')!=`out1' continue
                if el(`contrast',2,`l')!=`out2' continue
                mat `temp' = `stats0'[1..., `l']
                mat coleq `temp' = `"`outcomelab`i''-`outcomelab`j''"'
                mat `stats' = nullmat(`stats'), `temp'
            }
        }
    }
    capt mat drop `stats0'

// post rows to e()
    local i 0
    foreach ename of local enames {
        local ++i
        mat `temp' = `stats'[`i', 1...]
        ereturn matrix `prefix'`ename' = `temp'
        added_matrix `prefix'`ename' _rown
    }
end

* 20.
* -estadd- subroutine: support for -mlogtest- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_mlogtest, eclass
    version 8.2
    local caller : di _caller()
    syntax [anything] [ , Prefix(name) Replace Quietly set(passthru) * ]
    `quietly' version `caller': mlogtest `anything' , `set' `options'
    local rmat: r(matrices)

    // check names
    if `"`replace'"'=="" {
        foreach m in combine lrcomb {
            if `:list m in rmat'==0 continue
            forv r = 1/`=rowsof(r(`m'))' {
                local cat1 = el(r(`m'),`r',1)
                local cat2 = el(r(`m'),`r',2)
                confirm_new_ename `prefix'`m'_`cat1'_`cat2'_chi2
                confirm_new_ename `prefix'`m'_`cat1'_`cat2'_df
                confirm_new_ename `prefix'`m'_`cat1'_`cat2'_p
            }
        }
        foreach m in hausman suest smhsiao {
            if `:list m in rmat'==0 continue
            forv r = 1/`=rowsof(r(`m'))' {
                local cat = el(r(`m'),`r',1)
                confirm_new_ename `prefix'`m'_`cat'_chi2
                confirm_new_ename `prefix'`m'_`cat'_df
                confirm_new_ename `prefix'`m'_`cat'_p
            }
        }
        if `"`set'"'!="" {
            foreach m in wald lrtest {
                if `:list m in rmat'==0 continue
                local i 0
                local r = rownumb(r(`m'),"set_`++i'")
                while(`r'<.) {
                    confirm_new_ename `prefix'`m'_set`i'_chi2
                    confirm_new_ename `prefix'`m'_set`i'_df
                    confirm_new_ename `prefix'`m'_set`i'_p
                    local r = rownumb(r(`m'),"set_`++i'")
                }
            }
        }
        foreach m in wald lrtest {
            if `:list m in rmat'==0 continue
            local r .
            if `"`set'"'!="" local r = rownumb(r(`m'),"set_1")-1
            if `r'<1 continue
            confirm_new_ename `prefix'`m'
       }
    }

    local di_added_scalars `"di _n as txt "added scalars:"'
    // combine
    foreach m in combine lrcomb {
        if `:list m in rmat'==0 continue
        `di_added_scalars'
        local di_added_scalars
        forv r = 1/`=rowsof(r(`m'))' {
            local cat1 = el(r(`m'),`r',1)
            local cat2 = el(r(`m'),`r',2)
            eret scalar `prefix'`m'_`cat1'_`cat2'_chi2 = el(r(`m'),`r',3)
            added_scalar `prefix'`m'_`cat1'_`cat2'_chi2
            eret scalar `prefix'`m'_`cat1'_`cat2'_df   = el(r(`m'),`r',4)
            added_scalar `prefix'`m'_`cat1'_`cat2'_df
            eret scalar `prefix'`m'_`cat1'_`cat2'_p    = el(r(`m'),`r',5)
            added_scalar `prefix'`m'_`cat1'_`cat2'_p
        }
    }
    // iia
    foreach m in hausman suest smhsiao {
        if `:list m in rmat'==0 continue
        `di_added_scalars'
        local di_added_scalars
        if "`m'"=="smhsiao" local skip 2
        else                local skip 0
        forv r = 1/`=rowsof(r(`m'))' {
            local cat = el(r(`m'),`r',1)
            eret scalar `prefix'`m'_`cat'_chi2 = el(r(`m'),`r',2+`skip')
            added_scalar `prefix'`m'_`cat'_chi2
            eret scalar `prefix'`m'_`cat'_df   = el(r(`m'),`r',3+`skip')
            added_scalar `prefix'`m'_`cat'_df
            eret scalar `prefix'`m'_`cat'_p    = el(r(`m'),`r',4+`skip')
            added_scalar `prefix'`m'_`cat'_p
        }
    }

    // wald/lrtest
    tempname tmp
    if `"`set'"'!="" {
        foreach m in wald lrtest {
            if `:list m in rmat'==0 continue
            local i 0
            local r = rownumb(r(`m'),"set_`++i'")
            if `r'>=. continue
            `di_added_scalars'
            local di_added_scalars
            while(`r'<.) {
                eret scalar `prefix'`m'_set`i'_chi2 = el(r(`m'),`r',1)
                added_scalar `prefix'`m'_set`i'_chi2
                eret scalar `prefix'`m'_set`i'_df   = el(r(`m'),`r',2)
                added_scalar `prefix'`m'_set`i'_df
                eret scalar `prefix'`m'_set`i'_p    = el(r(`m'),`r',3)
                added_scalar `prefix'`m'_set`i'_p
                local r = rownumb(r(`m'),"set_`++i'")
            }
        }
    }
    local di_added_matrices `"di _n as txt "added matrices:"'
    foreach m in wald lrtest {
        if `:list m in rmat'==0 continue
        local r .
        if `"`set'"'!="" local r = rownumb(r(`m'),"set_1")-1
        if `r'<1 continue
        `di_added_matrices'
        local di_added_matrices
        mat `tmp' = r(`m')
        mat `tmp' = `tmp'[1..`r',1...]'
        eret mat `prefix'`m' = `tmp'
        added_matrix `prefix'`m' _rown
    }

end


* 21.
* -estadd- subroutine: support for -prchange- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_prchange
    version 8.2
    local caller : di _caller()
    syntax [anything] [if] [in] [ , Prefix(name) Replace Quietly ///
        PAttern(str) Binary(str) Continuous(str) NOAvg Avg split SPLIT2(name) ///
            adapt /// old syntax; now works as synonym for noavg
        Outcome(passthru) Fromto noBAse * ]

// handle some options
    if `"`split2'"'!="" local split split
    if "`split'"!="" & `"`outcome'"'!="" {
        di as err "split and outcome() not both allowed"
        exit 198
    }
    if "`split'"!="" & `"`avg'`noavg'"'!="" {
        di as err "split and avg not both allowed"
        exit 198
    }
    if "`avg'"!="" & `"`outcome'"'!="" {
        di as err "avg and outcome not both allowed"
        exit 198
    }
    if "`avg'"!="" & "`noavg'"!="" {
        di as err "avg and noavg not both allowed"
        exit 198
    }
    if `"`adapt'"'!=""  local noavg noavg
    if `:list sizeof binary'>1 | `:list sizeof continuous'>1  error 198
    estadd_prchange_ExpandType binary `"`binary'"'
    estadd_prchange_ExpandType continuous `"`continuous'"'
    if `"`binary'"'==""     local binary 2
    if `"`continuous'"'=="" local continuous 4
    if `"`pattern'"'!="" {
        estadd_prchange_ExpandType pattern `"`pattern'"'
    }

// check e(sample)
    confirm_esample

// run prchange
    capt findfile prchange.ado
    if _rc {
        di as error "-prchange- from the -spost9_ado- package by Long and Freese required"
        di as error `"type {stata "net from http://www.indiana.edu/~jslsoc/stata"}"'
        error 499
    }
    `quietly' version `caller': prchange `anything' `if' `in', `base' `outcome' `fromto' `options'

// determine type of model (ordinal: nomord = 1; nominal: nomord = 2)
    local nomord = (r(modeltype)=="typical nomord")
    if inlist(`"`e(cmd)'"',"mlogit","mprobit") local nomord = 2
    if "`avg'`noavg'"!="" {
        if `nomord'==0 {
            di as err "avg not allowed with this model"
            exit 198
        }
    }
    if !`nomord' & "`split'"!="" {
        di as err "split not allowed with this model"
        exit 198
    }

// determine outcome number (in prchange-returns)
    if `"`outcome'"'!="" {
        if `nomord' {
            forv i = 1/`=colsof(r(catval))' {
                if el(r(catval), 1, `i') == r(outcome) {
                    local outcomenum `i'
                    continue, break
                }
            }
            if "`outcomenum'"=="" { // should never happen
                di as err `"outcome `outcome' not found"'
                exit 499
            }
        }
        else {
            local outcomenum =  colnumb(r(predval), `"`r(outcome)'"')
        }
    }

// check names
    if "`replace'"=="" {
        if `"`outcome'"'!="" | "`split'"!="" | `nomord'==0 {
            confirm_new_ename `prefix'predval
            if `"`outcome'"'!="" | "`split'"!="" {
                confirm_new_ename `prefix'outcome
            }
        }
        else {
            forv i = 1/`=colsof(r(catval))' {
                local theoutcome: di el(r(catval),1,`i')
                confirm_new_ename `prefix'predval`theoutcome'
            }
        }
        confirm_new_ename `prefix'delta
        confirm_new_ename `prefix'centered
        confirm_new_ename `prefix'dc
        if "`fromto'"!="" {
            confirm_new_ename `prefix'dcfrom
            confirm_new_ename `prefix'dcto
        }
        if "`nobase'"=="" {
            confirm_new_ename `prefix'X
        }
    }

// grab r()-results and post in e()
    if "`split'"!="" {
        if `"`split2'"'=="" {
            local split2 `"`e(_estadd_estimates_name)'"'
            if `"`split2'"'=="" {
                local split2 `"`e(cmd)'"'
            }
            local split2 `"`split2'_"'
        }
        _estadd_prchange_StoreEachOutc `split2' , nomord(`nomord') ///
            pattern(`pattern') binary(`binary') continuous(`continuous') ///
            `base' `fromto' prefix(`prefix')
    }
    else {
        _estadd_prchange_AddStuffToE, nomord(`nomord') outcome(`outcomenum') ///
            pattern(`pattern') binary(`binary') continuous(`continuous') ///
            `avg' `noavg' `base' `fromto' prefix(`prefix')
    }
end
program estadd_prchange_ExpandType
    args name list
    foreach l of local list {
        local w = length(`"`l'"')
        if      `"`l'"'==substr("minmax",1,max(2,`w'))      local type 1
        else if `"`l'"'==substr("01",1,max(1,`w'))          local type 2
        else if `"`l'"'==substr("delta",1,max(1,`w'))       local type 3
        else if `"`l'"'==substr("sd",1,max(1,`w'))          local type 4
        else if `"`l'"'==substr("margefct",1,max(1,`w'))    local type 5
        else {
            di as err `"'`l'' not allowed"'
            exit 198
        }
        local newlist `newlist' `type'
    }
    c_local `name' `newlist'
end
program define _estadd_prchange_AddStuffToE, eclass
//      input                            add
// =========================    ========================================
// outcome() nomord    opt      change changenm change# predval  outcome
//   no        0        -         x                      last
//   yes       0        -         x                       x        x
//   no       1/2       -                 x       all    all
//   yes      1/2       -                          x      x        x
//   no       1/2      avg                x              all
//   no       1/2     noavg                       all    all
//  nobase==""  => add X, SD, Min, Max
//  all models  => add centered, delta
    syntax , nomord(str) [ pattern(passthru) binary(passthru) continuous(passthru) ///
        outcome(str) NOAVG avg nobase fromto prefix(str) split ] //
// prepare predval and determine value of outcome
    if `"`outcome'"'!="" {
        tempname predv
        mat `predv' = r(predval)
        mat `predv' = `predv'[1...,`outcome']
        if `nomord' {
            local theoutcome: di el(r(catval),1,`outcome')
        }
        else {
            local theoutcome: colnames `predv'
        }
    }
// add scalars
    di _n as txt "added scalars:"
// - predval and outcome
    local cpredval = colsof(r(predval))
    if `"`outcome'"'!="" {
        ereturn scalar `prefix'predval = `predv'[1,1]
        added_scalar `prefix'predval `"`lab_predval'"'
        ereturn scalar `prefix'outcome = `theoutcome'
        added_scalar `prefix'outcome
    }
    else if `nomord' { // add all
        forv i=1/`cpredval' {
            local theoutcome: di el(r(catval),1,`i')
            ereturn scalar `prefix'predval`theoutcome' = el(r(predval),1,`i')
            added_scalar `prefix'predval`theoutcome'
        }
    }
    else { // add last
        ereturn scalar `prefix'predval = el(r(predval),1,`cpredval')
        added_scalar `prefix'predval
    }
// - delta and centered
    ereturn scalar `prefix'delta = r(delta)
    added_scalar `prefix'delta
    ereturn scalar `prefix'centered = r(centered)
    added_scalar `prefix'centered
// add matrices
    di _n as txt "added matrices:"
    if `nomord'==0 {
        if r(modeltype)=="twoeq count" & "`test'"=="" {
            local eq: coleq e(b)
            local eq: word 1 of `eq'
        }
        _estadd_prchange_PostMat r(change), prefix(`prefix') ///
            name(dc) `pattern' `binary' `continuous' `fromto' eq(`eq')
    }
    else {
        if `"`outcome'"'=="" {
            if "`avg'"!="" local nomordmat "r(changemn)"
            else {
                tempname nomordmat
                _estadd_prchange_GatherNomChMat `nomordmat' `noavg'
            }
            _estadd_prchange_PostMat `nomordmat', prefix(`prefix') ///
                name(dc) `pattern' `binary' `continuous' `fromto'
        }
        else {
            if `nomord'==2 {
                _estadd_prchange_GetEqnmNomModl `theoutcome'
            }
            if `"`split'"'!="" {
                _estadd_prchange_PostMat r(change`theoutcome'), prefix(`prefix') ///
                    name(dc) `pattern' `binary' `continuous' `fromto' eq(`eq')
            }
            else {
                _estadd_prchange_PostMat r(change), prefix(`prefix') ///
                    name(dc) `pattern' `binary' `continuous' `fromto' eq(`eq')
            }
        }
    }
    if `"`base'"'=="" {
        _estadd_prchange_PostMat r(baseval), prefix(`prefix') name(X)
    }
    if `"`pattern'"'=="" {
        _estadd_prchange_dcNote, prefix(`prefix') name(dc) `binary' `continuous'
    }
end
program define _estadd_prchange_dcNote
    syntax [ , prefix(str) name(str) binary(str) continuous(str) ]
    local res `""{res:minmax} change" "{res:01} change" "{res:delta} change" "{res:sd} change" "{res:margefct}""'
    local bres: word `binary' of `res'
    local cres: word `continuous' of `res'
    di _n as txt `"first row in e(dc) contains:"'
    di _n `"  `bres' for binary variables"'
    di    `"  `cres' for continuous variables"'
end
program define _estadd_prchange_PostMat, eclass
    syntax anything, name(str) [ Fromto eq(str) prefix(str) ///
        pattern(passthru) binary(passthru) continuous(passthru) ]
    capt confirm matrix `anything'
    if _rc exit
    tempname tmp1
    local nmlist "`name'"
    matrix `tmp1' = `anything'
    if `"`eq'"'!="" {
        mat coleq `tmp1' = `"`eq'"'
    }
    if `"`pattern'`binary'`continuous'"'!="" {
        tempname pattmat
        _estadd_prchange_Merge `tmp1', pattmat(`pattmat') `pattern' `binary' `continuous' `fromto'
    }
    if "`fromto'"!="" {
        local nmlist "`nmlist' `name'from `name'to"
        tempname tmp tmp2 tmp3
        mat rename `tmp1' `tmp'
        local r = rowsof(`tmp')
        local i = 1
        while (`i'<=`r') {
            if (`r'-`i')>=2 {
                mat `tmp2' = nullmat(`tmp2') \ `tmp'[`i++',1...] // from
                mat `tmp3' = nullmat(`tmp3') \ `tmp'[`i++',1...] // to
            }
            mat `tmp1' = nullmat(`tmp1') \ `tmp'[`i++',1...]
        }
        mat drop `tmp'
    }
    local i 0
    foreach nm of local nmlist {
        local ++i
        local rown: rown `tmp`i''
        mat rown `tmp`i'' = `rown'  // fix problem with leading blanks in equations
        ereturn matrix `prefix'`nm' = `tmp`i''
        added_matrix `prefix'`nm' _rown
    }
    if `"`pattmat'"'!="" {
        ereturn matrix `prefix'pattern = `pattmat'
        added_matrix `prefix'pattern
    }
end
program define _estadd_prchange_Merge
    syntax name(name=tmp1) [, pattmat(str) pattern(str) binary(str) continuous(str) fromto ]
    tempname tmp
    mat rename `tmp1' `tmp'
    local r = cond("`fromto'"!="", 3, 1)
    mat `tmp1' = `tmp'[1..`r',1...]*.
    mat `pattmat' = `tmp'[1,1...]*.
    local rtot = rowsof(`tmp')
    mat rown `tmp1' = main
    mat rown `pattmat' = :type
    local vars: colnames `tmp1'
    local eqs: coleq `tmp1', quoted
    local j 0
    foreach var of local vars {
        local ++j
        gettoken eq eqs : eqs
        if `"`eq'"'!=`"`lasteq'"' gettoken type rest : pattern
        else                      gettoken type rest : rest
        local lasteq `"`eq'"'
        if `"`type'"'=="" {
            capt assert `var'==0|`var'==1 if e(sample) & `var'<.
            if _rc local type `continuous'
            else   local type `binary'
        }
        local ii = (`type'-1)*`r'+1
        forv i = 1/`r' {
            if `r'>1 & `i'<3 & `ii'>=`rtot' {
                mat `tmp1'[`i',`j'] = .z
            }
            else {
                mat `tmp1'[`i',`j'] = `tmp'[`ii++',`j']
            }
        }
        mat `pattmat'[1,`j'] = `type'
    }
    mat `tmp1' = `tmp1' \ `tmp'
end
program define _estadd_prchange_GatherNomChMat
    args mat noavg
    local cmd `"`e(cmd)'"'
    tempname tmpmat
    if `"`noavg'"'=="" {
        mat `tmpmat' = r(changemn)
        mat coleq `tmpmat' = `"Avg|Chg|"'
        mat `mat' = `tmpmat'
    }
    if `"`cmd'"'=="mlogit" {
        if c(stata_version) < 9 local outcat cat
        else local outcat out
        local k_cat = e(k_`outcat')
        local eqnames `"`e(eqnames)'"'
        if `k_cat'>`:list sizeof eqnames' { // no base equation
            local ibase = e(ibase`outcat')
            local baselab `"`e(baselab)'"'
            if `"`baselab'"'=="" {
                local baselab `"`e(base`outcat')'"'
            }
            forv i = 1/`k_cat' {
                if `i'==`ibase' {
                    local eq `"`"`baselab'"'"'
                }
                else gettoken eq eqnames : eqnames, quotes
                local temp `"`temp' `eq'"'
            }
            local eqnames: list retok temp
        }
        local i 0
        foreach eq of local eqnames {
            local ++i
            local theoutcome: di el(e(`outcat'),1,`i')
            mat `tmpmat' = r(change`theoutcome')
            mat coleq `tmpmat' = `"`eq'"'
            mat `mat' = nullmat(`mat'), `tmpmat'
        }
    }
    else if `"`cmd'"'=="mprobit" {
        local eqnames `"`e(outeqs)'"'
        local i 0
        foreach eq of local eqnames {
            local ++i
            local theoutcome: di el(e(outcomes),`i',1)
            mat `tmpmat' = r(change`theoutcome')
            mat coleq `tmpmat' = `"`eq'"'
            mat `mat' = nullmat(`mat'), `tmpmat'
        }
    }
    else { // ordered models
        local eqnames : colnames r(catval)
        local i 0
        foreach eq of local eqnames {
            local ++i
            local theoutcome: di el(r(catval),1,`i')
            mat `tmpmat' = r(change`theoutcome')
            mat coleq `tmpmat' = `"`eq'"'
            mat `mat' = nullmat(`mat'), `tmpmat'
        }
    }
end
program define _estadd_prchange_GetEqnmNomModl
    args theoutcome
    local cmd `"`e(cmd)'"'
    if `"`cmd'"'=="mlogit" {
        if c(stata_version) < 9 local outcat cat
        else local outcat out
        local k_cat = e(k_`outcat')
        local eqnames `"`e(eqnames)'"'
        local nobase = (`k_cat'>`:list sizeof eqnames')
        if `nobase' {
            local ibase = e(ibase`outcat')
            local baselab `"`e(baselab)'"'
        }
        forv i = 1/`k_cat' {
            if `nobase' {
                if `i'==`ibase' {
                    local eq `"`baselab'"'
                }
                else gettoken eq eqnames : eqnames
            }
            else gettoken eq eqnames : eqnames
            if el(e(`outcat'),1,`i')==`theoutcome' {
                local value `"`eq'"'
                continue, break
            }
        }
    }
    else if `"`cmd'"'=="mprobit" {
        local eqnames `"`e(outeqs)'"'
        local i 0
        foreach eq of local eqnames {
            if el(e(outcomes),`++i',1)==`theoutcome' {
                local value `"`eq'"'
                continue, break
            }
        }
    }
    if `"`value'"'=="" local value `theoutcome'
    c_local eq `"`value'"'
end
program define _estadd_prchange_StoreEachOutc // only for nomord models
    syntax anything [, nomord(str) nobase fromto prefix(passthru) ///
        pattern(passthru) binary(passthru) continuous(passthru) ]
// backup estimates
    tempname hcurrent
    _est hold `hcurrent', copy restore estsystem
    if `"`nomord'"'=="2" {  // backup b and V
        tempname b bi V Vi
        mat `b' = e(b)
        mat `V' = e(V)
    }
// cycle through categories
    local k_kat = colsof(r(predval))
    tempname catval catvali
    mat `catval' = r(catval)
    forv i=1/`k_kat' {
        mat `catvali' = `catval'[1...,`i']
        local catlabi: colnames `catvali'
        local catnumi: di `catvali'[1,1]
        if `"`nomord'"'=="2" {
            _estadd_prchange_GetEqnmNomModl `catnumi'
            if colnumb(`b', `"`eq':"')<. {
                mat `bi' = `b'[1...,`"`eq':"']
                mat `Vi' = `V'[`"`eq':"',`"`eq':"']
            }
            else {  // base outcome; get first eq and set zero
                local tmp : coleq `b', q
                gettoken tmp : tmp
                mat `bi' = `b'[1...,`"`tmp':"'] * 0
                mat `Vi' = `V'[`"`tmp':"',`"`tmp':"'] * 0
            }
            mat coleq `bi' = ""
            mat coleq `Vi' = ""
            mat roweq `Vi' = ""
            erepost b=`bi' V=`Vi'
        }
        `qui' _estadd_prchange_AddStuffToE, split nomord(1) outcome(`i') ///
            `base' `fromto' `pattern' `binary' `continuous' `prefix'
        `qui' di ""
        local qui qui
        _eststo `anything'`catnumi', title(`"`catlabi'"') // store without e(sample)
        di as txt "results for outcome " as res `catnumi' ///
         as txt " stored as " as res "`anything'`catnumi'"
    }
// retore estimates
    _est unhold `hcurrent'
end

* 22.
* -estadd- subroutine: support for -prvalue- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_prvalue, eclass
    version 9.2
    local caller : di _caller()
    syntax [anything] [if] [in] [ , Prefix(passthru) Replace Quietly ///
        LABel(str) Title(passthru) swap Diff * ]

// post
    if `"`anything'"'!="" {
        gettoken post post2 : anything
        if `"`post'"'!="post" {
            di as err `"`post' not allowed"'
            exit 198
        }
        else if `"`label'"'!="" {
            di as err "label() not allowed"
            exit 198
        }
        _estadd_prvalue_Post `post2' `if' `in', `prefix' `replace' `quietly' ///
            `title' `swap' `diff' `options'
        exit
    }
    else if `"`title'"'!="" {
        di as err "title() not allowed"
        exit 198
    }
    else if "`swap'"!="" {
        di as err "swap not allowed"
        exit 198
    }

// look for e(sample)
    confirm_esample

// run prvalue
    capt findfile prvalue.ado
    if _rc {
        di as error "-prvalue- from the -spost9_ado- package by Long and Freese required"
        di as error `"type {stata "net from http://www.indiana.edu/~jslsoc/stata"}"'
        error 499
    }
    `quietly' version `caller': prvalue `if' `in', `diff' `options'

// append?
    capture confirm existence `e(_estadd_prvalue)'
    local append = (_rc==0) & ("`replace'"=="")
    tempname prvalue prvalue_x prvalue_x2
    if `append' {
        mat `prvalue'   = e(_estadd_prvalue)
        mat `prvalue_x' = e(_estadd_prvalue_x)
        capt mat `prvalue_x2' = e(_estadd_prvalue_x2)
        local ires = rowsof(`prvalue') + 1
    }
    else local ires 1
    if `"`label'"'=="" {
        local label "pred`ires'"
    }
    else {
        local label = substr(`"`label'"', 1, 30)  // 30 characters max
        local problemchars `": . `"""'"'
        foreach char of local problemchars {
            local label: subinstr local label `"`char'"' "_", all
        }
    }

// collect results
    tempname pred
    mat `pred' = r(pred)
    if `"`diff'"'!="" {
        _estadd_prvalue_GetRidOfD `pred'
    }
    _estadd_prvalue_ReshapePred `pred', label(`label')
    _estadd_prvalue_AddPred `prvalue' `pred' `append'
    _estadd_prvalue_AddX `prvalue_x', label(`label')
    capture confirm matrix r(x2)
    local hasx2 = _rc==0
    if `hasx2' {
        _estadd_prvalue_AddX `prvalue_x2', label(`label') two
    }

// post in e()
    di as txt _n cond(`append',"updated","added") " matrices:"
    ereturn matrix _estadd_prvalue = `prvalue'
    added_matrix _estadd_prvalue
    ereturn matrix _estadd_prvalue_x = `prvalue_x'
    added_matrix _estadd_prvalue_x
    if `hasx2' {
        ereturn matrix _estadd_prvalue_x2 = `prvalue_x2'
        added_matrix _estadd_prvalue_x2
    }
end
program _estadd_prvalue_GetRidOfD
    args pred
    local coln: colnames `pred'
    local firstcol: word 1 of `coln'
    local nfirstcol = substr("`firstcol'",2,.)
    local coln : subinstr local coln "`firstcol'" "`nfirstcol'" , word
    mat coln `pred' = `coln'
end
program _estadd_prvalue_ReshapePred
    syntax anything, label(str)
    tempname tmp res
    local r = rowsof(`anything')
    forv i=1/`r' {
        mat `tmp' = `anything'[`i',1...]
        local nm: rownames `tmp'
        mat coleq `tmp' = `"`nm'"'
        mat `res' = nullmat(`res'), `tmp'
    }
    mat rown `res' = `"`label'"'
    mat `anything' = `res'
end
program _estadd_prvalue_AddPred
    args prvalue pred append
    if `append' {
        local coln1: colfullnames `prvalue'
        local coln2: colfullnames `pred'
        if `"`coln1'"'!=`"`coln2'"' {
            di as err "incompatible prvalue results"
            exit 498
        }
    }
    mat `prvalue' = nullmat(`prvalue') \ `pred'
end
program  _estadd_prvalue_AddX
    syntax anything, label(str) [ two ]
    if "`two'"!="" local two 2
    tempname tmp
    mat `tmp' = r(x`two')
    mat rown `tmp' = `"`label'"'
    mat `anything' = nullmat(`anything') \ `tmp'
end
program _estadd_prvalue_Post, eclass
    syntax [name(name=post2)] [ , Prefix(name) Replace Quietly ///
        Title(passthru) swap ]
    capture confirm matrix e(_estadd_prvalue)
    if _rc {
        di as err "prvalue results not found"
        exit 498
    }
// backup estimates
    tempname hcurrent
    _est hold `hcurrent', copy restore estsystem
    local cmd = e(cmd)
    local depvar = e(depvar)
    local N = e(N)
    local estname `"`e(_estadd_estimates_name)'"'

// get results
    tempname prvalue prvalue_x prvalue_x2
    mat `prvalue' = e(_estadd_prvalue)
    mat `prvalue_x' = e(_estadd_prvalue_x)
    capture confirm matrix e(_estadd_prvalue_x2)
    local hasx2 = _rc==0
    if `hasx2' {
        mat `prvalue_x2' = e(_estadd_prvalue_x2)
    }

// return prvalues
    tempname tmp tmp2 b se
    if "`swap'"=="" {
        local eqs: coleq `prvalue', q
        local eqs: list uniq eqs
        foreach eq of local eqs {
            mat `tmp' = `prvalue'[1...,`"`eq':"']
            mat `tmp2' = `tmp'[1...,1]'
            mat coleq `tmp2' = `"`eq'"'
            mat roweq `tmp2' = ""
            mat `b' = nullmat(`b'), `tmp2'
            mat `tmp2' = `tmp'[1...,`"`eq':SE"']'
            mat coleq `tmp2' = `"`eq'"'
            mat roweq `tmp2' = ""
            mat `se' = nullmat(`se'), `tmp2'
        }
        mat drop `tmp' `tmp2'
    }
    else {
        local r = rowsof(`prvalue')
        local c = colsof(`prvalue')
        local coln: colnames `prvalue'
        local eqs: coleq `prvalue', q
        mat coln `prvalue' = `eqs'
        mat coleq `prvalue' = `coln'
        local coln: list uniq coln
        local ncol: list sizeof coln
        local icol: list posof "SE" in coln
        forv i=1/`r' {
            mat `tmp' = `prvalue'[`i',1...]
            local labl : rownames `tmp'
            forv j=1(`ncol')`c' {
                mat `tmp2' = nullmat(`tmp2'), `tmp'[1...,`j']
            }
            mat coleq `tmp2' = `"`labl'"'
            mat `b' = nullmat(`b'), `tmp2'
            mat drop `tmp2'
            forv j=`icol'(`ncol')`c' {
                mat `tmp2' = nullmat(`tmp2'), `tmp'[1...,`j']
            }
            mat coleq `tmp2' = `"`labl'"'
            mat `se' = nullmat(`se'), `tmp2'
            mat drop `tmp2'
        }
        mat drop `tmp'
    }
    ereturn post `b', obs(`N')
    ereturn local model "`cmd'"
    ereturn local cmd "estadd_prvalue"
    ereturn local depvar "`depvar'"
    di as txt _n "scalars:"
    added_scalar N
    di as txt _n "macros:"
    added_macro depvar
    added_macro cmd
    added_macro model
    added_macro properties
    di as txt _n "matrices:"
    added_matrix b "predictions"
    ereturn matrix se = `se'
    added_matrix se "standard errors"
    local istat 0
    foreach stat in LB UB Category Cond {
        local elabel: word `++istat' of "lower CI bounds" "upper CI bounds" ///
            "outcome values" "conditional predictions"
        if "`swap'"=="" {
            foreach eq of local eqs {
                local colnumb = colnumb(`prvalue',`"`eq':`stat'"')
                if `colnumb'>=. continue
                mat `tmp2' = `prvalue'[1...,`colnumb']'
                mat coleq `tmp2' = `"`eq'"'
                mat roweq `tmp2' = ""
                mat `tmp' = nullmat(`tmp'), `tmp2'
            }
        }
        else {
            local icol: list posof "`stat'" in coln
            if `icol'==0 continue
            forv i=1/`r' {
                mat `tmp2' = `prvalue'[`i',1...]
                local labl : rownames `tmp2'
                mat coleq `tmp2' = `"`labl'"'
                forv j=`icol'(`ncol')`c' {
                    mat `tmp' = nullmat(`tmp'), `tmp2'[1...,`j']
                }
            }
            mat drop `tmp2'
        }
        capt confirm matrix `tmp'
        if _rc==0 {
            ereturn matrix `prefix'`stat' = `tmp'
            added_matrix `prefix'`stat' "`elabel'"
        }
    }

// return x-values
    matrix `prvalue_x' = `prvalue_x''
    ereturn matrix `prefix'X = `prvalue_x'
    added_matrix `prefix'X _rown
    if `hasx2' {
        matrix `prvalue_x2' = `prvalue_x2''
        ereturn matrix `prefix'X2 = `prvalue_x2'
        added_matrix `prefix'X2 _rown
    }

// store
    if "`post2'"!="" {
        _eststo `estname'`post2', `title'
        di as txt _n "results stored as " as res "`estname'`post2'"
    }
    else if `"`title'"'!="" {
        estimates change ., `title'
    }

// retore estimates
    if "`post2'"!="" {
        _est unhold `hcurrent'
    }
    else {
        _est unhold `hcurrent', not
    }
end

* 23.
* -estadd- subroutine: support for -asprvalue- by Long and Freese
* (see http://www.indiana.edu/~jslsoc/spost.htm)
program define estadd_asprvalue, eclass
    version 9.2
    local caller : di _caller()
    syntax [anything] [ , Prefix(passthru) Replace Quietly ///
        LABel(str) Title(passthru) swap * ]

// post
    if `"`anything'"'!="" {
        gettoken post post2 : anything
        if `"`post'"'!="post" {
            di as err `"`post' not allowed"'
            exit 198
        }
        else if `"`label'"'!="" {
            di as err "label() not allowed"
            exit 198
        }
        _estadd_asprvalue_Post `post2' , `prefix' `replace' `quietly' ///
            `title' `swap' `options'
        exit
    }
    else if `"`title'"'!="" {
        di as err "title() not allowed"
        exit 198
    }
    else if "`swap'"!="" {
        di as err "swap not allowed"
        exit 198
    }

// look for e(sample)
    confirm_esample

// run prvalue
    capt findfile asprvalue.ado
    if _rc {
        di as error "-asprvalue- from the -spost9_ado- package by Long and Freese required"
        di as error `"type {stata "net from http://www.indiana.edu/~jslsoc/stata"}"'
        error 499
    }
    `quietly' version `caller': asprvalue , `options'

// append?
    capture confirm existence `e(_estadd_asprval)'
    local append = (_rc==0) & ("`replace'"=="")
    tempname asprval asprval_asv asprval_csv
    if `append' {
        mat `asprval'          = e(_estadd_asprval)
        capt mat `asprval_asv' = e(_estadd_asprval_asv)
        capt mat `asprval_csv' = e(_estadd_asprval_csv)
        local ires = rowsof(`asprval') + 1
    }
    else local ires 1
    if `"`label'"'=="" {
        local label "pred`ires'"
    }
    else {
        local label = substr(`"`label'"', 1, 30)  // 30 characters max
        local problemchars `": . `"""'"'
        foreach char of local problemchars {
            local label: subinstr local label `"`char'"' "_", all
        }
    }

// collect results
    tempname res
    mat `res' = r(p)
    _estadd_asprvalue_Reshape `res', label(`label')
    _estadd_asprvalue_Add `asprval' `res' `append'
    capture confirm matrix r(asv)
    local hasasv = _rc==0
    if `hasasv' {
        mat `res' = r(asv)
        _estadd_asprvalue_Reshape `res', label(`label')
        _estadd_asprvalue_Add `asprval_asv' `res' `append'
    }
    capture confirm matrix r(csv)
    local hascsv = _rc==0
    if `hascsv' {
        _estadd_asprvalue_AddCsv `asprval_csv', label(`label')
    }

// post in e()
    di as txt _n cond(`append',"updated","added") " matrices:"
    ereturn matrix _estadd_asprval = `asprval'
    added_matrix _estadd_asprval
    if `hasasv' {
        ereturn matrix _estadd_asprval_asv = `asprval_asv'
        added_matrix _estadd_asprval_asv
    }
    if `hascsv' {
        ereturn matrix _estadd_asprval_csv = `asprval_csv'
        added_matrix _estadd_asprval_csv
    }
end
program _estadd_asprvalue_Reshape
    syntax anything, label(str)
    tempname tmp res
    local r = rowsof(`anything')
    forv i=1/`r' {
        mat `tmp' = `anything'[`i',1...]
        local nm: rownames `tmp'
        mat coleq `tmp' = `"`nm'"'
        mat `res' = nullmat(`res'), `tmp'
    }
    mat rown `res' = `"`label'"'
    mat `anything' = `res'
end
program _estadd_asprvalue_Add
    args master using append
    if `append' {
        local coln1: colfullnames `master'
        local coln2: colfullnames `using'
        if `"`coln1'"'!=`"`coln2'"' {
            di as err "incompatible asprvalue results"
            exit 498
        }
    }
    mat `master' = nullmat(`master') \ `using'
end
program _estadd_asprvalue_AddCsv
    syntax anything, label(str)
    tempname tmp
    mat `tmp' = r(csv)
    mat rown `tmp' = `"`label'"'
    mat `anything' = nullmat(`anything') \ `tmp'
end
program _estadd_asprvalue_Post, eclass
    syntax [name(name=post2)] [ , Prefix(name) Replace Quietly ///
        Title(passthru) swap ]
    capture confirm matrix e(_estadd_asprval)
    if _rc {
        di as err "asprvalue results not found"
        exit 498
    }

// backup estimates
    tempname hcurrent
    _est hold `hcurrent', copy restore estsystem
    local cmd = e(cmd)
    local depvar = e(depvar)
    local N = e(N)
    local estname `"`e(_estadd_estimates_name)'"'

// get results
    tempname asprval asprval_asv asprval_csv
    mat `asprval' = e(_estadd_asprval)
    capture confirm matrix e(_estadd_asprval_asv)
    local hasasv = _rc==0
    if `hasasv' {
        mat `asprval_asv' = e(_estadd_asprval_asv)
    }
    capture confirm matrix e(_estadd_asprval_csv)
    local hascsv = _rc==0
    if `hascsv' {
        mat `asprval_csv' = e(_estadd_asprval_csv)
    }

// return predictions
    tempname tmp tmp2 b
    if "`swap'"=="" {
        local eqs: coleq `asprval', q
        local eqs: list uniq eqs
        foreach eq of local eqs {
            mat `tmp' = `asprval'[1...,`"`eq':"']
            mat `tmp2' = `tmp'[1...,1]'
            mat coleq `tmp2' = `"`eq'"'
            mat roweq `tmp2' = ""
            mat `b' = nullmat(`b'), `tmp2'
        }
        mat drop `tmp' `tmp2'
    }
    else {
        local r = rowsof(`asprval')
        local coln: colnames `asprval'
        local eqs: coleq `asprval', q
        mat coln `asprval' = `eqs'
        forv i=1/`r' {
            mat `tmp' = `asprval'[`i',1...]
            local labl : rownames `tmp'
            mat coleq `tmp' = `"`labl'"'
            mat `b' = nullmat(`b'), `tmp'
        }
        mat drop `tmp'
    }
    ereturn post `b', obs(`N')
    ereturn local model "`cmd'"
    ereturn local cmd "estadd_asprvalue"
    ereturn local depvar "`depvar'"
    di as txt _n "scalars:"
    added_scalar N
    di as txt _n "macros:"
    added_macro depvar
    added_macro cmd
    added_macro model
    added_macro properties
    di as txt _n "matrices:"
    added_matrix b "predictions"

// return asv-values
    if `hasasv' {
        if "`swap'"=="" {
            local vars: coleq `asprval_asv'
            local vars: list uniq vars
            local cats: colnames `asprval_asv'
            local cats: list uniq cats
            foreach var of local vars {
                foreach cat of local cats {
                    mat `tmp2' = `asprval_asv'[1...,`"`var':`cat'"']'
                    mat coleq `tmp2' = `"`cat'"'
                    mat roweq `tmp2' = ""
                    mat `tmp' = nullmat(`tmp'), `tmp2'
                }
                mat rown `tmp' = `"`var'"'
                mat `b' = nullmat(`b') \ `tmp'
                mat drop `tmp'
            }
        }
        else {
            local r = rowsof(`asprval_asv')
            local vars: coleq `asprval_asv'
            local vars: list uniq vars
            forv i=1/`r' {
                foreach var of local vars {
                    mat `tmp2' = `asprval_asv'[`i',`"`var':"']
                    local lbl: rownames `tmp2'
                    mat coleq `tmp2' = `"`lbl'"'
                    mat rown `tmp2' = `"`var'"'
                    mat `tmp' = nullmat(`tmp') \ `tmp2'
                }
                mat `b' = nullmat(`b') , `tmp'
                mat drop `tmp'
            }
        }
        ereturn matrix `prefix'asv = `b'
        added_matrix `prefix'asv _rown
    }
// return csv-values
    if `hascsv' {
        matrix `asprval_csv' = `asprval_csv''
        ereturn matrix `prefix'csv = `asprval_csv'
        added_matrix `prefix'csv _rown
    }

// store
    if "`post2'"!="" {
        _eststo `estname'`post2', `title'
        di as txt _n "results stored as " as res "`estname'`post2'"
    }
    else if `"`title'"'!="" {
        estimates change ., `title'
    }

// retore estimates
    if "`post2'"!="" {
        _est unhold `hcurrent'
    }
    else {
        _est unhold `hcurrent', not
    }
end

* 24. estadd_margins
program define estadd_margins, eclass
    version 11.0
    local caller : di _caller()
    syntax [ anything(everything equalok)] [fw aw iw pw] [, Prefix(name) Replace Quietly * ]

// set default prefix
    if "`prefix'"=="" local prefix "margins_"

// compute and return the results
    if `"`weight'`exp'"'!="" local wgtexp `"[`weight'`exp']"'
    `quietly' version `caller': margins `anything' `wgtexp', `options'

// check names
    local rscalars: r(scalars)
    local rmacros: r(macros)
    local rmatrices: r(matrices)
    local rmatrices: subinstr local rmatrices "V" "se", word
    if "`replace'"=="" {
        foreach nmlist in rscalars rmacros rmatrices  {
            foreach name of local `nmlist' {
                confirm_new_ename `prefix'`name'
            }
        }
    }

// add results
    di as txt _n "added scalars:"
    foreach name of local rscalars {
        ereturn scalar `prefix'`name' = r(`name')
        added_scalar `prefix'`name'
    }
    di as txt _n "added macros:"
    foreach name of local rmacros {
        ereturn local `prefix'`name' `"`r(`name')'"'
        added_macro `prefix'`name'
    }
    di as txt _n "added matrices:"
    tempname tmpmat
    foreach name of local rmatrices {
        if "`name'"=="se" {
            mat `tmpmat' = vecdiag(r(V))
            forv i = 1/`=colsof(`tmpmat')' {
                mat `tmpmat'[1,`i'] = sqrt(`tmpmat'[1,`i'])
            }
        }
        else {
            mat `tmpmat' = r(`name')
        }
        eret matrix `prefix'`name' = `tmpmat'
        added_matrix `prefix'`name'
    }
end

* 99.
* copy of erepost.ado, version 1.0.1, Ben Jann, 30jul2007
* used by estadd_listcoef and estadd_prchange
prog erepost, eclass
    version 8.2
    syntax [anything(equalok)] [, cmd(str) noEsample Esample2(varname) REName ///
        Obs(passthru) Dof(passthru) PROPerties(passthru) * ]
    if "`esample'"!="" & "`esample2'"!="" {
        di as err "only one allowed of noesample and esample()"
        exit 198
    }
// parse [b = b] [V = V]
    if `"`anything'"'!="" {
        tokenize `"`anything'"', parse(" =")
        if `"`7'"'!="" error 198
        if `"`1'"'=="b" {
            if `"`2'"'=="=" & `"`3'"'!="" {
                local b `"`3'"'
                confirm matrix `b'
            }
            else error 198
            if `"`4'"'=="V" {
                if `"`5'"'=="=" & `"`6'"'!="" {
                    local v `"`6'"'
                    confirm matrix `b'
                }
                else error 198
            }
            else if `"`4'"'!="" error 198
        }
        else if `"`1'"'=="V" {
            if `"`4'"'!="" error 198
            if `"`2'"'=="=" & `"`3'"'!="" {
                local v `"`3'"'
                confirm matrix `v'
            }
            else error 198
        }
        else error 198
    }
//backup existing e()'s
    if "`esample2'"!="" {
        local sample "`esample2'"
    }
    else if "`esample'"=="" {
        tempvar sample
        gen byte `sample' = e(sample)
    }
    local emacros: e(macros)
    if `"`properties'"'!="" {
        local emacros: subinstr local emacros "properties" "", word
    }
    foreach emacro of local emacros {
        local e_`emacro' `"`e(`emacro')'"'
    }
    local escalars: e(scalars)
    if `"`obs'"'!="" {
        local escalars: subinstr local escalars "N" "", word
    }
    if `"`dof'"'!="" {
        local escalars: subinstr local escalars "df_r" "", word
    }
    foreach escalar of local escalars {
        tempname e_`escalar'
        scalar `e_`escalar'' = e(`escalar')
    }
    local ematrices: e(matrices)
    if "`b'"=="" & `:list posof "b" in ematrices' {
        tempname b
        mat `b' = e(b)
    }
    if "`v'"=="" & `:list posof "V" in ematrices' {
        tempname v
        mat `v' = e(V)
    }
    local bV "b V"
    local ematrices: list ematrices - bV
    foreach ematrix of local ematrices {
        tempname e_`ematrix'
        matrix `e_`ematrix'' = e(`ematrix')
    }
// rename
    if "`b'"!="" & "`v'"!="" & "`rename'"!="" {
        local eqnames: coleq `b', q
        local vnames: colnames `b'
        mat coleq `v' = `eqnames'
        mat coln `v' = `vnames'
        mat roweq `v' = `eqnames'
        mat rown `v' = `vnames'
    }
// post results
    if "`esample'"=="" {
        eret post `b' `v', esample(`sample') `obs' `dof' `properties' `options'
    }
    else {
        eret post `b' `v', `obs' `dof' `properties' `options'
    }
    foreach emacro of local emacros {
        eret local `emacro' `"`e_`emacro''"'
    }
    if `"`cmd'"'!="" {
        eret local cmd `"`cmd'"'
    }
    foreach escalar of local escalars {
        eret scalar `escalar' = scalar(`e_`escalar'')
    }
    foreach ematrix of local ematrices {
        eret matrix `ematrix' = `e_`ematrix''
    }
end
