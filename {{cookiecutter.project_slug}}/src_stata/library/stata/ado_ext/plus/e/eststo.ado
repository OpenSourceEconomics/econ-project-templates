*! version 1.1.0  05nov2008  Ben Jann

program define eststo, byable(onecall)
    version 8.2
    local caller : di _caller()
// --- eststo clear ---
    if `"`1'"'=="clear" {
        if `"`0'"'!="clear" {
            di as err "invalid syntax"
            exit 198
        }
        if "`_byvars'"!="" error 190
        _eststo_clear
        exit
    }
// --- update globals ---
    _eststo_cleanglobal
// --- eststo dir ---
    if `"`1'"'=="dir" {
        if `"`0'"'!="dir" {
            di as err "invalid syntax"
            exit 198
        }
        if "`_byvars'"!="" error 190
        _eststo_dir
        exit
    }
// --- eststo drop ---
    if `"`1'"'=="drop" {
        if "`_byvars'"!="" error 190
        _eststo_`0'
        exit
    }
// --- eststo store (no by) ---
    if "`_byvars'"=="" {
        version `caller': _eststo_store `0'
        exit
    }
// --- eststo store (by) ---
// - check sorting
    local sortedby : sortedby
    local i 0
    foreach byvar of local _byvars {
        local sortedbyi : word `++i' of `sortedby'
        if "`byvar'"!="`sortedbyi'" error 5
    }
// - parse command on if qualified
    capt _on_colon_parse `0'
    if _rc error 190
    if `"`s(after)'"'=="" error 190
    local estcom `"`s(after)'"'
    local 0 `"`s(before)'"'
    if substr(trim(`"`estcom'"'),1,3)=="svy" {
        di as err "svy commands not allowed with by ...: eststo:"
        exit 190
    }
    AddBygrpToIfqualifier `estcom'
// - parse syntax of _eststo_store call in order to determine
//   whether title() or missing was specified (note that
//   -estimates change- cannot be used to set the titles since
//   it does not work with -noesample-)
    TitleAndMissing `0'
// - generate byindex
    tempname _byindex
    qui egen long `_byindex' = group(`_byvars'), label `missing'
    qui su `_byindex', meanonly
    if r(N)==0 error 2000
    local Nby = r(max)
// - loop over bygroups
    forv i = 1/`Nby' {
        local ibylab: label (`_byindex') `i'
        di as txt _n "{hline}"
        di as txt `"-> `ibylab'"'   // could be improved
        if `titleopt'==0 local ibytitle
        else if `titleopt'==1 local ibytitle `" title(`ibylab')"'
        else if `titleopt'==2 local ibytitle `", title(`ibylab')"'
        capture noisily {
            version `caller': _eststo_store `0'`ibytitle' : `estcmd'
        }
        if _rc {
            if "`_byrc0'"=="" error _rc
        }
    }
end

prog TitleAndMissing
    capt syntax [anything] , Title(string) [ MISsing * ]
    if _rc==0 {
        c_local titleopt 0
        c_local missing "`missing'"
    }
    else {
        syntax [anything] [ , MISsing * ]
        if `"`missing'`options'"'!="" c_local titleopt 1
        else c_local titleopt 2
        c_local missing "`missing'"
    }
end

program AddBygrpToIfqualifier
    syntax anything(equalok) [if/] [in] [using] [fw aw pw iw] [, * ]
    local estcom `"`macval(anything)' if (\`_byindex'==\`i')"'
    if `"`macval(if)'"'!="" {
        local estcom `"`macval(estcom)' & (`macval(if)')"'
    }
    if `"`macval(in)'"'!="" {
        local estcom `"`macval(estcom)' `macval(in)'"'
    }
    if `"`macval(using)'"'!="" {
        local estcom `"`macval(estcom)' `macval(using)'"'
    }
    if `"`macval(weight)'"'!="" {
        local estcom `"`macval(estcom)' [`macval(weight)'`macval(exp)']"'
    }
    if `"`macval(options)'"'!="" {
        local estcom `"`macval(estcom)', `macval(options)'"'
    }
    c_local estcmd `"`macval(estcom)'"'
end

program define _eststo_clear
    local names $eststo
    foreach name of local names {
        capt estimates drop `name'
    }
    global eststo
    global eststo_counter
end

program define _eststo_dir
    if `"$eststo"'!="" {
        estimates dir $eststo
    }
end

program define _eststo_cleanglobal
    local enames $eststo
    if `"`enames'"'!="" {
        tempname hcurrent
        _return hold `hcurrent'
        qui _estimates dir
        local snames `r(names)'
        _return restore `hcurrent'
    }
    local names: list enames & snames
    global eststo `names'
    if "`names'"=="" global eststo_counter
end

program define _eststo_drop
    local droplist `0'
    if `"`droplist'"'=="" {
        di as error "someting required"
        exit 198
    }
    local names $eststo
    foreach item of local droplist {
        capt confirm integer number `item'
        if _rc {
            local dropname `item'
        }
        else {
            if `item'<1 {
                di as error "`item' not allowed"
                exit 198
            }
            local dropname est`item'
        }
        local found 0
        foreach name in `names' {
            if match("`name'",`"`dropname'"') {
                local found 1
                estimates drop `name'
                local names: list names - name
                di as txt "(" as res "`name'" as txt " dropped)"
            }
        }
        if `found'==0 {
            di as txt "(no matches found for " as res `"`dropname'"' as txt ")"
        }
    }
    global eststo `names'
end


program define _eststo_store, eclass
    local caller : di _caller()
    capt _on_colon_parse `0'
    if !_rc {
        local command `"`s(after)'"'
        local 0 `"`s(before)'"'
    }
    syntax [name] [, ///
        Title(passthru) ///
        Prefix(name) ///
        Refresh Refresh2(numlist integer max=1 >0) ///
        ADDscalars(string asis) ///
        noEsample ///
        noCopy ///
        MISsing svy /// doesn't do anything
        ]
    if `"`prefix'"'=="" local prefix "est"

// get previous eststo names and counter
    local names $eststo
    local counter $eststo_counter
    if `"`counter'"'=="" local counter 0

// if name provided; set refresh on if name already in list
    if "`namelist'"!="" {
        if "`refresh2'"!="" {
            di as error "refresh() not allowed"
            exit 198
        }
        local name `namelist'
        if `:list name in names' local refresh refresh
        else {
            if "`refresh'"!="" {
                di as txt "(" as res "`name'" as txt " not found)"
            }
            local refresh
        }
        if "`refresh'"=="" local ++counter
    }
// if no name provided
    else {
        if "`refresh2'"!="" local refresh refresh
        if "`refresh'"!="" {
// refresh2 not provided => refresh last (if available)
            if "`refresh2'"=="" {
                if "`names'"=="" {
                    di as txt "(nothing to refresh)"
                    local refresh
                }
                else local name: word `:list sizeof names' of `names'
            }
// refresh2 provided => check availability
            else {
                if `:list posof "`prefix'`refresh2'" in names' {
                    local name `prefix'`refresh2'
                }
                else {
                    di as txt "(" as res "`prefix'`refresh2'" as txt " not found)"
                    local refresh
                }
            }
        }
        if "`refresh'"=="" local ++counter
// set default name
        if "`name'"=="" local name `prefix'`counter'
    }

// run estimation command if provided
    if `"`command'"'!="" {
        version `caller': `command'
    }

// add scalars to e()
    if `"`addscalars'"'!="" {
        capt ParseAddscalars `addscalars'
        if _rc {
            di as err `"addscalars() invalid"'
            exit 198
        }
        if "`replace'"=="" {
            local elist `: e(scalars)' `: e(macros)' `: e(matrices)' `: e(functions)'
        }
        local forbidden b V sample
        while (1) {
            gettoken lhs rest: rest
            if `:list lhs in forbidden' {
                di as err `"`lhs' not allowed in addscalars()"'
                exit 198
            }
            if "`replace'"=="" {
                if `:list lhs in elist' {
                    di as err `"e(`lhs') already defined"'
                    exit 110
                }
            }
            gettoken rhs rest: rest, bind
            capt eret scalar `lhs' = `rhs'
            if _rc {
                di as err `"addscalars() invalid"'
                exit 198
            }
            capture local result = e(`lhs')
            di as txt "(e(" as res `"`lhs'"' as txt ") = " ///
             as res `result' as txt " added)"
            if `"`rest'"'=="" continue, break
        }
    }
// add e(cmd) if missing
    if `"`e(cmd)'"'=="" {
        if `"`: e(scalars)'`: e(macros)'`: e(matrices)'`: e(functions)'"'!="" {
            eret local cmd "."
        }
    }

// store estimates with e(sample)
    estimates store `name' , `copy' `title'

// remove e(sample) if -noesample- specified
    if "`esample'"!="" {
        capt confirm new var _est_`name'
        if _rc {
            tempname hcurrent
            _est hold `hcurrent', restore estsystem nullok
            qui replace _est_`name' = . in 1
            _est unhold `name'
            capt confirm new var _est_`name'
            if _rc qui drop _est_`name'
            else {
                di as error "somethings wrong; please contact author of -eststo- " ///
                 "(see e-mail in help {help eststo})"
                exit 498
            }
            _est hold `name', estimates varname(_est_`name')
                // varname() only needed so that _est hold does not return error
                // if variable `name' exists
        }
    }

// report
    if "`refresh'"=="" {
        global eststo `names' `name'
        global eststo_counter `counter'
        if `"`namelist'"'=="" {
            di as txt "(" as res "`name'" as txt " stored)"
        }
    }
    else {
        if `"`namelist'"'=="" {
            di as txt "(" as res "`name'" as txt " refreshed)"
        }
    }
end

program ParseAddscalars
    syntax anything [ , Replace ]
    c_local rest `"`anything'"'
    c_local replace `replace'
end
