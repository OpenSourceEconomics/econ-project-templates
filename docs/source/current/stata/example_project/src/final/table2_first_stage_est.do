/*
The file "table2_first_stage_est.do" creates table 2 with the first
stage estimates taking as input the regression results and p-values
from the corresponding do-file in the analysis folder "first_stage_estimates.do"
It writes the results to Latex file "`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"'"
*/


// Header do-file with path definitions, those end up in global macros.
include project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace


forvalues T = 2 / 6 {

	do `"${PATH_OUT_MODEL_SPECS}/``T''"'
	do `"${PATH_OUT_MODEL_SPECS}/geography"'
	use `"${PATH_OUT_ANALYSIS}/first_stage_estimation_``T''"', clear

	if `T' == 2 {
		listtab colstring coef_``T''_1 coef_``T''_2 coef_``T''_3 coef_``T''_4 coef_``T''_5 coef_``T''_6 coef_``T''_7 ///
			using `"${PATH_OUT_TABLES}/table2_first_stage_est.tex"', replace type rstyle(tabular) ///
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
	else if `T' < 6 {
		listtab colstring coef_``T''_1 coef_``T''_2 coef_``T''_3 coef_``T''_4 coef_``T''_5 coef_``T''_6 coef_``T''_7, ///
			appendto(`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"') type rstyle(tabular) ///
			head("\vspace{0.1cm}\\ " "\multicolumn{8}{l}{\textit{${TITLE}}}\\ ")
	}
 	else if `T' == 6 {
		listtab colstring coef_``T''_1 coef_``T''_2 coef_``T''_3 coef_``T''_4 coef_``T''_5 coef_``T''_6 coef_``T''_7, ///
			appendto(`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"') type rstyle(tabular) ///
			head("\vspace{0.1cm}\\ " "\multicolumn{8}{l}{\textit{${TITLE}}}\\ ") ///
			foot("\bottomrule \end{tabular}" "\end{center}" "\end{table}")
	}
}
