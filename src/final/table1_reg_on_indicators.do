/*** This file creates table 1 taking as input the regression results and 
correlations from do-file "table1_main_variables.do" ***/

// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace


// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list


set output error

# delimit ;
version 8.2 ;

use `"${PATH_OUT_ANALYSIS}/regression_on_indicators_EST"', clear ;
	
	listtab E_colstring E_1 E_2 E_3 using `"${PATH_OUT_TABLES}/table1_reg_on_indicators.tex"', replace type rstyle(tabular)
            head("\begin{table}" "\caption{Table 1 - Relationship of Main Variables to Campaign and Laborer Indicators}" 
			"\footnotesize" "\begin{center}" "\begin{tabular}{lccc}" 
			"\hline\hline"  
			"& \begin{tabular}[c]{@{}c@{}}Log mortality\end{tabular} 
			& \begin{tabular}[c]{@{}c@{}}Expropriation risk\end{tabular}
			& \begin{tabular}[c]{@{}c@{}}Log GDP\end{tabular} \\\" 
			"Dependent variable & (1) & (2) & (3)\\\"
			"\hline"
			"\textit{Original sample (64 countries)}\\\") ;

use `"${PATH_OUT_ANALYSIS}/regression_on_indicators_CORR"', clear ;

	listtab C_colstring C_1 C_2 C_3, appendto(`"${PATH_OUT_TABLES}/table1_reg_on_indicators.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Correlation with log mortality}\\\")
				foot("\hline" "\end{tabular}" "\end{center}" "\end{table}");
