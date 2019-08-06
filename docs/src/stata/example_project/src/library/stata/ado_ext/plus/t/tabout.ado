program define tabout
*! 2.0.7 Ian Watson 5jan2015
* bug fix - missing se option when doing counts for svy col and row totals, resulting in cell se not count se going into col and row totals, thanks Anwar Dudekula
* 2.0.6 Ian Watson 22nov2012
* added sort option, as per Thomas Odeny request
* bug fix - where variables have complete missing values, a warning is issues and program terminates, thanks Richard Fox
* 2.0.5 Ian Watson 31may2011
* added comma option, code contributed by Arjan Soede
* inserted warning in tutorial noting h1 thru h3 are limited to 256 characters, thanks Johannes Geyer
* 2.0.42 Ian Watson 10nov2010
* fixed typo in fweight option, thanks Jonathan Gardner
* 2.0.41 Ian Watson 7nov2010
* added omitted line for do_pop global macro, thanks Mitch Abdon
* 2.0.4 Ian Watson 1nov2010
* fixed bug for long variable list, thanks Eric Booth
* fixed bug with parsing when last variable is a string one, thanks Mikko Rönkkö
* changed "-1" to "-999" in various presentation functions, thanks Axel Engellandt
* various enhancements requesed by Stata users
* missing option, thanks Cathy Redmond
* semi-colon delimiter, thanks Ulrich Atz
* weighted pop estimates for svy option, thanks Nirmala Devi Naidoo
* frequency weights now allow long integers, thanks Thomas Masterson
* 2.0.3 Ian Watson 1apr2007
* fixed obs for svy basic tables (now uses ObsSub)
* 2.0.2 Ian Watson 21mar2007
* added string to syntax for cisep (was missing)
* changed options for bracket: cibnone and sebnone
* instead of nocib noseb
* fixed oneway problems (N labels, add_nrow indexing)
* added dots for svy commands
* 2.0.1 Ian Watson 16mar2007
* fixed percent in oneway
* removed $ around <> in texclean
* added noffset option
* made nwt global in svy_sum
* removed wtstr in ta from summary tables
* fixed typo in cblock rblock
* fixed typo in nwt option
* 2.0.0 Ian Watson 30nov2006 
* 1.2.0 Ian Watson 13mar2005
* 1.1.8 Ian Watson 30nov2004
* 1.1.0 Ian Watson 28oct2004 
* Program to produce publication quality tables
* See tabout_tutorial.pdf at www.ianwatson.com.au


     version 9.2

    syntax varlist [if] [in] [fweight aweight iweight] using/ ///
    [, REPlace APPend Cells(string) Format(string) clab(string) /// 
    LAYout(string) ONEway sum mi sort ///
    npos(string) nlab(string) nwt(string) nnoc NOFFset(string) /// 
    stats(string) /// 
    svy SEBnone CIBnone cisep(string) ci2col PERcent Level(string) pop ///
    delim(string) DPComma MONey(string) CHKWTnone debug NOBORDer ///
    show(string) wide(string) ///
    TOTal(string) PTOTal(string) h1(string) h2(string) h3(string) ///
    style(string) lines(string) font(string) ///
    bt ROTate(string) cl1(string) cl2(string) cltr1(string) cltr2(string) ///
    body topf(string) botf(string) topstr(string) botstr(string) ///
    PSymbol(string)] 

*------------------------ setup -------------------------

global dotss "nois _dots 0, title(Survey results being calculated)"
global dots "nois _dots 5 0"

tempvar touse 
mark `touse' `if' `in'


    global mainfile = "`using'"
    
    local opt ""
    local opt = cond("`replace'" == "replace","replace", ///
                    cond("`append'" == "append","append", ///
                        ""))

    if ("`opt'"=="") { 
        capture confirm file "$mainfile"
        if !_rc {
         di
         di as err "The file $mainfile already exists, but you haven't"
         di as err "used either the replace or append option. Please change"
         di as err "the file name or include replace or append."
         di
         clearglobs
         exit
        }
    }
    
    if ("`opt'"=="replace") { 
        tempname outfile
        capture file open `outfile' using "$mainfile", write replace
        capture file write `outfile' ""
            if _rc==111 {
              di
              di as err "File `using'"
              di as err "is already open inside another application."
              di as err "Please close it before running tabout."
              di
              clearglobs
              exit
        }
        capture file close `outfile'
    }

    local weightstr1 = cond("`weight'"~="","`weight'","none")
    local weightstr2 = cond("`weight'"~="",subinstr("`exp'"," ","",.),"none")
    
    if ("`weightstr1'"~="none") { 
        local wtvar = substr("`weightstr2'",2,.)
        local wttype : type `wtvar'
        if ("`weightstr1'"=="fweight" & "`wttype'" ~= "byte" & "`wttype'" ~= "int" & "`wttype'" ~= "long" & "`chkwtnone'"=="") {
            di
            di as err "Problem with frequency weights {search r(401)}"
            di
            clearglobs
            exit
        }
    }
        
    global oneway = cond("`oneway'"~="",1,0)
    global debug = cond("`debug'"~="","","qui")
    
*------------------------ set critical defaults -------------------------   

    
    if ("`svy'"~="") {
        global do_svy = 1
        if ("`sum'"~="") global do_sum = 1
            else global do_sum = 0
        }
    else {
        global do_svy = 0
        if ("`sum'"~="") global do_sum = 1
            else global do_sum = 0
    }
	
	if ("`dpcomma'"~="") {
        global dpcomma = ","        
	}	
    else {
		global dpcomma = "."        
    }
	

*------------------------ cells options -------------------------
        
        local nogood = 0
        local vnogood = 0
        local snogood = 0
        if ("`cells'" ~= "") {
        local a = "freq cell row col cum"
        local b = "se ci lb ub"
        local c = "N mean var sd skewness kurtosis sum uwsum min max count median iqr r9010 r9050 r7525 r1050 p1 p5 p10 p25 p50 p75 p90 p95 p99"
                
        local n : word count `cells'
        tokenize `cells'
        forval x = 1/`n' {
            local testwd = "``x''"
            if ($do_sum==0 & $do_svy==0) {
                if (strpos("`a'","`testwd'")==0) local nogood = 1
            }
            if ($do_sum==1) {
                if (strpos("`a'","`testwd'")~=0) local nogood = 1
            }
        }
        
        if (`nogood'==1) {
        di
        di as err "Invalid type of entry in cells option, or you may"
        di as err "have forgotten to turn on the sum or svy option" 
        di
        show_allowtable
        clearglobs
        exit
        }
        
        if ($do_sum==1) {
            local k : word count `cells'
            local fword : word 1 of `cells'
            local sword : word 2 of `cells'
            local tword : word 3 of `cells'
            local statkind = "`fword'"
            local statvar = "`sword'"
            if ($do_svy==1) {
                if ("`fword'"~="mean") {
                    di
                    di as err "Only mean is allowed for survey analysis"
                    di
                    show_allowtable
                    clearglobs
                    exit
                }
                if (strpos("`b'","`tword'")==0){
                    di
                    di as err "Only one summary statistic is allowed for survey analysis"
                    di
                    show_allowtable
                    clearglobs
                    exit
                }
                else {
                    local svy_sumvar = "`sword'"
                    local cells = subinstr("`cells'","`sword'","",.)
                    local cells = subinstr("`cells'","mean","SV",.)
                }
            }
            else {
                local n : word count `cells'
                tokenize `cells'
                forval x = 1/`n' {
                    local testwd = "``x''"
                    if (mod(`x',2))==1 {
                        if (strpos("`c'","`testwd'")==0) local snogood = 1
                    }
                    else {
                        capture confirm variable `testwd'
                        if (_rc~=0) {
                            local vnogood = 1
                            local err_msg = "Variable `testwd' not found {search r(111)}"
                        }
                    }
                }
            }
            if (`k'>2) {
                if (strpos("`c'","`tword'")~=0) global oneway = 1
            }
        }
    }
    else local cells = "freq"
    if (`snogood'==1) {
        di
        di as err "Invalid type of entry in cells option, or you may"
        di as err "have forgotten to turn on the sum or svy option" 
        di
        show_allowtable
        clearglobs
        exit
    }
    if (`vnogood'==1) {
        di
        di as err "`err_msg'"
        di
        clearglobs
        exit
    }

    
*------------------------ survey options -------------------------      

    
    local svyporp = cond("`percent'"~="",100,1)
    local svylevel = cond("`level'"~="",real("`level'"),95)


*------------------------ cell labelling options -------------------------
    
    if ("`clab'"~="") global clab = "`clab'"
    else {
        if ($do_sum==1) {
            if ($do_svy==0) global clab = ""
            else {
                global clab = "Mean"
                local c : word count `cells'
                tokenize `cells'
                forval x = 2/`c' {
                    global clab = "$clab " + upper("``x''")
                }
            }
        }
        else {
            global clab = ""
            local c : word count `cells'
            tokenize `cells'
            forval x = 1/`c' {
                if ($do_svy==0) {
                    if ("``x''"=="freq") local hstr = "No."
                        else    local hstr = "%"
                }
                else  {
                    if (`svyporp'==1) local suf="Prop."
                        else local suf = "%"
                    if ("``x''"=="freq") local hstr = "No."
                    else if ("``x''"=="se") local hstr = "SE"
                    else if ("``x''"=="ci") local hstr = "CI"
                    else if ("``x''"=="lb") local hstr = "LB"
                    else if ("``x''"=="ub") local hstr = "UB"
                    else local hstr = "`suf'"
                }
                global clab = "$clab `hstr'"
            }
        }
    }       
    
    local categ = cond("`cells'"~="","`cells'","FR")
    global numcat : word count `categ'
    tokenize "`categ'"
    global category ""
    forval i = 1/$numcat {
        local letter = upper(substr("``i''",1,2))
        global category "$category `letter' "
    }
    local nogood = 0
    if $do_svy==1 {
        tokenize "$category"
        forval x = 1/$numcat {
            local cat= "``x''"
            if (`x'==1) {
                if "`cat'"=="FR" local svycat = "count"
                    else if "`cat'"=="CE" local svycat = "cell"
                    else if "`cat'"=="CO" local svycat = "col"
                    else if "`cat'"=="RO" local svycat = "row"
                    else local svycat = "cell"
            }
            else {
                if ("`cat'"=="FR" | "`cat'"=="CE" | "`cat'"=="CO" | ///
                "`cat'"=="RO") {
                    local nogood = 1 
                }
            }
        }
    }

    if (`nogood'==1) {
        di
        di as err "Only one category (freq cell col or row) can be used with svy option."
        di
        show_allowtable
        clearglobs
    exit
    }

    global noseb = cond("`sebnone'"~="",1,0)
    global nocib = cond("`cibnone'"~="",1,0)
    global cisep = cond("`cisep'"~="","`cisep'",",")
    global do_pseudo = cond("`ci2col'"~="",1,0)
    
    local formbad = 0
    local format = cond("`format'"~="","`format'","1c")
    tokenize "a b d e f g h i j k l n o q r s t u v w x y z"
    forval x = 1/23 {
        if (strpos(lower("`format'"),"``x''")~=0) local formbad = 1
    }
    if (`formbad'==1) { 
        di
        di as err "Error in format. Only the letters c, m and p are allowed."
        di
        clearglobs
        exit
    }
    
    
    global layout = cond("`layout'"~="","`layout'","col")
    
    if ("`layout'"~=""){
        if ("`layout'"=="cb" | "`layout'"=="cblock")  ///
            global layout = "c_block"
        else if ("`layout'"=="rb" | "`layout'"=="rblock")  ///
            global layout = "r_block"
        else if ("`layout'"=="col") global layout = "col"
        else if ("`layout'"=="row") global layout = "row"
        else global layout = "col"
    }
    else global layout = "col"
        
    
*------------------------ output options -------------------------
    if ("`style'"~="") {
        if ("`style'"=="tex") global style = "tex"
            else if ("`style'"=="csv") global style = "csv"
                else if ("`style'"=="semi") global style = "semi"
                    else if (substr("`style'",1,3)=="htm") global style = "htm" 
                        else global style = "tab"
    }
    else global style = "tab"
    
    global h1 = cond("`h1'"~="","`h1'","")
    global h2 = cond("`h2'"~="","`h2'","")
    global h3 = cond("`h3'"~="","`h3'","")
    
    if ("`ptotal'"=="none"){
        global showtot = 0
        global finaltot = 0
    }
    else if ("`ptotal'"=="single"){
        global showtot = 0
        global finaltot = 1
    }
    else {
        global showtot = 1
        global finaltot = 0
    }
        
    
    if ("`total'")~="" {
        if ("`total'"=="d"){
            global vtotal = "Total"
            global htotal = "Total"
            
        }
        else {
            tokenize "`total'"
            if ("`1'"=="d") global vtotal = "Total"
                else global vtotal = subinstr("`1'","_"," ",.)
            if ("`2'"=="d") global htotal = "Total"
                else global htotal = subinstr("`2'","_"," ",.)
        }
    }
    else {
        global vtotal = "Total"
        global htotal = "Total"
    }       
    
    if "`lines'" ~= "" {
        if "`lines'" == "double" {
            global lspace 2
        }
        else if "`lines'" == "single" {
            global lspace 1
        }   
        else if "`lines'" == "none" {
            global lspace 0
        }
        else global lspace 1
    }   
    else global lspace 1

    if "`font'" ~= "" {
        if "`font'" == "bold" global tfont "bold"
        else if "`font'" == "italic"  global tfont "italic"
        else global tfont "plain"
        }
    else global tfont "plain"

    global bt = cond("`bt'" ~= "",1,0)
    global cl1 = cond("`cl1'" ~= "","`cl1'","")
    global cl2 = cond("`cl2'" ~= "","`cl2'","")
    global cltr1 = cond("`cltr1'" ~= "","`cltr1'",".75em")
    global cltr2 = cond("`cltr2'" ~= "","`cltr2'",".75em")

    
    if ("`rotate'"~="") {
        global angle = "`rotate'"
    }
    else global angle = "0"
   
    global money = cond("`money'"~="","`money'","$")
    
    global do_body = cond("`body'" ~= "", 1, 0)
    
    global prefile = cond("`topf'" ~= "", "`topf'" , "")
    global postfile = cond("`botf'" ~= "", "`botf'", "")
    global topinsert = cond("`topstr'" ~= "", "`topstr'", "nil")
    global botinsert = cond("`botstr'" ~= "", "`botstr'", "nil")

    global ps = cond("`psymbol'" ~= "", "`psymbol'", "#")
    global do_top = cond("$prefile" ~= "", 1, 0)
    global do_bot = cond("$postfile" ~= "", 1, 0)
    global delim = cond("`delim'"~="","`delim'","|")
    
    global mi = cond("`mi'"~="","`mi'","")
    
    global sort = cond("`sort'"~="",1, 0)
    
    if ($do_top==1) { 
    tempname infile
    capture file open `infile' using "$prefile", read
        if _rc~=0 {
            di
            di as err "File $prefile not found."
            di as err "Check and retype file specification."
            di
            clearglobs
            capture file close `infile'
            exit        
        }
    capture file close `infile'
    }

    if ("$botinsert"~="" & "$ps"=="") {
        di 
        di as err "You must specify the psymbol as well as the filename"
        di
        clearglobs
        exit
    }
    
    if ($do_bot==1) { 
    tempname infile
    capture file open `infile' using "$postfile", read
        if _rc~=0 {
            di
            di as err "File $postfile not found."
            di as err "Check and retype file specification."
            di
            clearglobs
            capture file close `infile'
            exit        
        }
    capture file close `infile'
    }

    global border = cond("`noborder'" ~= "", "", " border=3")
    
*------------------------ display options -------------------------

    
    global colwide = cond("`wide'"~="", "`wide'","10")
    global show = cond("`show'"~="","`show'","output") 

*------------------------ n options -------------------------   
    
    global do_n = 0
    global n_pos = "col"
    global n_wt = ""
    global n_offset = "0"
    
    if "`noffset'"!="" {
        local noffs = real("`noffset'")-1
        global n_offset = string(`noffs')
    }
    
    if "`npos'"~="" {
            if ("`npos'")=="d" global n_pos = "col"
                else global n_pos = "`npos'"
            global do_n 1
    }

    if "`nlab'"~="" {
        if ("`nlab'"=="d") {
            if ("`npos'"=="lab") global n_lab = "(n=#)"
                else global n_lab = "N"
        }
        else global n_lab = "`nlab'"
        global do_n 1
    }
    else {
        if ("`npos'"=="lab") global n_lab = "(n=#)"
            else global n_lab = "N"
    }       
        
    
    if "`nwt'"~="" {
            if ("`nwt'")=="d" global n_wt = ""
                else global n_wt = "[iw=`nwt']"
            global do_n 1
    }

    global do_nnoc = cond("`nnoc'"~="",1,0)
    
    global do_pop = cond("`pop'"~="",1,0)
        
*------------------------ stats options -------------------------

    if ("`stats'"~="") {
        global stats = "`stats'"
        global do_stats = 1
    }
    else {
        global stats = ""
        global do_stats = 0
    }
    global statstr = ""
    global statstr1 = ""
    global statstr2 = ""
    
    if ($do_svy==0 & "$stats"~="" & /// 
    ("`weightstr1'"=="aweight" | "`weightstr1'"=="iweight")) {
        di
        di as err "Only fweights are allowed with the stats option"
        di
        clearglobs
        exit
    }
    
*===================== main routine =============================   
    
    if ($do_svy==1) {
        local fvar : word 1 of `varlist'
        capture qui svy: total `fvar'   
            if (_rc==119) {
            di
            di as err "Your data needs to be {help svyset} for this table"
            di
            clearglobs
            exit
        }
        $dotss
    }

    local nvars : word count `varlist'
    if `nvars'==1 global oneway 1
    
    if ($oneway==0 & $sort==1) {
            di
            di as err "The sort option is only allowed for oneway tables"
            di
            clearglobs
            exit
    }
    
    local hvar : word `nvars' of `varlist'
    local hvarname : variable label `hvar'
    if ("`hvarname'"=="") label var `hvar' "`hvar'" 
    
    tokenize `varlist'
    local n = `nvars'-1
    forval i = 1/`n' {
        local vvar "`vvar' ``i''"
    }
    global fpass = 1
    global lpass = 0
    local colmat = "matcol(colvals)"
    local rowmat = "matrow(rowvals)"
    if $oneway==1 {
        local vvar "`vvar' `hvar'"
        local hvar = ""
        local colmat = "nil"
        global do_stats = 0
        global stats = ""
    }

    global droph = ""
    if ("`hvar'"~="") local htype : type `hvar'
    if (substr("`htype'",1,3)=="str") { 
        capture encode `hvar', gen(_`hvar'_x)
        local hvar = "_`hvar'_x"
        global droph = "`hvar'"
    }
    

    if ("$style"=="tex") texfix
    
    if ($finaltot==1) {
        tempvar paneltot
        gen `paneltot' = 1
        la var `paneltot' "!PTOTAL!"
        la def paneltot 1 "$vtotal", modify
        la val `paneltot' paneltot
        local vvar "`vvar' `paneltot'"
    }
    local nvvars : word count `vvar'
    global single = cond(`nvvars'==1,1,0)

    local lastvar : word `nvvars' of `vvar'
    mat check = J(1,1,0)
    global dropv = ""
            /* core loop starts here */
    
    foreach v of local vvar {
        if ("`v'"=="`lastvar'") global lpass = 1
        local vvarname : variable label `v'
        if ("`vvarname'"=="") label var `v' "`v'" 

        local vtype : type `v'
        if (substr("`vtype'",1,3)=="str") { 
            capture encode `v', gen(_`v'_x)
            local v = "_`v'_x"
            global dropv = "$dropv `v'"
        }
                 
        if $do_svy==0 {
            if $oneway==1 local hvar = "_xx_ph_xx_" 
            if ($do_sum==0) { 
                do_mat `v' `hvar' `weightstr1' `weightstr2' `colmat' `touse'
                do_write `v' `hvar' "`format'"
            }
            else {
                if ($oneway==0) sum_twoway `v' `hvar' ///
                    `weightstr1' `weightstr2' ///
                    `colmat' `statkind' `statvar' `touse'
                else sum_oneway "`cells'" `v' ///
                    `weightstr1' `weightstr2' `touse'
                sum_write `v' `hvar' "`format'" "`cells'"
            }
        }
        else if $do_svy==1 {
            if $oneway==1 local hvar = "_xx_ph_xx_"
            if ($do_sum==0) ///
                svy_mat `v' `hvar' `svycat' `svylevel' `svyporp' `touse'
                else svy_sum `svy_sumvar' `v' `hvar' `svylevel' `colmat' `touse' 
            do_write `v' `hvar' "`format'" 
        }
    global fpass = 0
    }

di
di as text "Table output written to: `using'"
di
if ("$show"=="all" | "$show"=="output") type "`using'"

local j = colsof(check)
local warning = 0
forval x = 3/`j' {
    local k = `x'-1
    if (check[1,`x']~=check[1,`k']) local warning = 1
}
if (`warning'==1) {
    di
    di as err "Warning: not all panels have the same number of columns."
    di as err "Include show(all) in your syntax to view panels."
    di
}

if ("$droph"~="") drop $droph
if ("$dropv"~="") {
    local ndrops : word count $dropv
    tokenize $dropv
    forval x = 1/`ndrops' {
        capture drop ``x''
    }
}

clearglobs
end

*======================== sub routines ========================

*------------------------ error message display table ----------------------

program show_allowtable
di as input "{c TLC}{hline 22}{c TT}{hline 38}{c TT}{hline 22}{c TRC}"
di as input "{c |} {it:Type of table}        {c |}      {it:Allowable cell contents}         {c |}   {it:Available layout}   {c |}"
di as input "{c |} {it:}                     {c |}             {it:cells( )}                 {c |}     {it:layout( )}        {c |}"
di as input "{c LT}{hline 22}{c +}{hline 38}{c +}{hline 22}{c RT}"
di as input "{c |} {bf:basic}                {c |} freq cell row col cum                {c |} col row  cb rb       {c |}"
di as input "{c |} {bf:}                     {c |} {bf:any number of above, in any order}    {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} {it:for example: cells(freq col)}         {c |}                      {c |}"
di as input "{c LT}{hline 22}{c +}{hline 38}{c +}{hline 22}{c RT}"
di as input "{c |} {bf:basic with SE or CI}  {c |} freq cell row col se ci lb ub        {c |} col row cb rb        {c |}"
di as input "{c |} {bf:}                     {c |} {bf:only one of:} freq cell row col       {c |}                      {c |}"
di as input "{c |} {bf:}(turn on {it:svy} option) {c |} {it:(must come first in the cell)}        {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} {bf:and any number of:} se ci lb ub       {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} {it:for example: cells(col se lb ub)}     {c |}                      {c |}"
di as input "{c LT}{hline 22}{c +}{hline 38}{c +}{hline 22}{c RT}"
di as input "{c |} {bf:summary}              {c |} {bf:any number of:} N mean var sd skewness{c |} no options (fixed)   {c |}"
di as input "{c |} {bf:}-as a oneway table   {c |} kurtosis sum uwsum min max count     {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} median iqr r9010 r9050 r7525 r1050   {c |}                      {c |}"
di as input "{c |} {bf:}(turn on {it:sum} option; {c |} p1 p5 p10 p25 p50 p75 p90 p95 p99    {c |}                      {c |}"
di as input "{c |} {bf:}also may need to turn{c |} {bf:with each followed by variable name}  {c |}                      {c |}"
di as input "{c |} {bf:}on {it:oneway} option)    {c |} {it:for example: cells(min wage mean age)}{c |}                      {c |}"
di as input "{c LT}{hline 22}{c +}{hline 38}{c +}{hline 22}{c RT}"
di as input "{c |} {bf:summary}              {c |} {bf:only one of:} N mean var sd skewness  {c |} no options (fixed)   {c |}"
di as input "{c |} {bf:}-as a twoway table   {c |} kurtosis sum uwsum min max count     {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} median iqr r9010 r9050 r7525 r1050   {c |}                      {c |}"
di as input "{c |} {bf:}(turn on {it:sum} option) {c |} p1 p5 p10 p25 p50 p75 p90 p95 p99    {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} {bf:followed by one variable name}        {c |}                      {c |}"
di as input "{c |} {bf:}                     {c |} {it:for example: cells(sum income)}       {c |}                      {c |}"
di as input "{c LT}{hline 22}{c +}{hline 38}{c +}{hline 22}{c RT}"
di as input "{c |} {bf:summary with SE or CI}{c |} mean {bf:followed by one variable name}   {c |} col row cb rb        {c |}"
di as input "{c |} {bf:}(turn on {it:sum} option  {c |} {bf:and any number of:} se ci lb ub       {c |}                      {c |}"
di as input "{c |} {bf:} and {it:svy} option)     {c |} {it:for example: cells(mean weight se ci)}{c |}                      {c |}"
di as input "{c BLC}{hline 22}{c BT}{hline 38}{c BT}{hline 22}{c BRC}"
end

*------------- routines to construct basic matrices -------------------------

*------------------------ basic tables -------------------------
program do_mat
    args  v hvar weightstr1 weightstr2 colmat touse

	
    local format93f = "%9"+"$dpcomma"+"3f"
	local format94f = "%9"+"$dpcomma"+"4f"
	
	if ("`colmat'"=="nil") local colmat = "" 
    local wtstr = cond("`weightstr1'"=="none","","[`weightstr1'`weightstr2']") 
     if $oneway==1 local hvar = ""
     if $sort==1 local dosort = "sort"
    $debug ta `v' `hvar' `wtstr' if `touse', matcell(raw) ///
            matrow(rowvals) `colmat' $stats $mi `dosort'
    local nobs = r(N)
    if (`nobs' == .) {
         di
         di as err "Some of your variables consist entirely of missing values"
         di
         clearglobs
         exit
    }
    if $do_stats==1 {
         local df =  (r(r)-1)*(r(c)-1)
         if ("$stats"=="chi2") {
            local val = string(r(chi2),"`format94f'")
            local pval = string(r(p),"`format93f'")
            local pstr = "Pr = `pval'"
            local ststr = "Pearson chi2(`df') = `val'"
        }
        else
        if ("$stats")=="gamma" {
			local val = string(r(gamma),"`format94f'")
            local pval = string(r(ase_gam),"`format93f'")
            local pstr = "ASE = `pval'"
            local ststr = "Gamma = `val'"
        }
        else
        if ("$stats"=="V") {
            local val = string(r(CramersV),"`format94f'")
            local pstr = ""
            local ststr = "Cramer's V = `val'"
        }
        else
        if ("$stats"=="taub") {
            local val = string(r(taub),"`format94f'")
            local pval = string(r(ase_taub),"`format93f'")
            local pstr = "ASE = `pval'"
            local ststr = "Kendall's tau-b = `val'"
        }
        if ("$stats"=="lrchi2") {
            local val = string(r(chi2_lr),"`format94f'")
            local pval = string(r(p_lr),"`format93f'")
            local pstr = "Pr = `pval'"
            local ststr = "Likelihood-ratio chi2(`df') = `val'"
        }
         global statstr "`ststr' `pstr'"
     }
    
    if $do_n==1 {
        $debug ta `v' `hvar' $n_wt if `touse', matcell(obs)
        mata: build_nmats("obs")
    }
    mata: build_mats($oneway)
end


*------------------------ basic tables with svy option ---------------------

program svy_mat
    args v hvar svycat svylevel svyporp touse
    
    $dots
    if ("$stats"=="chi2") global stats = "pearson"
    if "`svycat'"=="count" local extra = "count"
        else local extra = ""
    if "`svycat'"=="cell" local svycat = "" 
    if $oneway==1 local hvar = ""   
    $dots
    $debug svy, subpop(`touse'): tab `v' `hvar', `svycat' se ci
    local studt = invttail(e(N_psu)-e(N_strata),(1-`svylevel'/100)/2)
    local row = e(r)
    local col = e(c)
    mat obs = e(ObsSub)
    mat rowvals = e(Row)
    mat rowvals = rowvals'
    mat colvals = e(Col)
    mat svymain = e(V)
    mat raw = e(b)
    $dots
		
    local format92f = "%9"+"$dpcomma"+"2f"
	local format93f = "%9"+"$dpcomma"+"3f"
	local format94f = "%9"+"$dpcomma"+"4f"
    if $do_stats==1 {
         if ("$stats"=="pearson") {
            local df =  (e(r)-1)*(e(c)-1)
            local val = string(e(cun_Pear),"`format94f'")
            local pval = string(e(p_Pear),"`format93f'")
            local F1 = string(e(F_Pear),"`format94f'")
            local F1df = string(e(df1_Pear),"`format92f'")
            local F2df = string(e(df2_Pear),"`format92f'")
            global statstr1 "Pearson: Uncorrected chi2(`df') = `val'"
        global statstr2 ///
        "Design-based F(`F1df', `F2df') = `F1' Pr = `pval'"
        }
    }
    
    if $oneway==1 {
        $dots
        mata: svy_oneway(`svyporp')
        mata: svy_se_oneway(`svyporp',`row') 
    }
    else {
        $dots
        $debug svy, subpop(`touse'): tab `hvar' if `v'<., `extra' se
        mat svyrow = e(V)
        mat rawrt = e(b)
        $dots
        $debug svy, subpop(`touse'): tab `v' if `hvar'<., `extra' se
        mat svycol = e(V)
        mat rawct = e(b)
        if "`svycat'"=="" | "`svycat'"=="count" ///
            mata: svy_cell(`svyporp',`col')
        else    mata: svy_rowcol(`svyporp',`row',`col')
        mata: svy_se(`svyporp',`row',`col') 
    }
    $dots
    if $do_pop==1 {
        $debug ta `v' `hvar' $n_wt if `touse', matcell(obs)
        mata: build_nmats("obs")
    }
    else {
        mata: build_nmats("obs")
    }
    mata: cis(`svyporp',`studt',`"`extra'"')
    $dots
end

*------------------------ summary tables with svy option -------------------
program svy_sum
    args svy_sumvar v hvar svylevel colmat touse
    
    $dots
    if ("`colmat'"=="nil") local colmat = ""
    if $oneway==1 {
        local hvar = ""
        local over = ", over(`v')"
    }
    else local over = ", over(`v' `hvar')"

    $dots
    $debug svy, subpop(`touse'): mean `svy_sumvar' `over'
    local studt = invttail(e(N_psu)-e(N_strata),(1-`svylevel'/100)/2)
    mat svymain = e(V)
    mat raw = e(b)
    $dots

    if ($oneway==0) {
        $dots
        $debug svy, subpop(`touse'): mean `svy_sumvar', over(`hvar')
        mat svyrow = e(V)
        mat rawrt = e(b)
        $dots
        $debug svy, subpop(`touse'): mean `svy_sumvar', over(`v')
        mat svycol = e(V)
        mat rawct = e(b)
    }

    $dots
    $debug svy, subpop(`touse'): mean `svy_sumvar' if `v'<.,
    mat gmean = e(b)
    mat svygmean = e(V)
    $dots
    $debug ta `v' `hvar' $n_wt if `touse', matcell(obs) ///
            matrow(rowvals) `colmat' 
    local row = r(r)        
    local col = r(c)
    
    $dots
    mata: svy_mean(`row',`col',$oneway)
    $dots
    mata: svy_meanse(`row',`col',$oneway)
    $dots
    mata: meancis(`studt')
    $dots
    mata: build_nmats("obs")
    $dots
end

*------------------------ summary tables as twoway (not svy) ----------------
program sum_twoway
    args  v hvar weightstr1 weightstr2 colmat statkind statvar touse
    
    $debug ta `v' `hvar' $n_wt if `touse', matcell(obs) ///
                matrow(rowvals) `colmat'
            
    local r = rowsof(obs)       
    local c = colsof(obs)
    mat mstat = J(`r',`c',0)
    mat rhs = J(`r',1,0)
    mat bot = J(1,`c',0)
    mat gm = J(1,1,0)
    local mtype = "mstat"
    forval x = 1/`r' {
        forval y = 1/`c' {
        local hvalnum = colvals[1,`y']
        local vvalnum = rowvals[`x',1]
        do_statres `statkind'  `statvar' ///
            `v' `hvar' `vvalnum' `hvalnum' ///
            `weightstr1' `weightstr2' `mtype' `touse'
        mat mstat[`x',`y'] = real(r(statres))
        }
    }
    local mtype = "rhs"
    forval x = 1/`r' {
        local vvalnum = rowvals[`x',1]
        local hvalnum = 0
        do_statres `statkind'  `statvar' ///
            `v' `hvar' `vvalnum' `hvalnum' ///
            `weightstr1' `weightstr2' `mtype' `touse'
        mat rhs[`x',1] = real(r(statres))   
    }
    local mtype = "bot"
    forval y = 1/`c' {
        local hvalnum = colvals[1,`y']
        local vvalnum = 0
        do_statres  `statkind'  `statvar' ///
            `v' `hvar' `vvalnum' `hvalnum' ///
            `weightstr1' `weightstr2' `mtype' `touse'
        mat bot[1,`y'] = real(r(statres))   
    }
    local mtype = "gm"
        local vvalnum = 0
        local hvalnum = 0
        do_statres `statkind'  `statvar' ///
            `v' `hvar' `vvalnum' `hvalnum' ///
            `weightstr1' `weightstr2' `mtype' `touse'
        mat gm[1,1] = real(r(statres))  

    mat mstat = mstat , rhs
    mat bot = bot, gm
    mat raw = mstat \ bot
    mata: build_nmats("obs")
end

*--------- summary tables oneway ie. multiple stats (not svy) -----------

program sum_oneway
    args  cells v weightstr1 weightstr2 touse
    
    $debug ta `v' $n_wt if `touse', matcell(obs) ///
            matrow(rowvals)
    local r = rowsof(obs)
    local hvar = "_xx_ph_xx_"
    local c : word count `cells'
    local s = `c'/2
    tokenize `cells'
    forval j = 1/`s' {
        local statkind = "`1'"
        local statvar = "`2'"
        mat m`j' = J(`r',1,0)
        mat t`j' = J(1,1,0)
        local mtype = "onew"
        forval x = 1/`r' {
            local vvalnum = rowvals[`x',1]
            local hvalnum = 0
            do_statres `statkind'  `statvar' ///
                `v' `hvar' `vvalnum' `hvalnum' ///
                `weightstr1' `weightstr2' `mtype' `touse'
            mat m`j'[`x',1] = real(r(statres))  
        }
        local mtype = "onet"
        local vvalnum = 0
        local hvalnum = 0
        do_statres `statkind'  `statvar' ///
            `v' `hvar' `vvalnum' `hvalnum' ///
            `weightstr1' `weightstr2' `mtype' `touse'
        mat t`j'[1,1] = real(r(statres))
        mat full`j' = m`j' \ t`j'
        if (`j'==1) mat raw = full`j'
            else mat raw = raw, full`j'
            
    mac shift 2     
    }
    mata: build_nmats("obs")
end


program do_statres , rclass
    args statkind  statvar v hvar ///
        vvalnum hvalnum weightstr1 weightstr2 mtype touse
    
    local wtstr = cond("`weightstr1'"=="none","","[`weightstr1'`weightstr2']")
    if ("`statkind'"=="uwsum") {
        local wtstr = ""
        local statkind = "sum"
    }
    if "`statkind'" == "median" local statkind "p50" 
    if "`statkind'" == "count" local statkind "N"
    if ("`mtype'"=="mstat") ///
        qui sum `statvar' `wtstr' if `touse' ///
            & `v' == `vvalnum' & `hvar' == `hvalnum', detail
    else if ("`mtype'"=="rhs") ///
        qui sum `statvar' `wtstr' if `touse' /// 
            & `v' == `vvalnum' & !mi(`hvar'), detail
    else if ("`mtype'"=="bot") ///
        qui sum `statvar' `wtstr' if `touse' /// 
            & !mi(`v') & `hvar' == `hvalnum', detail
    else if ("`mtype'"=="gm") ///
        qui sum `statvar' `wtstr' if `touse' /// 
            & !mi(`v') & !mi(`hvar'), detail
    else if ("`mtype'"=="onew") ///
        qui sum `statvar' `wtstr' if `touse' /// 
            & `v' == `vvalnum' , detail
    else if ("`mtype'"=="onet") ///
        qui sum `statvar' `wtstr' if `touse' /// 
            & !mi(`v') , detail     
        if "`statkind'" == "iqr" local statres = r(p75)-r(p25)
        else if "`statkind'" == "r9010" local statres = r(p90)/r(p10)
        else if "`statkind'" == "r9050" local statres = r(p90)/r(p50)
        else if "`statkind'" == "r7525" local statres = r(p75)/r(p25)
        else if "`statkind'" == "r1050" local statres = r(p10)/r(p50)
        else local statres = r(`statkind')
    return local statres "`statres'"
end
    
*--------------- prepare for sending to mata output routines --------------

program do_write
    args v hvar format 
    
    if $oneway==1 local hvar = ""   
    if $oneway==0 {
        local colname : value label `hvar'
        global hvarname : variable label `hvar'
    }
    local rowname : value label `v'
    global vvarname : variable label `v'
    local clab = "$clab"
    local layout = "$layout"
    mata: do_output($oneway,$numcat,$do_n,$do_svy)
end

program sum_write
    args v hvar format cells
    
    if $oneway==1 local hvar = ""   
    if $oneway==0 {
        local colname : value label `hvar'
        global hvarname : variable label `hvar'
    }
    local rowname : value label `v'
    global vvarname : variable label `v'
    local clab = "$clab"
    mata: sum_output($oneway,$do_n)
end



program texfix
    local bad = "$ & _ % ^"
    tokenize `bad'
    local tot = "$vtotal"
    forval x = 1/5 {
        if (strpos("$vtotal","``x''")~=0) ///
            local tot = subinstr("$vtotal","``x''","\\``x''",.)
    }
    if ("$tfont"=="bold") local z = "\textbf{`tot'}" 
        else if ("$tfont"=="italic") local z = "\emph{`tot'}" 
        else if ("$tfont"=="plain") local z = "`tot'"
    global vtotal= "`z'"
end


*------------------------ clearglobs -------------------------
program clearglobs

capture mac drop fpass          
capture mac drop vvarname       
capture mac drop hvarname       
capture mac drop lpass          
capture mac drop single         
capture mac drop vtotal         
capture mac drop do_stats       
capture mac drop do_nnoc        
capture mac drop do_pop
capture mac drop mi
capture mac drop do_n           
capture mac drop n_lab          
capture mac drop n_pos          
capture mac drop show           
capture mac drop colwide        
capture mac drop border         
capture mac drop delim          
capture mac drop do_bot         
capture mac drop do_top         
capture mac drop ps             
capture mac drop botinsert      
capture mac drop topinsert      
capture mac drop postfile       
capture mac drop prefile        
capture mac drop do_body        
capture mac drop money          
capture mac drop angle          
capture mac drop cltr2          
capture mac drop cltr1          
capture mac drop cl2            
capture mac drop cl1            
capture mac drop bt             
capture mac drop tfont          
capture mac drop lspace         
capture mac drop htotal         
capture mac drop finaltot       
capture mac drop showtot        
capture mac drop h3             
capture mac drop style          
capture mac drop layout         
capture mac drop do_pseudo      
capture mac drop cisep          
capture mac drop nocib          
capture mac drop noseb          
capture mac drop category       
capture mac drop numcat         
capture mac drop clab           
capture mac drop do_sum         
capture mac drop do_svy         
capture mac drop debug          
capture mac drop oneway         
capture mac drop mainfile       
capture mac drop nogood       
capture mac drop stats       
capture mac drop statstr1       
capture mac drop statstr2       
capture mac drop dpcomma

capture mat drop   check
capture mat drop      CU
capture mat drop      RO
capture mat drop      CO
capture mat drop      CE
capture mat drop      FR
capture mat drop     OBS
capture mat drop   PCOBS
capture mat drop    COBS
capture mat drop    ROBS
capture mat drop     obs
capture mat drop colvals
capture mat drop rowvals
capture mat drop     raw
capture mat drop      UB
capture mat drop      LB
capture mat drop      SE
capture mat drop      SV
capture mat drop svygmean
capture mat drop   gmean
capture mat drop   rawct
capture mat drop  svycol
capture mat drop   rawrt
capture mat drop  svyrow
capture mat drop svymain
capture mat drop     bot
capture mat drop   mstat
capture mat drop      gm
capture mat drop     rhs
capture mat drop   full5
capture mat drop      t5
capture mat drop      m5
capture mat drop   full4
capture mat drop      t4
capture mat drop      m4
capture mat drop   full3
capture mat drop      t3
capture mat drop      m3
capture mat drop   full2
capture mat drop      t2
capture mat drop      m2
capture mat drop   full1
capture mat drop      t1
capture mat drop      m1

end

*======================== mata sub routines ========================

version 9.2
mata:


/* ------------------- data building for basic tables ------------ */

void build_mats (real scalar oneway)
{
    RM = st_matrix("raw")
     FR = counts(RM)
    if (oneway==1) FR = exvector(FR)
     CE = J(rows(FR),cols(FR),0)
     RO = J(rows(FR),cols(FR),0)
     CO = J(rows(FR),cols(FR),0)
     CU = J(rows(FR),cols(FR),.)
     for (i=1; i<=rows(FR); i++) {
        h = i-1
          for (j=1; j<=cols(FR); j++) {
               CE[i,j] = FR[i,j] / FR[rows(FR),cols(FR)] * 100
               RO[i,j] = FR[i,j] / FR[i,cols(FR)] * 100
            CO[i,j] = FR[i,j] / FR[rows(FR),j] * 100
               if (i==1) CU[i,j] = CO[i,j] 
                else if (i<rows(FR)) CU[i,j] = CU[h,j] + CO[i,j]
        }
     }
    st_matrix("FR",FR)
    st_matrix("CE",CE)
    st_matrix("CO",CO)
    st_matrix("RO",RO)
    st_matrix("CU",CU)
}
 


/* ------------------ svy data building routines ------------------ */


void svy_mean   (real scalar r, ///
            real scalar c, ///
            real scalar oneway)
{   
    real matrix SV

    RM = st_matrix("raw")
    OB = st_matrix("obs")
    GM = st_matrix("gmean")
    if (oneway==0){ 
        RT = st_matrix("rawrt")
        CT = st_matrix("rawct")

        SV = J(r,c,0)
        k = 1
        for (i=1; i<=rows(OB); i++) {
            for (j=1; j<=cols(OB); j++) {
                if (OB[i,j]~=0) SV[i,j] = RM[1,k++]
                    else SV[i,j] = .
            }
        }
        CT = CT'
        if (rows(SV)==rows(CT)) SV = SV , CT
        RT = RT, GM
        if (cols(SV)==cols(RT)) SV = SV \ RT
    }
    else {
        GM = st_matrix("gmean")
        SV = RM'
        SV = SV \ GM
    }
    st_matrix("SV",SV)
}

void svy_meanse (real scalar r, /// 
            real scalar c, ///
            real scalar oneway)
                
{
    M = st_matrix("svymain")
    M = diagonal(M)
    OB = st_matrix("obs")
    GM = st_matrix("svygmean")
    if (oneway==0){
        C = st_matrix("svycol")
        C = diagonal(C)
        R = st_matrix("svyrow")
        R = diagonal(R)
        SE = J(r,c,0)
        k = 1
        for (i=1; i<=rows(OB); i++) {
            for (j=1; j<=cols(OB); j++) {
                if (OB[i,j]~=0) SE[i,j] = M[k++,1]
                    else SE[i,j] = .
            }
        }
        if (rows(SE)==rows(C)) SE = SE , C
        R = R'
        R = R, GM
        if (cols(SE)==cols(R)) SE = SE \ R 
    }
    else {
        G = st_matrix("svygmean")
        SE = M \ G
    }
    SE = sqrt(SE)
    st_matrix("SE",SE)
}     


void meancis    (real scalar studt)

{
    SE = st_matrix("SE")
    SV = st_matrix("SV")
    LB = J(rows(SE),cols(SE),0)
    UB = J(rows(SE),cols(SE),0)
    h = rows(SE)
    w = cols(SE)
    for (i=1; i<=rows(SE); i++) {
        for (j=1; j<=cols(SE); j++) {
            d = SV[i,j]
            se = SE[i,j]
            LB[i,j] = d - studt*se
            UB[i,j] = d + studt*se
        }
    }
    st_matrix("LB",LB)
    st_matrix("UB",UB)
}


void svy_rowcol     (real scalar porp, ///
                real scalar r, ///
                real scalar c)
{   
     RM = st_matrix("raw")
     RT = st_matrix("rawrt")
    CT = st_matrix("rawct")
    r = r+1
    type = st_local("svycat")
    if (type=="row") {
        SV = RM, RT
        SV = rowshape(SV,r)
        TT = J(r,1,1) 
        SV = SV, TT
    }
    else if (type=="col") {
        SV = colshape(RM,c)
        CT = CT'
        SV = SV, CT
        c = c+1
        TT = J(1,c,1)
        SV = SV \ TT
    }
    SV = SV*porp
    st_matrix("SV",SV)
}
    

void svy_col    (real scalar porp, ///
            real scalar r, ///
            real scalar c)
{   
     RM = st_matrix("raw")
    CT = st_matrix("rawct")
    c = c+1
    SV = colshape(RM,c)
    CT = CT'
    SV = SV, CT
    c = c+1
    TT = J(1,c,1)
    SV = SV \ TT
    SV = SV*porp
    st_matrix("SV",SV)
}



void svy_cell   (real scalar porp, ///
            real scalar c)
{
    RM = st_matrix("raw")
    RM = colshape(RM,c)
    C = rowsum(RM)
     R = colsum(RM)
    type = st_local("svycat")
     if (type=="count") T = rgtotal(R) 
        else T = 1
     M = RM,C
     BR = R,T
     SV = M \ BR
    SV = SV*porp
    st_matrix("SV",SV)
}     

void svy_oneway (real scalar porp) ///
            
{
    RM = st_matrix("raw")
    RM = colshape(RM,1)
    type = st_local("svycat")
     if (type=="count") T = cgtotal(RM) 
        else T = 1
     SV = RM \ T
     SV = SV*porp
    st_matrix("SV",SV)
}     

void svy_se (real scalar porp, ///
            real scalar r, ///
            real scalar c)
                
{
    M = st_matrix("svymain")
    M = diagonal(M)
    M = colshape(M,c)
    C = st_matrix("svycol")
    C = diagonal(C)
    R = st_matrix("svyrow")
    R = diagonal(R)
    R = rowshape(R,1)
     T = 1
    type = st_local("svycat")
     if (type=="row"){
        for (i=1; i<=rows(C); i++) {
            C[i,1]=.
        }
    }
    else if (type=="col") {
        for (j=1; j<=cols(R); j++) {
            R[1,j]=.
        }
    }
    SE = M,C
     BR = R,T
     SE = SE \ BR
    SE = sqrt(SE)
    SE[r+1,c+1] = .
    SE = SE*porp
    st_matrix("SE",SE)
}     


void svy_se_oneway  (real scalar porp, ///
                real scalar r)
{
    M = st_matrix("svymain")
    SE = diagonal(M)
    T = .
    SE = SE \ T
    SE = sqrt(SE)
    SE = SE*porp
    st_matrix("SE",SE)
}     


void cis    (real scalar porp, ///
        real scalar studt, ///
        string scalar type)
{
    SE = st_matrix("SE")
    SV = st_matrix("SV")
    LB = J(rows(SE),cols(SE),0)
    UB = J(rows(SE),cols(SE),0)
    h = rows(SE)
    w = cols(SE)
    for (i=1; i<=rows(SE); i++) {
        for (j=1; j<=cols(SE); j++) {
            if (type=="count") {
                d = SV[i,j]
                se = SE[i,j]
                LB[i,j] = d - studt*se
                UB[i,j] = d + studt*se
            }
            else {
                d = SV[i,j]
                se = SE[i,j]
                if (porp==100) d = d/100 
                LB[i,j] = porp/(1 + exp(-(log(d/(1-d)) ///
                    - studt*se/(porp*d*(1-d)))))
                UB[i,j] = porp/(1 + exp(-(log(d/(1-d)) ///
                    + studt*se/(porp*d*(1-d)))))
            }
        }
    }
    if (type=="count") {
        LB[h,w] = .
        UB[h,w] = .
    }
    st_matrix("LB",LB)
    st_matrix("UB",UB)
}


/* ----------------- n option data matrices --------------------- */

void build_nmats (string scalar obs)
{
    RM = st_matrix(obs)
    OBS = counts(RM)
    c = cols(OBS)
    r = rows(OBS)
    ROBS = OBS[r,.]
    COBS = OBS[.,c]
    PCOBS = trunc(colperc(COBS))
    st_matrix("ROBS",ROBS)
    st_matrix("COBS",COBS)
    st_matrix("PCOBS",PCOBS)
    st_matrix("OBS",OBS)
}     


/* ------- output matrices standard (incl svy) --------------------- */

void do_output (real scalar oneway, ///
            real scalar numcat, ///
            real scalar do_n, ///
            real scalar do_svy)

{
    do_ci = 0
    do_pseudo = strtoreal(st_global("do_pseudo"))
    htotal = st_global("htotal")
    vtotal = st_global("vtotal")
    
    categ = st_global("category")
    if (do_n==1) { 
        COBS = st_matrix("COBS")
        ROBS = st_matrix("ROBS")
        npos = st_global("n_pos")
        nlab = st_global("n_lab")
        noffset = strtoreal(st_global("n_offset"))
        do_nnoc = strtoreal(st_global("do_nnoc"))
		dpcomma = st_global("dpcomma")				
		if (do_nnoc==0) nform = "%14"+dpcomma+"0fc"
            else nform = "%14"+ dpcomma + "0f"
    }
    if (do_svy==0) {
        DP = (&st_matrix("FR"), &st_matrix("CE"), &st_matrix("CO"), ///
            &st_matrix("RO"), &st_matrix("CU"))
        LIST = ("FR", "CE", "CO", "RO", "CU" \ "1", "2", "3", "4", "5")
        CAT = tokens(categ)
    }
    else {
        DP = (&st_matrix("SV"), &st_matrix("SE"), &st_matrix("LB"), ///
            &st_matrix("UB"))
        LIST = ("SV", "SE", "LB", "UB" \ "1", "2", "3", "4")
        
        if (strpos(categ,"CI") ~=0) {
            categ = subinstr(categ,"CI","LB UB")
            do_ci = 1
        }
        CAT = tokens(categ)
        CAT[1,1] ="SV"
    }
    
        
    FORMAT = tokens(st_local("format"))
    clab = st_local("clab")
    CLAB = tokens(clab)
    TEMP = CLAB
    if (clab~="") CLAB = subinstr(TEMP,"_"," ",.)
    if (do_ci==1)   numcat = numcat+1
    FORMAT = fixgaps(FORMAT,numcat)
    CLAB = fixgaps(CLAB,numcat)

    DOUBLEF = extraformat(FORMAT)
    FORMAT = DOUBLEF[1,.]
    EXTRA = DOUBLEF[2,.]
    for (j=1; j<=cols(FORMAT); j++) {
        formout = FORMAT[1,j]
        formback = fixformat(formout)
        FORMAT[1,j] = formback
    }
    
    ENTRY = CAT \ FORMAT \ EXTRA \CLAB
    CCOUNT = J(1,cols(ENTRY),"")
    for (j=1; j<=cols(ENTRY); j++) {
        for (i=1; i<=cols(LIST); i++) {
            if (ENTRY[1,j]==LIST[1,i]) ///
                CCOUNT[1,j] = LIST[2,i]
        }
    }
    ENTRY = ENTRY \ CCOUNT
    for (j=1; j<=cols(ENTRY); j++) {
        if (ENTRY[5,j]=="") { 
            ""
            "One of your cell entries is invalid"
            exit(0)
        }
    }
    
    layout = st_local("layout")
    fpass = 1
    k = 1
    if (do_ci==0){ 
        for (j=1; j<=cols(ENTRY); j++) {
            i = strtoreal(ENTRY[5,j])       
            M = *DP[i]
            numcols = cols(M)
            if (ENTRY[1,j]=="SE") do_se = 1
                else do_se = 0
            *DP[i] = ///
                makestr(M,ENTRY[2,j],ENTRY[3,j],do_se,do_pseudo,ENTRY[1,j])
            H3 = J(1,cols(M),ENTRY[4,j])
            if (layout=="col" | layout=="c_block" | layout=="r_block" ) ///
                *DP[i] = H3 \ *DP[i]
            k = k+1
            if (oneway==0) {
                HVARVALS = st_matrix("colvals")
                colname = st_local("colname")
                if (colname=="") HVARLABS = hvtostr(HVARVALS)
                    else    HVARLABS = st_vlmap(colname,HVARVALS)
                HVARLABS = HVARLABS , htotal
                *DP[i] = HVARLABS \ *DP[i]
            }
            finrows = rows(*DP[i])
            if (layout=="c_block") {
                if (fpass==1) DATA = *DP[i]
                else DATA = DATA, *DP[i]
            }
            if (layout=="r_block") {
                if (fpass==1) DATA = *DP[i]
                else DATA = DATA \ *DP[i]
               
            }
            fpass = fpass+1
            
        }
    }
    else {
        slast = cols(ENTRY)-1
        last = cols(ENTRY)
        for (j=1; j<=cols(ENTRY); j++) {
            i = strtoreal(ENTRY[5,j])       
            p = strtoreal(ENTRY[5,slast])       
            q = strtoreal(ENTRY[5,last])        
            M = *DP[i]
            SLM = *DP[p]
            LM = *DP[q]
            numcols = cols(M)
            if (j<slast) {
                if (ENTRY[1,j]=="SE") do_se = 1
                    else do_se = 0
                *DP[i] = ///
                    makestr(M,ENTRY[2,j],ENTRY[3,j],do_se,do_pseudo,ENTRY[1,j])
                H3 = J(1,cols(M),ENTRY[4,j])
            }
            else {
                *DP[i] = make_cistr(SLM,LM,ENTRY[2,j],ENTRY[3,j])
                H3 = J(1,cols(M),ENTRY[4,j])
                j = last
            }
            if (layout=="col" | layout=="c_block" | layout=="r_block") ///
                *DP[i] = H3 \ *DP[i]
            k = k+1
            if (oneway==0) {
                HVARVALS = st_matrix("colvals")
                colname = st_local("colname")
                if (colname=="") HVARLABS = hvtostr(HVARVALS)
                    else    HVARLABS = st_vlmap(colname,HVARVALS)
                HVARLABS = HVARLABS , htotal
                *DP[i] = HVARLABS \ *DP[i]
            }
            finrows = rows(*DP[i])
            if (layout=="c_block") {
                if (fpass==1) DATA = *DP[i]
                    else DATA = DATA, *DP[i]
            }
            if (layout=="r_block") {
                if (fpass==1) DATA = *DP[i]
                    else DATA = DATA \ *DP[i]
            }
            fpass = fpass+1
        }
    }
    if (do_ci==1){
        nwide = cols(ENTRY)-1
        NENTRY = J(rows(ENTRY),nwide,"")
        for (i=1; i<=rows(ENTRY); i++) {
            for (j=1; j<=cols(NENTRY); j++) {
                NENTRY[i,j]=ENTRY[i,j]
            }
        }
    ENTRY = NENTRY
    }
    if (layout=="col") { 
        fpass = 1
        for (j=1; j<=numcols; j++) {
            for (k=1; k<=cols(ENTRY); k++) {
                i = strtoreal(ENTRY[5,k])
                M = *DP[i]
                if (fpass==1) DATA = M[.,j]
                    else DATA = DATA, M[.,j]
                fpass = fpass+1
            }
        }
    }
    RVALS = st_matrix("rowvals")
    rowname = st_local("rowname")
    if (rowname=="") RLABELS = vvtostr(RVALS)
        else    RLABELS = st_vlmap(rowname,RVALS)
    RLABELS = RLABELS \ vtotal
    ORIGLABELS = RLABELS
    if (do_n==1) {
        if (npos=="tufte") ///
            RLABELS = add_nlab(RLABELS,PCOBS,1,nlab,nform)
            else if (npos=="lab") ///
                RLABELS = add_nlab(RLABELS,COBS,0,nlab,nform)
    }
    if (layout=="row") { 
        fpass = 1
        if (oneway==0) stpt=2
            else stpt=1
        for (j=stpt; j<=finrows; j++) {
            for (k=1; k<=cols(ENTRY); k++) {
                i = strtoreal(ENTRY[5,k])
                M = *DP[i]
                if (fpass==1) DATA = M[j,.]
                    else DATA = DATA \ M[j,.]
                fpass = fpass+1
            }
        }
        LABS = ENTRY[4,.]
        FINLABS = addlab_torow(RLABELS,LABS)
        DATA = FINLABS, DATA
        if (oneway==1) {
            BLANKS = J(1,numcols,"")
            TOPROW = "#H2", BLANKS
            NEXTROW = "#H3", BLANKS
        }
        else {
            TOPROW = "#H2", HVARLABS
            BLANKS = J(1,cols(HVARLABS),"")
            NEXTROW = "#H3", BLANKS
        }
        DATA = TOPROW \ NEXTROW \ DATA
    }
    if (layout=="col" | layout=="c_block" | layout=="r_block") {
        RLABELS = "#H2" \ "#H3" \ RLABELS
        if (oneway==1) {
            BLANKS = J(1,cols(DATA),"")
            DATA = BLANKS \ DATA
        }
        if (layout=="r_block") {
            if (do_n==1) { 
                k = rows(COBS)+2
                BLANKCOBS = J(k,1,-1)
            }
            if (oneway==1) ADDLABELS = "#H3" \ ORIGLABELS
            else ADDLABELS = "#H2" \ "#H3" \ ORIGLABELS
            p = 1
            counter = numcat
            while (p<counter) {
                if (do_n==1) COBS = COBS \ BLANKCOBS
                RLABELS = RLABELS \ ADDLABELS
                p = p+1
            }
        }
        DATA = RLABELS, DATA
    }
    if (do_svy==1 & (layout=="col" | layout=="c_block")) ///
        DATA = empty_col(DATA) 

    if (do_n==1) {
        if (npos=="col") ///
            DATA = build_ncol(DATA,COBS,nlab,numcat,layout,noffset,nform)
        else if (npos=="row") ///
                DATA = add_nrow(DATA,ROBS,nlab,numcat,layout,noffset, ///
                        nform,oneway)
        else if (npos=="both") {
            DATA = build_ncol(DATA,COBS,nlab, numcat,layout,noffset,nform)
            DATA = add_nrow(DATA,ROBS,nlab,numcat,layout,noffset,nform,oneway)
        }
    }
    DATA = strip_neg(DATA)
    DATA = strip_rows(DATA) 
    
    if (layout=="row") numrows=numcat
        else numrows = 1
    if (do_n==1 & (npos=="row" | npos=="both")) numrows = numrows+1     
    wrap_up(DATA, oneway, numrows)
}

/* ----- output matrices for summary tables (except svy) ------------ */


void sum_output (real scalar oneway, ///
            real scalar do_n)

{
    htotal = st_global("htotal")
    vtotal = st_global("vtotal")
    if (do_n==1) {      
        npos = st_global("n_pos")
        nlab = st_global("n_lab")
        noffset = strtoreal(st_global("n_offset"))
        do_nnoc = strtoreal(st_global("do_nnoc"))
        dpcomma = st_global("dpcomma")
        if (do_nnoc==0) nform = "%14"+dpcomma+"0fc"
            else nform = "%14"+dpcomma+"0f"
    }
    
    RM = st_matrix("raw")
    numcols = cols(RM)
    FORMAT = tokens(st_local("format"))
    FORMAT = fixgaps(FORMAT,numcols)
    DOUBLEF = extraformat(FORMAT)
    FORMAT = DOUBLEF[1,.]
    EXTRA = DOUBLEF[2,.]
    for (j=1; j<=cols(FORMAT); j++) {
        formout = FORMAT[1,j]
        formback = fixformat(formout)
        FORMAT[1,j] = formback
    }
    if (oneway==0) DATA = makestr(RM,FORMAT[1,1],EXTRA[1,1],0,0,"NIL")
    else if (oneway==1) {
        for (j=1; j<=cols(RM); j++) {
            if (j==1) { 
                OM = RM[.,j]
                M = makestr(OM,FORMAT[1,j],EXTRA[1,j],0,0,"NIL")
                DATA = M
            }
            else {
                OM = RM[.,j]
                M = makestr(OM,FORMAT[1,j],EXTRA[1,j],0,0,"NIL")
                DATA = DATA, M
            }
        }
    }
    RVALS = st_matrix("rowvals")
    rowname = st_local("rowname")
    if (rowname=="") RLABELS = vvtostr(RVALS)
        else    RLABELS = st_vlmap(rowname,RVALS)
    RLABELS = RLABELS \ vtotal
    if (do_n==1) {
        if (npos=="tufte") ///
            RLABELS = add_nlab(RLABELS,st_matrix("PCOBS"),1,nlab,nform)
            else if (npos=="lab") ///
                RLABELS = add_nlab(RLABELS,st_matrix("COBS"),0,nlab,nform)
    }
    CELL = tokens(st_local("cells"))
    c = (cols(CELL))/2
    CELL1 = J(1,c,"")
    CELL2 = J(1,c,"")
    j = 1
    p = 1
    while (p<=cols(CELL1)) {
        k = j+1
        CELL1[1,p]= strproper(CELL[1,j])
        CELL2[1,p] = CELL[1,k]
        j = j+2
        p = p+1
    }
    clab = (st_local("clab"))
    if (clab~="") {
        CLAB = tokens(clab)
        CLAB = fixgaps(CLAB,numcols)
        H3LAB = CLAB
    }
    else {
        H3LAB = CELL2
    }
    
    if (oneway==1) {
            TOPROW =  CELL1
            NEXTROW =  H3LAB
        }
    else {
        HVARVALS = st_matrix("colvals")
        colname = st_local("colname")
        if (colname=="") HVARLABS = hvtostr(HVARVALS)
            else    HVARLABS = st_vlmap(colname,HVARVALS)
        HVARLABS = HVARLABS , htotal
        TOPROW = HVARLABS
        if (clab~="")   cstr = CLAB[1,1]+" "
            else cstr = CELL1[1,1]+"_"+CELL2[1,1]+" "
        NEXTROW = tokens(numcols*cstr)
    }
    
    TEMP = NEXTROW  
    NEXTROW = subinstr(TEMP,"_"," ",.) 
        
    DATA = TOPROW \ NEXTROW \ DATA
    RLABELS = "#H2" \ "#H3" \ RLABELS
    DATA = RLABELS, DATA
    
    if (do_n==1) {
        numcat = 0
        layout = "nil"
        if (npos=="col") ///
            DATA = build_ncol(DATA,st_matrix("COBS"),nlab, numcat, ///
                        layout,noffset,nform)
        else if (npos=="row") ///
                DATA = add_nrow(DATA,st_matrix("ROBS"),nlab,numcat, ///
                    layout,noffset,nform,oneway)
        else if (npos=="both") {
            DATA = build_ncol(DATA,st_matrix("COBS"),nlab, ///
                numcat,layout,noffset,nform)
            DATA = add_nrow(DATA,st_matrix("ROBS"),nlab, numcat, ///
                layout,noffset,nform,oneway)
        }
    }
    DATA = strip_neg(DATA)
    numrows = 1
    if (do_n==1 & (npos=="row" | npos=="both")) numrows = numrows+1     
    wrap_up(DATA, oneway, numrows)
}

/* ------------- misc routines for processing ------------------ */

    
            
void wrap_up (string matrix DATA, ///
            real scalar oneway, ///
            real scalar numrows)
{           
    show = st_global("show")
    if (show=="all") show_data(DATA)
    fpass = strtoreal(st_global("fpass"))
    lpass = strtoreal(st_global("lpass"))
    style = st_global("style")
    
    do_body = strtoreal(st_global("do_body"))
    if (do_body==1 & fpass==1) ///
        write_body(1,style,cols(DATA))
    
    do_top = strtoreal(st_global("do_top"))
    if (do_top==1 & fpass==1) /// 
        write_prepost(st_global("prefile"), ///
                st_global("topinsert"), ///
                st_global("ps"), ///
                st_global("delim"))
    
    
    if (style=="tex") write_tex(DATA,oneway,numrows)
        else if (style=="htm") write_htm(DATA,oneway,numrows)
            else write_tab(DATA,oneway,numrows,style)
    
    do_bot = strtoreal(st_global("do_bot"))
    if (do_bot==1 & lpass==1) /// 
        write_prepost(st_global("postfile"), ///
                st_global("botinsert"), ///
                st_global("ps"), ///
                st_global("delim"))
    
                
    if (do_body==1 & lpass==1) ///
        write_body(0,style,cols(DATA))

    check_cols(DATA)
}



void check_cols (string matrix X)
{
    check = st_matrix("check")
    p = cols(X)
    check = check, p
    st_matrix("check",check)
}


function empty_col(string matrix X)

{
    Z = X
    Y = Z[.,1]
    for (j=2; j<=cols(Z); j++) {
        empty = 1
        for (i=3; i<=rows(Z); i++) {
            if (Z[i,j]~="") empty = 0
        }
        if (empty==0)   Y = Y, Z[.,j]
    }
    return(Y)
}
        
        
        
function strip_rows (string matrix X)
{
    Z = X
    k = cols(Z)
    Y = J(2,k,"")
    for (i=1; i<=2; i++) {
        Y[i,.] = Z[i,.]
    }
    for (i=3; i<=rows(Z); i++) {
        if (Z[i,1]~="#H2") { 
            if (Z[i,1]=="#H3") Z[i,1] = ""
            Y = Y \ Z[i,.]
        }
    }
    return(Y)
}           
            
function strip_neg (string matrix X)
{
    p = rows(X)
    q = cols(X)
    Z = J(p,q,"")
    
    for (i=1; i<=rows(Z); i++) {
        for (j=1; j<=cols(Z); j++) {
            if (X[i,j]~="-999") Z[i,j] = X[i,j]
        }
    }
    return(Z)
}           



function hvtostr( real matrix X)
{
    string matrix Z
    
    Y = X
    Z = J(1,cols(Y),"")
    for (j=1; j<=cols(Y); j++) {
        Z[1,j] = strofreal(Y[1,j])
    }
    return(Z)
}

function vvtostr( real matrix X)
{
    string matrix Z
    
    Y = X
    Z = J(rows(Y),1,"")
    for (i=1; i<=rows(Y); i++) {
        Z[i,1] = strofreal(Y[i,1])
    }
    return(Z)
}



function addlab_torow(string matrix X, ///
                    string matrix Y)
{
    Y[1,1] = " "+Y[1,1]
    t = rows(X)*cols(Y)
    A = J(t,1,"")
    k = 1
    for (i=1; i<=rows(X); i++) {
        for (j=1; j<=cols(Y); j++) {
            if (j==1)   A[k++,1] = X[i,1] + Y[1,j]
            else A[k++,1] = Y[1,j]
        }
    }
    return(A)
}


function extraformat (string matrix Z)
{
    string matrix Y
    Y = J(2,cols(Z),"")
    for (j=1; j<=cols(Z); j++) {
        if (strpos(Z[1,j],"p")) { 
            a = subinstr(Z[1,j],"p","")
            Y[1,j] = a
            Y[2,j] = "p"
        }
        if (strpos(Z[1,j],"m")) { 
            a = subinstr(Z[1,j],"m","")
            Y[1,j] = a
            Y[2,j] = "m"
        }
        if (Y[1,j]=="") {
            Y[1,j] = Z[1,j] 
            Y[2,j] = "nil"
        }
    }
    return(Y)
}
        

function fixformat (string scalar Z)
{
    string scalar X
    dpcomma = st_global("dpcomma")	
    fmt = substr(Z,1,1)
    k = strpos(Z,"c")
    if (k~=0) X = "%14"+dpcomma+fmt+"fc"
        else X = "%14"+dpcomma+fmt+"f"
    return(X)   
}


function fixgaps (string matrix Z, ///
                real scalar numcols)
{
    X = Z
    c = cols(X)
    if (c<numcols) {
        d = numcols-c
        last = X[1,c]
        Y = J(1,d,last)
        X = X,Y
    }
    else if (c>numcols) {
        Y = J(1,numcols,"")
        for (j=1; j<=cols(Y); j++) {
            Y[1,j]=X[1,j]
        }
        X = Y
    }
    return(X)
}
            


function makestr (real matrix Z, ///
                string scalar form, ///
                string scalar extra, ///
                real scalar do_se, ///
                real scalar do_pseudo, ///
                string scalar ctype)
{
    string matrix X

    if (do_se==1) {
        noseb = strtoreal(st_global("noseb"))
        if (noseb==0) {
            lbrack = "("
            rbrack = ")"
        }
        else {
            lbrack = ""
            rbrack = ""
        }
    }
    if (do_pseudo==1) {
        nocib = strtoreal(st_global("nocib"))
        cisep = st_global("cisep")
        if (nocib==0) {
            lcbrack = "["
            rcbrack = "]"
        }
        else {
            lcbrack = ""
            rcbrack = ""
        }
    }
    money = st_global("money")
    X = J(rows(Z),cols(Z)," ")
    for (i=1; i<=rows(Z); i++) {
        for (j=1; j<=cols(Z); j++) {
            a = strofreal(Z[i,j],form)
            if (extra~="nil") {
                if (extra=="p") a = a + "%"
                else if (extra=="m") a = money + a 
            }
            X[i,j] = a
            if (do_se==1)   X[i,j] = lbrack+a+rbrack
            if (do_pseudo & ctype=="LB") X[i,j] = lcbrack+a+cisep   
            if (do_pseudo & ctype=="UB") X[i,j] = a+rcbrack
            if (Z[i,j]==.) X[i,j] = "" 
        }
    }
    return(X)
}



function make_cistr (real matrix Z, ///
                real matrix Y, ///
                string scalar form, ///
                string scalar extra)
{

    cisep = st_global("cisep")
    nocib = strtoreal(st_global("nocib"))
    if (nocib==0) {
        lcbrack = "["
        rcbrack = "]"
    }
    else {
        lcbrack = ""
        rcbrack = ""
    }
    money = st_global("money")
    X = J(rows(Z),cols(Z)," ")
    for (i=1; i<=rows(Z); i++) {
        for (j=1; j<=cols(Z); j++) {
            a = strofreal(Z[i,j],form)
            b = strofreal(Y[i,j],form)
            if (extra~="nil") {
                if (extra=="p") {
                    a = a + "%"
                    b = b + "%"
                }
                else if (extra=="m") {
                    a = money + a 
                    b = money + b
                }
            }
            X[i,j] = lcbrack+a+cisep+b+rcbrack
            if (Z[i,j]==. & Y[i,j]==.) X[i,j] = "" 
        }
    }
    return(X)
}

                    
function labcols (string scalar z, ///
                real scalar j) ///
{
    string rowvector X
    for (i=1; i<=j; i++) {
        X= X, z
    }
    return(X)
}
                

function labrows (string scalar z, ///
                real scalar j) ///
{
    string colvector X
    for (i=1; i<=j; i++) {
        X= X \ z
    }
    return(X)
}

/* -------------------- adding n to table------------------ */

function add_nlab   (string matrix X, ///
                real matrix Y, ///
                real scalar tufte, ///
                string scalar nlab, ///
                string scalar nform)
{
    if (tufte==1){ 
        LB = J(rows(X),1," (")
        RB = J(rows(X),1,"%)")
    }
    else {
        lbreak = strpos(nlab,"#")-1
        rbreak = strpos(nlab,"#")+1
        LB = " " + substr(nlab,1,lbreak)  
        RB = substr(nlab,rbreak,.) 
    }
    A = X:+LB
    B = A:+strofreal(Y,nform)
    Z = B:+RB
    return(Z)
}


function add_nrow   (string matrix X, ///
                real matrix Y, ///
                string scalar nlab, ///
                real scalar numcat, ///
                string scalar layout, ///
                real scalar noffset, ///
                string scalar nform, ///
                real scalar oneway)
{
    if (noffset>=numcat) noffset = numcat-1
    string rowvector A
    D = strofreal(Y,nform)
    if (oneway==1) D = D[1,1]
    if (layout=="c_block"){
        if (noffset==0){
            extra = (cols(X)-cols(D))-1 //need to allow for label
            EX = J(1,extra,"-999")
            B = D, EX
        }
        else {
            dnum = cols(D)
            fnum = cols(X)
            space = dnum*noffset
            remainder = fnum-(dnum+space+1) // need to allow for label
            B = J(1,space,"-999")
            B = B, D
            if (remainder!=0) {
                RE = J(1,remainder,"-999")
                B = B, RE
            }
        }
    }
    else if (layout=="col") {
        ncols = cols(X)-1
        B = J(1,ncols,"-999")
        k = noffset+1
        for (j=1; j<=cols(D); j++) {
             B[1,k] = D[1,j]
             k = k + numcat
        }
    }
    else {
        ncols = cols(X)-1
        B = J(1,ncols,"-999")
        for (j=1; j<=cols(D); j++) {
             B[1,j] = D[1,j]
        }
    }
    L = "@N@"+fixfont(texclean(nlab))
    B = L, B
    Z = X \ B
    return(Z)
}


function build_ncol (string matrix X, ///
                real matrix Y, ///
                string scalar nlab, ///
                real scalar numcat, ///
                string scalar layout, ///
                real scalar noffset, ///
                string scalar nform)
{               
    if (noffset>=numcat) noffset = numcat-1
    string colvector A
    A = strofreal(Y,nform)
    D = ""
    m = 0
    for (i=1; i<=rows(Y); i++) {
        if (Y[i,1]!=-1) {
            m = m+1
            if (m==1) D = A[i,1]
            else  D = D \ A[i,1]
        }
    }
    if (layout=="r_block"){
        if (noffset==0){
            B = J(2,1,"-999")
            B = B \ A
        }
        else {
            C = J(2,1,"-999")
            D = C \ D
            dnum = rows(D)
            fnum = rows(X)
            space = dnum*noffset
            remainder = fnum-(dnum+space)
            B = J(space,1,"-999")
            B = B \ D
            if (remainder!=0) {
                RE = J(remainder,1,"-999")
                B = B \ RE
            }
        }
    }
    else if (layout=="row"){
        nrows = rows(X)
        B = J(nrows,1,"-999")
        k = noffset+3
        for (i=1; i<=rows(D); i++) {
            B[k,1] = D[i,1]
            k = k + numcat
        }
    }
    else {
        B = J(2,1,"-999")
        B = B \ D
    }
    B[1,1] = nlab
    W = X,B
return(W)   
}
    


/* ------------------ misc routines ------------------------ */


function colperc (real matrix Z)
{
    X = J(rows(Z),1,0)
    for (i=1; i<=rows(X); i++) {
        X[i,1]=(Z[i,1]/Z[rows(Z),1])*100
    }
    return(X)
}

function rowperc (real matrix Z)
{
    X = J(1,cols(Z),0)
    for (i=1; i<=cols(X); i++) {
        X[1,i]=(Z[1,i]/Z[1,cols(Z)])*100
    }
    return(X)
}


function rgtotal (real matrix Z)
{
    X = 0
    for (j=1; j<=cols(Z); j++) {
            X = X + Z[1,j]
    }
    return(X)
}

function cgtotal (real matrix Z)
{
    X = 0
    for (i=1; i<=rows(Z); i++) {
            X = X + Z[i,1]
    }
    return(X)
}

function counts (real matrix Z)
{
     R = rowsum(Z)
     C = colsum(Z)
     T = sum(R)
     MR = Z,R
     BR = C,T
     X = MR \ BR
     return(X)
}     


function exvector (real matrix Z)
{
    X = J(rows(Z),1,0)
    for (i=1; i<=rows(X); i++) {
        X[i,1]=Z[i,1]
    }
    return(X)
}

/* -------------------- displaying the results ---------------------- */

void show_data (string matrix X)
{           
            
    finaltot = strtoreal(st_global("finaltot"))
    lpass = strtoreal(st_global("lpass"))
    
    if (finaltot==1 & lpass==1) show = 0
        else show = 1
    if (show==1) {
        colwide = strtoreal(st_global("colwide"))
        Z = X
        for (i=1; i<=rows(Z); i++) {
            Z[i,1] = substr(Z[i,1],1,colwide)
        }
        for (j=1; j<=cols(Z); j++) {
            for (i=1; i<=2; i++) {
                Z[i,j] = substr(Z[i,j],1,colwide)
            }
        }
        Z[1,1] = ""
        Z[2,1] = ""
        Z
    }
}

/* ------------------ writing output to files ---------------------- */

void write_tab(string matrix X, ///
            real scalar oneway, ///
            real scalar numrows, ///
            string scalar style)
{               
    done = 0
    outfile = st_global("mainfile")
    fh_out = fopen(outfile,"a")
    do_n = strtoreal(st_global("do_n"))
    npos = st_global("n_pos")
        
    statstr = st_global("statstr")
    statstr1 = st_global("statstr1")
    statstr2 = st_global("statstr2")
    
    single = strtoreal(st_global("single"))
    fpass = strtoreal(st_global("fpass"))
    lpass = strtoreal(st_global("lpass"))
    showtot = strtoreal(st_global("showtot"))
    finaltot = strtoreal(st_global("finaltot"))
    
    h1 = st_global("h1")
    h2 = st_global("h2")
    h3 = st_global("h3")
    lspace = strtoreal(st_global("lspace"))
    vvarname = st_global("vvarname")
    delim = st_global("delim")
    if (oneway==1 & do_n==1 & (npos=="col" | npos=="both")) fixn =1 
        else fixn = 0

    if (style=="csv") { 
        ptab = ","
        X = fix_commas(X)
    }
    else if (style=="semi") {
        ptab = ";"
    }
    else ptab = char(09)
    
    if (fpass==1) {
        if (oneway==0)  {
            if (h1~="nil") { 
                if (h1~="") {
                    topstr = subinstr(h1,delim,ptab)
                    fput(fh_out, topstr)
                }
                else {
                    hvarname = st_global("hvarname")
                    numcols =  cols(X)-2
                    topstr = ptab + hvarname + numcols*ptab
                    fput(fh_out, topstr)
                }
            }
        }
        if (h2~="nil"){ 
            if (h2~="") {
                midstr = subinstr(h2,delim,ptab)
                fput(fh_out, midstr)
            }
            else {
                if (X[1,2]~=""){
                    if (single==1) {
                        line = vvarname
                        done = 1
                    }
                    else line =""
                    for (j=2; j<=cols(X); j++) {
                        line = line + ptab + X[1,j]
                    }
                    fput(fh_out, line)
                }
            }
        }
        if (h3~="nil") { 
            if (h3~="") {
                botstr = subinstr(h3,delim,ptab)
                fput(fh_out, botstr)
            }
            else {
                if (single==1 & done==0) line = vvarname
                    else line =""
                for (j=2; j<=cols(X); j++) {
                    if (fixn==1 & j==cols(X)) w = 1
                        else w = 2
                    line = line + ptab + X[w,j]
                }
                fput(fh_out, line)
            }
        }
    }
    if (single==0) {
        numcols = cols(X)-1
        varstr = vvarname + numcols*ptab
        if (vvarname~="!PTOTAL!") fput(fh_out, varstr)
    }

    if (showtot==0) size = rows(X) - numrows
        else size = rows(X)
        
    for (i=3; i<=size; i++) {
        line = X[i,1]
        for (j=2; j<=cols(X); j++) {
            line = line + ptab + X[i,j]
        }
        if (substr(X[i,1],1,3)~="@N@") ///
            fput(fh_out, line)
    }

    if (finaltot==1 & lpass==1) do_stat = 0
        else do_stat = 1    
    if (do_stat==1) { 
        if (statstr~="") {
            numtabs = cols(X)-1
            outstr = statstr + numtabs*ptab
            fput(fh_out, "")
            fput(fh_out, outstr)
        }
        if (statstr1~="") {
            numtabs = cols(X)-1
            outstr1 = statstr1 + numtabs*ptab
            outstr2 = statstr2 + numtabs*ptab
            fput(fh_out, "")
            fput(fh_out, outstr1)
            fput(fh_out, outstr2)
        }
    }
        
    k = rows(X)
    if (lpass==1 & substr(X[k,1],1,3)=="@N@") {
        line = X[k,1]
        for (j=2; j<=cols(X); j++) {
            line = line + ptab + X[k,j]
        }
        if (finaltot==0) fput(fh_out, "")
        line = subinstr(line,"@N@","")
        fput(fh_out, line)
    }
    
    for (j=1; j<=lspace; j++) {
        fput(fh_out, "")
    }
        
    fclose(fh_out)
}   


void write_tex(string matrix X, ///
            real scalar oneway, ///
            real scalar numrows)
{               

    done = 0
    outfile = st_global("mainfile")
    fh_out = fopen(outfile,"a")
    do_n = strtoreal(st_global("do_n"))
    npos = st_global("n_pos")
    
    statstr = st_global("statstr")
    statstr1 = st_global("statstr1")
    statstr2 = st_global("statstr2")
    
    single = strtoreal(st_global("single"))
    fpass = strtoreal(st_global("fpass"))
    lpass = strtoreal(st_global("lpass"))
    showtot = strtoreal(st_global("showtot"))
    finaltot = strtoreal(st_global("finaltot"))
    
    h1 = st_global("h1")
    h2 = st_global("h2")
    h3 = st_global("h3")
    lspace = strtoreal(st_global("lspace"))
    vvarname = st_global("vvarname")
    
    ptab = "&"
    pterm = " \\"
    cl1 = st_global("cl1")
    cl2 = st_global("cl2")
    CL1 = tokens(cl1)
    CL2 = tokens(cl2)
    cltr1 = st_global("cltr1")
    cltr2 = st_global("cltr2")
    CLTR1 = tokens(cltr1)
    CLTR2 = tokens(cltr2)
    if (cl1~="") CLTR1 = fixgaps(CLTR1,cols(CL1))
    if (cl2~="") CLTR2 = fixgaps(CLTR1,cols(CL2))
    
    if (oneway==1 & do_n==1 & (npos=="col" | npos=="both")) fixn =1 
        else fixn = 0
    
    if (strtoreal(st_global("bt"))==1) rule = "\midrule"
        else rule = "\hline"

    if (fpass==1) {
        if (oneway==0)  {
            if (h1~="nil") { 
                if (h1~="") {
                    topstr = h1
                    fput(fh_out, topstr)
                }
                else {
                    hvarname = fixfont(texclean(st_global("hvarname")))
                    if (do_n==1 & (npos=="col" | npos=="both")) ///
                            numcols = cols(X)-2
                        else numcols = cols(X)-1
                    mc_cols = strofreal(numcols)
                    topstr = " & \multicolumn{"+ mc_cols + ///
                        "}{c}{" + hvarname + "} \\"
                    fput(fh_out, topstr)
                }
            }
        }
        if (cl1~="") {
            cline = "\cmidrule(l{" + CLTR1[1,1] + "}){" + CL1[1,1] + "} "
            for (j=2; j<=cols(CL1); j++) {
                cline = cline ///
                + "\cmidrule(l{" + CLTR1[1,j] + "}){" + CL1[1,j] + "}"
            }
            fput(fh_out,cline)
        }
        if (h2~="nil"){ 
            if (h2~="") {
                midstr = h2
                fput(fh_out, midstr)
            }
            else {
                if (X[1,2]~="") {
                    if (single==1) {
                        line = fixfont(texclean(vvarname))
                        done = 1
                    }
                    else line =""
                    mcol=fixmulti(X[1,.]) 
                    if (mcol[2,1]~="na"){
                        for (j=1; j<=cols(mcol); j++) {
                            name = fixfont(texclean(mcol[1,j]))
                            if (mcol[2,j]~="1") { 
                            line = line + ///
                                " & \multicolumn{" + ///
                                mcol[2,j] + ///
                                "}{c}{" + name +"}"
                            }
                            else    line = line + ptab + name
                        }
                    }
                    else {
                        for (j=2; j<=cols(X); j++) {
                            line = line + ptab + ///
                                rotate(fixfont(texclean(X[1,j])))
                        }
                    }
                line = line + pterm
                fput(fh_out, line)
                }
            }
        }
        if (cl2~="") {
            cline = "\cmidrule(l{" + CLTR2[1,1] + "}){" + CL2[1,1] + "} "
            for (j=2; j<=cols(CL2); j++) {
                cline = cline ///
                + "\cmidrule(l{" + CLTR2[1,j] + "}){" + CL2[1,j] + "}"
            }
            fput(fh_out,cline)
        }
        if (h3~="nil") { 
            if (h3~="") {
                botstr = h3
                fput(fh_out, botstr)
            }
            else {
                if (single==1 & done==0) ///
                    line = fixfont(texclean(vvarname))
                else line = ""
                for (j=2; j<=cols(X); j++) {
                    if (fixn==1 & j==cols(X)) w = 1
                        else w = 2
                    line = line + ptab +texclean(X[w,j])
                }
                fput(fh_out, line+pterm)
            }
        }
    }
    
    for (j=1; j<=lspace; j++) {
        fput(fh_out, rule)
    }

    if (single==0) {
        numcols = cols(X)-1
        varstr = fixfont(texclean(vvarname)) + numcols*ptab + pterm
        if (vvarname~="!PTOTAL!") fput(fh_out, varstr)
    }

    if (showtot==0) size = rows(X) - numrows
        else size = rows(X)

    for (i=3; i<=size; i++) {
        line = texclean(X[i,1])
        for (j=2; j<=cols(X); j++) {
            line = line + ptab + texclean(X[i,j])
        }
        if (substr(X[i,1],1,3)~="@N@") ///
            fput(fh_out, line+pterm)
    }
    
    if (finaltot==1 & lpass==1) do_stat = 0
        else do_stat = 1    
    if (do_stat==1) { 
        if (statstr~="") {
            a = subinstr(statstr,"=","=&")
            b = subinstr(a,"Pr","&Pr")
            c = subinstr(b,"ASE","&ASE")
            k = tokens(c,"&")
            j = (cols(k)/2)
            numtabs = cols(X)-j
            outstr = c + numtabs*ptab + pterm
            fput(fh_out, rule)
            fput(fh_out, outstr)
        }
        if (statstr1~="") {
            numtabs = cols(X)-2
            a = subinstr(statstr1,"=","=&")
            outstr1 = a + numtabs*ptab + pterm
            fput(fh_out, rule)
            fput(fh_out, outstr1)
            a = subinstr(statstr2,"=","=&")
            b = subinstr(a,"Pr","&Pr")
            numtabs = cols(X)-4 
            outstr2 = b + numtabs*ptab + pterm
            fput(fh_out, outstr2)
        }
    }
    k = rows(X)
    if (lpass==1 & substr(X[k,1],1,3)=="@N@") {
        line = X[k,1]
        for (j=2; j<=cols(X); j++) {
            line = line + ptab + texclean(X[k,j])
        }
        if (finaltot==0) fput(fh_out, rule)
        line = subinstr(line,"@N@","")
        fput(fh_out, line+pterm)
    }
    
    fclose(fh_out)
}   

void write_htm(string matrix X, ///
            real scalar oneway, ///
            real scalar numrows)
{               

    done = 0
    outfile = st_global("mainfile")
    fh_out = fopen(outfile,"a")
    do_n = strtoreal(st_global("do_n"))
    npos = st_global("n_pos")
    
    statstr = st_global("statstr")
    statstr1 = st_global("statstr1")
    statstr2 = st_global("statstr2")
    
    single = strtoreal(st_global("single"))
    fpass = strtoreal(st_global("fpass"))
    lpass = strtoreal(st_global("lpass"))
    showtot = strtoreal(st_global("showtot"))
    finaltot = strtoreal(st_global("finaltot"))
    
    h1 = st_global("h1")
    h2 = st_global("h2")
    h3 = st_global("h3")
    vvarname = st_global("vvarname")
    
    pre = "<TD>"
    post = "</TD>"
    rbeg = "<TR>"
    rend = "</TR>"
    
    if (oneway==1 & do_n==1 & (npos=="col" | npos=="both")) fixn =1 
        else fixn = 0

    
    if (fpass==1) {
        if (oneway==0)  {
            if (h1~="nil") { 
                if (h1~="") {
                    topstr = h1
                    fput(fh_out, topstr)
                }
                else {
                    hvarname = fixfont(st_global("hvarname"))
                    if (do_n==1 & (npos=="col" | npos=="both")) ///
                            numcols = cols(X)-2
                        else numcols = cols(X)-1
                    mc_cols = strofreal(numcols)
                    topstr = topstr = pre+post+"<TD colspan="+mc_cols ///
                        + " align=center>"+ hvarname +post
                    fput(fh_out,rbeg)
                    fput(fh_out, topstr)
                    fput(fh_out,rend)
                }
            }
        }
        if (h2~="nil"){ 
            if (h2~="") {
                midstr = h2
                fput(fh_out, midstr)
            }
            else {
                if (X[1,2]~="") {
                    if (single==1) {
                        line = fixfont(vvarname)
                        done = 1
                    }
                    else line =""
                    mcol=fixmulti(X[1,.]) 
                    if (mcol[2,1]~="na"){
                        for (j=1; j<=cols(mcol); j++) {
                            name = fixfont(mcol[1,j])
                            if (mcol[2,j]~="1") { 
                            line = line + ///
                                "<TD colspan=" + ///
                                mcol[2,j] + ///
                                " align=center>"+ name
                            }
                            else    line = line + pre + name +post
                        }
                    }
                    else {
                        for (j=2; j<=cols(X); j++) {
                            line = line + pre + fixfont(X[1,j]) + post
                        }
                    }
                fput(fh_out, rbeg)
                fput(fh_out, pre+line)
                fput(fh_out, rend)
                }
            }
        }
        if (h3~="nil") { 
            if (h3~="") {
                botstr = h3
                fput(fh_out, botstr)
            }
            else {
                if (single==1 & done==0) ///
                    line = fixfont(vvarname)
                else line = ""
                for (j=2; j<=cols(X); j++) {
                    if (fixn==1 & j==cols(X)) w = 1
                        else w = 2
                    line = line + pre + X[w,j] + post
                }
                fput(fh_out, rbeg)
                fput(fh_out, pre+post+line)
                fput(fh_out, rend)
            }
        }
    }
    
    if (single==0) {
        numcols = cols(X)-1
        varstr = fixfont(vvarname) 
        if (vvarname~="!PTOTAL!") {
            fput(fh_out, rbeg)
            fput(fh_out, pre+varstr+post)   
            fput(fh_out, rend)
        }
    }

    if (showtot==0) size = rows(X) - numrows
        else size = rows(X)

    for (i=3; i<=size; i++) {
        line = pre + X[i,1] + post
        for (j=2; j<=cols(X); j++) {
            line = line + pre + X[i,j] +post
        }
        if (substr(X[i,1],1,3)~="@N@") {
            fput(fh_out, rbeg)
            fput(fh_out, line)  
            fput(fh_out, rend)
        }           
    }
    
    if (finaltot==1 & lpass==1) do_stat = 0
        else do_stat = 1    
    if (do_stat==1) {
        j = strofreal(cols(X))
        if (statstr~="") {
            statstr="<TD colspan="+ j ///
                        + " align=left>"+ statstr +post
            fput(fh_out, rbeg)
            fput(fh_out, statstr)
            fput(fh_out, rend)
        }
        if (statstr1~="") {
            statstr1="<TD colspan="+ j  ///
                        + " align=left>"+ statstr1 +post
            statstr2="<TD colspan="+ j ///
                        + " align=left>"+ statstr2 +post
            fput(fh_out, rbeg)
            fput(fh_out, statstr1)
            fput(fh_out, rend)
            fput(fh_out, rbeg)
            fput(fh_out, statstr2)
            fput(fh_out, rend)
        }
    }
    k = rows(X)
    if (lpass==1 & substr(X[k,1],1,3)=="@N@") {
        line = X[k,1]
        for (j=2; j<=cols(X); j++) {
            line = line + pre + X[k,j] + post
        }
        line = subinstr(line,"@N@","<TD>")
            fput(fh_out, rbeg)
            fput(fh_out, line)
            fput(fh_out, rend)
    }
    
    fclose(fh_out)
}   


/* ------------------ misc routines for writing  ---------------------- */


void write_prepost (string scalar pfilename,
                string scalar insert, ///
                string scalar ps, ///
                string scalar delim)
{
    outfile = st_global("mainfile")
    fh_out = fopen(outfile,"a")
    infile = pfilename

    fh_in = fopen(infile,"r")
    if (insert~="nil"){ 
        INS = tokens(insert,delim)
        INS = strip_delim(INS,delim)
        k = 1
        while ((line=fget(fh_in))!=J(0,0,"")) {
            if (strpos(line,ps)>0) {
                if (k<=cols(INS)) { 
                    line = subinstr(line,ps,INS[1,k])
                    k = k+1
                }
            }
            fput(fh_out,line)
        }
    }
    else {
        while ((line=fget(fh_in))!=J(0,0,"")) {
            fput(fh_out,line)
        }
    }
    
    fclose(fh_out)
    fclose(fh_in)
}


void write_body (real scalar top, ///                 
            string scalar style, ///
            real scalar cols)
{
    outfile = st_global("mainfile")
    fh_out = fopen(outfile,"a")
    
    if (style=="tex") { 
        if (top==1){
            cols = cols-1
            fput(fh_out,"\documentclass{article}")
            fput(fh_out,"\usepackage{multicol}")
            fput(fh_out,"\begin{document}")
            cstr = cols*"r"
            fput(fh_out,"\begin{tabular}{l"+cstr+"}")
            fput(fh_out,"\hline")
        }
        else {
            fput(fh_out,"\hline")
            fput(fh_out,"\end{tabular}")
            fput(fh_out,"\end{document}")
            }
    }
    else if (style=="htm") {
        border = st_global("border")
        if (top==1) { 
            fput(fh_out,"<HTML>")
            fput(fh_out,"<BODY> <TABLE "+border+">")
        }
        else {
            fput(fh_out,"</TABLE>")
            fput(fh_out,"</BODY>") 
            fput(fh_out,"</HTML>") 
        }
    }
    fclose(fh_out)
}

function fix_commas(string matrix X)
{
    Z = X
    for (i=1; i<=rows(Z); i++) {
        for (j=1; j<=cols(Z); j++) {
            if (strpos(Z[i,j],",")~=0) ///
                Z[i,j]=`"""'+Z[i,j]+`"""'
        }
    }
    return(Z)
}

function strip_delim (string matrix X, ///
                 string scalar delim)
{
    Z = X
    Y = Z[1,1]
    k = 2
    while (k<=cols(Z)) {
        if (Z[1,k]~=delim) ///
            Y = Y, Z[1,k]
            k = k+1
    }
    return(Y)
}
        

function fixfont (string scalar X)
{
    font = st_global("tfont")
    style = st_global("style")
    if (style=="tex"){ 
        if (font=="bold") Z = "\textbf{"+X+"}" 
            else if (font=="italic") Z = "\emph{"+X+"}" 
            if (font=="plain") Z = X
    }
    else if (style=="htm") {
        if (font=="bold") Z = "<B>"+X+"</B>"
            else if (font=="italic") Z = "<I>"+X+"</I>" 
            if (font=="plain") Z = X
    }   
    else Z = X
    return(Z)
}

function rotate( string scalar X)
{
    style = st_global("style")
    angle = st_global("angle")
    if (style=="tex" & angle~="0") {
        Z = "\rot{"+angle+"}{"+X+"}"
    }
    else Z = X
    return(Z)
}


function texclean( string scalar X)
{
    a = X
    style = st_global("style")
    if (style=="tex"){ 
        b = subinstr(a,"$","\\$")
        c = subinstr(b,"&","\&")
        d = subinstr(c,"_","\_")
        e = subinstr(d,"%","\%")
    }
    else e = a
    return(e)
}


function fixmulti (string matrix inrow)
{
    w = cols(inrow)
    mstr = J(1,w,"")
    mnum = J(1,w,0)
    k = 1
    mstr[1,1] = inrow[1,2]
    mnum[1,1] = 1
    for (j=3; j<=w; j++) {
        p = j-1
        if (inrow[1,j]==inrow[1,p]) mnum[1,k] = mnum[1,k]+1
        else {
            k = k+1
            mstr[1,k] = inrow[1,j]
            mnum[1,k] = 1
        } 
    }
    count = sum(mnum)
    multi1 = mstr[1,1]
    multi2 = strofreal(mnum[1,1])
    j = 2
    while (mnum[1,j]~=0) {
        multi1 = multi1, mstr[1,j]
        multi2 = multi2, strofreal(mnum[1,j])
        j = j+1
    }
    multi = multi1 \ multi2
    if (cols(multi)==count) multi[2,1] = "na"
    return(multi)
}


end
