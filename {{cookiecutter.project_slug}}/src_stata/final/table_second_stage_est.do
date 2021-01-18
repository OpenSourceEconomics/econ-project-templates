/*
The file ``table_second_stage_est.do`` creates the table with the
IV estimates taking as input the regression results and confidence
intervals from the corresponding do-file ``second_stage_estimates.do``.
It writes the results to Latex file ``table_second_stage_est.tex``

*/


log using `"`1'"', replace


foreach T in 3 5 {

	local Tp1 = `T' + 1

	do `"``T''"'
	do `"`2'"'
	use `"``Tp1''"', clear


	// The following transposes the variables - necessary because we have strings

	format pointT_1 %4.2f
	tostring pointT_1,generate(pointT_str) force u
	keep pointT_str waldT_ci cilmT_ci

	gen id = _n

	rename pointT_str aux1pointT_str
	rename waldT_ci aux2waldT_ci
	rename cilmT_ci aux3cilmT_ci

	reshape long aux, i(id) j(name) string
	reshape wide aux, i(name) j(id)
	sort name
	rename name colstring

    // Generate column names as in table 3
	gen id2 = _n
	sort id2
	replace colstring = "Expropriation risk" if id2==1
	replace colstring = "Wald 95\% conf. region" if id2==2
	replace colstring = "AR 95\% conf. region" if id2==3
	drop id2

    // Write to Latex file
	if `T' == 3 {
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7 using `"`7'"', replace type rstyle(tabular) ///
		head( ///
			"\begin{table}[htb]" ///
			"\caption[]{Instrumental Variable Estimates and Confidence Regions\\First-stage dependent var.: log GDP, second-stage dependent var.: expropriation risk}" ///
			"\scriptsize" ///
			"\begin{center}" ///
			"\begin{tabular}{lccccccc}" ///
			"\toprule" ///
			"\noalign{\smallskip}" ///
			"& \begin{tabular}[c]{@{}c@{}}No\\controls\end{tabular}" ///
			"& \begin{tabular}[c]{@{}c@{}}Latitude\\control\end{tabular}" ///
			"& \begin{tabular}[c]{@{}c@{}}without\\Neo-Europes\end{tabular}" ///
			"& \begin{tabular}[c]{@{}c@{}}Continent\\indicators\end{tabular}" ///
			"& \begin{tabular}[c]{@{}c@{}}Continent\\and latitude\end{tabular}" ///
			"& \begin{tabular}[c]{@{}c@{}}Percentage\\European\\in 1975\end{tabular}" ///
			"& \begin{tabular}[c]{@{}c@{}}Malaria\\in 1994\end{tabular}\\" ///
			"Control variables & (1) & (2) & (3) & (4) & (5) & (6) & (7)\\" ///
			"\midrule" ///
			"\vspace{0.05cm}\\" ///
			"\multicolumn{8}{l}{\textit{${TITLE}}}\\" ///
		)
	}
	else if `T' == 5 {
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, ///
			appendto(`"`7'"') type rstyle(tabular) ///
			head("\vspace{0.1cm}\\" "\multicolumn{8}{l}{\textit{${TITLE}}}\\") ///
			foot("\bottomrule \end{tabular}" "\end{center}" "\end{table}")
	}

}







