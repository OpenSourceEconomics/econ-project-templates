program define tabstatout, rclass byable(recall) sort
*! 2.1 Ian Watson 19feb2009. New version for spreadsheet textfile output only. Based on latabstat
*! 1.1 Ian Watson 18jan2003. Modification of tabstat version 2.5.2  09nov2000 
* Note the shallow indentation mostly indicates modifications. Deeper indentations are 
* generally from original tabstat coding.

	version 6

	syntax varlist(numeric) [if] [in] [aw fw] [ , /*
	*/ 	BY(varname) CASEwise Columns(str) Format Format2(str) /*
	*/ 	LAbelwidth(int 16) LOngstub Missing /*
	*/ 	SAME SAVE noSEP Statistics(str) STATS(str) noTotal /*
	*/	tf(string)Replace APPend TX(string) CAPtion(string) /*
	*/	CLabel(string) HWidth(string)]

	if "`tx'" ~=""{
		if "`tx'"=="0" {
			local wide="\linewidth" 
		}
		else {
			local wide="`tx'cm"
		}
	}

	if "`hwidth'" ~=""{
		local hwide="`hwidth'"
		local fhwide=`hwidth'+2
		}
		else {
		local hwide="8"
		local fhwide="10"
	}


	tempname hh 

	if "`casewise'" != "" {
		local same same
	}

	if `"`stats'"' != "" {
		if `"`statistics'"' != "" {
			di in red /*
			*/ "may not specify both statistics() and stats() options"
			exit 198
		}
		local statist `"`stats'"'
		local stats
	}

	if "`total'" != "" & "`by'" == "" {
		di in gr "nothing to display
		exit 0
	}

	if "`format'" != "" & `"`format2'"' != "" {
		di in re "may not specify both format and format()"
		exit 198
	}
	if `"`format2'"' != "" {
		capt local tmp : display `format2' 1
		if _rc {
			di in re `"invalid %format in format() : `format2'"'
			exit 120
		}
	}

	if `"`columns'"' == "" {
		local incol "variables"
	}
	else if `"`columns'"' == substr("variables",1,length(`"`columns'"')) {
		local incol "variables"
	}
	else if `"`columns'"' == substr("statistics",1,length(`"`columns'"')) {
		local incol "statistics"
	}
	else {
		di in red `"column(`columns') invalid -- specify "' /*
			*/ "column(variables) or column(statistics)"
		exit 198
	}

	if "`longstub'" != "" | "`by'" == "" {
		local descr descr
	}

	* sample selection

	marksample touse, novar
	if "`same'" != "" {
		markout `touse' `varlist'
	}
	if "`by'" != "" & "`missing'" == "" {
		markout `touse' `by' , strok
	}
	qui count if `touse'
	local ntouse = r(N)
	if `ntouse' == 0 {
		error 2000
	}
	if `"`weight'"' != "" {
		local wght `"[`weight'`exp']"'
	}

	* varlist -> var1, var2, ... variables
	*            fmt1, fmt2, ... display formats

	tokenize "`varlist'"
	local nvars : word count `varlist'
	local i 1
	while `i' <= `nvars' {
		local var`i' ``i''
		if "`format'" != "" {
			local fmt`i' : format ``i''
		}
		else if `"`format2'"' != "" {
			local fmt`i' `format2'
		}
		else	local fmt`i' %9.0g
		local i = `i' + 1
	}
	if `nvars' == 1 & `"`columns'"' == "" {
		local incol statistics
	}

	* Statistics

	Stats `statistics'
	local stats   `r(names)'
	local expr    `r(expr)'
	local summopt `r(summopt)'
	local nstats : word count `stats'

	tokenize `expr'
	local i 1
	while `i' <= `nstats' {
		local expr`i' ``i''
		local i = `i' + 1
	}
	tokenize `stats'
	local i 1
	while `i' <= `nstats' {
		local name`i' ``i''
		local names "`names' ``i''"
		if `i' < `nstats' { local names "`names'," }
		local i = `i' + 1
	}
	if "`sep'" == "" & ( (`nstats' > 1 & "`incol'" == "variables") /*
		 */              |(`nvars' > 1  & "`incol'" == "statistics")) {
		local sepline yes
	}

	local matsize : set matsize
	local matreq = max(`nstats',`nvars')
	if `matsize' < `matreq' {
		di in re "set matsize to at least `matreq' (see help matsize for details)"
		exit 908
	}

	* compute the statistics
	* ----------------------

	if "`by'" != "" {
		* conditional statistics are saved in matrices Stat1, Stat2, etc

		* the data are sorted on by groups, putting unused obs last
		* be careful not to change the sort order
		* note that touse is coded -1/0 rather than 1/0!

		qui replace `touse' = - `touse'
		sort `touse' `by'

		local bytype : type `by'
		local by2 0
		local iby 1
		while `by2' < `ntouse'  {
			tempname Stat`iby'
			mat `Stat`iby'' = J(`nstats',`nvars',0)
			mat colnames `Stat`iby'' = `varlist'
			mat rownames `Stat`iby'' = `stats'

			* range `iby1'/`iby2' refer to obs in the current by-group
			local by1 = `by2' + 1
			qui count if (`by'==`by'[`by1']) & (`touse')
			local by2 = `by1' + r(N) - 1

			* loop over all variables
			local i 1
			while `i' <= `nvars' {
				qui summ `var`i'' in `by1'/`by2' `wght', `summopt'
				local is 1
				while `is' <= `nstats' {
					* set matrix[is,i] with mv-handling
					SetMat  `Stat`iby''[`is',`i']   `expr`is''
					local is = `is' + 1
				}
				local i = `i' + 1
			}

			* save label for groups in lab1, lab2 etc
			if substr("`bytype'",1,3) != "str" {
				local iby1 = `by'[`by1']
				local lab`iby' : label (`by') `iby1'
			}
			else	local lab`iby' = `by'[`by1']

			local iby = `iby' + 1
		}
		local nby = `iby' - 1

		/* wwg did not like this. Fine.
		if `nby' == 1 {
			di in gr "(`by' is constant on selected sample)"
			local by
			local nby 0
		}
		*/
	}
	else	local nby 0

	if "`total'" == "" {
		* unconditional (Total) statistics are stored in Stat`nby+1'
		local iby = `nby'+1

		tempname Stat`iby'
		mat `Stat`iby'' = J(`nstats',`nvars',0)
		mat colnames `Stat`iby'' = `varlist'
		mat rownames `Stat`iby'' = `stats'

		local i 1
		while `i' <= `nvars' {
			qui summ `var`i'' if `touse' `wght' , `summopt'
			local is 1
			while `is' <= `nstats' {
				* set matrix[is,i] with mv-handling
				SetMat  `Stat`iby''[`is',`i']  `expr`is''
				local is = `is' + 1
			}
			local i = `i' + 1
		}
		local lab`iby' "Total"
	}

	* display results
	* ---------------

	di
	di in gr "\begin{table}[htbp]\centering"
	if "`tx'"~=""{
		di in gr "\newcolumntype{Y}{>{\raggedleft\arraybackslash}X}"
		di in gr "\parbox{`wide'} {"
	}


	* constants for displaying results

	local labw = min(max(`labelwidth',8),60)
	* note changing 32 to 60 determines greatest width for table stub
	if "`by'" != "" {
		if substr("`bytype'",1,3) != "str" {
			local lv : value label `by'
			if "`lv'" != "" {
				local lg : label (`by') maxlength
				local wby = min(`labw',`lg')
			}
			else	local wby 8
		}
		else {
			local wby = min(real(substr("`bytype'",4,.)),`labw')
			local bytype str
		}
		local wby = max(length("`by'"), `wby')
	}
	else	local wby 8

	local lleft = (1 + `wby')*("`by'"!="") + 9*("`descr'"!="")
	local cbar  = `lleft' + 1

	local lsize : set display linesize
	* number of non-label elements in the row of a block
	local neblock = int((`lsize' - `cbar')/10)
	* number of blocks if stats horizontal
	local nsblock  = 1 + int((`nstats'-1)/`neblock')
	* number of blocks if variables horizontal
	local nvblock  = 1 + int((`nvars'-1)/`neblock')

	* left align by-label if also descr
	if "`descr'" != "" & "`by'" != "" {
		local aby "-"
	}
	

	
	if "`incol'" == "statistics" {

		* display the results: horizontal = statistics (block wise)
		* ---------------------------------------------------------

		* header
	di in gr "\caption{\label{`clabel'} "
	di in gr _c "\textbf{`caption'} }"

		* loop over all nsblock blocks of statistics

		local isblock 1
		local is2 0
		while `isblock' <= `nsblock' {

			* is1..is2 are indices of statistics in a block
			local is1 = `is2' + 1
			local is2 = min(`nstats', `is1'+`neblock'-1)

	if "`tx'"~="" {
		di in gr "}"
		di in gr _c "\begin{tabularx} {`wide'} {@{} l"
	}
	else {
		di in gr _c "\begin{tabular} {@{} l"
	}
	local p=1
	while `p'<= `nstats' {
		if "`tx'"~="" {
			di in gr _c " Y"
		}
		else {
			di in gr _c " r"
		}
		local p=`p'+1
	} * end while loop
	di in gr _c " @{}} \\\ \hline"
	di

	di in gr _c "\textbf{"
			* display header
			if "`by'" != "" { di in gr %`aby'`wby's "`by'" " " _c }
			if "`descr'" != "" { di in gr "variable " _c	}
	di in gr "} & \textbf{" _c
			local is `is1'
			while `is' <= `is2' {
				di in gr %10s "`name`is''" _c
				if `is' < `is2'{  
			* < ensures last column does not end with column separator
					di in gr "} & \textbf{" _c 
				}
				local is = `is' + 1
			}
	di in gr "} \\\" 
	di in gr "\\hline" 

			* loop over the categories of -by- (1..nby) and -total- (nby+1)
			local nbyt = `nby' + ("`total'"=="")
			local iby 1
			while `iby' <= `nbyt'{
				local i 1
				while `i' <= `nvars' {
					if "`by'" != "" {
						if `i' == 1 {
							local lab = substr(`"`lab`iby''"'0, 1, `wby')
							di in ye % `aby'`wby's `"`lab'"' " " _c
						}
						else	di in ye _skip(`wby') " " _c
					}
					if "`descr'" != "" {
						di in ye %`fhwide's abbrev("`var`i''", `hwide') " " _c
					}
					local is `is1'
					while `is' <= `is2' {
						GetMat s : `fmt`i'' `Stat`iby''[`is',`i']
	di in ye " & " _c
						di in ye %10s "`s'" _c
						local is = `is' + 1
					}
	di in ye " \\\"
					local i = `i' + 1
				}
				local iby = `iby' + 1

				if ("`sepline'"!="") | (`iby'>`nbyt') | /*
					*/ ((`iby'==`nbyt') & ("`total'"=="")) {

				}
			}
	di in gr "\hline"
	di in gr _c "\multicolumn{" (`nstats'+1) "}{@{}l}{"
	di in gr  "\footnotesize{\emph{Source:} $S_FN}}"
	if "`tx'"~=""{
		di in gr "\end{tabularx}"
	}
	else {
		di in gr "\end{tabular}"      
	}
	di in gr "\end{table}"


			local isblock = `isblock' + 1
			if `isblock' <= `nsblock' {
				display
			}
		} /* isblock */
	}
	else {

		* display the results: horizontal = variables (block wise)
		* --------------------------------------------------------

		* header
	di in gr "\caption{\label{`clabel'} "
	di in gr _c "\textbf{`caption'} }"

	if "`tx'"~="" {
		di in gr "}"
		di in gr _c "\begin{tabularx} {`wide'} {@{} l"
	}
	else {
		di in gr _c "\begin{tabular} {@{} l"
	}
	local p=1
	while `p'<= `nvars' {
		if "`tx'"~="" {
			di in gr _c " Y"
		}
		else {
			di in gr _c " r"
		}
		local p=`p'+1
	} * end while loop
	di in gr _c " @{}} \\\ \hline"
	di



		* loop over all nvblock blocks of variables

		local iblock 1
		local i2 0
		while `iblock' <= `nvblock' {

			* i1..i2 are indices of variables in a block
			local i1 = `i2' + 1
			local i2 = min(`nvars', `i1'+`neblock'-1)

	di in gr _c "\textbf{"
			* display header
			if "`by'" != "" { di in gr %`aby'`wby's "`by'" " " _c }
			if "`descr'" != "" { di in gr "   stats " _c	}

	di in gr "} & \textbf{" _c
			local i `i1'
			while `i' <= `i2' {
				di in gr %`fhwide's abbrev("`var`i''",`hwide') _c
					if `i' < `i2'{
					di in gr "} & \textbf{" _c 
					}
				local i = `i' + 1
			}
	di in gr "} \\\" 
	di in gr "\\hline" 
	
			* loop over the categories of -by- (1..nby) and -total- (nby+1)
			local nbyt = `nby' + ("`total'"=="")
			local iby 1
			while `iby' <= `nbyt'{
				local is 1
				while `is' <= `nstats' {
					if "`by'" != "" {
						if `is' == 1 {
							local lab = substr(`"`lab`iby''"'0, 1, `wby')
							di in ye %`aby'`wby's `"`lab'"' " " _c
						}
						else	di in ye _skip(`wby') " " _c
					}
					if "`descr'" != "" {
						di in ye %8s "`name`is''" " " _c
					}

					local i `i1'
					while `i' <= `i2' {
						GetMat s : `fmt`i'' `Stat`iby''[`is',`i']
	di in ye " & " _c
						di in ye %10s "`s'" _c
						local i = `i' + 1
					}
	di in ye " \\\"
					local is = `is' + 1
				}
				local iby = `iby' + 1

				if ("`sepline'"!="") | (`iby'>`nbyt') | /*
					*/ ((`iby'==`nbyt') & ("`total'"=="")) {
				}
			}
	di in gr "\hline"
	di in gr "\multicolumn{" (`i2'+1) "}{@{}l}{"
	di in gr "\footnotesize{\emph{Source:} $S_FN}}"
	if "`tx'"~=""{
		di in gr "\end{tabularx}"
	}
	else {
		di in gr "\end{tabular}"      
	}
	di in gr "\end{table}"


			local iblock = `iblock' + 1
			if `iblock' <= `nvblock' {
				display
			}
		} /* iblock */
	}

	* save results (mainly for certification)
	* ---------------------------------------

	if "`save'" != "" {
		if "`total'" == "" {
			local iby = `nby'+1
			return matrix StatTot `Stat`iby''
		}

		if "`by'" == "" { exit }
		local iby 1
		while `iby' <= `nby' {
			return matrix Stat`iby' `Stat`iby''
			return local  name`iby' `"`lab`iby''"'
			local iby = `iby' + 1
		}
	}
	
	
	* send to file if requested
	* --------------------------
	
if "`tf'" ~="" {
	if "`replace'" == "replace" {local opt "replace"}
	if "`append'" == "append" {local opt "append"}
	file open `hh' using"`tf'.csv", write `opt'

	* send to file the results
	* ------------------------

	if "`tx'"~=""{
		file write `hh'  "\newcolumntype{Y}{>{\raggedleft\arraybackslash}X}" _n
		file write `hh' "\parbox{`wide'} {" _n
	}


	* constants for displaying results

	local labw = min(max(`labelwidth',8),60)
	* note changing 32 to 60 determines greatest width for row labels
	if "`by'" != "" {
		if substr("`bytype'",1,3) != "str" {
			local lv : value label `by'
			if "`lv'" != "" {
				local lg : label (`by') maxlength
				local wby = min(`labw',`lg')
			}
			else	local wby 8
		}
		else {
			local wby = min(real(substr("`bytype'",4,.)),`labw')
			local bytype str
		}
		local wby = max(length("`by'"), `wby')
	}
	else	local wby 8

	local lleft = (1 + `wby')*("`by'"!="") + 9*("`descr'"!="")
	local cbar  = `lleft' + 1

	local lsize : set display linesize
	* number of non-label elements in the row of a block
	local neblock = int((`lsize' - `cbar')/10)
	* number of blocks if stats horizontal
	local nsblock  = 1 + int((`nstats'-1)/`neblock')
	* number of blocks if variables horizontal
	local nvblock  = 1 + int((`nvars'-1)/`neblock')

	* left align by-label if also descr
	if "`descr'" != "" & "`by'" != "" {
		local aby "-"
	}
	

	
	if "`incol'" == "statistics" {

		* send to file the results: horizontal = statistics (block wise)
		* --------------------------------------------------------------

		* header

		* loop over all nsblock blocks of statistics

		local isblock 1
		local is2 0
		while `isblock' <= `nsblock' {

			* is1..is2 are indices of statistics in a block
			local is1 = `is2' + 1
			local is2 = min(`nstats', `is1'+`neblock'-1)

	if "`tx'"~="" {
		file write `hh' "}" _n
		file write `hh'  "\begin{tabularx} {`wide'} {@{} l"
	}

	local p=1
	while `p'<= `nstats' {
		if "`tx'"~="" {
			file write `hh' " Y"
		}
		local p=`p'+1
	} * end while loop
			* display header
			if "`by'" != "" { file write `hh' %`aby'`wby's "`by'" " "  }
			if "`descr'" != "" { file write `hh' "variable" 	}
	file write `hh'  _tab 
			local is `is1'
			while `is' <= `is2' {
				file write `hh' %10s "`name`is''" 
				if `is' < `is2'{  
			* < ensures last column does not end with column separator
					file write `hh' _tab  
				}
				local is = `is' + 1
			}
	file write `hh'  _n
			* loop over the categories of -by- (1..nby) and -total- (nby+1)
			local nbyt = `nby' + ("`total'"=="")
			local iby 1
			while `iby' <= `nbyt'{
				local i 1
				while `i' <= `nvars' {
					if "`by'" != "" {
						if `i' == 1 {
							local lab = substr(`"`lab`iby''"'0, 1, `wby')
							file write `hh' % `aby'`wby's `"`lab'"' " " 
						}
						else	file write `hh' _skip(`wby') " " 
					}
					if "`descr'" != "" {
						file write `hh' (abbrev("`var`i''",`hwide')) " "
					}
					local is `is1'
					while `is' <= `is2' {
						GetMat s : `fmt`i'' `Stat`iby''[`is',`i']
	file write `hh'  _tab 
						file write `hh' %10s "`s'"
						local is = `is' + 1
					}
	file write `hh'  _n
					local i = `i' + 1
				}
				local iby = `iby' + 1

				if ("`sepline'"!="") | (`iby'>`nbyt') | /*
					*/ ((`iby'==`nbyt') & ("`total'"=="")) {

				}
			}
	file write `hh'   _n
	if "`tx'"~=""{
		file write `hh' "\end{tabularx}" _n
	}

	di
	di in white "The table has been written to the file:`tf'.csv"
	file close `hh'
	 



			local isblock = `isblock' + 1
			if `isblock' <= `nsblock' {
				file write `hh' _n
			}
		} /* isblock */
	}
	else {

		* send to file the results: horizontal = variables (block wise)
		* -------------------------------------------------------------

		* header

	if "`tx'"~="" {
		file write `hh' "}" _n
		file write `hh' "\begin{tabularx} {`wide'} {@{} l"
	}
	local p=1
	while `p'<= `nvars' {
		if "`tx'"~="" {
			file write `hh' " Y"
		}
		local p=`p'+1
	} * end while loop
	di



		* loop over all nvblock blocks of variables

		local iblock 1
		local i2 0
		while `iblock' <= `nvblock' {

			* i1..i2 are indices of variables in a block
			local i1 = `i2' + 1
			local i2 = min(`nvars', `i1'+`neblock'-1)

			* display header
			if "`by'" != "" { file write `hh' %`aby'`wby's "`by'" " "  }
			if "`descr'" != "" { file write `hh' "stats" 	}

	file write `hh'  _tab 
			local i `i1'
			while `i' <= `i2' {
				file write `hh' %`fhwide's (abbrev("`var`i''",`hwide'))
					if `i' < `i2'{
					file write `hh' _tab  
					}
				local i = `i' + 1
			}
	file write `hh'  _n

			* loop over the categories of -by- (1..nby) and -total- (nby+1)
			local nbyt = `nby' + ("`total'"=="")
			local iby 1
			while `iby' <= `nbyt'{
				local is 1
				while `is' <= `nstats' {
					if "`by'" != "" {
						if `is' == 1 {
							local lab = substr(`"`lab`iby''"'0, 1, `wby')
							file write `hh' %`aby'`wby's `"`lab'"' " " 
						}
						else	file write `hh'  _skip(`wby') " " 
					}
					if "`descr'" != "" {
						file write `hh' %8s "`name`is''" " " 
					}

					local i `i1'
					while `i' <= `i2' {
						GetMat s : `fmt`i'' `Stat`iby''[`is',`i']
	file write `hh' _tab 
						file write `hh' %10s "`s'" 
						local i = `i' + 1
					}
	file write `hh'  _n
					local is = `is' + 1
				}
				local iby = `iby' + 1

				if ("`sepline'"!="") | (`iby'>`nbyt') | /*
					*/ ((`iby'==`nbyt') & ("`total'"=="")) {
				}
			}
	file write `hh'   _n
	if "`tx'"~=""{
		file write `hh'  "\end{tabularx}" _n
	}
	file write `hh' _n 
	di
	di in white "The table has been written to the file:`tf'.csv"
	file close `hh'
 

			local iblock = `iblock' + 1
			if `iblock' <= `nvblock' {
				display
			}
		} /* iblock */
	}
} * end send to file



end


* As a work around that matrices can't have missing values,
* mv's are coded as the magic number 1e+300

program define SetMat
	matrix `1' = cond(`2' != ., `2', 1e+300)
end

program define GetMat
	args rslt colon fmt exp
	local s : display `fmt' =cond(`exp' != 1e+300, `exp', .)
	c_local `rslt'  `s'
end


/* Stats str
   processes the contents() option. It returns in
     r(names)   -- names of statistics, separated by blanks
     r(expr)    -- r() expressions for statistics, separated by blanks
     r(summopt) -- option for summarize command (meanonly, detail)
*/
program define Stats, rclass
	if `"`0'"' == "" {
		local 0 "mean"
	}

	* ensure that order of requested statistics is preserved
	* invoke syntax for each word in input
	local class 0
	tokenize `0'
	while "`1'" != "" {
		local 0 = lower(`", `1'"')
		syntax [, n MEan sd SUm COunt MIn MAx Range SKewness Kurtosis /*
			*/  SDMean p1 p5 p10 p25 p50 p75 p90 p95 p99 iqr q MEDian ]

		if "`median'" != "" {
			local p50 p50
		}
		if "`count'" != "" {
			local n n
		}

		* class 1 : available via -summarize, meanonly-

		* summarize.r(N) returns #obs (note capitalization)
		if "`n'" != "" {
			local n N
		}
		local s "`n'`min'`mean'`max'`sum'"
		if "`s'" != "" {
			local names "`names' `s'"
			local expr  "`expr' r(`s')"
			local class = max(`class',1)
		}
		if "`range'" != "" {
			local names "`names' range"
			local expr  "`expr' r(max)-r(min)"
			local class = max(`class',1)
		}

		* class 2 : available via -summarize-

		if "`sd'" != "" {
			local names "`names' sd"
			local expr  "`expr' r(sd)"
			local class = max(`class',2)
		}
		if "`sdmean'" != "" {
			local names "`names' sd(mean)"
			local expr  "`expr' r(sd)/sqrt(r(N))"
			local class = max(`class',2)
		}

		* class 3 : available via -detail-

		local s "`skewness'`kurtosis'`p1'`p5'`p10'`p25'`p50'`p75'`p90'`p95'`p99'"
		if "`s'" != "" {
			local names "`names' `s'"
			local expr  "`expr' r(`s')"
			local class = max(`class',3)
		}
		if "`iqr'" != "" {
			local names "`names' iqr"
			local expr  "`expr' r(p75)-r(p25)"
			local class = max(`class',3)
		}
		if "`q'" != "" {
			local names "`names' p25 p50 p75"
			local expr  "`expr' r(p25) r(p50) r(p75)"
			local class = max(`class',3)
		}

		mac shift
	}

	return local names `names'
	return local expr  `expr'
	if `class' == 1 {
		return local summopt "meanonly"
	}
	else if `class' == 3 {
		return local summopt "detail"
	}


end
