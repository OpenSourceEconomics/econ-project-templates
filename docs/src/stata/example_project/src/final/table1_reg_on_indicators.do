/*
The file "table1_reg_on_indicators.do" creates table 1 with the regression
estimates and correlations of the main indicators (mortality,
expropriation risk and GDP) from the corresponding do-file in
the analysis directory "regression_on_indicators.do"
*/


// Header do-file with path definitions, those end up in global macros.
include project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace


// Estimation results

use `"${PATH_OUT_ANALYSIS}/regression_on_indicators_est"', clear
	
listtab E_colstring E_1 E_2 E_3 ///
	using `"${PATH_OUT_TABLES}/table1_reg_on_indicators.tex"', replace type rstyle(tabular) ///
	head("\begin{table}[htb]" "\caption{Relationship of Main Variables to Campaign and Laborer Indicators}" ///
	"\footnotesize" "\begin{center}" "\begin{tabular}{lccc}" ///
	"\toprule" ///
	"& \begin{tabular}[c]{@{}c@{}}Log mortality\end{tabular}" ///
	"& \begin{tabular}[c]{@{}c@{}}Expropriation risk\end{tabular}" ///
	"& \begin{tabular}[c]{@{}c@{}}Log GDP\end{tabular} \\ " ///
	"Dependent variable & (1) & (2) & (3)\\ " ///
	"\midrule" ///
	"\vspace{0.1cm}\\ " ///
	"\multicolumn{4}{l}{\textit{Original sample (64 countries)}:}\\ ")

// Correlations with log mortatlity:

use `"${PATH_OUT_ANALYSIS}/regression_on_indicators_corr"', clear

listtab C_colstring C_1 C_2 C_3, ///
	appendto(`"${PATH_OUT_TABLES}/table1_reg_on_indicators.tex"') type rstyle(tabular) ///
	head("\vspace{0.1cm}\\ " ///
	"\multicolumn{4}{l}{\textit{Correlation with log mortality}}\\ ") ///
	foot("\bottomrule" "\end{tabular}" "\end{center}" "\end{table}")
