/*
The file "table2_first_stage_est.do" creates table 2 with the first 
stage estimates taking as input the regression results and p-values 
from the corresponding do-file in the analysis folder "first_stage_estimates.do" 
It writes the results to Latex file "`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"'" 
*/


// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace

// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list

set output error

# delimit ;
version 8.2 ;


forval T = 1(1)5 {;

	use `"${PATH_OUT_ANALYSIS}/first_stage_estimation_`T'"', clear ;

	if `T'==1 {;
		listtab colstring coef`T'_1 coef`T'_2 coef`T'_3 coef`T'_4 coef`T'_5 coef`T'_6 coef`T'_7 using `"${PATH_OUT_TABLES}/table2_first_stage_est.tex"', replace type rstyle(tabular)
            head("\begin{table}[htb]" 
            "\caption[]{First-Stage Estimates\\\Dependent variable: expropriation risk}" 
            "\footnotesize" 
            "\begin{center}" 
            "\begin{tabular}{lccccccc}" 
			"\hline\hline"  
			"& \begin{tabular}[c]{@{}c@{}}No\\\controls\end{tabular} 
			& \begin{tabular}[c]{@{}c@{}}Latitude\\\control\end{tabular}
			& \begin{tabular}[c]{@{}c@{}}without\\\Neo-Europes\end{tabular} 
			& \begin{tabular}[c]{@{}c@{}}Continent\\\indicators\end{tabular} 
			& \begin{tabular}[c]{@{}c@{}}Continent\\\and latitude\end{tabular} 
			& \begin{tabular}[c]{@{}c@{}}Percentage\\\European\\\in 1975\end{tabular}
			& \begin{tabular}[c]{@{}c@{}}Malaria\\\in 1994\end{tabular}\\\" 
			"Control variables & (1) & (2) & (3) & (4) & (5) & (6) & (7)\\\"
			"\hline"
			"\vspace{0.05cm}\\\"
			"\multicolumn{8}{l}{\textit{Panel A: Original mortality rates (64 countries)}}\\\") ;
	};
			
	if `T'==2 {;
		listtab colstring coef`T'_1 coef`T'_2 coef`T'_3 coef`T'_4 coef`T'_5 coef`T'_6 coef`T'_7, appendto(`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel B: Removing conjectured mortality rates}}\\\") ;
	};
	
	if `T'==3 {;
		listtab colstring coef`T'_1 coef`T'_2 coef`T'_3 coef`T'_4 coef`T'_5 coef`T'_6 coef`T'_7, appendto(`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel C: Original data, adding campaign and laborer indicators}}\\\") ;
	};
	
	if `T'==4 {;
		listtab colstring coef`T'_1 coef`T'_2 coef`T'_3 coef`T'_4 coef`T'_5 coef`T'_6 coef`T'_7, appendto(`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel D: Removing conjectured data, adding campaign and laborer indicators}}\\\") ;			
	};
	
	if `T'==5 {;
		listtab colstring coef`T'_1 coef`T'_2 coef`T'_3 coef`T'_4 coef`T'_5 coef`T'_6 coef`T'_7, appendto(`"${PATH_OUT_TABLES}/table2_first_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel E: Removing conjectured data, adding campaign and laborer indic. and new data}}\\\")
				foot("\end{tabular}" "\end{center}" "\end{table}");
	};							
};


