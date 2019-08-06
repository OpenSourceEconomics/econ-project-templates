*! version 3.17  02jun2014  Ben Jann

program define estout, rclass
    version 8.2
    return local cmdline estout `macval(0)'
    syntax [anything] [using] [ , ///
        Cells(string asis) ///
        Drop(string asis)  ///
        Keep(string asis) ///
        Order(string asis) ///
        REName(passthru) ///
        Indicate(string asis) ///
        TRansform(string asis) ///
        EQuations(passthru) ///
        EFORM2(string) ///
        Margin2(string) ///
        DIscrete(string asis) ///
        MEQs(string) ///
        DROPPED2(string) ///
        level(numlist max=1 int >=10 <=99) ///
        Stats(string asis) ///
        STARLevels(string asis) ///
        STARKeep(string asis) ///
        STARDrop(string asis) ///
        VARwidth(numlist max=1 int >=0) ///
        MODELwidth(numlist int >=0) ///
        EXTRAcols(numlist sort) ///
        BEGin(string asis) ///
        DELimiter(string asis) ///
        INCELLdelimiter(string asis) ///
        end(string asis) ///
        DMarker(string) ///
        MSign(string) ///
        SUBstitute(string asis) ///
        INTERACTion(string asis) ///
        TItle(string) ///
        note(string) ///
        PREHead(string asis) ///
        POSTHead(string asis) ///
        PREFoot(string asis) ///
        POSTFoot(string asis) ///
        HLinechar(string) ///
        VARLabels(string asis) ///
        REFcat(string asis) ///
        MLabels(string asis) ///
        NUMbers2(string asis) ///
        COLLabels(string asis) ///
        EQLabels(string asis) ///
        MGRoups(string asis) ///
        LABCOL2(string asis) ///
        TOPfile(string) ///
        BOTtomfile(string) ///
        STYle(string) ///
        DEFaults(string) ///
        * ///
        ]
    MoreOptions, `options'
    if "`style'"!="" local defaults "`style'"

*Matrix mode
    MatrixMode, `anything' `rename' // resets the cells argument
        // and returns r(coefs) etc. and local 'matrixmode'

*Parse suboptions
    local elnum 0
    if `"`cells'"'!="none" {
        gettoken row rest: cells, bind match(par) qed(qed)
        if `"`par'"'=="(" local qed 1
        local cells
        while `"`row'"'!="" {
            local newrow
            gettoken opt row: row, parse(" ([&")
            if `"`macval(row)'"'=="" & `qed'==0 {
                local row0
                gettoken trash: rest, parse("[")
                if `"`trash'"'=="[" {
                    gettoken trash rest: rest, parse("[")
                    gettoken mrow rest: rest, parse("]") q
                    gettoken trash rest: rest, parse("]")
                    if `"`trash'"'!="]" {
                        error 198
                    }
                }
                gettoken trash: rest, match(par)
                if `"`par'"'=="(" {
                    gettoken opt2 rest: rest, match(par)
                }
                else local opt2
            }
            else {
                gettoken trash: row, parse("[")
                if `"`trash'"'=="[" {
                    gettoken trash row: row, parse("[")
                    gettoken mrow row: row, parse("]") q
                    gettoken trash row: row, parse("]")
                    if `"`trash'"'!="]" {
                        error 198
                    }
                }
                gettoken trash row0: row, match(par)
                gettoken opt2: row, match(par)
            }
            while "`opt'"!="" {
                if "`opt'"!="&" & "`opt'"!="." {
                    local `opt'_tname "el`++elnum'"
                    local ``opt'_tname'_ "`opt'"
                    local newrow `"`newrow' ``opt'_tname'"'
                    if `"`par'"'!="(" local opt2
                    ParseValueSubopts ``opt'_tname' `opt', mrow(`mrow') `macval(opt2)'
                    local mrow
                }
                else {
                    if `"`par'"'=="(" | `"`mrow'"'!="" error 198
                    local newrow `"`newrow' `opt'"'
                }
                if `"`par'"'!="(" {
                    gettoken opt row: row, parse(" ([&")
                }
                else {
                    gettoken opt row: row0, parse(" ([&")
                }
                gettoken trash: row, parse("[")
                if `"`trash'"'=="[" {
                    gettoken trash row: row, parse("[")
                    gettoken mrow row: row, parse("]") q
                    gettoken trash row: row, parse("]")
                    if `"`trash'"'!="]" {
                        error 198
                    }
                }
                gettoken trash row0: row, match(par)
                gettoken opt2: row, match(par)
            }
            local newrow: list retok newrow
            if `qed' local cells `"`cells'"`newrow'" "'
            else local cells `"`cells'`newrow' "'
            gettoken row rest: rest, bind match(par) qed(qed)
            if `"`par'"'=="(" local qed 1
        }
        local cells: list retok cells
    }
    if "`eform2'"!="" {
        local eform "`eform2'"
        local eform2
    }
    if `"`transform'"'!="" {
        ParseTransformSubopts `transform'
    }
    if "`margin2'"!="" {
        local margin "`margin2'"
        local margin2
    }
    if `"`dropped'"'!="" local dropped "(dropped)"
    if `"`macval(dropped2)'"'!="" {
        local dropped `"`macval(dropped2)'"'
        local dropped2
    }
    if `"`macval(stats)'"'!="" {
        ParseStatsSubopts `macval(stats)'
        if `"`macval(statslabels)'"'!="" {
            if trim(`"`statslabels'"')=="none" {
                local statslabelsnone none
                local statslabels
            }
            else {
                ParseLabelsSubopts statslabels `macval(statslabels)'
            }
        }
    }
    foreach opt in mgroups mlabels eqlabels collabels varlabels {
        if `"`macval(`opt')'"'!="" {
            if trim(`"``opt''"')=="none" {
                local `opt'none none
                local `opt'
            }
            else {
                ParseLabelsSubopts `opt' `macval(`opt')'
            }
        }
    }
    if `"`macval(numbers2)'"'!="" {
        local numbers `"`macval(numbers2)'"'
        local numbers2
    }
    if `"`macval(indicate)'"'!="" {
        ParseIndicateOpts `macval(indicate)'
    }
    if `"`macval(refcat)'"'!="" {
        ParseRefcatOpts `macval(refcat)'
    }
    if `"`macval(starlevels)'"'!="" {
        ParseStarlevels `macval(starlevels)'
    }
    if `"`macval(labcol2)'"'!="" {
        ParseLabCol2 `macval(labcol2)'
    }

*Process No-Options
    foreach opt in unstack eform margin dropped discrete stardetach wrap ///
     legend label refcatlabel numbers lz abbrev replace append type showtabs ///
     smcltags smclrules smclmidrules smcleqrules asis outfilenoteoff ///
     omitted baselevels {
        if "`no`opt''"!="" local `opt'
    }

*Defaults
    if "`defaults'"=="esttab"               local defaults "tab"
    if "`defaults'"=="" & `"`using'"'==""   local defaults "smcl"
    if inlist("`defaults'", "", "smcl", "tab", "fixed", "tex", "html","mmd")  {
        local varwidthfactor = (1 + ("`eqlabelsmerge'"!="" & "`unstack'"=="")*.5)
        if inlist("`defaults'", "", "tab") {
            if `"`macval(delimiter)'"'==""   local delimiter _tab
            if `"`macval(interaction)'"'=="" local interaction `"" # ""'
        }
        else if "`defaults'"=="smcl" {
            if "`varwidth'"==""              local varwidth = cond("`label'"=="", 12, 20) * `varwidthfactor'
            if "`modelwidth'"==""            local modelwidth 12
            if "`noabbrev'"==""              local abbrev abbrev
            if `"`macval(delimiter)'"'==""   local delimiter `"" ""'
            if "`nosmcltags'"==""            local smcltags smcltags
            if "`nosmclrules'"==""           local smclrules smclrules
            if "`asis'"==""                  local noasis noasis
            if `"`macval(interaction)'"'=="" local interaction `"" # ""'
        }
        else if "`defaults'"=="fixed" {
            if "`varwidth'"==""              local varwidth = cond("`label'"=="", 12, 20) * `varwidthfactor'
            if "`modelwidth'"==""            local modelwidth 12
            if "`noabbrev'"==""              local abbrev abbrev
            if `"`macval(delimiter)'"'==""   local delimiter `"" ""'
            if `"`macval(interaction)'"'=="" local interaction `"" # ""'
        }
        else if "`defaults'"=="tex" {
            if "`varwidth'"==""              local varwidth = cond("`label'"=="", 12, 20) * `varwidthfactor'
            if "`modelwidth'"==""            local modelwidth 12
            if `"`macval(delimiter)'"'==""   local delimiter &
            if `"`macval(end)'"'=="" {
                local end \\\
            }
            if `"`macval(interaction)'"'=="" local interaction `"" $\times$ ""'
        }
        else if "`defaults'"=="html" {
            if "`varwidth'"==""              local varwidth = cond("`label'"=="", 12, 20) * `varwidthfactor'
            if "`modelwidth'"==""            local modelwidth 12
            if `"`macval(begin)'"'==""       local begin <tr><td>
            if `"`macval(delimiter)'"'==""   local delimiter </td><td>
            if `"`macval(end)'"'==""         local end </td></tr>
            if `"`macval(interaction)'"'=="" local interaction `"" # ""'
        }
        else if "`defaults'"=="mmd" {
            if "`varwidth'"==""              local varwidth = cond("`label'"=="", 12, 20) * `varwidthfactor'
            if "`modelwidth'"==""            local modelwidth 12
            if `"`macval(begin)'"'==""       local begin "| "
            if `"`macval(delimiter)'"'==""   local delimiter " | "
            if `"`macval(end)'"'==""         local end " |"
            if `"`macval(interaction)'"'=="" local interaction `"" # ""'
        }
        if "`nostatslabelsfirst'"=="" local statslabelsfirst first
        if "`nostatslabelslast'"==""  local statslabelslast last
        if "`novarlabelsfirst'"==""   local varlabelsfirst first
        if "`novarlabelslast'"==""    local varlabelslast last
        if "`noeqlabelsfirst'"==""    local eqlabelsfirst first
        if "`noeqlabelslast'"==""     local eqlabelslast last
        if "`nolz'"==""               local lz lz
        if `"`macval(discrete)'"'=="" & "`nodiscrete'"=="" {
            local discrete `"" (d)" for discrete change of dummy variable from 0 to 1"'
        }
        if `"`macval(indicatelabels)'"'=="" local indicatelabels "Yes No"
        if `"`macval(refcatlabel)'"'=="" & "`norefcatlabel'"==""    local refcatlabel "ref."
        if `"`macval(incelldelimiter)'"'=="" local incelldelimiter " "
        if "`noomitted'"==""          local omitted omitted
        if "`nobaselevels'"==""       local baselevels baselevels
    }
    else {
        capture findfile estout_`defaults'.def
        if _rc {
            di as error `"`defaults' style not available "' ///
             `"(file estout_`defaults'.def not found)"'
            exit 601
        }
        else {
            tempname file
            file open `file' using `"`r(fn)'"', read text
            if c(SE) local max 244
            else local max 80
            while 1 {
                ReadLine `max' `file'
                if `"`line'"'=="" continue, break
                gettoken opt line: line
                else if index(`"`opt'"',"_") {
                    gettoken opt0 opt1: opt, parse("_")
                    if `"``opt0'_tname'"'!="" {
                        local opt `"``opt0'_tname'`opt1'"'
                    }
                }
                if `"`macval(`opt')'"'=="" & `"`no`opt''"'=="" {
                    if `"`opt'"'=="cells" {
                        local newline
                        gettoken row rest: line, match(par) qed(qed)
                        if `"`par'"'=="(" local qed 1
                        while `"`row'"'!="" {
                            local newrow
                            gettoken el row: row, parse(" &")
                            while `"`el'"'!="" {
                                if `"`el'"'!="." & `"`el'"'!="&" {
                                    local `el'_tname "el`++elnum'"
                                    local ``el'_tname'_ "`el'"
                                    local newrow "`newrow' ``el'_tname'"
                                }
                                else {
                                    local newrow "`newrow' `el'"
                                }
                                gettoken el row: row, parse(" &")
                            }
                            local newrow: list retok newrow
                            if `qed' local newline `"`newline'"`newrow'" "'
                            else local newline `"`newline'`newrow' "'
                            gettoken row rest: rest, match(par) qed(qed)
                            if `"`par'"'=="(" local qed 1
                        }
                        local line `"`newline'"'
                    }
                    local line: list retok line
                    local `opt' `"`macval(line)'"'
                }
            }
            file close `file'
        }
    }
    if "`notype'"=="" & `"`using'"'=="" local type type
    if "`smcltags'"=="" & "`noasis'"=="" local asis asis
    if "`asis'"!="" local asis "_asis"
    if "`smclrules'"!="" & "`nosmclmidrules'"=="" local smclmidrules smclmidrules
    if "`smclmidrules'"!="" & "`nosmcleqrules'"=="" local smcleqrules smcleqrules
    local haslabcol2 = (`"`macval(labcol2)'"'!="")

*title/notes option
    if `"`macval(prehead)'`macval(posthead)'`macval(prefoot)'`macval(postfoot)'"'=="" {
        if `"`macval(title)'"'!="" {
            local prehead `"`"`macval(title)'"'"'
        }
        if `"`macval(note)'"'!="" {
            local postfoot `"`"`macval(note)'"'"'
        }
    }

*Generate/clean-up cell contents
    if `"`:list clean cells'"'=="" {
        local cells b
        local b_tname "b"
        local b_ "b"
    }
    else if `"`:list clean cells'"'=="none" {
        local cells
    }
    CellsCheck `"`cells'"'
    if `:list sizeof incelldelimiter'==1 gettoken incelldelimiter: incelldelimiter

*Special treatment of confidence intervalls
    if "`level'"=="" local level $S_level
    if `level'<10 | `level'>99 {
        di as error "level(`level') invalid"
        exit 198
    }
    if "`ci_tname'"!="" {
        if `"`macval(`ci_tname'_label)'"'=="" {
            local `ci_tname'_label "ci`level'"
        }
        if `"`macval(`ci_tname'_par)'"'=="" {
            local `ci_tname'_par `""" , """'
        }
        gettoken 1 2 : `ci_tname'_par
        gettoken 2 3 : 2
        gettoken 3 : 3
        local `ci_tname'_l_par `""`macval(1)'" "`macval(2)'""'
        local `ci_tname'_u_par `""" "`macval(3)'""'
    }
    if "`ci_l_tname'"!="" {
        if `"`macval(`ci_l_tname'_label)'"'=="" {
            local `ci_l_tname'_label "min`level'"
        }
    }
    if "`ci_u_tname'"!="" {
        if `"`macval(`ci_u_tname'_label)'"'=="" {
            local `ci_u_tname'_label "max`level'"
        }
    }

*Formats
    local firstv: word 1 of `values'
    if "`firstv'"=="" local firstv "b"
    if "``firstv'_fmt'"=="" local `firstv'_fmt %9.0g
    foreach v of local values {
        if "``v'_fmt'"=="" local `v'_fmt "``firstv'_fmt'"
        if `"`macval(`v'_label)'"'=="" {
            local `v'_label "``v'_'"
        }
    }

*Check margin option / prepare discrete option / prepare dropped option
    if "`margin'"!="" {
        if !inlist("`margin'","margin","u","c","p") {
            di as error "margin(`margin') invalid"
            exit 198
        }
        if `"`macval(discrete)'"'!="" {
            gettoken discrete discrete2: discrete
        }
    }
    else local discrete
    local droppedison = (`"`macval(dropped)'"'!="")

*Formats/labels/stars for statistics
    if "`statsfmt'"=="" local statsfmt: word 1 of ``firstv'_fmt'
    ProcessStatslayout `"`stats'"' `"`statsfmt'"' `"`statsstar'"' ///
     `"`statslayout'"' `"`statspchar'"'
    local stats: list uniq stats
    if "`statsstar'"!="" local p " p"
    else local p

*Significance stars
    local tablehasstars 0
    foreach v of local values {
        local el "``v'_'"
        if "``v'_star'"!="" | inlist("`el'","_star","_sigsign") {
            if "``v'_pvalue'"=="" local `v'_pvalue p
            local tablehasstars 1
        }
    }

*Check/define starlevels/make levelslegend
    if `tablehasstars' | `"`statsstar'"'!="" {
        if `"`macval(starlevels)'"'=="" ///
         local starlevels "* 0.05 ** 0.01 *** 0.001"
        CheckStarvals `"`macval(starlevels)'"' `"`macval(starlevelslabel)'"' ///
         `"`macval(starlevelsdelimiter)'"'
    }

*Get coefficients/variances/statistics: _estout_getres
*   - prepare transform/eform
    if `"`transform'"'=="" {  // transform() overwrites eform()
        if "`eform'"!="" {
            local transform "exp(@) exp(@)"
            if "`eform'"!="eform" {
                local transformpattern "`eform'"
            }
        }
    }
    foreach m of local transformpattern {
        if !( "`m'"=="1" | "`m'"=="0" ) {
            di as error "invalid pattern in transform(,pattern()) or eform()"
            exit 198
        }
    }
*   - handle pvalue() suboption
    if `tablehasstars' {
        local temp
        foreach v of local values {
            local temp: list temp | `v'_pvalue
        }
        foreach v of local temp {
            if `"``v'_tname'"'=="" {
                local `v'_tname "el`++elnum'"
                local ``v'_tname'_ "`v'"
                local values: list values | `v'_tname
            }
        }
    }
*   - prepare list of results to get from e()-matrices
    if "`ci_tname'"!="" {
        local values: subinstr local values "`ci_tname'" "`ci_tname'_l `ci_tname'_u", word
        local `ci_tname'_l_ "ci_l"
        local ci_l_tname "`ci_tname'_l"
        local `ci_tname'_u_ ci_u
        local ci_u_tname "`ci_tname'_u"
    }
    foreach v of local values {
        local temp = ("``v'_transpose'"!="")
        local values1mrow `"`values1mrow' `"``v'_' `temp' ``v'_mrow'"'"'
    }
    tempname B D St
    if `matrixmode'==0 {
*   - expand model names
        if `"`anything'"'=="" {
            capt est_expand $eststo
            if !_rc {
                local anything `"$eststo"'
            }
        }
        if `"`anything'"'=="" local anything "."
        capt est_expand `"`anything'"'
        if _rc {
            if _rc==301 {  // add e(cmd)="." to current estimates if undefined
                if `:list posof "." in anything' & `"`e(cmd)'"'=="" {
                    if `"`: e(scalars)'`: e(macros)'`: e(matrices)'`: e(functions)'"'!="" {
                        qui estadd local cmd "."
                    }
                }
            }
            est_expand `"`anything'"'
        }
        local models `r(names)'
        // could not happen, ...
        if "`models'" == "" {
            exit
        }
*   - get results
        local temp names(`models') coefs(`values1mrow') stats(`stats'`p') ///
            `rename' margin(`margin') meqs(`meqs') dropped(`droppedison') level(`level') ///
            transform(`transform') transformpattern(`transformpattern') ///
            `omitted' `baselevels'
        _estout_getres, `equations' `temp'
        local ccols = r(ccols)
        if `"`equations'"'=="" & "`unstack'"=="" & `ccols'>0 { // specify equations("") to deactivate
            TableIsAMess
            if `value' {
                _estout_getres, equations(main=1) `temp'
            }
        }
        mat `St' = r(stats)
    }
    else { // matrix mode
        local models `r(names)'
        // define `St' so that code does not break
        if `"`stats'"'!="" {
            mat `St' = J(`:list sizeof stats',1,.z)
            mat coln `St' = `models'
            mat rown `St' = `stats'
        }
    }
    local nmodels = r(nmodels)
    local ccols = r(ccols)
    if `ccols'>0 {
        mat `B'  = r(coefs)
    }
    return add
*   - process order() option
    if `"`order'"' != "" {
        ExpandEqVarlist `"`order'"' `B' append
        local order `"`value'"'
        Order `B' `"`order'"'
    }
*   - process indicate() option
    local nindicate 0
    foreach indi of local indicate {
        local ++nindicate
        ProcessIndicateGrp `nindicate' `B' `nmodels' "`unstack'" ///
        `"`macval(indicatelabels)'"' `"`macval(indi)'"'
    }
*   - process keep() option
    if `"`keep'"' != "" {
        ExpandEqVarlist `"`keep'"' `B'
        DropOrKeep 1 `B' `"`value'"'
    }
*   - process drop() option
    if `"`drop'"' != "" {
        ExpandEqVarlist `"`drop'"' `B'
        DropOrKeep 0 `B' `"`value'"'
    }

*   - names and equations of final set
    capt confirm matrix `B'
    if _rc {
        return local coefs  ""  // erase r(coefs)
        return local ccols  ""
        local R 0
        local varlist       ""
        local eqlist        ""
        local eqs           "_"
        local fullvarlist   ""
    }
    else {
        return matrix coefs = `B', copy // replace r(coefs)
        local R = rowsof(`B')
        local C = colsof(`B')
        QuotedRowNames `B'
        local varlist `"`value'"'
        local eqlist: roweq `B', q
        local eqlist: list clean eqlist
        UniqEqsAndDims `"`eqlist'"'
        MakeQuotedFullnames `"`varlist'"' `"`eqlist'"'
        local fullvarlist `"`value'"'
*   - dropped coefs
        local droppedpos = `ccols'
        if "`margin'"!="" {
            local droppedpos `droppedpos' - 1
        }
*   - 0/1-variable indicators (for marginals)
        mat `D' = `B'[1...,1], J(`R',1,0)  // so that row names are copied from `B'
        mat `D' = `D'[1...,2]
        if "`margin'"!="" {
            forv i = 1/`R' {    // last colum for each model contains _dummy info
                forv j = `ccols'(`ccols')`C' {
                    if `B'[`i',`j']==1 {
                        mat `D'[`i',1] = 1
                    }
                }
            }
        }
    }

*Prepare element specific keep/drop
    local dash
    tempname tmpmat
    foreach v in star `values' {
        local temp `"`fullvarlist'"'
        if "`unstack'"!="" {
            local temp2: list uniq eqs
            local `v'`dash'eqdrop: list uniq eqs
        }
        if `"``v'`dash'keep'"'!="" {
            capt mat `tmpmat' = `B'
            ExpandEqVarlist `"``v'`dash'keep'"' `tmpmat'
            DropOrKeep 1 `tmpmat' `"`value'"'
            capt confirm matrix `tmpmat'
            if _rc local temp
            else {
                QuotedRowNames `tmpmat'
                MakeQuotedFullnames `"`value'"' `"`: roweq `tmpmat', q'"'
                local temp: list temp & value
                if "`unstack'"!="" {
                    local value: roweq `tmpmat', q
                    local value: list uniq value
                    local temp2: list temp2 & value
                }
            }
        }
        if `"``v'`dash'drop'"'!="" {
            capt mat `tmpmat' = `B'
            ExpandEqVarlist `"``v'`dash'drop'"' `tmpmat'
            DropOrKeep 0 `tmpmat' `"`value'"'
            capt confirm matrix `tmpmat'
            if _rc local temp
            else {
                QuotedRowNames `tmpmat'
                MakeQuotedFullnames `"`value'"' `"`: roweq `tmpmat', q'"'
                local temp: list temp & value
                if "`unstack'"!="" {
                    local value: roweq `tmpmat', q
                    local value: list uniq value
                    local temp2: list temp2 & value
                }
            }
        }
        local `v'`dash'drop: list fullvarlist - temp
        if "`unstack'"!="" {
            local `v'`dash'eqdrop: list `v'`dash'eqdrop - temp2
        }
        local dash "_"
    }
    capt mat drop `tmpmat'

*Prepare unstack
    if "`unstack'"!="" & `R'>0 {
        local varlist: list uniq varlist
        GetVarnamesFromOrder `"`order'"'
        local temp: list value & varlist
        local varlist: list temp | varlist
        local cons _cons
        if `:list cons in value'==0 {
            if `:list cons in varlist' {
                local varlist: list varlist - cons
                local varlist: list varlist | cons
            }
        }
        local R: word count `varlist'
        local eqswide: list uniq eqs
        forv i=1/`nindicate' {
            ReorderEqsInIndicate `"`nmodels'"' `"`eqswide'"' ///
             `"`indicate`i'eqs'"' `"`macval(indicate`i'lbls)'"'
            local indicate`i'lbls `"`macval(value)'"'
        }
    }
    else local eqswide "_"

*Prepare coefs for tabulation
    if `R'>0 {
        local i 0
        foreach v of local values {
            local ++i
            tempname _`v'
            forv j = 1/`nmodels' {
                mat `_`v'' = nullmat(`_`v''), `B'[1..., (`j'-1)*`ccols'+`i']
            }
            mat coln `_`v'' = `models'
            mat coleq `_`v'' = `models'
            if inlist("``v'_'", "t", "z") {
                if `"``v'_abs'"'!="" {  // absolute t-values
                    forv r = 1/`R' {
                        forv j = 1/`nmodels' {
                            if `_`v''[`r',`j']>=. continue
                            mat `_`v''[`r',`j'] = abs(`_`v''[`r',`j'])
                        }
                    }
                }
            }
        }
    }

*Model labels
    if "`nomlabelstitles'"=="" & "`label'"!="" local mlabelstitles titles
    local tmp: list sizeof mlabels
    local i 0
    foreach model of local models {
        local ++i
        if `i'<=`tmp' continue
        local lab
        if "`mlabelsdepvars'"!="" {
            local var `"`return(m`i'_depname)'"'
            if "`label'"!="" {
                local temp = index(`"`var'"',".")
                local temp2  = substr(`"`var'"',`temp'+1,.)
                capture local lab: var l `temp2'
                if _rc | `"`lab'"'=="" {
                    local lab `"`temp2'"'
                }
                local temp2 = substr(`"`var'"',1,`temp')
                local lab `"`temp2'`macval(lab)'"'
            }
            else local lab `"`var'"'
        }
        else if "`mlabelstitles'"!="" {
                local lab `"`return(m`i'_estimates_title)'"'
                if `"`lab'"'=="" local lab "`model'"
        }
        else {
            local lab "`model'"
        }
        local mlabels `"`macval(mlabels)' `"`macval(lab)'"'"'
    }
    if "`mlabelsnumbers'"!="" {
        NumberMlabels `nmodels' `"`macval(mlabels)'"'
    }

*Equations labels
    local eqconssubok = (`"`macval(eqlabels)'"'!=`""""')
    local numeqs: list sizeof eqs
    local temp: list sizeof eqlabels
    if `temp'<`numeqs' {
        forv i = `=`temp'+1'/`numeqs' {
            local eq: word `i' of `eqs'
            local value
            if "`label'"!="" {
                capture confirm variable `eq'
                if !_rc {
                    local value: var l `eq'
                }
            }
            if `"`value'"'=="" local value "`eq'"
            local eqlabels `"`macval(eqlabels)' `"`value'"'"'
        }
    }
    if `eqconssubok' {
        if "`eqlabelsnone'"!="" & `numeqs'>1 & "`unstack'"=="" {
            EqReplaceCons `"`varlist'"' `"`eqlist'"' `"`eqlabels'"' `"`macval(varlabels)'"'
            if `"`macval(value)'"'!="" {
                local varlabels `"`macval(value)' `macval(varlabels)'"'
            }
        }
    }

*Column labels
    if `"`macval(collabels)'"'=="" {
        forv j = 1/`ncols' {
            local temp
            forv i = 1/`nrows' {
                local v: word `i' of `cells'
                local v: word `j' of `v'
                local v: subinstr local v "&" " ", all
                local v: subinstr local v "." "", all
                local v: list retok v
                foreach vi of local v {
                    if `"`macval(temp)'"'!="" {
                        local temp `"`macval(temp)'/"'
                    }
                    local temp `"`macval(temp)'`macval(`vi'_label)'"'
                }
            }
            local collabels `"`macval(collabels)'`"`macval(temp)'"' "'
        }
    }

*Prepare refcat()
    if `"`macval(refcat)'"'!="" {
        PrepareRefcat `"`macval(refcat)'"'
    }

*Determine table layout
    local m 1
    local starcol 0
    foreach model of local models {
        local e 0
        foreach eq of local eqswide {
            local stc 0
            local ++e
            if "`unstack'"!="" & `R'>0 {
                ModelEqCheck `B' `"`eq'"' `m' `ccols'
                if !`value' continue
            }
            local eqsrow "`eqsrow'`e' "
            local modelsrow "`modelsrow'`m' "
            local k 0
            local something 0
            forv j = 1/`ncols' {
                local col
                local nocol 1
                local colhasstats 0
                forv i = 1/`nrows' {
                    local row: word `i' of `cells'
                    local v: word `j' of `row'
                    local v: subinstr local v "&" " ", all
                    foreach vi in `v' {
                        if "`vi'"=="." continue
                        local colhasstats 1
                        if "`unstack'"!="" {
                            if `:list eq in `vi'_eqdrop' continue
                        }
                        if "`:word `m' of ``vi'_pattern''"=="0" {
                            local v: subinstr local v "`vi'" ".`vi'", word
                        }
                        else {
                            local nocol 0
                            if `"``vi'_star'"'!="" local starcol 1
                        }
                    }
                    local v: subinstr local v " " "&", all
                    if "`v'"=="" local v "."
                    local col "`col'`v' "
                }
                if `colhasstats'==0 local nocol 0
                if !`nocol' {
                    local colsrow "`colsrow'`j' "
                    if `++k'>1 {
                        local modelsrow "`modelsrow'`m' "
                        local eqsrow "`eqsrow'`e' "
                    }
                    if `"`: word `++stc' of `statscolstar''"'=="1" local starcol 1
                    local starsrow "`starsrow'`starcol' "
                    local starcol 0
                    Add2Vblock `"`vblock'"' "`col'"
                    local something 1
                }
            }
            if !`something' {
                local col
                forv i = 1/`nrows' {
                    local col "`col'. "
                }
                Add2Vblock `"`vblock'"' "`col'"
                local colsrow "`colsrow'1 "
                if `"`: word `++stc' of `statscolstar''"'=="1" local starcol 1
                local starsrow "`starsrow'`starcol' "
                local starcol 0
            }
        }
        local ++m
    }
    CountNofEqs "`modelsrow'" "`eqsrow'"
    local neqs `value'
    if `"`extracols'"'!="" {
        foreach row in model eq col star {
            InsertAtCols `"`extracols'"' `"``row'srow'"'
            local `row'srow `"`value'"'
        }
        foreach row of local vblock {
            InsertAtCols `"`extracols'"' `"`row'"'
            local nvblock `"`nvblock' `"`value'"'"'
        }
        local vblock: list clean nvblock
    }
    local ncols = `: word count `starsrow'' + 1 + `haslabcol2'

*Modelwidth/varwidth/starwidth
    if "`modelwidth'"=="" local modelwidth 0
    if "`varwidth'"=="" local varwidth 0
    local nmodelwidth: list sizeof modelwidth
    local modelwidthzero: list uniq modelwidth
    local modelwidthzero = ("`modelwidth'"=="0")
    if "`labcol2width'"=="" local labcol2width `: word 1 of `modelwidth''
    local starwidth 0
    if `modelwidthzero'==0 {
        if `tablehasstars' | `"`statsstar'"'!="" {
            Starwidth `"`macval(starlevels)'"'
            local starwidth `value'
        }
    }
    if `varwidth'<2 local wrap

* totcharwidth / hline
    local totcharwidth `varwidth'
    capture {
        local delwidth = length(`macval(delimiter)')
    }
    if _rc {
        local delwidth = length(`"`macval(delimiter)'"')
    }
    if `haslabcol2' {
        local totcharwidth = `totcharwidth' + `delwidth' + `labcol2width'
    }
    local j 0
    foreach i of local starsrow {
        local modelwidthj: word `=1 + mod(`j++',`nmodelwidth')' of `modelwidth'
        local totcharwidth = `totcharwidth' + `delwidth' + `modelwidthj'
        if `i' {
            if "`stardetach'"!="" {
                local ++ncols
                local totcharwidth = `totcharwidth' + `delwidth'
            }
            local totcharwidth = `totcharwidth' + `starwidth'
        }
    }
    IsInString "@hline" `"`0'"'  // sets local strcount
    if `strcount' {
        local hline `totcharwidth'
        if `hline'>400 local hline 400 // _dup(400) is limit
        if `"`macval(hlinechar)'"'=="" local hlinechar "-"
        local hline: di _dup(`hline') `"`macval(hlinechar)'"'
    }
    else local hline

* check begin, delimiter, end
    tempfile tfile
    tempname file
    file open `file' using `"`tfile'"', write text
    foreach opt in begin delimiter end {
        capture file write `file' `macval(`opt')'
        if _rc {
            local `opt' `"`"`macval(`opt')'"'"'
        }
    }
    file close `file'

* RTF support: set macros rtfrowdef, rtfrowdefbrdrt, rtfrowdefbrdrb, rtfemptyrow
    local hasrtfbrdr 0
    local rtfbrdron 0
    IsInString "@rtfrowdef" `"`begin'"' // sets local strcount
    local hasrtf = `strcount'
    if `hasrtf' {
        MakeRtfRowdefs `"`macval(begin)'"' `"`starsrow'"' "`stardetach'" ///
            `varwidth' "`modelwidth'" `haslabcol2' `labcol2width'
        local varwidth 0
        local wrap
        local modelwidth 0
        local nmodelwidth 1
        local modelwidthzero 1
        local starwidth 0
        local labcol2width 0
        IsInString "@rtfrowdefbrdr" `"`begin'"' // sets local strcount
        if `strcount' {
            local hasrtfbrdr 1
            local rtfbeginbak `"`macval(begin)'"'
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrt'"'
            local rtfbrdron 1
        }
        else {
            StableSubinstr begin `"`macval(begin)'"' "@rtfrowdef" `"`rtfrowdef'"'
        }
    }

* set widths
    if `starwidth'>0 local fmt_stw "%-`starwidth's"
    if `varwidth'>0 local fmt_v "%-`varwidth's"
    if `labcol2width'>0 local fmt_l2 "%~`labcol2width's"
    if "`mgroupsspan'`mlabelsspan'`eqlabelsspan'`collabelsspan'"!="" {
        if `modelwidthzero'==0 {
            file open `file' using `"`tfile'"', write text replace
            file write `file' `macval(delimiter)'
            file close `file'
            file open `file' using `"`tfile'"', read text
            file read `file' delwidth
            file close `file'
            local delwidth = length(`"`macval(delwidth)'"')
        }
        else local delwidth 0
    }
    local stardetachon = ("`stardetach'"!="")
    if `stardetachon' {
        local stardetach `"`macval(delimiter)'"'
    }

*Prepare @-Variables
    local atvars2 `""`nmodels'" "`neqs'" "`totcharwidth'" `"`macval(hline)'"' `hasrtf' `"`rtfrowdefbrdrt'"' `"`rtfrowdefbrdrb'"' `"`rtfrowdef'"' `"`rtfemptyrow'"'"'
    local atvars3 `"`"`macval(title)'"' `"`macval(note)'"' `"`macval(discrete)'`macval(discrete2)'"' `"`macval(starlegend)'"'"'

*Open output file
    file open `file' using `"`tfile'"', write text replace

*Write prehead
    if `"`macval(prehead)'"'!="" {
        if index(`"`macval(prehead)'"',`"""')==0 {
            local prehead `"`"`macval(prehead)'"'"'
        }
    }
    foreach line of local prehead {
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(line)'"' 0 "`ncols'" `macval(atvars2)' `macval(atvars3)'
        file write `file' `"`macval(value)'"' _n
    }
    local hasheader 0
    if "`smcltags'"!="" local thesmclrule "{txt}{hline `totcharwidth'}"
    else                local thesmclrule "{hline `totcharwidth'}"
    if "`smclrules'"!="" {
        file write `file' `"`thesmclrule'"' _n
    }

*Labcol2 - title
    if `haslabcol2' {
        IsInString `"""' `"`macval(labcol2title)'"' // sets local strcount
        if `strcount'==0 {
            local labcol2chunk `"`macval(labcol2title)'"'
            local labcol2rest ""
        }
        else {
            gettoken labcol2chunk labcol2rest : labcol2title
        }
    }

*Write head: Models groups
    if "`mgroupsnone'"=="" & `"`macval(mgroups)'"'!="" {
        local hasheader 1
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(mgroupsbegin)'"' 2 "`ncols'" `macval(atvars2)'
        local mgroupsbegin `"`macval(value)'"'
        InsertAtVariables `"`macval(mgroupsend)'"' 2 "`ncols'" `macval(atvars2)'
        local mgroupsend `"`macval(value)'"'
        local tmpbegin `"`macval(begin)'"'
        local tmpend `"`macval(end)'"'
        if "`mgroupsreplace'"!="" {
            if `"`macval(mgroupsbegin)'"'!="" local tmpbegin
            if `"`macval(mgroupsend)'"'!=""  local tmpend
        }
        MgroupsPattern "`modelsrow'" "`mgroupspattern'"
        Abbrev `varwidth' `"`macval(mgroupslhs)'"' "`abbrev'"
        WriteBegin `"`file'"' `"`macval(mgroupsbegin)'"' `"`macval(tmpbegin)'"' ///
         `"`fmt_v' (`"`macval(value)'"')"'
        if `haslabcol2' {
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        WriteCaption `"`file'"' `"`macval(delimiter)'"' ///
            `"`macval(stardetach)'"' "`mgroupspattern'" "`mgroupspattern'" ///
            `"`macval(mgroups)'"' "`starsrow'" "`mgroupsspan'" "`abbrev'" ///
            "`modelwidth'" "`delwidth'" "`starwidth'" ///
            `"`macval(mgroupserepeat)'"' `"`macval(mgroupsprefix)'"' ///
            `"`macval(mgroupssuffix)'"'
        WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(mgroupsend)'"' ///
         `"`"`macval(value)'"'"'
        if `hasrtfbrdr' & `rtfbrdron' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
            local rtfbrdron 0
        }
        gettoken labcol2chunk labcol2rest : labcol2rest
    }

*Write head: Models numbers
    if `"`macval(numbers)'"'!="" {
        local hasheader 1
        if "`smcltags'"!="" file write `file' "{txt}"
        if `"`macval(numbers)'"'=="numbers" local numbers "( )"
        file write `file' `macval(begin)' `fmt_v' (`""')
        if `haslabcol2' {
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        tokenize `"`macval(numbers)'"'
        numlist `"1/`nmodels'"'
        WriteCaption `"`file'"' `"`macval(delimiter)'"' ///
            `"`macval(stardetach)'"' "`modelsrow'" "`modelsrow'"  ///
            "`r(numlist)'" "`starsrow'" "`mlabelsspan'" "`abbrev'"  ///
            "`modelwidth'" "`delwidth'" "`starwidth'" ///
            `""' `"`macval(1)'"' `"`macval(2)'"'
        file write `file' `macval(end)' _n
        if `hasrtfbrdr' & `rtfbrdron' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
            local rtfbrdron 0
        }
        gettoken labcol2chunk labcol2rest : labcol2rest
    }

*Write head: Models captions
    if "`nomlabelsnone'"=="" & "`models'"=="." & `"`macval(mlabels)'"'=="." local mlabelsnone "none"
    if "`mlabelsnone'"=="" {
        local hasheader 1
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(mlabelsbegin)'"' 2 "`ncols'" `macval(atvars2)'
        local mlabelsbegin `"`macval(value)'"'
        InsertAtVariables `"`macval(mlabelsend)'"' 2 "`ncols'" `macval(atvars2)''
        local mlabelsend `"`macval(value)'"'
        local tmpbegin `"`macval(begin)'"'
        local tmpend `"`macval(end)'"'
        if "`mlabelsreplace'"!="" {
            if `"`macval(mlabelsbegin)'"'!="" local tmpbegin
            if `"`macval(mlabelsend)'"'!=""  local tmpend
        }
        Abbrev `varwidth' `"`macval(mlabelslhs)'"' "`abbrev'"
        WriteBegin `"`file'"' `"`macval(mlabelsbegin)'"' `"`macval(tmpbegin)'"' ///
         `"`fmt_v' (`"`macval(value)'"')"'
        if `haslabcol2' {
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        WriteCaption `"`file'"' `"`macval(delimiter)'"' ///
            `"`macval(stardetach)'"' "`modelsrow'" "`modelsrow'"  ///
            `"`macval(mlabels)'"' "`starsrow'" "`mlabelsspan'" "`abbrev'"  ///
            "`modelwidth'" "`delwidth'" "`starwidth'" ///
            `"`macval(mlabelserepeat)'"' `"`macval(mlabelsprefix)'"' ///
            `"`macval(mlabelssuffix)'"'
        WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(mlabelsend)'"' ///
         `"`"`macval(value)'"'"'
        if `hasrtfbrdr' & `rtfbrdron' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
            local rtfbrdron 0
        }
        gettoken labcol2chunk labcol2rest : labcol2rest
    }

*Write head: Equations captions
    if "`eqlabelsnone'"=="" {
        InsertAtVariables `"`macval(eqlabelsbegin)'"' 2 "`ncols'" `macval(atvars2)'
        local eqlabelsbegin `"`macval(value)'"'
        InsertAtVariables `"`macval(eqlabelsend)'"' 2 "`ncols'" `macval(atvars2)'
        local eqlabelsend `"`macval(value)'"'
    }
    if `"`eqswide'"'!="_" & "`eqlabelsnone'"=="" {
        local hasheader 1
        local tmpbegin `"`macval(begin)'"'
        local tmpend `"`macval(end)'"'
        if "`eqlabelsreplace'"!="" {
            if `"`macval(eqlabelsbegin)'"'!="" local tmpbegin
            if `"`macval(eqlabelsend)'"'!=""  local tmpend
        }
        if "`smcltags'"!="" file write `file' "{txt}"
        Abbrev `varwidth' `"`macval(eqlabelslhs)'"' "`abbrev'"
        WriteBegin `"`file'"' `"`macval(eqlabelsbegin)'"' `"`macval(tmpbegin)'"' ///
         `"`fmt_v' (`"`macval(value)'"')"'
        if `haslabcol2' {
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        WriteCaption `"`file'"' `"`macval(delimiter)'"' ///
            `"`macval(stardetach)'"' "`eqsrow'" "`modelsrow'" ///
            `"`macval(eqlabels)'"' "`starsrow'" "`eqlabelsspan'"  "`abbrev'" ///
            "`modelwidth'" "`delwidth'" "`starwidth'" ///
            `"`macval(eqlabelserepeat)'"' `"`macval(eqlabelsprefix)'"' ///
            `"`macval(eqlabelssuffix)'"'
        WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(eqlabelsend)'"' ///
         `"`"`macval(value)'"'"'
        if `hasrtfbrdr' & `rtfbrdron' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
            local rtfbrdron 0
        }
        gettoken labcol2chunk labcol2rest : labcol2rest
    }

*Write head: Columns captions
    if `"`macval(collabels)'"'!="" & "`collabelsnone'"=="" {
        local hasheader 1
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(collabelsbegin)'"' 2 "`ncols'" `macval(atvars2)'
        local collabelsbegin `"`macval(value)'"'
        InsertAtVariables `"`macval(collabelsend)'"' 2 "`ncols'" `macval(atvars2)'
        local collabelsend `"`macval(value)'"'
        local tmpbegin `"`macval(begin)'"'
        local tmpend `"`macval(end)'"'
        if "`collabelsreplace'"!="" {
            if `"`macval(collabelsbegin)'"'!="" local tmpbegin
            if `"`macval(collabelsend)'"'!=""  local tmpend
        }
        Abbrev `varwidth' `"`macval(collabelslhs)'"' "`abbrev'"
        WriteBegin `"`file'"' `"`macval(collabelsbegin)'"' `"`macval(tmpbegin)'"' ///
         `"`fmt_v' (`"`macval(value)'"')"'
        if `haslabcol2' {
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        WriteCaption `"`file'"' `"`macval(delimiter)'"' ///
            `"`macval(stardetach)'"' "`colsrow'" "" `"`macval(collabels)'"' ///
            "`starsrow'" "`collabelsspan'" "`abbrev'" "`modelwidth'" ///
            "`delwidth'" "`starwidth'" `"`macval(collabelserepeat)'"' ///
            `"`macval(collabelsprefix)'"' `"`macval(collabelssuffix)'"'
        WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(collabelsend)'"' ///
         `"`"`macval(value)'"'"'
        if `hasrtfbrdr' & `rtfbrdron' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
            local rtfbrdron 0
        }
        gettoken labcol2chunk labcol2rest : labcol2rest
    }

*Write posthead
    if `hasheader' & "`smclmidrules'"!="" {
        file write `file' `"`thesmclrule'"' _n
    }
    if `"`macval(posthead)'"'!="" {
        if index(`"`macval(posthead)'"',`"""')==0 {
            local posthead `"`"`macval(posthead)'"'"'
        }
    }
    foreach line of local posthead {
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(line)'"' 0 "`ncols'" `macval(atvars2)' `macval(atvars3)'
        file write `file' `"`macval(value)'"' _n
    }

* Create mmd alignment/divider line
    if `"`defaults'"'=="mmd" {
        MakeMMDdef "`varwidth'" "`haslabcol2'" "`labcol2width'" ///
            "`modelwidth'" "`starsrow'" "`stardetachon'" "`starwidth'"
        file write `file' `"`macval(value)'"' _n
    }

*Write body of table
*Loop over table rows
    InsertAtVariables `"`macval(varlabelsbegin)'"' 2 "`ncols'" `macval(atvars2)'
    local varlabelsbegin `"`macval(value)'"'
    InsertAtVariables `"`macval(varlabelsend)'"' 2 "`ncols'" `macval(atvars2)'
    local varlabelsend `"`macval(value)'"'
    tempname first
    if `"`vblock'"'!="" {
        local RI = `R' + `nindicate'
        local e 0
        local eqdim = `R' + `nindicate'
        local weqcnt 0
        local theeqlabel
        if `hasrtfbrdr' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrt'"'
            local rtfbrdron 1
        }
        local varlabelsbegin0 `"`macval(varlabelsbegin)'"'
        local eqlabelsbegin0 `"`macval(eqlabelsbegin)'"'
        if "`eqlabelsfirst'"=="" local eqlabelsbegin0
        forv r = 1/`R' {
            local varlabelsend0 `"`macval(varlabelsend)'"'
            local var: word `r' of `varlist'

*Write equation name/label
            if "`unstack'"=="" {
                local eqvar: word `r' of `fullvarlist'
                if `"`eqs'"'!="_" {
                    local eqrlast `"`eqr'"'
                    local eqr: word `r' of `eqlist'
                    if `"`eqr'"'!=`"`eqrlast'"' & "`eqlabelsnone'"=="" {
                        local value: word `++e' of `macval(eqlabels)'
                        local eqdim: word `e' of `macval(eqsdims)'
                        local weqcnt 0
                        if `e'==`numeqs' {
                            if "`eqlabelslast'"=="" local eqlabelsend
                            local eqdim = `eqdim' + `nindicate'
                        }
                        if "`eqlabelsmerge'"!="" {
                            local theeqlabel `"`macval(eqlabelsprefix)'`macval(value)'`macval(eqlabelssuffix)'"'
                        }
                        else {
                            local tmpbegin `"`macval(begin)'"'
                            local tmpend `"`macval(end)'"'
                            if "`eqlabelsreplace'"!="" {
                                if `"`macval(eqlabelsbegin0)'"'!="" local tmpbegin
                                if `"`macval(eqlabelsend)'"'!=""  local tmpend
                            }
                            if `e'>1 & "`smcleqrules'"!="" {
                                file write `file' `"`thesmclrule'"' _n
                            }
                            WriteBegin `"`file'"' `"`macval(eqlabelsbegin0)'"' `"`macval(tmpbegin)'"'
                            if "`smcltags'"!="" file write `file' "{res}"
                            WriteEqrow `"`file'"' `"`macval(delimiter)'"' ///
                                `"`macval(stardetach)'"' `"`macval(value)'"' "`starsrow'" ///
                                "`eqlabelsspan'" "`varwidth'" "`fmt_v'" "`abbrev'" ///
                                "`modelwidth'" "`delwidth'" "`starwidth'" ///
                                `"`macval(eqlabelsprefix)'"' `"`macval(eqlabelssuffix)'"' ///
                                "`haslabcol2'" "`labcol2width'" "`fmt_l2'"
                            if "`smcltags'"!="" file write `file' "{txt}"
                            WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(eqlabelsend)'"'
                            if `hasrtfbrdr' & `rtfbrdron' {
                                StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
                                local rtfbrdron 0
                            }
                            local eqlabelsbegin0 `"`macval(eqlabelsbegin)'"'
                        }
                    }
                }
            }
            local ++weqcnt
            if `weqcnt'==1 {
                if "`varlabelsfirst'"=="" local varlabelsbegin0
            }

*Determine rows to be written
            local rvblock
            foreach row of local vblock {
                local c 0
                local skiprow 1
                local rowhasstats 0
                foreach v of local row {
                    local ++c
                    if "`unstack'"!="" {
                        local eqr: word `:word `c' of `eqsrow'' of `eqs'
                        if `"`eqr'"'!="" local eqvar `"`eqr':`var'"'
                        else local eqvar "`var'"
                    }
                    local v: subinstr local v "&" " ", all
                    foreach vi of local v {
                        if "`vi'"=="." continue
                        if rownumb(`B',`"`eqvar'"')<. {
                            local rowhasstats 1
                            if index("`vi'",".")==1 continue
                            if `: list eqvar in `vi'_drop' continue
                            local skiprow 0
                            continue, break
                        }
                    }
                    if `skiprow'==0 continue, break
                }
                if `rowhasstats'==0 local skiprow 0
                if `"`ferest()'"'=="" & `"`rvblock'"'=="" local skiprow 0
                if `skiprow' continue
                local rvblock `"`rvblock'"`row'" "'
            }
            local nrvblock: list sizeof rvblock

*Insert refcat() (unless refcatbelow)
            if `"`macval(refcat)'"'!="" {
                local isref: list posof "`var'" in refcatcoefs
                if `isref' {
                    if "`unstack'"=="" {
                        local temp `"`eqr'"'
                        if `"`temp'"'=="" local temp "_"
                    }
                    else local temp `"`eqswide'"'
                    GenerateRefcatRow `B' `ccols' "`var'" `"`temp'"' `"`macval(refcatlabel)'"'
                    local refcatrow `"`macval(value)'"'
                }
            }
            else local isref 0
            if `isref' & `"`refcatbelow'"'=="" {
                if "`smcltags'"!="" file write `file' "{txt}"
                local tmpbegin `"`macval(begin)'"'
                local tmpend `"`macval(end)'"'
                if "`varlabelsreplace'"!="" {
                    if `"`macval(varlabelsbegin0)'"'!="" local tmpbegin
                    if `"`macval(varlabelsend0)'"'!=""  local tmpend
                }
                if "`varlabelsnone'"=="" {
                    local value: word `isref' of `macval(refcatnames)'
                    Abbrev `varwidth' `"`macval(value)'"' "`abbrev'"
                }
                else local value
                WriteBegin `"`file'"' `"`macval(varlabelsbegin0)'"' `"`macval(tmpbegin)'"' ///
                 `"`fmt_v' (`"`macval(varlabelsprefix)'`macval(value)'`macval(varlabelssuffix)'"')"'
                if `haslabcol2' {
                    gettoken labcol2chunk labcol2 : labcol2
                    Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
                    file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
                }
                if "`smcltags'"!="" file write `file' "{res}"
                WriteStrRow `"`file'"' "`modelsrow'" `"`eqsrow'"' `"`: list sizeof eqswide'"' ///
                    `"`macval(refcatrow)'"' `"`macval(delimiter)'"' ///
                    `"`macval(stardetach)'"' "`starsrow'" "`abbrev'"  ///
                    "`modelwidth'" "`delwidth'" "`starwidth'"
                if "`smcltags'"!="" file write `file' "{txt}"
                WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(varlabelsend0)'"'
                if `hasrtfbrdr' & `rtfbrdron' {
                    StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
                    local rtfbrdron 0
                }
                local varlabelsbegin0 `"`macval(varlabelsbegin)'"'
            }

*Write variable name/label
            if "`smcltags'"!="" file write `file' "{txt}"
            local tmpbegin `"`macval(begin)'"'
            if "`varlabelsnone'"=="" {
                VarInList `"`var'"' "`unstack'" `"`eqvar'"' ///
                 `"`eqr'"' `"`macval(varlabelsblist)'"'
                if `"`macval(value)'"'!="" {
                    IsInString `"""' `"`value'"' // sets local strcount
                    if `strcount'==0 {
                        local value `"`"`macval(value)'"'"'
                    }
                    InsertAtVariables `"`macval(value)'"' 2 "`ncols'" `macval(atvars2)'
                    WriteStrLines `"`file'"' `"`macval(value)'"'
                    if "`varlabelsreplace'"!="" {
                        local tmpbegin
                        local varlabelsbegin0
                    }
                }
                if "`label'"!="" {
                    CompileVarl, vname(`var') interaction(`macval(interaction)')
                }
                else local varl `var'
                VarInList `"`var'"' "`unstack'" `"`eqvar'"' ///
                 `"`eqr'"' `"`macval(varlabels)'"'
                if `"`macval(value)'"'!="" {
                    local varl `"`macval(value)'"'
                }
                if `"`macval(discrete)'"'!="" {
                    local temp 0
                    if "`unstack'"=="" {
                        if `D'[`r',1]==1 local temp 1
                    }
                    else {
                        foreach eqr of local eqswide {
                            if `D'[rownumb(`D',`"`eqr':`var'"'),1]==1 local temp 1
                        }
                    }
                    if `temp'==1 & `temp'<. {
                        local varl `"`macval(varl)'`macval(discrete)'"'
                    }
                }
            }
            else local varl
            if `hasrtfbrdr' & `r'==`RI' & !(`isref' & `"`refcatbelow'"'!="") {
                if `nrvblock'==1 {
                    StableSubinstr tmpbegin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrb'"'
                    local rtfbrdron 1
                }
            }
            if "`varlabelsreplace'"!="" {
                if `"`macval(varlabelsbegin0)'"'!="" local tmpbegin
            }
            if "`wrap'"!="" & `nrvblock'>1 {
                local wrap_i 1
                local value: piece `wrap_i' `varwidth' of `"`macval(theeqlabel)'`macval(varl)'"', nobreak
                Abbrev `varwidth' `"`macval(value)'"' "`abbrev'"
            }
            else {
                Abbrev `varwidth' `"`macval(theeqlabel)'`macval(varl)'"' "`abbrev'"
            }
            WriteBegin `"`file'"' `"`macval(varlabelsbegin0)'"' `"`macval(tmpbegin)'"' ///
             `"`fmt_v' (`"`macval(varlabelsprefix)'`macval(value)'`macval(varlabelssuffix)'"')"'
            if `haslabcol2' {
                gettoken labcol2chunk labcol2 : labcol2
                Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
                file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
            }
            if `hasrtfbrdr' & `rtfbrdron' {
                StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
                local rtfbrdron 0
            }
            local varlabelsbegin0 `"`macval(varlabelsbegin)'"'

*Write table cells
            if "`smcltags'"!="" file write `file' "{res}"
            local newrow 0
            mat `first'=J(1,`nmodels',1)
            foreach row of local rvblock {
                if `hasrtfbrdr' & `r'==`RI' & !(`isref' & `"`refcatbelow'"'!="") {
                    if `"`ferest()'"'=="" {
                        StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrb'"'
                        local rtfbrdron 1
                    }
                }
                local c 0
                foreach v of local row {
                    local m: word `++c' of `modelsrow'
                    local unstackskipcoef 0
                    if "`unstack'"!="" {
                        capt local eqr: word `:word `c' of `eqsrow'' of `eqs'
                        local rr=rownumb(`B',`"`eqr':`var'"')
                        if `"`eqr'"'!="" local eqvar `"`eqr':`var'"'
                        else local eqvar "`var'"
                        if `rr'>=. local unstackskipcoef 1 // local v "."
                    }
                    else local rr `r'
                    if `newrow' & `c'==1 {
                        if "`smcltags'"!="" file write `file' "{txt}"
                        if "`wrap'"!="" & `nrvblock'>1 {
                            local value
                            local space
                            while (1) {
                                local temp: piece `++wrap_i' `varwidth' of `"`macval(varl)'"', nobreak
                                if `"`macval(temp)'"'=="" continue, break
                                local value `"`macval(value)'`space'`macval(temp)'"'
                                if `wrap_i'<`nrvblock' continue, break
                                local space " "
                            }
                            Abbrev `varwidth' `"`macval(value)'"' "`abbrev'"
                            local value `"`fmt_v' (`"`macval(varlabelsprefix)'`macval(value)'`macval(varlabelssuffix)'"')"'
                        }
                        else local value "_skip(`varwidth')"
                        file write `file' `macval(end)' _n `macval(begin)' `value'
                        if `haslabcol2' {
                            file write `file' `macval(delimiter)' `fmt_l2' ("")
                        }
                        if "`smcltags'"!="" file write `file' "{res}"
                    }
                    local v: subinstr local v "&" " ", all
                    local modelwidthj: word `=1+mod(`c'-1,`nmodelwidth')' of `modelwidth'
                    if `modelwidthj'>0 local fmt_m "%`modelwidthj's"
                    else local fmt_m
                    local thevalue
                    foreach vi of local v {
                        if index("`vi'",".")!=1 {
                            if `: list eqvar in `vi'_drop' local vi "..`vi'"
                            else {
                                local vipar: subinstr local `vi'_par "@modelwidth" "`modelwidthj'", all
                            }
                        }
                        if index("`vi'",".")==1 {
                            local value
                        }
                        else if `unstackskipcoef' {
                            local value `"``vi'_vacant'"'
                        }
                        else if `B'[`rr',`m'*`droppedpos']==1 & `droppedison' {
                            if `first'[1,`m'] {
                                local value `"`macval(dropped)'"'
                                mat `first'[1,`m']=0
                            }
                            else local value
                        }
                        else if "``vi'_'"=="ci" {
                            if `_`vi'_l'[`rr',`m']>=.y local value `"``vi'_vacant'"'
                            else {
                                local format: word `r' of `ci_fmt'
                                if "`format'"=="" {
                                    local format: word `:word count ``vi'_fmt'' of ``vi'_fmt'
                                }
                                local value = `_`vi'_l'[`rr',`m']
                                local vipar: subinstr local `vi'_l_par "@modelwidth" "`modelwidthj'", all
                                vFormat `value' `format' "`lz'" `"`macval(dmarker)'"' ///
                                    `"`macval(msign)'"' `"`macval(vipar)'"'
                                local temp "`macval(value)'"
                                local value = `_`vi'_u'[`rr',`m']
                                local vipar: subinstr local `vi'_u_par "@modelwidth" "`modelwidthj'", all
                                vFormat `value' `format' "`lz'" `"`macval(dmarker)'"' ///
                                    `"`macval(msign)'"' `"`macval(vipar)'"'
                                local value `"`macval(temp)'`macval(value)'"'
                            }
                        }
                        else if `_`vi''[`rr',`m']>=.y   local value `"``vi'_vacant'"'
                        //else if `_`vi''[`rr',`m']>=.    local value .
                        else if "``vi'_'"=="_star" {
                            CellStars `"`macval(starlevels)'"' `_```vi'_pvalue'_tname''[`rr',`m'] `"`macval(vipar)'"'
                        }
                        else if "``vi'_'"=="_sign" {
                            MakeSign `_`vi''[`rr',`m'] `"`macval(msign)'"' `"`macval(vipar)'"'
                        }
                        else if "``vi'_'"=="_sigsign" {
                            MakeSign `_`vi''[`rr',`m'] `"`macval(msign)'"' `"`macval(vipar)'"' ///
                                `"`macval(starlevels)'"' `_```vi'_pvalue'_tname''[`rr',`m']
                        }
                        else {
                            local format: word `r' of ``vi'_fmt'
                            if "`format'"=="" {
                                local format: word `:word count ``vi'_fmt'' of ``vi'_fmt'
                            }
                            local value = `_`vi''[`rr',`m']
                            vFormat `value' `format' "`lz'" `"`macval(dmarker)'"' ///
                                `"`macval(msign)'"' `"`macval(vipar)'"'
                        }
                        local thevalue `"`macval(thevalue)'`macval(value)'"'
                        if !`stardetachon' & `:word `c' of `starsrow''==1 {
                            if `modelwidthj'>0 | `starwidth'>0 local fmt_m "%`=`modelwidthj'+`starwidth''s"
                            local value
                            if index("`vi'",".")!=1 & `"``vi'_star'"'!="" {
                                if !`: list eqvar in stardrop' {
                                    Stars `"`macval(starlevels)'"' `_```vi'_pvalue'_tname''[`rr',`m']
                                }
                            }
                            if "`ferest()'"=="" {
                                local value: di `fmt_stw' `"`macval(value)'"'
                            }
                            local thevalue `"`macval(thevalue)'`macval(value)'"'
                        }
                        if "`ferest()'"!="" & index("`vi'","..")!=1  {
                            local thevalue `"`macval(thevalue)'`macval(incelldelimiter)'"'
                        }
                    }
                    file write `file' `macval(delimiter)' `fmt_m' (`"`macval(thevalue)'"')
                    if `stardetachon' & `:word `c' of `starsrow''==1 {
                        local thevalue
                        foreach vi of local v {
                            if index("`vi'",".")!=1 {
                                if `: list eqvar in `vi'_drop' local vi "..`vi'"
                            }
                            if index("`vi'",".")!=1 & `"``vi'_star'"'!="" {
                                if `: list eqvar in stardrop' local value
                                else {
                                    Stars `"`macval(starlevels)'"' `_```vi'_pvalue'_tname''[`rr',`m']
                                }
                                local thevalue `"`macval(thevalue)'`macval(value)'"'
                            }
                            if "`ferest()'"!="" & index("`vi'","..")!=1  {
                                local thevalue `"`macval(thevalue)'`macval(incelldelimiter)'"'
                            }
                        }
                        file write `file' `macval(stardetach)' `fmt_stw' (`"`macval(thevalue)'"')
                    }
                }
                local newrow 1
            }

*End of table row
            if "`smcltags'"!="" file write `file' "{txt}"
            if `weqcnt'==`eqdim' & "`varlabelslast'"=="" ///
             & !(`isref' & `"`refcatbelow'"'!="") local varlabelsend0
            local tmpend `"`macval(end)'"'
            if "`varlabelsreplace'"!="" {
                if `"`macval(varlabelsend0)'"'!=""  local tmpend
            }
            VarInList `"`var'"' "`unstack'" `"`eqvar'"' `"`eqr'"' ///
             `"`macval(varlabelselist)'"'
            if `"`macval(value)'"'!="" {
                IsInString `"""' `"`value'"' // sets local strcount
                if `strcount'==0 {
                    local value `"`"`macval(value)'"'"'
                }
                InsertAtVariables `"`macval(value)'"' 2 "`ncols'" `macval(atvars2)'
                if "`varlabelsreplace'"!="" local varlabelsend0
            }
            WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(varlabelsend0)'"' ///
             `"`macval(value)'"'
* insert refcat() (if refcatbelow)
            if `isref' & `"`refcatbelow'"'!="" {
            if "`smcltags'"!="" file write `file' "{txt}"
                if `hasrtfbrdr' & `r'==`RI' {
                    StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrb'"'
                    local rtfbrdron 1
                }
                if `weqcnt'==`eqdim' & "`varlabelslast'"=="" local varlabelsend0
                local tmpbegin `"`macval(begin)'"'
                local tmpend `"`macval(end)'"'
                if "`varlabelsreplace'"!="" {
                    if `"`macval(varlabelsbegin0)'"'!="" local tmpbegin
                    if `"`macval(varlabelsend0)'"'!=""  local tmpend
                }
                if "`varlabelsnone'"=="" {
                    local value: word `isref' of `macval(refcatnames)'
                    Abbrev `varwidth' `"`macval(value)'"' "`abbrev'"
                }
                else local value
                WriteBegin `"`file'"' `"`macval(varlabelsbegin0)'"' `"`macval(tmpbegin)'"' ///
                 `"`fmt_v' (`"`macval(varlabelsprefix)'`macval(value)'`macval(varlabelssuffix)'"')"'
                if `haslabcol2' {
                    gettoken labcol2chunk labcol2 : labcol2
                    Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
                    file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
                }
                if "`smcltags'"!="" file write `file' "{res}"
                WriteStrRow `"`file'"' "`modelsrow'" `"`eqsrow'"' `"`: list sizeof eqswide'"' ///
                    `"`macval(refcatrow)'"' `"`macval(delimiter)'"' ///
                    `"`macval(stardetach)'"' "`starsrow'" "`abbrev'"  ///
                    "`modelwidth'" "`delwidth'" "`starwidth'"
                if "`smcltags'"!="" file write `file' "{txt}"
                WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(varlabelsend0)'"'
            }
* end insert refcat()
        }
    }

*Write indicator sets
    forv i=1/`nindicate' {
        if `hasrtfbrdr' & `i'==`nindicate' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrb'"'
            local rtfbrdron 1
        }
        if `i'==`nindicate' & "`varlabelslast'"=="" local varlabelsend
        local tmpbegin `"`macval(begin)'"'
        local tmpend `"`macval(end)'"'
        if "`varlabelsreplace'"!="" {
            if `"`macval(varlabelsbegin0)'"'!="" local tmpbegin
            if `"`macval(varlabelsend)'"'!=""  local tmpend
        }
        if "`varlabelsnone'"=="" {
            Abbrev `varwidth' `"`macval(indicate`i'name)'"' "`abbrev'"
        }
        else local value
        if "`smcltags'"!="" file write `file' "{txt}"
        WriteBegin `"`file'"' `"`macval(varlabelsbegin0)'"' `"`macval(tmpbegin)'"' ///
         `"`fmt_v' (`"`macval(varlabelsprefix)'`macval(value)'`macval(varlabelssuffix)'"')"'
        if `haslabcol2' {
            gettoken labcol2chunk labcol2 : labcol2
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        if "`smcltags'"!="" file write `file' "{res}"
        WriteStrRow `"`file'"' "`modelsrow'" `"`eqsrow'"' `"`: list sizeof eqswide'"' ///
            `"`macval(indicate`i'lbls)'"' `"`macval(delimiter)'"' ///
            `"`macval(stardetach)'"' "`starsrow'" "`abbrev'"  ///
            "`modelwidth'" "`delwidth'" "`starwidth'"
        if "`smcltags'"!="" file write `file' "{txt}"
        WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(varlabelsend)'"'
    }

*Write prefoot
    if `"`macval(prefoot)'"'!="" {
        if index(`"`macval(prefoot)'"',`"""')==0 {
            local prefoot `"`"`macval(prefoot)'"'"'
        }
    }
    foreach line of local prefoot {
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(line)'"' 0 "`ncols'" `macval(atvars2)' `macval(atvars3)'
        file write `file' `"`macval(value)'"' _n
    }
    if ((`"`vblock'"'!="" & `R'>0) | `nindicate'>0) & "`smclmidrules'"!="" {
        if `"`macval(statsarray)'"'!="" {
            file write `file' `"`thesmclrule'"' _n
        }
    }

*Write foot of table (statistics)
    InsertAtVariables `"`macval(statslabelsbegin)'"' 2 "`ncols'" `macval(atvars2)'
    local statslabelsbegin `"`macval(value)'"'
    InsertAtVariables `"`macval(statslabelsend)'"' 2 "`ncols'" `macval(atvars2)'
    local statslabelsend `"`macval(value)'"'
    local statslabelsbegin0 `"`macval(statslabelsbegin)'"'
    local S: list sizeof statsarray
    local eqr "_"
    if `hasrtfbrdr' {
        StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrt'"'
        local rtfbrdron 1
    }
    forv r = 1/`S' {
        if `r'==`S' & `hasrtfbrdr' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdefbrdrb'"'
            local rtfbrdron 1
        }
        local stat: word `r' of `macval(statslabels)'
        if `"`stat'"'=="" local stat: word `r' of `statsrowlbls'
        if "`statslabelsnone'"!="" local stat
        if "`smcltags'"!="" file write `file' "{txt}"
        if `r'==1 & "`statslabelsfirst'"=="" local statslabelsbegin0
        local tmpbegin `"`macval(begin)'"'
        if "`statslabelsreplace'"!="" {
            if `"`macval(statslabelsbegin0)'"'!="" local tmpbegin
        }
        Abbrev `varwidth' `"`macval(stat)'"' "`abbrev'"
        WriteBegin `"`file'"' `"`macval(statslabelsbegin0)'"' `"`macval(tmpbegin)'"' ///
         `"`fmt_v' (`"`macval(statslabelsprefix)'`macval(value)'`macval(statslabelssuffix)'"')"'
        if `r'==1 & "`statslabelsfirst'"=="" {
            local statslabelsbegin0 `"`macval(statslabelsbegin)'"'
        }
        if `haslabcol2' {
            gettoken labcol2chunk labcol2 : labcol2
            Abbrev `labcol2width' `"`macval(labcol2chunk)'"' "`abbrev'"
            file write `file' `macval(delimiter)' `fmt_l2' (`"`macval(value)'"')
        }
        if "`smcltags'"!="" file write `file' "{res}"
        local strow: word `r' of `statsarray'
        local strowlay: word `r' of `macval(statslayout)'
        local strowfmt: word `r' of  `statsrowfmt'
        local strowstar: word `r' of  `statsrowstar'
        local lastm
        local lasteq
        local c 0
        local mpos 0
        foreach m of local modelsrow {
            local ++c
            local modelwidthj: word `=1+mod(`c'-1,`nmodelwidth')' of `modelwidth'
            if `modelwidthj'>0 local fmt_m "%`modelwidthj's"
            else local fmt_m
            if "`m'"=="." {
                file write `file' `macval(delimiter)' `fmt_m' (`""')
                continue
            }
            local value
            local eq: word `:word `c' of `eqsrow'' of `eqs'
            if "`m'"!="`lastm'" {
                local stc 0
                local hasmestats 0
            }
            if "`m'"!="`lastm'" | `"`eq'"'!="`lasteq'"  local stc_eq 0
            local usemestats 0
            local ++stc_eq
            local stcell: word `++stc' of `strow'
            local stcelllay: word `stc' of `macval(strowlay)'
            local stcellfmt: word `stc' of `strowfmt'
            local stcellstar: word `stc' of `strowstar'
            local cellhasstat 0
            foreach stat of local stcell {
                gettoken format stcellfmt: stcellfmt
                local rr = rownumb(`St',`"`stat'"')
                local value = `St'[`rr',`m']
                if `value'==.y {
                    local value `"`return(m`m'_`stat')'"'
                    if `"`value'"'!="" {
                        local cellhasstat 1
                        local stcelllay: subinstr local stcelllay `"`statspchar'"' ///
                        `"`value'"'
                    }
                }
                else if `value'==.x {
                    local hasmestats 1
                }
                else if `value'<.x {
                    local cellhasstat 1
                    vFormat `value' "`format'" "`lz'" `"`macval(dmarker)'"' ///
                    `"`macval(msign)'"'
                    local stcelllay: subinstr local stcelllay `"`statspchar'"' ///
                    `"`macval(value)'"'
                }
            }
            if `cellhasstat'==0 & `hasmestats' {
                local stcell: word `stc_eq' of `strow'
                local stcelllay: word `stc_eq' of `macval(strowlay)'
                local stcellfmt: word `stc_eq' of `strowfmt'
                local stcellstar: word `stc_eq' of `strowstar'
                local cellhasstat 0
                foreach stat of local stcell {
                    gettoken format stcellfmt: stcellfmt
                    local rr = rownumb(`St',`"`eq':`stat'"')
                    if `rr'>=. local value .z
                    else local value = `St'[`rr',`m']
                    if `value'!=.z {
                        local cellhasstat 1
                        vFormat `value' "`format'" "`lz'" `"`macval(dmarker)'"' ///
                         `"`macval(msign)'"'
                        local stcelllay: subinstr local stcelllay `"`statspchar'"' `"`macval(value)'"'
                    }
                }
                if `cellhasstat' local usemestats 1
            }
            if `cellhasstat'==0 local stcelllay
            file write `file' `macval(delimiter)' `fmt_m' (`"`macval(stcelllay)'"')
            if `:word `c' of `starsrow''==1 {
                if "`stcellstar'"=="1" & `cellhasstat' {
                    if `usemestats' {
                        local rr=rownumb(`St',`"`eq':p"')
                    }
                    else {
                        local rr=rownumb(`St',"p")
                    }
                    Stars `"`macval(starlevels)'"' `St'[`rr',`m']
                    file write `file' `macval(stardetach)' `fmt_stw' (`"`macval(value)'"')
                }
                else {
                    file write `file' `macval(stardetach)' _skip(`starwidth')
                }
            }
            local lastm "`m'"
            local lasteq `"`eq'"'
        }
        if `r'==`S' & "`statslabelslast'"=="" local statslabelsend
        local tmpend `"`macval(end)'"'
        if "`statslabelsreplace'"!="" {
            if `"`macval(statslabelsend)'"'!="" local tmpend
        }
        if "`smcltags'"!="" file write `file' "{txt}"
        WriteEnd `"`file'"' `"`macval(tmpend)'"' `"`macval(statslabelsend)'"'
        if `hasrtfbrdr' & `rtfbrdron' {
            StableSubinstr begin `"`macval(rtfbeginbak)'"' "@rtfrowdefbrdr" `"`rtfrowdef'"'
            local rtfbrdron 0
        }
    }

*Write postfoot
    if "`smclrules'"!="" {
        file write `file' `"`thesmclrule'"' _n
    }
    local discrete: list retok discrete
    if `"`macval(postfoot)'"'!="" {
        if index(`"`macval(postfoot)'"',`"""')==0 {
            local postfoot `"`"`macval(postfoot)'"'"'
        }
    }
    foreach line of local postfoot {
        if "`smcltags'"!="" file write `file' "{txt}"
        InsertAtVariables `"`macval(line)'"' 0 "`ncols'" `macval(atvars2)' `macval(atvars3)'
        file write `file' `"`macval(value)'"' _n
    }

*Write legend (starlevels, marginals)
    if "`legend'"!="" {
        if `"`macval(discrete2)'"'!="" {
            mat `D' = `D''*`D'
            if `D'[1,1]!=0 {
                if "`smcltags'"!="" file write `file' "{txt}"
                file write `file' `"`macval(discrete)'`macval(discrete2)'"' _n
            }
        }
        if `"`macval(starlegend)'"'!="" {
            if "`smcltags'"!="" file write `file' "{txt}"
            file write `file' `"`macval(starlegend)'"' _n
        }
    }

*Finish: copy tempfile to user file / type to screen
    file close `file'
    local S: word count `macval(substitute)'
    if `"`topfile'"'!="" {
        confirm file `"`topfile'"'
    }
    if `"`bottomfile'"'!="" {
        confirm file `"`bottomfile'"'
    }
    if `"`using'"'!="" {
        tempname file2
        file open `file2' `using', write text `replace' `append'
    }
    if "`type'"!="" di as res ""
    if `"`topfile'"'!="" {
        file open `file' using `"`topfile'"', read text
        file read `file' temp
        while r(eof)==0 {
            if `"`using'"'!="" {
                file write `file2' `"`macval(temp)'"' _n
            }
            if "`type'"!="" {
                if "`showtabs'"!="" {
                    local temp: subinstr local temp "`=char(9)'" "<T>", all
                }
                di `asis' `"`macval(temp)'"'
            }
            file read `file' temp
        }
        file close `file'
    }
    file open `file' using `"`tfile'"', read text
    file read `file' temp
    while r(eof)==0 {
        forv s = 1(2)`S' {
            local from: word `s' of `macval(substitute)'
            local to:  word `=`s'+1' of `macval(substitute)'
            if `"`macval(from)'`macval(to)'"'!="" {
                local temp: subinstr local temp `"`macval(from)'"' `"`macval(to)'"', all
            }
        }
        if `"`using'"'!="" {
            file write `file2' `"`macval(temp)'"' _n
        }
        if "`type'"!="" {
            if "`showtabs'"!="" {
                local temp: subinstr local temp "`=char(9)'" "<T>", all
            }
            di `asis' `"`macval(temp)'"'
        }
        file read `file' temp
    }
    file close `file'
    if `"`bottomfile'"'!="" {
        file open `file' using `"`bottomfile'"', read text
        file read `file' temp
        while r(eof)==0 {
            if `"`using'"'!="" {
                file write `file2' `"`macval(temp)'"' _n
            }
            if "`type'"!="" {
                if "`showtabs'"!="" {
                    local temp: subinstr local temp "`=char(9)'" "<T>", all
                }
                di `asis' `"`macval(temp)'"'
            }
            file read `file' temp
        }
        file close `file'
    }
    if `"`using'"'!="" {
        file close `file2'
        gettoken junk using0 : using
        return local fn `using0'
        if "`outfilenoteoff'"=="" {
            di as txt `"(output written to {browse `using0'})"'
        }
    }
end

program MoreOptions
// estout has more options than -syntax- can handle; a subroutine is used
// here (rather than a second syntax call) to preserve the 'using' macro
// from the first syntax call
// MoreOptions is intended for options without arguments only
    local theoptions ///
        NOOMITted OMITted ///
        NOBASElevels BASElevels ///
        NOEFORM eform ///
        NOMargin Margin ///
        NODIscrete ///
        NODROPPED dropped ///
        NOSTARDetach STARDetach ///
        NOABbrev ABbrev ///
        NOUNStack UNStack ///
        NOLZ lz ///
        NOLabel Label ///
        NOLEgend LEgend ///
        NONUMbers NUMbers ///
        NOReplace Replace ///
        NOAppend Append ///
        NOTYpe TYpe ///
        NOSHOWTABS showtabs ///
        NOASIS asis ///
        NOWRAP wrap ///
        NOSMCLTags SMCLTags ///
        NOSMCLRules SMCLRules ///
        NOSMCLMIDRules SMCLMIDRules ///
        NOSMCLEQRules SMCLEQRules ///
        NOOUTFILENOTEOFF outfilenoteoff
    syntax [, `theoptions' ]
    foreach opt of local theoptions {
        local opt = lower("`opt'")
        c_local `opt' "``opt''"
    }
    c_local options
end

program ParseValueSubopts
    syntax anything [ , mrow(string asis) NOTranspose Transpose ///
        NOStar Star PVALue(string) Fmt(string) Label(string) Vacant(string) ///
        NOPAR par PAR2(string asis) Keep(string asis) Drop(string asis) ///
        PATtern(string) NOABS abs ]
    local el: word 1 of `anything'
    local elname: word 2 of `anything'
    CheckPattern `"`pattern'"' "`elname'"
    if `"`macval(par2)'"'!="" {
        local par `"`macval(par2)'"'
    }
    else if "`par'"!="" {
        if "`elname'"=="ci" local par "[ , ]"
        else if "`elname'"=="ci_l" local par `"[ """'
        else if "`elname'"=="ci_u" local par `""" ]"'
        else local par "( )"
    }
    if `"`mrow'"'!="" {
        capt confirm integer number `mrow'
        if _rc==0 {
            if `mrow'>=1 {
                if `"`macval(label)'"'=="" {
                    local label "`elname'[`mrow']"
                }
            }
            else {
                local mrow `""`mrow'""'
                if `"`macval(label)'"'=="" {
                    local label `mrow'
                }
            }
        }
        else {
            gettoken trash : mrow, qed(qed)
            if `qed'==0 {
                local mrow `"`"`mrow'"'"'
            }
            if `"`macval(label)'"'=="" {
                local label `mrow'
            }
        }
    }
    foreach opt in transpose star par abs {
        if "`no`opt''"!="" c_local no`el'_`opt' 1
        else c_local `el'_`opt' "``opt''"
    }
    foreach opt in mrow pvalue fmt label vacant keep drop pattern {
        c_local `el'_`opt' `"`macval(`opt')'"'
    }
end

program CheckPattern
    args pattern option
    foreach p of local pattern {
        if !( "`p'"=="1" | "`p'"=="0" ) {
            di as error `""`pattern'" invalid in `option'(... pattern())"'
            exit 198
        }
    }
end

program ParseStatsSubopts
    syntax [anything] [ , Fmt(string) Labels(string asis) ///
     NOStar Star Star2(string) LAYout(string asis) PChar(string) ]
    foreach opt in fmt labels layout pchar {
        c_local stats`opt' `"`macval(`opt')'"'
    }
    if "`nostar'"!="" c_local nostatsstar 1
    else if "`star2'"!="" {
        local anything: list anything | star2
        c_local statsstar "`star2'"
    }
    else if "`star'"!="" {
        local star2: word 1 of `anything'
        c_local statsstar "`star2'"
    }
    c_local stats "`anything'"
    c_local stats2
end

prog ProcessStatslayout // returns statsarray, -rowlbls, -rowfmt, -rowstar, -colstar, -layout
    args stats statsfmt statsstar statslayout statspchar
    local format "%9.0g"
    if `"`statspchar'"'=="" {
        local statspchar "@"
        c_local statspchar "@"
    }
    local statsarray
    local statsrowlbls
    local statsrowfmt
    local statsrowstar
    local space1
    local i 0
    local wmax 0
    foreach row of local statslayout {
        local statsrow
        local statsrowlbl
        local statsrfmt
        local statsrstar
        local space2
        local w = 0
        foreach cell of local row {
            local ++w
            local statscell
            local statsclbl `"`cell'"'
            local statscfmt
            local statscstar 0
            local space3
            local trash: subinstr local cell `"`statspchar'"' "", all count(local cnt)
            forv j=1/`cnt' {
                local stat: word `++i' of `stats'
                local statscell `"`statscell'`space3'`stat'"'
                local statsclbl: subinstr local statsclbl `"`statspchar'"' "`stat'"
                local tmp: word `i' of `statsfmt'
                if `"`tmp'"'!="" local format `"`tmp'"'
                local statscfmt `"`statscfmt'`space3'`format'"'
                if `:list stat in statsstar' {
                    local statscstar 1
                    local statscol_`w' 1
                }
                local space3 " "
            }
            local statsrow `"`statsrow'`space2'"`statscell'""'
            local statsrowlbl `"`statsrowlbl'`space2'`statsclbl'"'
            local statsrfmt `"`statsrfmt'`space2'"`statscfmt'""'
            local statsrstar "`statsrstar'`space2'`statscstar'"
            local space2 " "
        }
        local statsarray `"`statsarray'`space1'`"`statsrow'"'"'
        local statsrowlbls `"`statsrowlbls'`space1'`"`statsrowlbl'"'"'
        local statsrowfmt `"`statsrowfmt'`space1'`"`statsrfmt'"'"'
        local statsrowstar `"`statsrowstar'`space1'`"`statsrstar'"'"'
        local space1 " "
        local wmax = max(`w',`wmax')
    }
    while (1) {
        local stat: word `++i' of `stats'
        if `"`stat'"'=="" continue, break
        local tmp: word `i' of `statsfmt'
        if `"`tmp'"'!="" local format `"`tmp'"'
        local statscstar: list stat in statsstar
        if `statscstar' local statscol_1 1
        local statsarray `"`statsarray'`space1'`"`stat'"'"'
        local statsrowlbls `"`statsrowlbls'`space1'`"`stat'"'"'
        local statsrowfmt `"`statsrowfmt'`space1'`"`format'"'"'
        local statsrowstar `"`statsrowstar'`space1'`"`statscstar'"'"'
        local statslayout `"`statslayout'`space1'`statspchar'"'
        local space1 " "
        local wmax = max(1,`wmax')
    }
    local statscolstar
    local space
    forv w = 1/`wmax' {
        if "`statscol_`w''"=="" local statscol_`w' 0
        local statscolstar "`statscolstar'`space'`statscol_`w''"
        local space " "
    }
    c_local statsarray   `"`statsarray'"'
    c_local statsrowlbls `"`statsrowlbls'"'
    c_local statsrowfmt  `"`statsrowfmt'"'
    c_local statsrowstar `"`statsrowstar'"'
    c_local statscolstar `"`statscolstar'"'
    c_local statslayout  `"`statslayout'"'
end

program ParseLabelsSubopts
    gettoken type 0: 0
    local lblsubopts
    syntax [anything] [ , NONUMbers NUMbers NOTItles TItles NODEPvars DEPvars ///
     NONONE NONE NOSPAN span Prefix(string) Suffix(string) Begin(string asis) ///
     End(string asis) NOReplace Replace BList(string asis) EList(string asis) ///
     ERepeat(string) NOFirst First NOLast Last lhs(string) PATtern(string) ///
     NOMerge Merge ]
    CheckPattern `"`pattern'"' "`type'"
    if "`merge'"!="" & "`nomerge'`macval(suffix)'"=="" local suffix ":"
    foreach opt in begin end {
        if `"`macval(`opt')'"'!="" {
            if index(`"`macval(`opt')'"', `"""')==0 {
                local `opt' `"`"`macval(`opt')'"'"'
            }
        }
    }
    foreach opt in prefix suffix begin end blist elist erepeat lhs pattern {
        c_local `type'`opt' `"`macval(`opt')'"'
    }
    foreach opt in numbers titles depvars span replace none first last merge {
        if "`no`opt''"!="" c_local no`type'`opt' 1
        else c_local `type'`opt' "``opt''"
    }
    c_local `type' `"`macval(anything)'"'
end

program ReadLine
    args max file
    local end 0
    file read `file' temp1
    local temp1: subinstr local temp1 "`=char(9)'" "    ", all
    while r(eof)==0 {
        local j 1
        local temp2
        local temp3: piece `j++' `max' of `"`macval(temp1)'"'
        if `"`temp3'"'=="" | index(`"`temp3'"',"*")==1 ///
         | index(`"`temp3'"',"//")==1 {
            file read `file' temp1
            local temp1: subinstr local temp1 "`=char(9)'" "    ", all
            continue
        }
        while `"`temp3'"'!="" {
            local comment=index(`"`macval(temp3)'"'," ///")
            if `comment' {
                local temp3=substr(`"`macval(temp3)'"',1,`comment')
                local temp2 `"`macval(temp2)'`macval(temp3)'"'
                local end 0
                continue, break
            }
            local comment=index(`"`macval(temp3)'"'," //")
            if `comment' {
                local temp3=substr(`"`macval(temp3)'"',1,`comment')
                local temp2 `"`macval(temp2)'`macval(temp3)'"'
                local end 1
                continue, break
            }
            local temp2 `"`macval(temp2)'`macval(temp3)'"'
            local temp3: piece `j++' `max' of `"`macval(temp1)'"'
            local end 1
        }
        if `end' {
            local line `"`macval(line)'`macval(temp2)'"'
            continue, break
        }
        else {
            local line `"`macval(line)'`macval(temp2)'"'
            file read `file' temp1
            local temp1: subinstr local temp1 "`=char(9)'" "    ", all
        }
    }
    c_local line `"`macval(line)'"'
end

program CellsCheck
    args cells
    local ncols 0
    local nrows 0
    local cells: subinstr local cells "& " "&", all
    local cells: subinstr local cells " &" "&", all
    local cells: subinstr local cells `"&""' `"& ""', all
    local cells: subinstr local cells `""&"' `"" &"', all
    foreach row of local cells {
        local newrow
        foreach col of local row {
            local vals: subinstr local col "&" " ", all
            //local vals: list vals - values
            local values: list values | vals
            local vals: list retok vals
            local vals: subinstr local vals " " "&", all
            //local newrow: list newrow | vals
            local newrow `"`newrow'`vals' "'
        }
        local newrow: list retok newrow
        if "`newrow'"!="" {
            local ncols = max(`ncols',`:list sizeof newrow')
            local newcells `"`newcells'"`newrow'" "'
            local ++nrows
        }
    }
    local newcells: list retok newcells
    c_local cells `"`newcells'"'
    c_local ncols `ncols'
    c_local nrows `nrows'
    local dot "."
    c_local values: list values - dot
end

program Star2Cells
    args cells star
    local newcells
    foreach row of local cells {
        local newrow
        foreach col of local row {
            if "`col'"=="`star'" {
                local col "`col'star"
            }
            local newrow: list newrow | col
        }
        local newcells `"`newcells'"`newrow'" "'
    }
    local newcells: list retok newcells
    c_local cells `"`newcells'"'
end

prog ParseStarlevels
    syntax [anything(equalok)] [ , Label(str) Delimiter(str) ]
    c_local starlevels `"`macval(anything)'"'
    c_local starlevelslabel `"`macval(label)'"'
    c_local starlevelsdelimiter `"`macval(delimiter)'"'
end

program CheckStarvals
    args starlevels label del
    if `"`macval(label)'"'=="" local label " p<"
    if `"`macval(del)'"'=="" local del ", "
    local nstar: word count `macval(starlevels)'
    local nstar = `nstar'/2
    capture confirm integer number `nstar'
    if _rc {
        di as error "unmatched list of significance symbols and levels"
        exit 198
    }
    local istar 1
    forv i = 1/`nstar' {
        local iistar: word `=`i'*2' of `macval(starlevels)'
        confirm number `iistar'
        if `iistar'>`istar' | `iistar'<=0 {
            di as error "significance levels out of order or out of range (0,1]"
            exit 198
        }
        local istar `iistar'
        local isym: word `=`i'*2-1' of `macval(starlevels)'
        if `"`macval(legend)'"'!="" {
            local legend `"`macval(legend)'`macval(del)'"'
        }
        local ilabel: subinstr local label "@" "`istar'", count(local hasat)
        if `hasat'==0 {
            local ilabel `"`macval(label)'`istar'"'
        }
        local legend `"`macval(legend)'`macval(isym)'`macval(ilabel)'"'
    }
    c_local starlegend `"`macval(legend)'"'
end

program Starwidth
    args starlevels
    local nstar: word count `macval(starlevels)'
    forv i = 2(2)`nstar' {
        local istar: word `=`i'-1' of `macval(starlevels)'
        local width = max(length("`width'"),length(`"`macval(istar)'"'))
    }
    c_local value `width'
end

// Loosely based on Mkemat from est_table.ado, but with heavy modifications
program _estout_getres, rclass
    syntax, names(str) [ coefs(str asis) stats(str asis) equations(str) ///
        rename(str asis) margin(str asis) meqs(str asis) ///
        dropped(int 0) level(int 95) ///
        transform(str asis)  transformpattern(str asis) ///
        omitted baselevels ]
    // coefs: coef "coef O/1 #" `"coef O/1 "rowname""' etc...

    tempname bc bbc bs bbs st

    local nnames : word count `names'
    local rename : subinstr local rename "," "", all
    if `"`stats'"' != "" {
        local stats : subinstr local stats "," "", all
        confirm names `stats'
        local stats : list uniq stats
        local nstat : list sizeof stats
        mat `bbs' = J(`nstat', `nnames', .z)
        mat colnames `bbs' = `: subinstr local names "." "active", all word'
        mat rownames `bbs' = `stats'
    }

    if "`equations'" != "" {
        MatchNames "`equations'"
        local eqspec  `r(eqspec)'
        local eqnames `r(eqnames)'
    }

    local ncoefs 0
    foreach coefn of local coefs {
        local ++ncoefs
        gettoken coef : coefn
        local coefnms `"`coefnms' `coef'"' // use more informative label? (coefn => error in Stata 8 and 10)
    }
    local bVs "b se var t z p ci_l ci_u _star _sign _sigsign"
    local hasbVs = `"`: list coefnms & bVs'"'!=""
    local hastransform = (`"`transform'"'!="") & `hasbVs'
    local getbV = cond(`hasbVs' | `dropped', "b var ", "")

    tempname hcurrent esample
    local estcycle = ("`names'"!=".")
    if `estcycle' {
        _est hold `hcurrent', restore nullok estsystem
    }

    local ni 0
    local hasbbc 0
    local ccols = `ncoefs' + ("`margin'"!="") + `dropped'
    foreach name of local names {
        local ++ni
        local hasbc 0
        local hasmargin 0
        nobreak {
            if "`name'" != "." {
                local eqname `name'
                *est_unhold `name' `esample'        // (why preserve missings in esample?)
                capt confirm new var _est_`name'    // fix e(sample) if obs have been added
                if _rc qui replace _est_`name' = 0 if _est_`name' >=.
                _est unhold `name'
            }
            else    {
                local eqname active
                if `estcycle' {
                    _est unhold `hcurrent'
                }
            }

            // get coefficients
            capture noisily break {
                CheckEqs `"`getbV'`coefs'"'                 // sets local seqmerge
                GetCoefs `bc' `seqmerge' `"`getbV'`coefs'"' // sets local hasbc
                if `hasbc' {
                    mat coln `bc' = `getbV'`coefnms'
                }
            }
            local rc = _rc

            // set equation names and get marginal effects
            if `hasbc' & `rc'==0 {
                capture noisily break {
                    if `dropped' {
                        DroppedCoefs `bc'
                    }
                    if "`equations'"!="" {
                        AdjustRowEq `bc' `ni' `nnames' "`eqspec'" "`eqnames'"
                    }
                    if "`margin'"!="" & `hasbVs' {
                        GetMarginals `bc' "`margin'" `"`meqs'"' // resets local hasmargin
                    }
                    if `hasbVs' {
                        ComputeCoefs `bc' `hasmargin' `"`coefnms'"' `level'
                    }
                    if `hastransform' & `hasbVs' {
                        if `"`transformpattern'"'!="" {
                            local transformthis: word `ni' of `transformpattern'
                        }
                        else local transformthis 1
                        if `"`transformthis'"'=="1" {
                            TransformCoefs `bc' `"`coefnms'"' `"`transform'"'
                        }
                    }
                    if "`getbV'"!="" {
                        mat `bc' = `bc'[1...,3...] // remove b and var
                    }
                }
                local rc = _rc
            }

            // get stats
            if `rc'==0 {
                capture noisily break {
                    if "`stats'" != "" {
                        GetStats "`stats'" `bbs' `ni'
                        if `hasbc'>0 & inlist(`"`e(cmd)'"', "reg3", "sureg", "mvreg") {
                            GetEQStats "`stats'" `bbs' `ni' `bc'
                        }
                        return add
                    }
                }
                local rc = _rc
            }

            local depname: word 1 of `e(depvar)'
            return local m`ni'_depname "`depname'"

            local title `"`e(estimates_title)'"'
            if `"`title'"'=="" local title `"`e(_estimates_title)'"'  // prior to Stata 10
            return local m`ni'_estimates_title `"`title'"'

            if "`name'" != "." {
                *est_hold `name' `esample'
                _est hold `name', estimates varname(_est_`name')
            }
            else {
                if `estcycle' {
                    _est hold `hcurrent', restore nullok estsystem
                }
            }
        }

        if `rc' {
            exit `rc'
        }
        
        if (c(stata_version)>=11) & (`hasbc'>0) {
            mata: estout_omitted_and_base() // sets local hasbc
        }

        if `hasbc'>0 {
            mat coleq `bc' = `eqname'
            if `"`rename'"'!="" {
                RenameCoefs `bc' `"`rename'"'
            }
            if `hasbbc' {
                mat_capp `bbc' : `bbc' `bc', miss(.z) cons ts
            }
            else {
                mat `bbc' = `bc'
                if `ni'>1 { // add previous empty models
                    mat `bc' = (1, `bc'[1,1...]) \ ( `bc'[1...,1], J(rowsof(`bc'), colsof(`bc'), .z))
                    mat `bc' = `bc'[2...,2...]
                    forv nj = 1/`ni' {
                        if `nj'==`ni' continue
                        local eqname: word `nj' of `names'
                        if `"`eqname'"'=="." {
                            local eqname active
                        }
                        mat coleq `bc' = `eqname'
                        mat `bbc' = `bc', `bbc'
                    }
                }
            }
            local hasbbc 1
        }
        else {
            if `hasbbc' { // add empty model if bbc exists
                mat `bc' = `bbc'[1...,1..`ccols']
                mat `bc' = (1, `bc'[1,1...]) \ ( `bc'[1...,1], J(rowsof(`bc'), colsof(`bc'), .z))
                mat `bc' = `bc'[2...,2...]
                mat coleq `bc' = `eqname'
                mat `bbc' = `bbc', `bc'
            }
        }
    }

    if `hasbbc' {
        return matrix coefs = `bbc'
        return scalar ccols = `ccols'
    }
    else {
        return scalar ccols = 0  // indicates that r(coefs) is missing
    }
    if "`stats'" != "" {
        return matrix stats = `bbs'
    }
    return local names `names'
    return scalar nmodels = `ni'
end

program DroppedCoefs // identify dropped coeffficients
    args bc
    tempname tmp
    mat `tmp' = `bc'[1..., 1] * 0
    mat coln `tmp' = "_dropped"
    local r = rowsof(`bc')
    forv i = 1/`r' {
        if `bc'[`i',1]==0 & `bc'[`i',2]==0 { // b=0 and var=0
            mat `tmp'[`i',1] = 1
        }
    }
    mat `bc' = `bc', `tmp'
end

program RenameCoefs
    args bc rename
    local Stata11 = cond(c(stata_version)>=11, "version 11:", "")
    tempname tmp
    local eqs: roweq `bc', q
    local eqs: list clean eqs
    local eqs: list uniq eqs
    local newnames
    foreach eq of local eqs {
        mat `tmp' = `bc'[`"`eq':"',1]
        QuotedRowNames `tmp'
        local vars `"`value'"'
        gettoken from rest : rename
        gettoken to rest : rest
        while (`"`from'`to'"'!="") {
            if index(`"`to'"',":") | `"`to'"'=="" {
                di as err "invalid rename()"
                exit 198
            }
            local hasfrom = rownumb(`tmp', `"`from'"')
            if `hasfrom'<. {
                local hasto = rownumb(`tmp', `"`to'"')
                if `hasto'<. {
                    di as err `"`to' already exists in equation; cannot rename"'
                    exit 110
                }
                local colonpos = index(`"`from'"',":")
                if index(`"`from'"',":") { // remove equation
                    gettoken chunk from : from, parse(":") // eq
                    gettoken chunk from : from, parse(":") // :
                    gettoken from : from
                    if `"`from'"'=="" {
                        di as err "invalid rename()"
                        exit 190
                    }
                }
                local vars: subinstr local vars `"`from'"' `"`"`to'"'"', word
                `Stata11' mat rown `tmp' = `vars'
            }
            gettoken from rest : rest
            gettoken to rest : rest
        }
        local newnames `"`newnames'`vars' "'
    }
    `Stata11' mat rown `bc' = `newnames'
end

// Source: est_table.ado  version 1.1.4  09oct2008  (unmodified)
program MatchNames, rclass
    args eqspec

    local eqspec  : subinstr local eqspec ":" " ", all
    local eqspec0 : subinstr local eqspec "#" "" , all

    local iterm 0
    gettoken term eqspec : eqspec0 , parse(",")
    while "`term'" != "" {
        local ++iterm

        // term = [name =] { # | #-list }
        gettoken eqname oprest: term, parse("=")
        gettoken op rest : oprest, parse("=")
        if trim(`"`op'"') == "=" {
            confirm name `eqname'
            local term `rest'
        }
        else {
            local eqname #`iterm'
        }
        local eqnames `eqnames' `eqname'

        if "`eqspec'" == "" {
            continue, break
        }
        gettoken term eqspec: eqspec , parse(",")
        assert "`term'" == ","
        gettoken term eqspec: eqspec , parse(",")
    }

    if `"`:list dups eqnames'"' != "" {
        dis as err "duplicate matched equation names"
        exit 198
    }

    return local eqspec   `eqspec0'
    return local eqnames  `eqnames'
end

// Source: est_table.ado  version 1.1.4  09oct2008
// 02oct2013: added -version 11: matrix roweq- to support new eqnames
program AdjustRowEq
    args b ni nmodel eqspec eqnames

    local beqn : roweq `b', quote
    local beqn : list clean beqn
    local beq  : list uniq beqn

    if `"`:list beq & eqnames'"' != "" {
        dis as err "option equations() invalid"
        dis as err "specified equation name already occurs in model `ni'"
        exit 198
    }

    local iterm 0
    gettoken term eqspec : eqspec , parse(",")
    while "`term'" != "" {
        // dis as txt "term:|`term'|"
        local ++iterm

        // term = [name =] { # | #-list }
        gettoken eqname oprest: term, parse("=")
        gettoken op rest : oprest, parse("=")
        if trim(`"`op'"') == "=" {
            local term `rest'
        }
        else {
            local eqname #`iterm'
        }

        local nword : list sizeof term
        if !inlist(`nword', 1, `nmodel') {
            dis as err "option equations() invalid"
            dis as err "a term should consist of either 1 or `nmodel' equation numbers"
            exit 198
        }
        if `nword' > 1 {
            local term  : word `ni' of `term'
        }

        if trim("`term'") != "." {
            capt confirm integer number `term'
            if _rc {
                dis as err "option equations() invalid"
                dis as err "`term' was found, while an integer equation number was expected"
                exit 198
            }
            if !inrange(`term',1,`:list sizeof beq') {
                dis as err "option equations() invalid"
                dis as err "equation number `term' for model `ni' out of range"
                exit 198
            }
            if `:list posof "`eqname'" in beq' != 0 {
                dis as err "impossible to name equation `eqname'"
                dis as err "you should provide (another) equation name"
                exit 198
            }

            local beqn : subinstr local beqn  ///
                `"`:word `term'  of `beq''"'    ///
                "`eqname'" , word all
        }

        if "`eqspec'" == "" {
            continue, break
        }
        gettoken term eqspec: eqspec , parse(",")
        assert "`term'" == ","
        gettoken term eqspec: eqspec , parse(",")
    }
    if c(stata_version)>=11 { // similar to RenameCoefs
        version 11: matrix roweq `b' = `beqn'
    }
    else {
        matrix roweq `b' = `beqn'
    }
end

// Source: est_table.ado  version 1.1.4  09oct2008  (modified)
// Modification: returns string scalars in r(m`ni'_name) (and sets `bbs' = .y)
program GetStats, rclass
    args stats bbs ni
    tempname rank st V
    local escalars : e(scalars)
    local emacros : e(macros)
    local is 0
    foreach stat of local stats {
        local ++is
        if inlist("`stat'", "aic", "bic", "rank") {
            if "`hasrank'" == "" {
                capt mat `V' = syminv(e(V))
                local rc = _rc
                if `rc' == 0 {
                    scalar `rank' = colsof(`V') - diag0cnt(`V')
                }
                else if `rc' == 111 {
                    scalar `rank' = 0
                }
                else {
                    // rc<>0; show error message
                    mat `V' = syminv(e(V))
                }
                local hasrank 1
            }
            if "`stat'" == "aic" {
                scalar `st' = -2*e(ll) + 2*`rank'
            }
            else if "`stat'" == "bic" {
                scalar `st' = -2*e(ll) + log(e(N)) * `rank'
            }
            else if "`stat'" == "rank" {
                scalar `st' = `rank'
            }
        }
        else {
            if `:list stat in escalars' > 0 {
                scalar `st' = e(`stat')
            }
            else if "`stat'"=="p" {
                if e(F)<. {
                    scalar `st' = Ftail(e(df_m), e(df_r), e(F))
                }
                else if e(chi2)<. {
                    scalar `st' = chi2tail(e(df_m), e(chi2))
                }
            }
            else if `:list stat in emacros' > 0 {
                scalar `st' = .y
                capt return local m`ni'_`stat' `"`e(`stat')'"'  // name might be too long
            }
            else {
                scalar `st' = .z
            }
        }
        mat `bbs'[`is',`ni'] = `st'
    }
end

program GetEQStats, rclass  // eq-specific stats for reg3, sureg, and mvreg (sets `bbs' = .x)
    args stats bbs ni bc
    return add
    tempname addrow
    local ic "aic bic rank"
    local eqs: roweq `bc', q
    local eqs: list clean eqs
    local eqs: list uniq eqs
    local s 0
    foreach stat of local stats {
        local ++s
        if inlist(`"`stat'"', "aic", "bic", "rank") continue
        if `bbs'[`s',`ni']<.y  continue
        local e 0
        local found 0
        foreach eq of local eqs {
            local ++e
            if e(cmd)=="mvreg" {
                if "`stat'"=="p" local value: word `e' of `e(p_F)'
                else local value: word `e' of `e(`stat')'
            }
            else if "`stat'"=="df_m" {
                local value `"`e(`stat'`e')'"'
            }
            else {
                local value `"`e(`stat'_`e')'"'
            }
            capture confirm number `value'
            if _rc==0 {
                local found 1
                local r = rownumb(`bbs', `"`eq':`stat'"')
                if `r'>=. {
                    mat `addrow' = J(1, colsof(`bbs'), .z)
                    mat rown `addrow' = `"`eq':`stat'"'
                    mat `bbs' = `bbs' \ `addrow'
                    local r = rownumb(`bbs', `"`eq':`stat'"')
                }
                mat `bbs'[`r',`ni'] = `value'
            }
        }
        if `found' {
            if `bbs'[`s',`ni']==.y {
                capt return local m`ni'_`stat' ""
            }
            mat `bbs'[`s',`ni'] = .x
        }
    }
end

program CheckEqs
    args coefs
    tempname tmp
    local j 0
    local bVs "b _star _sign _sigsign"
    local seqmerge 0
    local hasseqs 0
    foreach coefn in `coefs' {
        local ++j
        gettoken coef row : coefn
        gettoken transpose row : row
        gettoken row : row, q
        if `"`coef'"'=="b" & `j'==1 {
            capt confirm mat e(`coef')
            if _rc continue
            mat `tmp' = e(`coef')
            local eqs: coleq `tmp', q
            if `:list posof "_" in eqs'==0 {
                local seqmerge 1
            }
            else continue, break
        }
        if `:list coef in bVs' continue
        capt confirm mat e(`coef')
        if _rc continue
        mat `tmp' = e(`coef')
        if `transpose' {
            mat `tmp' = `tmp''
        }
        if `"`row'"'=="" local row 1
        capt confirm number `row'
        if _rc {
            local row = rownumb(`tmp',`row')
        }
        if `row'>rowsof(`tmp') continue
        local eqs: coleq `tmp', q
        if `:list posof "_" in eqs' {
            local eqs: list uniq eqs
            local eqs: list clean eqs
            if `"`eqs'"'!="_" { // => contains "_" but also others
                local local seqmerge 0
                continue, break
            }
            else local hasseqs 1
        }
        else {
            local seqmerge 1
        }
    }
    if `hasseqs'==0 local seqmerge 0
    c_local seqmerge `seqmerge'
end

program GetCoefs
    args bc seqmerge coefs
    tempname tmp
    local hasbc 0
    local j 0
    local bVs "b _star _sign _sigsign"
    foreach coefn of local coefs {
        local ++j
        gettoken coef row : coefn
        gettoken transpose row : row
        gettoken row : row, q
        local isinbVs: list coef in bVs
        if `isinbVs' & `j'>2 {
            if `hasbc'==0  continue
            mat `bc' = `bc', J(rowsof(`bc'),1, .y)
            continue
        }
        if `j'==2 & `"`coef'"'=="var" {
            local isinbVs 1
            capt mat `tmp' = vecdiag(e(V))
            if _rc {
                capt confirm mat e(se)
                if _rc==0 {
                    mat `tmp' = e(se)
                    forv i = 1/`=colsof(`tmp')' {
                        mat `tmp'[1, `i'] = `tmp'[1, `i']^2
                    }
                }
            }
        }
        else {
            capt confirm mat e(`coef')
            if _rc==0 {
                mat `tmp' = e(`coef')
            }
        }
        if _rc {
            if `hasbc'==0  continue
            mat `bc' = `bc', J(rowsof(`bc'),1, .y)
            continue
        }
        if `isinbVs'==0 { // => not b or var
            if `transpose' {
                mat `tmp' = `tmp''
            }
            if `"`row'"'=="" local row 1
            capt confirm number `row'
            if _rc {
                local row = rownumb(`tmp',`row')
            }
            if `row'>rowsof(`tmp') {
                if `hasbc'==0  continue
                mat `bc' = `bc', J(rowsof(`bc'),1, .y)
                continue
            }
            mat `tmp' = `tmp'[`row', 1...]
        }
        local bcols = colsof(`tmp')
        if `bcols'==0 {
            if `hasbc'==0  continue
            mat `bc' = `bc', J(rowsof(`bc'),1, .y)
            continue
        }
        mat `tmp' = `tmp''
        if `seqmerge' & `isinbVs'==0 {
            local eqs: roweq `tmp', q
            local eqs: list uniq eqs
            local eqs: list clean eqs
            if `"`eqs'"'=="_" {
                local seqmergejs `seqmergejs' `j'
                local seqmergecoefs `"`seqmergecoefs'`"`coefn'"' "'
                if `hasbc'==0  continue
                mat `bc' = `bc', J(rowsof(`bc'),1, .y)
                continue
            }
        }
        if `hasbc'==0 {
            mat `bc' = `tmp'
            local hasbc 1
            if `j'>1 {
                mat `bc' = `bc', J(`bcols',`j'-1, .y), `bc'
                mat `bc' = `bc'[1...,2...]
            }
        }
        else {
            mat_capp `bc' : `bc' `tmp', miss(.y) cons ts
        }
    }
    foreach coefn of local seqmergecoefs {
        gettoken j seqmergejs : seqmergejs
        gettoken coef row : coefn
        gettoken transpose row : row
        gettoken row : row, q
        mat `tmp' = e(`coef')
        if `transpose' {
            mat `tmp' = `tmp''
        }
        if `"`row'"'=="" local row 1
        capt confirm number `row'
        if _rc {
            local row = rownumb(`tmp',`row')
        }
        mat `tmp' = `tmp'[`row', 1...]
        SEQMerge `bc' `j' `tmp'
    }
    c_local hasbc `hasbc'
end

program SEQMerge
    args bc j x
    tempname tmp
    local r = rowsof(`bc')
    forv i = 1/`r' {
        mat `tmp' = `bc'[`i',1...]
        local v: rown `tmp'
        local c = colnumb(`x', `"`v'"')
        if `c'<. {
            mat `bc'[`i',`j'] = `x'[1,`c']
        }
    }
end

program ComputeCoefs
    args bc hasmargin coefs level
    local bVs1 "b _star _sign _sigsign"
    local bVs2 "se var t z p ci_l ci_u"
    local c = colsof(`bc')
    forv j = 3/`c' {
        gettoken v coefs : coefs
        if `"`v'"'=="" continue, break
        if `: list v in bVs1' {
            ComputeCoefs_`v' `bc' `j' `level'
            continue
        }
        if `: list v in bVs2' {
            if `hasmargin' {
                ComputeCoefs_`v' `bc' `j' `level'
                continue
            }
            capt confirm matrix e(`v')
            if _rc {
                ComputeCoefs_`v' `bc' `j' `level'
            }
        }
    }
end

program CopyColFromTo
    args m from to cname
    tempname tmp
    mat `tmp' = `m'[1...,`from']
    mat coln `tmp' = `cname'
    local c = colsof(`m')
    if `to'==`c' {
        mat `m' = `m'[1...,1..`c'-1], `tmp'
        exit
    }
    mat `m' = `m'[1...,1..`to'-1], `tmp', `m'[1...,`to'+1..`c']
end

program ComputeCoefs_b
    args bc j
    CopyColFromTo `bc' 1 `j' "b"
end

program ComputeCoefs_se
    args bc j
    local r = rowsof(`bc')
    forv i = 1/`r' {
            local var `bc'[`i',2]
            local res `bc'[`i',`j']
            if `var'>=.      mat `res' = `var'
            else if `var'==0 mat `res' = .
            else             mat `res' = sqrt(`var')
    }
end

program ComputeCoefs_var
    args bc j
    CopyColFromTo `bc' 2 `j' "var"
end

program ComputeCoefs_t
    args bc j
    local r = rowsof(`bc')
    forv i = 1/`r' {
            local b   `bc'[`i',1]
            local var `bc'[`i',2]
            local res `bc'[`i',`j']
            if `b'>=.        mat `res' = `b'
            else if `var'>=. mat `res' = `var'
            else             mat `res' = `b'/sqrt(`var')
    }
end

program ComputeCoefs_z
    ComputeCoefs_t `0'
end

program ComputeCoefs_p
    args bc j
    local r = rowsof(`bc')
    local df_r = e(df_r)
    if `"`e(mi)'"'=="mi" { // get df_mi
        capt confirm matrix e(df_mi)
        if _rc==0 {
            tempname dfmi
            matrix `dfmi' = e(df_mi)
        }
    }
    forv i = 1/`r' {
            local b   `bc'[`i',1]
            local var `bc'[`i',2]
            local res `bc'[`i',`j']
            if `b'>=.        mat `res' = `b'
            else if `var'>=. mat `res' = `var'
            else if "`dfmi'"!="" {
                mat `res' = ttail(`dfmi'[1,`i'],abs(`b'/sqrt(`var'))) * 2
            }
            else if `df_r'<. mat `res' = ttail(`df_r',abs(`b'/sqrt(`var'))) * 2
            else             mat `res' = (1 - norm(abs(`b'/sqrt(`var')))) * 2
    }
end

program ComputeCoefs_ci_l
    args bc j
    ComputeCoefs_ci - `0'
end

program ComputeCoefs_ci_u
    args bc j
    ComputeCoefs_ci + `0'
end

program ComputeCoefs_ci
    args sign bc j level
    local r = rowsof(`bc')
    local df_r = e(df_r)
    if `"`e(mi)'"'=="mi" { // get df_mi
        capt confirm matrix e(df_mi)
        if _rc==0 {
            tempname dfmi
            matrix `dfmi' = e(df_mi)
        }
    }
    forv i = 1/`r' {
            local b   `bc'[`i',1]
            local var `bc'[`i',2]
            local res `bc'[`i',`j']
            if `b'>=.        mat `res' = `b'
            else if `var'>=. mat `res' = `var'
            else if "`dfmi'"!="" {
                mat `res' = `b' `sign' ///
                    invttail(`dfmi'[1,`i'],(100-`level')/200) * sqrt(`var')
            }
            else if `df_r'<. mat `res' = `b' `sign' ///
                                invttail(`df_r',(100-`level')/200) * sqrt(`var')
            else             mat `res' = `b' `sign' ///
                                invnorm(1-(100-`level')/200) * sqrt(`var')
    }
end

program ComputeCoefs__star
    args bc j
    CopyColFromTo `bc' 1 `j' "_star"
end

program ComputeCoefs__sign
    args bc j
    CopyColFromTo `bc' 1 `j' "_sign"
end

program ComputeCoefs__sigsign
    args bc j
    CopyColFromTo `bc' 1 `j' "_sigsign"
end

program GetMarginals
    args bc margin meqs
    tempname D dfdx
    mat `D' = `bc'[1...,1]*0
    mat coln `D' = "_dummy"
    local type `e(Xmfx_type)'
    if "`type'"!="" {
        mat `dfdx' = e(Xmfx_`type')
        capture confirm matrix e(Xmfx_se_`type')
        if _rc==0 {
            mat `dfdx' = `dfdx' \ e(Xmfx_se_`type')
        }
        if "`e(Xmfx_discrete)'"=="discrete" local dummy `e(Xmfx_dummy)'
    }
    else if "`e(cmd)'"=="dprobit" {
        mat `dfdx' = e(dfdx) \ e(se_dfdx)
        local dummy `e(dummy)'
    }
    else if "`e(cmd)'"=="tobit" & inlist("`margin'","u","c","p") {
        capture confirm matrix e(dfdx_`margin')
        if _rc==0 {
            mat `dfdx' = e(dfdx_`margin') \ e(se_`margin')
        }
        local dummy `e(dummy)'
    }
    else if "`e(cmd)'"=="truncreg" {
        capture confirm matrix e(dfdx)
        if _rc==0 {
            tempname V se
            mat `V' = e(V_dfdx)
            forv k= 1/`=rowsof(`V')' {
                mat `se' = nullmat(`se') , sqrt(`V'[`k',`k'])
            }
            mat `dfdx' = e(dfdx) \ `se'
        }
    }
    capture confirm matrix `dfdx'
    if _rc==0 {
        QuotedRowNames `bc'
        local rnames `"`value'"'
        if `"`meqs'"'!="" local reqs: roweq `bc', q
        local i 1
        foreach row of loc rnames {
            if `"`meqs'"'!="" {
                local eq: word `i' of `reqs'
            }
            local col = colnumb(`dfdx',"`row'")
            if `col'>=. | !`:list eq in meqs' {
                mat `bc'[`i',1] = .y
                mat `bc'[`i',2] = .y
            }
            else {
                mat `bc'[`i',1] =`dfdx'[1,`col']
                mat `bc'[`i',2] = (`dfdx'[2,`col'])^2
                if "`:word `col' of `dummy''"=="1" mat `D'[`i',1] = 1
            }
            local ++i
        }
        c_local hasmargin 1
    }
    mat `bc' = `bc', `D'
end

program TransformCoefs
    args bc coefs transform
    local c = colsof(`bc')
    forv j = 3/`c' {
        gettoken v coefs : coefs
        if inlist("`v'", "b", "ci_l", "ci_u") {
            _TransformCoefs `bc' `j' 0 "" "" `"`transform'"'
        }
        else if "`v'"=="se" {
            _TransformCoefs `bc' `j' 1 "abs" "" `"`transform'"'
        }
        else if "`v'"=="var" {
            _TransformCoefs `bc' `j' 1 "" "^2" `"`transform'"'
        }
    }
end

program _TransformCoefs
    args bc j usedf abs sq transform
    local r = rowsof(`bc')
    gettoken coef rest : transform
    gettoken f rest : rest
    gettoken df rest : rest
    while `"`coef'`f'`df'"'!="" {
        if `"`df'`rest'"'=="" { // last element of list may be without coef
            local df   `"`f'"'
            local f    `"`coef'"'
            local coef ""
        }
        local trcoefs `"`trcoefs'`"`coef'"' "'
        if `usedf' {
            local trs `"`trs'`"`df'"' "'
        }
        else {
            local trs `"`trs'`"`f'"' "'
        }
        gettoken coef rest : rest
        gettoken f rest : rest
        gettoken df rest : rest
    }
    local trs : subinstr local trs  "@" "\`b'", all
    forv i = 1/`r' {
        gettoken coef coefrest : trcoefs
        gettoken tr trrest : trs
        while `"`coef'`tr'"'!="" {
            MatchCoef `"`coef'"' `bc' `i'
            if `match' {
                if `usedf' {
                    local b   `bc'[`i',1]
                    local res `bc'[`i',`j']
                    if `res'<. {
                        mat `res' = `res' * `abs'(`tr')`sq'
                    }
                }
                else {
                    local b `bc'[`i',`j']
                    if `b'<. {
                        mat `b' = (`tr')
                    }
                }
                continue, break
            }
            gettoken coef coefrest : coefrest
            gettoken tr trrest : trrest
        }
    }
end

program MatchCoef
    args eqx b i
    if inlist(trim(`"`eqx'"'),"","*") {
        c_local match 1
        exit
    }
    tempname tmp
    mat `tmp' = `b'[`i',1...]
    local eqi: roweq `tmp'
    local xi: rown `tmp'
    gettoken eq x : eqx, parse(:)
    local eq: list clean eq
    if `"`eq'"'==":" {    // case 1: ":[varname]"
        local eq
    }
    else if `"`x'"'=="" { // case 2: "varname"
        local x `"`eq'"'
        local eq
    }
    else {                // case 3. "eqname:[varname]"
        gettoken colon x : x, parse(:)
        local x: list clean x
    }
    if `"`eq'"'=="" local eq "*"
    if `"`x'"'=="" local x "*"
    c_local match = match(`"`eqi'"', `"`eq'"') & match(`"`xi'"', `"`x'"')
end

program NumberMlabels
    args M mlabels
    forv m = 1/`M' {
        local num "(`m')"
        local lab: word `m' of `macval(mlabels)'
        if `"`macval(lab)'"'!="" {
            local lab `"`num' `macval(lab)'"'
        }
        else local lab `num'
        local labels `"`macval(labels)'`"`macval(lab)'"' "'
    }
    c_local mlabels `"`macval(labels)'"'
end

program ModelEqCheck
    args B eq m ccols
    tempname Bsub
    mat `Bsub' = `B'["`eq':",(`m'-1)*`ccols'+1]
    local R = rowsof(`Bsub')
    local value 0
    forv r = 1/`R' {
        if `Bsub'[`r',1]<. {
            local value 1
            continue, break
        }
    }
    c_local value `value'
end

program Add2Vblock
    args block col
    foreach v of local col {
        gettoken row block: block
        local row "`row' `v'"
        local row: list retok row
        local vblock `"`vblock'"`row'" "'
    }
    c_local vblock `"`vblock'"'
end

program CountNofEqs
    args ms es
    local m0 0
    local e0 0
    local i 0
    local eqs 0
    foreach m of local ms {
        local ++i
        local e: word `i' of `es'
        if `m'!=`m0' | `e'!=`e0' {
            local ++eqs
        }
        local m0 `m'
        local e0 `e'
    }
    c_local value `eqs'
end

program InsertAtVariables
    args value type span M E width hline rtf rtfrowdefbrdrt rtfrowdefbrdrb rtfrowdef rtfemptyrow ///
        title note discrete starlegend
    if `type'==1 local atvars span
    else {
        local atvars span M E width hline
        if `rtf' local atvars `atvars' rtfrowdefbrdrt rtfrowdefbrdrb rtfrowdef rtfemptyrow
        if `type'!=2  local atvars `atvars' title note discrete starlegend
    }
    foreach atvar of local atvars {
        StableSubinstr value `"`macval(value)'"' "@`atvar'" `"`macval(`atvar')'"' all
    }
    c_local value `"`macval(value)'"'
end

program Abbrev
    args width value abbrev
    if "`abbrev'"!="" {
        if `width'>32 {
            local value = substr(`"`macval(value)'"',1,`width')
        }
        else if `width'>0 {
            if length(`"`macval(value)'"')>`width' {
                local value = abbrev(`"`macval(value)'"',`width')
            }
        }
    }
    c_local value `"`macval(value)'"'
end

program MgroupsPattern
    args mrow pattern
    local i 0
    local m0 0
    local j 0
    foreach m of local mrow {
        if `m'>=. {
            local newpattern `newpattern' .
            continue
        }
        if `m'!=`m0' {
            local p: word `++i' of `pattern'
            if `i'==1 local p 1
            if "`p'"=="1" local j = `j' + 1
        }
        local newpattern `newpattern' `j'
        local m0 `m'
    }
    c_local mgroupspattern `newpattern'
end

program WriteCaption
    args file delimiter stardetach row rowtwo labels starsrow span  ///
     abbrev colwidth delwidth starwidth repeat prefix suffix
    local c 0
    local nspan 0
    local c0 2
    local spanwidth -`delwidth'
    local spanfmt
    local ncolwidth: list sizeof colwidth
    foreach r of local row {
        local rtwo: word `++c' of `rowtwo'
        local colwidthj: word `=1+mod(`c'-1,`ncolwidth')' of `colwidth'
        if `colwidthj'>0 local colfmt "%`colwidthj's"
        else local colfmt
        if "`r'"=="." {
            local ++c0
            file write `file' `macval(delimiter)' `colfmt' (`""')
        }
        else if `"`span'"'=="" {
            if ( "`r'"!="`lastr'" | "`rtwo'"!="`lastrtwo'" | `"`rowtwo'"'=="" ) {
                local value: word `r' of `macval(labels)'
                Abbrev `colwidthj' `"`macval(value)'"' "`abbrev'"
                local value `"`macval(prefix)'`macval(value)'`macval(suffix)'"'
                InsertAtVariables `"`macval(value)'"' 1 "1"
            }
            else local value
            file write `file' `macval(delimiter)' `colfmt' (`"`macval(value)'"')
            if `:word `c' of `starsrow''==1 {
                file write `file' `macval(stardetach)' _skip(`starwidth')
            }
            local lastr "`r'"
            local lastrtwo "`rtwo'"
        }
        else {
            local ++nspan
            local spanwidth=`spanwidth'+`colwidthj'+`delwidth'
            if `:word `c' of `starsrow''==1 {
                local spanwidth = `spanwidth' + `starwidth'
                if `"`macval(stardetach)'"'!="" {
                    local ++nspan
                    local spanwidth = `spanwidth' + `delwidth'
                }
            }
            local nextrtwo: word `=`c'+1' of `rowtwo'
            local nextr: word `=`c'+1' of `row'
            if "`r'"!="." & ///
             ("`r'"!="`nextr'" | "`rtwo'"!="`nextrtwo'" | `"`rowtwo'"'=="") {
                local value: word `r' of `macval(labels)'
                Abbrev `spanwidth' `"`macval(value)'"' "`abbrev'"
                local value `"`macval(prefix)'`macval(value)'`macval(suffix)'"'
                InsertAtVariables `"`macval(value)'"' 1 "`nspan'"
                if `spanwidth'>0 local spanfmt "%-`spanwidth's"
                file write `file' `macval(delimiter)' `spanfmt' (`"`macval(value)'"')
                InsertAtVariables `"`macval(repeat)'"' 1 "`c0'-`=`c0'+`nspan'-1'"
                local repeatlist `"`macval(repeatlist)'`macval(value)'"'
                local c0 = `c0' + `nspan'
                local nspan 0
                local spanwidth -`delwidth'
            }
        }
    }
    c_local value `"`macval(repeatlist)'"'
end

program WriteBegin
    args file pre begin post
    foreach line of local pre {
        file write `file' `newline' `"`macval(line)'"'
        local newline _n
    }
    file write `file' `macval(begin)' `macval(post)'
end

program WriteEnd
    args file end post post2
    file write `file' `macval(end)'
    WriteStrLines `"`file'"' `"`macval(post)'"'
    WriteStrLines `"`file'"' `"`macval(post2)'"'
    file write `file' _n
end

program WriteStrLines
    args file lines
    foreach line of local lines {
        file write `file' `newline' `"`macval(line)'"'
        local newline _n
    }
end

program WriteEqrow
    args file delimiter stardetach value row span vwidth fmt_v ///
     abbrev mwidth delwidth starwidth prefix suffix ///
     haslabcol2 labcolwidth fmt_l2
    local nspan 1
    local spanwidth `vwidth'
    local spanfmt
    local c 0
    local nmwidth: list sizeof mwidth
    if `"`span'"'=="" {
        Abbrev `vwidth' `"`macval(value)'"' "`abbrev'"
        local value `"`macval(prefix)'`macval(value)'`macval(suffix)'"'
        InsertAtVariables `"`macval(value)'"' 1 "1"
        file write `file' `fmt_v' (`"`macval(value)'"')
        if `haslabcol2' {
            file write `file' `macval(delimiter)' `fmt_l2' ("")
        }
        foreach r of local row {
            local mwidthj: word `=1+mod(`c++',`nmwidth')' of `mwidth'
            if `mwidthj'>0 local fmt_m "%`mwidthj's"
            else local fmt_m
            file write `file' `macval(delimiter)' `fmt_m' ("")
            if `r'==1 {
                file write `file' `macval(stardetach)' _skip(`starwidth')
            }
        }
    }
    else {
        if `haslabcol2' {
            local ++nspan
            local spanwidth = `spanwidth' + `delwidth' + `labcolwidth'
        }
        foreach r of local row {
            local mwidthj: word `=1+mod(`c++',`nmwidth')' of `mwidth'
            local ++nspan
            local spanwidth = `spanwidth' + `delwidth' + `mwidthj'
            if `r'==1 {
                local spanwidth = `spanwidth' + `starwidth'
                if `"`macval(stardetach)'"'!="" {
                    local ++nspan
                    local spanwidth = `spanwidth' + `delwidth'
                }
            }
        }
        Abbrev `spanwidth' `"`macval(value)'"' "`abbrev'"
        local value `"`macval(prefix)'`macval(value)'`macval(suffix)'"'
        InsertAtVariables `"`macval(value)'"' 1 "`nspan'"
        if `spanwidth'>0 local spanfmt "%-`spanwidth's"
        file write `file' `spanfmt' (`"`macval(value)'"')
    }
end

prog WriteStrRow
    args file mrow eqrow neq labels delimiter stardetach starsrow  ///
     abbrev colwidth delwidth starwidth
    local c 0
    local ncolwidth: list sizeof colwidth
    foreach mnum of local mrow {
        local eqnum: word `++c' of `eqrow'
        local colwidthj: word `=1+mod(`c'-1,`ncolwidth')' of `colwidth'
        if `colwidthj'>0 local colfmt "%`colwidthj's"
        else local colfmt
        if "`mnum'"=="." {
            file write `file' `macval(delimiter)' `colfmt' (`""')
            continue
        }
        if ( "`mnum'"!="`lastmnum'" | "`eqnum'"!="`lasteqnum'" ) {
            local value: word `=(`mnum'-1)*`neq'+`eqnum'' of `macval(labels)'
            Abbrev `colwidthj' `"`macval(value)'"' "`abbrev'"
        }
        else local value
        file write `file' `macval(delimiter)' `colfmt' (`"`macval(value)'"')
        if `:word `c' of `starsrow''==1 {
            file write `file' `macval(stardetach)' _skip(`starwidth')
        }
        local lastmnum "`mnum'"
        local lasteqnum "`eqnum'"
    }
end

program VarInList
    args var unstack eqvar eq list
    local value
    local L: word count `macval(list)'
    forv l = 1(2)`L' {
        local lvar: word `l' of `macval(list)'
        local lab: word `=`l'+1' of `macval(list)'
        if "`unstack'"!="" {
            if `"`var'"'==`"`lvar'"' {
                local value `"`macval(lab)'"'
                continue, break
            }
        }
        else {
            if inlist(`"`lvar'"',`"`var'"',`"`eqvar'"',`"`eq':"') {
                local value `"`macval(lab)'"'
                continue, break
            }
        }
    }
    c_local value `"`macval(value)'"'
end

program vFormat
    args value fmt lz dmarker msign par
    if substr(`"`fmt'"',1,1)=="a" {
        SignificantDigits `fmt' `value'
    }
    else {
        capt confirm integer number `fmt'
        if !_rc {
            local fmt %`=`fmt'+9'.`fmt'f
        }
    }
    else if `"`fmt'"'=="%g" | `"`fmt'"'=="g" local fmt "%9.0g"
    else if substr(`"`fmt'"',1,1)!="%" {
        di as err `"`fmt': invalid format"'
        exit 198
    }
    local value: di `fmt' `value'
    local value: list retok value
    if "`lz'"=="" {
        if index("`value'","0.")==1 | index("`value'","-0.") {
            local value: subinstr local value "0." "."
        }
    }
    if `"`macval(dmarker)'"'!="" {
        if "`: set dp'"=="comma" local dp ,
        else local dp .
        local val: subinstr local value "`dp'" `"`macval(dmarker)'"'
    }
    else local val `"`value'"'
    if `"`msign'"'!="" {
        if index("`value'","-")==1 {
            local val: subinstr local val "-" `"`macval(msign)'"'
        }
    }
    if `"`par'"'!="" {
        tokenize `"`macval(par)'"'
        local val `"`macval(1)'`macval(val)'`macval(2)'"'
    }
    c_local value `"`macval(val)'"'
end

program SignificantDigits // idea stolen from outreg2.ado
    args fmt value
    local d = substr("`fmt'", 2, .)
    if `"`d'"'=="" local d 3
    capt confirm integer number `d'
    if _rc {
        di as err `"`fmt': invalid format"'
        exit 198
    }
// missing: format does not matter
    if `value'>=. local fmt "%9.0g"
// integer: print no decimal places
    else if (`value'-int(`value'))==0 {
        local fmt "%12.0f"
    }
// value in (-1,1): display up to 9 decimal places with d significant
// digits, then switch to e-format with d-1 decimal places
    else if abs(`value')<1 {
        local right = -int(log10(abs(`value'-int(`value')))) // zeros after dp
        local dec = max(1,`d' + `right')
        if `dec'<=9 {
            local fmt "%12.`dec'f"
        }
        else {
            local fmt "%12.`=min(9,`d'-1)'e"
        }
    }
// |values|>=1: display d+1 significant digits or more with at least one
// decimal place and up to nine digits before the decimal point, then
// switch to e-format
    else {
        local left = int(log10(abs(`value'))+1) // digits before dp
        if `left'<=9 {
            local fmt "%12.`=max(1,`d' - `left' + 1)'f"
        }
        else {
            local fmt "%12.0e" // alternatively: "%12.`=min(9,`d'-1)'e"
        }
    }
    c_local fmt "`fmt'"
end

program Stars
    args starlevels P
    if inrange(`P',0,1) {
        local nstar: word count `macval(starlevels)'
        forv i=1(2)`nstar' {
            local istarsym: word `i' of `macval(starlevels)'
            local istar: word `=`i'+1' of `macval(starlevels)'
            if `istar'<=`P' continue, break
            local value "`macval(istarsym)'"
        }
    }
    c_local value `"`macval(value)'"'
end

program CellStars
    args starlevels P par
    Stars `"`macval(starlevels)'"' `P'
    if `"`par'"'!="" {
        tokenize `"`macval(par)'"'
        local value `"`macval(1)'`macval(value)'`macval(2)'"'
    }
    c_local value `"`macval(value)'"'
end

prog MakeSign
    args value msign par starlevels P
    if "`P'"!="" {
        local factor = 0
        while 1 {
            gettoken istar starlevels : starlevels
            gettoken istar starlevels : starlevels
            if `"`istar'"'=="" continue, break
            if `P'<`istar' local factor = `factor' + 1
            else if `istar'==1 local factor = 1
        }
    }
    else local factor 1
    if `"`macval(msign)'"'=="" local msign "-"
    if `value'<0 {
        local val: di _dup(`factor') `"`macval(msign)'"'
    }
    else if `value'==0 local val: di _dup(`factor') "0"
    else if `value'>0 & `value'<. local val: di _dup(`factor') "+"
    else local val `value'
    if `"`par'"'!="" {
        tokenize `"`macval(par)'"'
        local val `"`macval(1)'`macval(val)'`macval(2)'"'
    }
    c_local value `"`macval(val)'"'
end

program DropOrKeep
    args type b spec // type=0: drop; type=1: keep
    capt confirm matrix `b'
    if _rc {
        exit
    }
    tempname res bt
    local R = rowsof(`b')
    forv i=1/`R' {
        local hit 0
        mat `bt' = `b'[`i',1...]
        foreach sp of local spec {
            if rownumb(`bt', `"`sp'"')==1 {
                local hit 1
                continue, break
            }
        }
        if `hit'==`type' mat `res' = nullmat(`res') \ `bt'
    }
    capt mat drop `b'
    capt mat rename `res' `b'
end

program Order
    args b spec
    capt confirm matrix `b'
    if _rc {
        exit
    }
    tempname bt res
    local eqlist: roweq `b', q
    local eqlist: list uniq eqlist
    mat `bt' = `b'
    gettoken spi rest : spec
    while `"`spi'"'!="" {
        gettoken spinext rest : rest
        if !index(`"`spi'"',":") {
            local vars `"`vars'`"`spi'"' "'
            if `"`spinext'"'!="" & !index(`"`spinext'"',":") {
                local spi `"`spinext'"'
                continue
            }
            foreach eq of local eqlist {
                foreach var of local vars {
                    local splist `"`splist'`"`eq':`var'"' "'
                }
                local splist `"`splist'`"`eq':"' "' // rest
            }
            local vars
        }
        else local splist `"`spi'"'
        gettoken sp splist : splist
        while `"`sp'"'!="" {
            local isp = rownumb(`bt', "`sp'")
            if `isp' >= . {
                gettoken sp splist : splist
                continue
            }
            while `isp' < . {
                mat `res' = nullmat(`res') \ `bt'[`isp',1...]
                local nb = rowsof(`bt')
                if `nb' == 1 { // no rows left in `bt'
                    capt mat drop `b'
                    capt mat rename `res' `b'
                    exit
                }
                if `isp' == 1 {
                    mat `bt' = `bt'[2...,1...]
                }
                else if `isp' == `nb' {
                    mat `bt' = `bt'[1..`=`nb'-1',1...]
                }
                else {
                    mat `bt' = `bt'[1..`=`isp'-1',1...] \ `bt'[`=`isp'+1'...,1...]
                }
                local isp = rownumb(`bt', "`sp'")
            }
            gettoken sp splist : splist
        }
        local spi `"`spinext'"'
    }
    capt mat `res' = nullmat(`res') \ `bt'
    capt mat drop `b'
    capt mat rename `res' `b'
end

prog MakeQuotedFullnames
    args names eqs
    foreach name of local names {
        gettoken eq eqs : eqs
        local value `"`value'`"`eq':`name'"' "'
    }
    c_local value: list clean value
end

program define QuotedRowNames
    args matrix
    capt confirm matrix `matrix'
    if _rc {
        c_local value ""
        exit
    }
    tempname extract
    if substr(`"`matrix'"',1,2)=="r(" {
        local matrix0 `"`matrix'"'
        tempname matrix
        mat `matrix' = `matrix0'
    }
    local R = rowsof(`matrix')
    forv r = 1/`R' {
        mat `extract' = `matrix'[`r',1...]
        local name: rownames `extract'
        local value `"`value'`"`name'"' "'
    }
    c_local value: list clean value
end

prog EqReplaceCons
    args names eqlist eqlabels varlabels
    local skip 0
    foreach v of local varlabels {
        if `skip' {
            local skip 0
            continue
        }
        local vlabv `"`vlabv'`"`v'"' "'
        local skip 1
    }
    local deqs: list dups eqlist
    local deqs: list uniq deqs
    local i 0
    foreach eq of local eqlist {
        local ++i
        if `"`eq'"'!=`"`last'"' {
            gettoken eqlab eqlabels : eqlabels
        }
        local last `"`eq'"'
        if `:list eq in deqs' | `"`eq'"'=="_" continue
        local name: word `i' of `names'
        local isinvlabv: list posof `"`eq':`name'"' in vlabv
        if `"`name'"'=="_cons" & `isinvlabv'==0 {
            local value `"`value'`space'`"`eq':`name'"' `"`eqlab'"'"'
            local space " "
        }
    }
    c_local value `"`value'"'
end

prog UniqEqsAndDims
    local n 0
    foreach el of local 1 {
        if `"`macval(el)'"'!=`"`macval(last)'"' {
            if `n'>0 local eqsdims "`eqsdims' `n'"
            local eqs `"`macval(eqs)' `"`macval(el)'"'"'
            local n 0
        }
        local ++n
        local last `"`macval(el)'"'
    }
    local eqsdims "`eqsdims' `n'"
    c_local eqsdims: list clean eqsdims
    c_local eqs: list clean eqs
end

prog InsertAtCols
    args colnums row symb
    if `"`symb'"'=="" local symb .
    gettoken c rest : colnums
    local i 0
    foreach r of local row {
        local ++i
        while `"`c'"'!="" {
            if `c'<=`i' {
                local value `"`value' `symb'"'
                gettoken c rest : rest
            }
            else continue, break
        }
        local value `"`value' `"`r'"'"'
    }
    while `"`c'"'!="" {
        local value `"`value' `symb'"'
        gettoken c rest : rest
    }
    c_local value: list clean value
end

prog GetVarnamesFromOrder
    foreach sp of local 1 {
        if index(`"`sp'"', ":") {
            gettoken trash sp: sp, parse(:)
            if `"`trash'"'!=":" {
                gettoken trash sp: sp, parse(:)
            }
        }
        local value `"`value'`space'`sp'"'
        local space " "
    }
    c_local value `"`value'"'
end

prog ParseIndicateOpts
    syntax [anything(equalok)] [, Labels(str asis) ]
    gettoken tok rest : anything, parse(" =")
    while `"`macval(tok)'"'!="" {
        if `"`macval(tok)'"'=="=" {
            local anything `"`"`macval(anything)'"'"'
            continue, break
        }
        gettoken tok rest : rest, parse(" =")
    }
    c_local indicate `"`macval(anything)'"'
    c_local indicatelabels `"`macval(labels)'"'
end

prog ProcessIndicateGrp
    args i B nmodels unstack yesno indicate
    gettoken yes no : yesno
    gettoken no : no
    gettoken tok rest : indicate, parse(=)
    while `"`macval(tok)'"'!="" {
        if `"`macval(rest)'"'=="" {
            local vars `"`indicate'"'
            continue, break
        }
        if `"`macval(tok)'"'=="=" {
            local vars `"`rest'"'
            continue, break
        }
        local name `"`macval(name)'`space'`macval(tok)'"'
        local space " "
        gettoken tok rest : rest, parse(=)
    }
    if `"`macval(name)'"'=="" {
        local name: word 1 of `"`vars'"'
    }
    ExpandEqVarlist `"`vars'"' `B'
    local evars `"`value'"'
    IsInModels `B' `nmodels' "`unstack'" `"`macval(yes)'"' `"`macval(no)'"' `"`evars'"'
    local lbls `"`macval(value)'"'
    DropOrKeep 0 `B' `"`evars'"'
    c_local indicate`i'name `"`macval(name)'"'
    c_local indicate`i'lbls `"`macval(lbls)'"'
    c_local indicate`i'eqs `"`eqs'"'
end

prog IsInModels
    args B nmodels unstack yes no vars
    capt confirm matrix `B'
    if _rc {
        forv i = 1/`nmodels' {
            local lbls `"`macval(lbls)' `"`macval(no)'"'"'
        }
        c_local value `"`macval(lbls)'"'
        if `"`unstack'"'!="" {
            c_local eqs "_"
        }
        exit
    }
    local models: coleq `B', q
    local models: list uniq models
    local eqs: roweq `B', q
    local eqs: list uniq eqs
    tempname Bt Btt Bttt
    foreach model of local models {
        local stop 0
        mat `Bt' = `B'[1...,"`model':"]
        foreach eq of local eqs {
            mat `Btt' = `Bt'[`"`eq':"',1]
            if `"`unstack'"'!="" local stop 0
            foreach var of local vars {
                if !index(`"`var'"',":") {
                    local var `"`eq':`var'"'
                }
                capt mat `Bttt' = `Btt'["`var'",1]
                if _rc continue
                forv i = 1/`= rowsof(`Bttt')' {
                    if `Bttt'[`i',1]<.z {
                        local lbls `"`macval(lbls)' `"`macval(yes)'"'"'
                        local stop 1
                        continue, break
                    }
                }
                if `stop' continue, break
            }
            if `"`unstack'"'!="" {
                if `stop'==0 {
                    local lbls `"`macval(lbls)' `"`macval(no)'"'"'
                }
            }
            else if `stop' continue, break
        }
        if `"`unstack'"'=="" & `stop'==0 {
            local lbls `"`macval(lbls)' `"`macval(no)'"'"'
        }
    }
    c_local value `"`macval(lbls)'"'
    if `"`unstack'"'!="" {
        c_local eqs `"`eqs'"'
    }
end

prog ReorderEqsInIndicate
    args nmodels eqs ieqs lbls
    local neq: list sizeof ieqs
    foreach eq of local eqs {
        local i: list posof `"`eq'"' in ieqs
        if `i' {
            local pos `pos' `i'
        }
    }
    forv m=1/`nmodels' {
        foreach i of local pos {
            local mi = (`m'-1)*`neq' + `i'
            local lbl: word `mi' of `macval(lbls)'
            local value `"`macval(value)'`"`macval(lbl)'"' "'
        }
    }
    c_local value `"`macval(value)'"'
end

prog ParseRefcatOpts
    syntax [anything(equalok)] [, NOLabel Label(str) Below ]
    c_local refcatbelow "`below'"
    c_local norefcatlabel "`nolabel'"
    c_local refcatlabel `"`macval(label)'"'
    c_local refcat `"`macval(anything)'"'
end

prog PrepareRefcat
    gettoken coef rest : 1
    gettoken name rest : rest
    while `"`macval(coef)'"'!="" {
        local coefs `"`coefs'`coef' "'
        local names `"`macval(names)'`"`macval(name)'"' "'
        gettoken coef rest : rest
        gettoken name rest : rest
    }
    c_local refcatcoefs `"`coefs'"'
    c_local refcatnames `"`macval(names)'"'
end

prog GenerateRefcatRow
    args B ccols var eqs label
    local models: coleq `B', q
    local models: list uniq models
    local col 1
    foreach model of local models {
        foreach eq of local eqs {
            local eqvar `"`eq':`var'"'
            local row = rownumb(`B',"`eqvar'")
            if `B'[`row', `col']<.z {
                local value `"`macval(value)'`"`macval(label)'"' "'
            }
            else {
                local value `"`macval(value)'`""' "'
            }
        }
        local col = `col' + `ccols'
    }
    c_local value `"`macval(value)'"'
end

prog ParseTransformSubopts
    syntax anything(equalok) [, Pattern(string) ]
    c_local transform `"`anything'"'
    c_local transformpattern "`pattern'"
end

prog MakeTransformList
    args B transform
    local R = rowsof(`B')
    if `:list sizeof transform'<=2 {
        gettoken f rest : transform
        gettoken df : rest
        forv i = 1/`R' {
            local valuef `"`valuef'`f' "'
            local valuedf `"`valuedf'`df' "'
        }
        c_local valuef: list retok valuef
        c_local valuedf: list retok valuedf
        exit
    }
    gettoken coef rest : transform
    gettoken f rest : rest
    gettoken df rest : rest
    while (`"`coef'"'!="") {
        if (`"`df'`rest'"'!="") { // last element of list may be without coef
            ExpandEqVarlist `"`coef'"' `B'
            local coef `"`value'"'
        }
        local coefs `"`coefs'`"`coef'"' "'
        local fs `"`fs'`"`f'"' "'
        local dfs `"`dfs'`"`df'"' "'
        gettoken coef rest : rest
        gettoken f rest : rest
        gettoken df rest : rest
    }
    tempname b
    local value
    forv i = 1/`R' {
        mat `b' = `B'[`i',1...]
        local i 0
        local hit 0
        foreach coef of local coefs {
            local f: word `++i' of `fs'
            local df: word `i' of `dfs'
            if (`"`df'`rest'"'=="") {
                local valuef `"`valuef'`"`coef'"' "'  // sic! (see above)
                local valuedf `"`valuedf'`"`f'"' "'
                local hit 1
                continue, break
            }
            foreach c of local coef {
                if rownumb(`b', `"`c'"')==1 {
                    local valuef `"`valuef'`"`f'"' "'
                    local valuedf `"`valuedf'`"`df'"' "'
                    local hit 1
                    continue, break
                }
            }
            if `hit' continue, break
        }
        if `hit'==0 {
            local valuef `"`valuef'"" "'
            local valuedf `"`valuedf'"" "'
        }
    }
    c_local valuef: list retok valuef
    c_local valuedf: list retok valuedf
end

prog TableIsAMess
    local ccols = r(ccols)
    local eq: roweq r(coefs), q
    local eq: list uniq eq
    if `: list sizeof eq'<=1 {
        c_local value 0
        exit
    }
    tempname b bt
    mat `b' = r(coefs)
    gettoken eq : eq
    mat `b' = `b'[`"`eq':"', 1...]
    local R = rowsof(`b')
    local models: coleq `b', q
    local models: list uniq models
    local value 0
    local i = 1 - `ccols'
    foreach model of local models {
        local i = `i' + `ccols'
        if `i'==1 continue // skip first model
        mat `bt' = `b'[1...,`i']
        local allz 1
        forv r = 1/`R' {
            if `bt'[`r',1]<.z {
                local allz 0
                continue, break
            }
        }
        if `allz' {
            local value 1
            continue, break
        }
    }
    c_local value `value'
end

prog ExpandEqVarlist
    args list B append
    ParseEqVarlistRelax `list'
    QuotedRowNames `B'
    local coefs `"`value'"'
    local value
    local ucoefs: list uniq coefs
    capt confirm matrix `B'
    if _rc==0 {
        local eqs: roweq `B', q
    }
    else local eqs "_"
    local ueqs: list uniq eqs
    while `"`list'"'!="" {
// get next element
        gettoken eqx list : list
// separate eq and x
        gettoken eq x : eqx, parse(:)
        local eq: list clean eq
        if `"`eq'"'==":" {    // case 1: ":[varname]"
            local eq
        }
        else if `"`x'"'=="" { // case 2: "varname"
            local x `"`eq'"'
            local eq
        }
        else {                // case 3. "eqname:[varname]"
            gettoken colon x : x, parse(:)
            local x: list clean x
        }
// match equations
        local eqmatch
        if `:list eq in ueqs' { // (note: evaluates to 1 if eq empty)
            local eqmatch `"`eq'"'
        }
        else {
            foreach e of local ueqs {
                if match(`"`e'"', `"`eq'"') {
                    local eqmatch `"`eqmatch' `"`e'"'"'
                }
            }
            if `"`eqmatch'"'=="" & "`relax'"=="" {
                if !("`append'"!="" & `"`x'"'!="") {
                    di as err `"equation `eq' not found"'
                    exit 111
                }
            }
            local eqmatch: list clean eqmatch
        }
        if `"`x'"'=="" {
            foreach e of local eqmatch {
                local value `"`value' `"`e':"'"'
            }
            continue
        }
// match coefficients
        local vlist
// - without equation
        if `"`eq'"'=="" {
            if `:list x in ucoefs' {
                local value `"`value' `"`x'"'"'
                continue
            }
            foreach coef of local ucoefs {
                if match(`"`coef'"', `"`x'"') {
                    local vlist `"`vlist' `"`coef'"'"'
                }
            }
            if `"`vlist'"'=="" {
                if "`append'"!="" {
                    local appendlist `"`appendlist' `"`x'"'"'
                    local value `"`value' `"`x'"'"'
                }
                else if "`relax'"=="" {
                    di as err `"coefficient `x' not found"'
                    exit 111
                }
            }
            else {
                local value `"`value' `vlist'"'
            }
            continue
        }
// - within equations
        local rest `"`eqs'"'
        foreach coef of local coefs {
            gettoken e rest : rest
            if !`:list e in eqmatch' {
                continue
            }
            if match(`"`coef'"', `"`x'"') {
                local vlist `"`vlist' `"`e':`coef'"'"'
            }
        }
        if `"`vlist'"'=="" {
            if "`append'"!="" {
                local appendlist `"`appendlist' `"`eq':`x'"'"'
                local value `"`value' `"`eq':`x'"'"'
            }
            else if "`relax'"=="" {
                di as err `"coefficient `eq':`x' not found"'
                exit 111
            }
        }
        else {
            local value `"`value' `vlist'"'
        }
    }
    if "`append'"!="" {
        local nappend : list sizeof appendlist
        if `nappend'>0 {
            capt confirm matrix `B'
            if _rc==0 {
                tempname tmp
                mat `tmp' = J(`nappend', colsof(`B'), .z)
                mat rown `tmp' = `appendlist'
                matrix `B' = `B' \ `tmp'
            }
        }
    }
    c_local value: list clean value
end

program ParseEqVarlistRelax
    syntax [anything] [, Relax ]
    c_local list `"`anything'"'
    c_local relax `relax'
end

program IsInString //, rclass
    args needle haystack
    local trash: subinstr local haystack `"`needle'"' "", count(local count)
    c_local strcount = `count'
end

program MakeRtfRowdefs
    args str srow sdetach vwidth mwidth haslc2 lc2width
    local factor 120
    ParseRtfcmdNum `"`str'"' "trgaph" 0
    ParseRtfcmdNum `"`str'"' "trleft" 0
    if `vwidth'<=0 local vwidth 12
    if real(`"`trgaph'"')>=. local trgaph 0
    if real(`"`trleft'"')>=. local trleft 0
    local swidth = 3
    local vtwips = `vwidth'*`factor'
    local stwips = `swidth'*`factor'
    local ipos = `vtwips' + 2*`trgaph' + (`trleft')
    local brdrt "\clbrdrt\brdrw10\brdrs"
    local brdrb "\clbrdrb\brdrw10\brdrs"
    local emptycell "\pard\intbl\ql\cell"
    local rtfdef "\cellx`ipos'"
    local rtfdefbrdrt "`brdrt'\cellx`ipos'"
    local rtfdefbrdrb "`brdrb'\cellx`ipos'"
    local rtfrow "`emptycell'"
    if `haslc2' {
        if `lc2width'<=0 local lc2width 12
        local lc2twips = `lc2width'*`factor'
        local ipos = `ipos' + `lc2twips' + 2*`trgaph'
        local rtfdef "`rtfdef'\cellx`ipos'"
        local rtfdefbrdrt "`rtfdefbrdrt'`brdrt'\cellx`ipos'"
        local rtfdefbrdrb "`rtfdefbrdrb'`brdrb'\cellx`ipos'"
        local rtfrow "`rtfrow'`emptycell'"
    }
    local j 0
    local nmwidth: list sizeof mwidth
    foreach i of local srow {
        local mwidthj: word `=1 + mod(`j++',`nmwidth')' of `mwidth'
        if `mwidthj'<=0 local mwidthj 12
        local mtwips = `mwidthj'*`factor'
        local ipos = `ipos' + `mtwips' + 2*`trgaph'
        if `i' & "`sdetach'"=="" local ipos = `ipos' + `stwips'
        local rtfdef "`rtfdef'\cellx`ipos'"
        local rtfdefbrdrt "`rtfdefbrdrt'`brdrt'\cellx`ipos'"
        local rtfdefbrdrb "`rtfdefbrdrb'`brdrb'\cellx`ipos'"
        local rtfrow "`rtfrow'`emptycell'"
        if `i' & "`sdetach'"!="" {
            local ipos = `ipos' + `stwips' + 2*`trgaph'
            local rtfdef "`rtfdef'\cellx`ipos'"
            local rtfdefbrdrt "`rtfdefbrdrt'`brdrt'\cellx`ipos'"
            local rtfdefbrdrb "`rtfdefbrdrb'`brdrb'\cellx`ipos'"
            local rtfrow "`rtfrow'`emptycell'"
        }
    }
    c_local rtfrowdef "`rtfdef'"
    c_local rtfrowdefbrdrt "`rtfdefbrdrt'"
    c_local rtfrowdefbrdrb "`rtfdefbrdrb'"
    c_local rtfemptyrow "`rtfdef'`rtfrow'"
end

prog ParseRtfcmdNum
    args str cmd default
    local pos = index(`"`str'"', `"\\`cmd'"')
    if `pos' {
        local pos = `pos' + strlen(`"`cmd'"') + 1
        local digit = substr(`"`str'"',`pos',1)
        if `"`digit'"'=="-" {
            local value "`digit'"
            local digit = substr(`"`str'"',`++pos',1)
        }
        while real(`"`digit'"')<. {
            local value "`value'`digit'"
            local digit = substr(`"`str'"',`++pos',1)
        }
    }
    local value = real(`"`value'"')
    if `value'>=. local value = `default'
    c_local `cmd' `"`value'"'
end

prog ParseLabCol2
    syntax [anything(equalok)] [ , Title(str asis) Width(numlist max=1 int >=0) ]
    c_local labcol2 `"`macval(anything)'"'
    c_local labcol2title `"`macval(title)'"'
    c_local labcol2width `"`width'"'
end

prog StableSubinstr
    // use mata in stata>=9 because -:subinstr- breaks if length of <to>
    // is more than 502 characters
    args new old from to all word
    if c(stata_version)>=9 {
        if "`all'"=="all"   local cnt .
        else if "`all'"=="" local cnt 1
        else error 198
        if "`word'"=="" local word str
        else if "`word'"!="word" error 198
        mata: st_local("tmp", subin`word'(st_local("old"), ///
                   st_local("from"), st_local("to"), `cnt'))
        c_local `new' `"`macval(tmp)'"'
    }
    else {
        capt local tmp: subinstr local old `"`macval(from)'"' ///
            `"`macval(to)'"', `all' `word'
        if _rc==0 {
             c_local `new' `"`macval(tmp)'"'
        }
    }
end

prog MakeMMDdef
    args varw labcol2 labcol2w modelw starsrow stardetachon starw
    if "`varw'"=="0"     | "`varw'"==""     local varw 1
    if "`labcol2w'"=="0" | "`labcol2w'"=="" local labcol2w 1
    if "`modelw'"=="0"   | "`modelw'"==""   local modelw 1
    if "`starw'"=="0"    | "`starw'"==""    local starw 1
    local varw      = max(1,`varw')
    local labcol2w  = max(1,`labcol2w'-2)
    if "`stardetachon'"=="1" local starw = max(1,`starw'-2)
    else                     local starw = max(1,`starw')

    local mmddef `"| `:di _dup(`varw') "-"'"'
    if "`labcol2'"=="1" {
        local mmddef `"`mmddef' | :`:di _dup(`labcol2w') "-"':"'
    }
    local nmodelw: list sizeof modelw
    local c 0
    foreach col of local starsrow {
        local modelwj: word `=1+mod(`c++',`nmodelw')' of `modelw'
        local modelwj = max(1,`modelwj'-2)
        local mmddef `"`mmddef' | :`:di _dup(`modelwj') "-"'"'
        if "`col'"=="1" {
            if "`stardetachon'"=="1" {
                local mmddef `"`mmddef': | :"'
            }
            local mmddef `"`mmddef'`:di _dup(`starw') "-"'"'
        }
        local mmddef `"`mmddef':"'
    }
    c_local value `"`mmddef' |"'
end

program MatrixMode, rclass
    capt syntax [, Matrix(str asis) e(str asis) r(str asis) rename(str asis) ]
    if _rc | `"`matrix'`e'`r'"'=="" {
        c_local matrixmode 0
        exit
    }
    if ((`"`matrix'"'!="") + (`"`e'"'!="") + (`"`r'"'!=""))>1 {
        di as err "only one of matrix(), e(), or r() allowed"
        exit 198
    }
    ParseMatrixOpt `matrix'`e'`r'
    if `"`e'"'!="" {
        local name "e(`name')"
    }
    else if `"`r'"'!="" {
        local name "r(`name')"
    }
    confirm matrix `name'
    tempname bc
    if "`transpose'"=="" {
        mat `bc' = `name''
    }
    else {
        mat `bc' = `name'
    }
    QuotedRowNames `bc'
    local rnames `"`value'"'
    local eqs: roweq `bc', q
    mat `bc' = `bc''
    local cols = colsof(`bc')
    local cells
    local space
    gettoken fmti fmtrest : fmt, match(par)
    gettoken rname rnames : rnames
    gettoken eq eqs : eqs
    forv i = 1/`cols' {
        if `"`fmti'"'!="" {
            local fmtopt `"f(`fmti') "'
            gettoken fmti fmtrest : fmtrest, match(par)
            if `"`fmti'"'=="" & `"`fmtrest'"'=="" { // recycle
                gettoken fmti fmtrest : fmt, match(par)
            }
        }
        else local fmtopt
        if `"`eq'"'=="_" {
            local lbl `"l(`"`rname'"')"'
        }
        else {
            local lbl `"l(`"`eq':`rname'"')"'
        }
        local cells `"`cells'`space'c`i'(`fmtopt'`lbl')"'
        local space " "
        gettoken rname rnames : rnames
        gettoken eq eqs : eqs
    }
    if `"`rename'"'!="" {
        local rename : subinstr local rename "," "", all
        RenameCoefs `bc' `"`rename'"'
    }
    return local names      "`name'"
    return scalar nmodels   = 1
    return scalar ccols     = `cols'
    return matrix coefs     = `bc'
    c_local matrixmode      1
    c_local cells           (`cells')
end

program ParseMatrixOpt
    syntax name [, Fmt(str asis) Transpose ]
    c_local name `"`namelist'"'
    c_local fmt `"`fmt'"'
    c_local transpose `"`transpose'"'
end

program CompileVarl
    syntax [, vname(str asis) interaction(str) ]
    gettoken vi vname: vname, parse("#")
    while (`"`vi'"') !="" {
        local xlabi
        if `"`vi'"'=="#" {
            local xlabi `"`macval(interaction)'"'
        }
        else if strpos(`"`vi'"',".")==0 {
            capt confirm variable `vi', exact
            if _rc==0 {
                local xlabi: var lab `vi'
            }
        }
        else {
            gettoken li vii : vi, parse(".")
            gettoken dot vii : vii, parse(".")
            capt confirm variable `vii', exact
            if _rc==0 {
                capt confirm number `li'
                if _rc {
                    local xlabi: var lab `vii'
                    if (`"`macval(xlabi)'"'=="") local xlabi `"`vii'"'
                    if substr(`"`li'"',1,1)=="c" ///
                                         local li = substr(`"`li'"',2,.)
                    if (`"`li'"'!="")    local xlabi `"`li'.`macval(xlabi)'"'
                }
                else {
                    local viilab : value label `vii'
                    if `"`viilab'"'!="" {
                        local xlabi: label `viilab' `li'
                    }
                    else {
                        local viilab: var lab `vii'
                        if (`"`macval(viilab)'"'=="") local viilab `"`vii'"'
                        local xlabi `"`macval(viilab)'=`li'"'
                    }
                }
            }
        }
        if `"`macval(xlabi)'"'=="" {
            local xlabi `"`vi'"'
        }
        local xlab `"`macval(xlab)'`macval(xlabi)'"'
        gettoken vi vname: vname, parse("#")
    }
    c_local varl `"`macval(xlab)'"'
end

if c(stata_version)<11 exit
version 11
mata:
mata set matastrict on

void estout_omitted_and_base()
{
    real colvector      p
    real matrix         bc
    string matrix       rstripe, cstripe
    string colvector    coefnm
    
    bc = st_matrix(st_local("bc"))
    rstripe = st_matrixrowstripe(st_local("bc"))
    cstripe = st_matrixcolstripe(st_local("bc"))
    coefnm = rstripe[,2]
    //coefnm = subinstr(coefnm,"bn.", ".")                              // *bn.
    //coefnm = subinstr(coefnm,"bno.", "o.")                            // *bno.
    p = J(rows(bc), 1, 1)
    if (st_local("omitted")=="") {
        p = p :* (!strmatch(coefnm, "*o.*"))
    }
    else {
        coefnm = substr(coefnm, 1:+2*(substr(coefnm, 1, 2):=="o."), .)  // o.
        coefnm = subinstr(coefnm, "o.", ".")                            // *o.
    }
    if (st_local("baselevels")=="") {
        p = p :* (!strmatch(coefnm, "*b.*"))
    }
    else {
        coefnm = subinstr(coefnm, "b.", ".")                            // *b.
    }
    if (any(p)) {
        st_matrix(st_local("bc"), select(bc, p))
        st_matrixrowstripe(st_local("bc"), select((rstripe[,1], coefnm), p))
        st_matrixcolstripe(st_local("bc"), cstripe)
        st_local("hasbc", "1")
    }
    else {
        st_local("hasbc", "0")
    }
}
end
