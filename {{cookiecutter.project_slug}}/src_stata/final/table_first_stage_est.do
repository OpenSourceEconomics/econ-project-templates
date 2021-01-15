/*
The file "table_first_stage_est.do" creates the table with the first
stage estimates taking as input the regression results and confidence
intervals from the corresponding do-file "first_stage_estimates.do".
It writes the results to Latex file "`"table_first_stage_est.tex"'"

*/


log using `"`1'"', replace


foreach T in 2 4 {
	local Tp1 = `T' + 1

	do `"``T''"'
	use `"``Tp1''"', clear

	if `T' == 2 {
		listtab colstring ///
			coef_${MODEL_NAME}_1 ///
			coef_${MODEL_NAME}_2 ///
			coef_${MODEL_NAME}_3 ///
			coef_${MODEL_NAME}_4 ///
			coef_${MODEL_NAME}_5 ///
			coef_${MODEL_NAME}_6 ///
			coef_${MODEL_NAME}_7 ///
			using `"`6'"', replace type rstyle(tabular) ///
 			head( ///
				"\begin{table}[htb]" ///
				"\caption[]{First-Stage Estimates\\Dependent variable: expropriation risk}" ///
				"\footnotesize" ///
				"\begin{center}" ///
				"\begin{tabular}{lccccccc}" ///
				"\toprule" ///
				"& \begin{tabular}[c]{@{}c@{}}No\\controls\end{tabular}" ///
				"& \begin{tabular}[c]{@{}c@{}}Latitude\\control\end{tabular}" ///
				"& \begin{tabular}[c]{@{}c@{}}without\\Neo-Europes\end{tabular}" ///
				"& \begin{tabular}[c]{@{}c@{}}Continent\\indicators\end{tabular}" ///
				"& \begin{tabular}[c]{@{}c@{}}Continent\\and latitude\end{tabular}" ///
				"& \begin{tabular}[c]{@{}c@{}}Percentage\\European\\in 1975\end{tabular}" ///
				"& \begin{tabular}[c]{@{}c@{}}Malaria\\in 1994\end{tabular}\\ " ///
				"Control variables & (1) & (2) & (3) & (4) & (5) & (6) & (7)\\ " ///
				"\midrule" ///
				"\vspace{0.05cm}\\ " ///
				"\multicolumn{8}{l}{\textit{${TITLE}}}\\ " ///
			)
	}
 	else if `T' == 4 {
		listtab colstring ///
			coef_${MODEL_NAME}_1 ///
			coef_${MODEL_NAME}_2 ///
			coef_${MODEL_NAME}_3 ///
			coef_${MODEL_NAME}_4 ///
			coef_${MODEL_NAME}_5 ///
			coef_${MODEL_NAME}_6 ///
			coef_${MODEL_NAME}_7, ///
			appendto(`"`6'"') type rstyle(tabular) ///
			head("\vspace{0.1cm}\\ " "\multicolumn{8}{l}{\textit{${TITLE}}}\\ ") ///
			foot("\bottomrule \end{tabular}" "\end{center}" "\end{table}")
	}
}
