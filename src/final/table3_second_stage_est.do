/*** This file creates table 3 taking as input the regression results and confidence
intervals from the temporary do-files "table3_second_stage_est_temp1_i.do"
It writes the results to Latex file "table3_second_stage_est.tex" ***/

// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace

// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list

set output error


# delimit ;
version 8.2 ;

	/***DIFFERENT DATASET SPECIFICATIONS FOR FIRST STAGE AND IV ESTIMATION:
		1 = PANEL_A: Original mortality data (64 countries)
		2 = PANEL_B: Only countries with non-conjectured mortality rates (rest: 28 countries)
		3 = PANEL_C: Original data (64 countries) with campaign and laborer indicators
		4 = PANEL_D: Only countries with non-conjectured mortality rates and campaign and laborer indicators 
		5 = PANEL_E: As Panel D with new data provided by AJR
	***/
forval T = 1(1)5 {;

use `"${PATH_OUT_ANALYSIS}/second_stage_estimation_`T'"',clear;

/*** The following transposes the variables - necessary because we have strings ***/

	format pointT_1 %4.2f ;
	tostring pointT_1,generate(pointT_str) force u ;
	keep pointT_str waldT_ci cilmT_ci ;

	gen id = _n ;

	rename pointT_str aux1pointT_str ;
	rename waldT_ci aux2waldT_ci ;
	rename cilmT_ci aux3cilmT_ci ;

	reshape long aux, i(id) j(name) string ;
	reshape wide aux, i(name) j(id);
	sort name ;
	rename name colstring ;
	
/***Generate column names as in table 3 ***/	
	gen id2 = _n ;
	sort id2 ;
	replace colstring = "Expropriation risk" if id2==1 ;
	replace colstring = "Wald 95\% conf. region" if id2==2 ;
	replace colstring = "AR 95\% conf. region" if id2==3 ;
	drop id2; 
	
/***Write to Latex file ***/	
	
	if `T'==1 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7 using `"${PATH_OUT_TABLES}/table3_second_stage_est.tex"', replace type rstyle(tabular)
            head("\begin{table}" "\caption{Table 3 - Instrumental Variable Estimates and Confidence Regions}" 
            "\scriptsize" 
            "\begin{center}"
            "\begin{tabular}{lccccccc}" 
			"\hline\hline" 
			"\noalign{\smallskip}" 
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
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(`"${PATH_OUT_TABLES}/table3_second_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel B: Removing conjectured mortality rates}}\\\") ;
	};
	
	if `T'==3 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(`"${PATH_OUT_TABLES}/table3_second_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel C: Original data, adding campaign and laborer indicators}}\\\") ;
	};
	
	if `T'==4 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(`"${PATH_OUT_TABLES}/table3_second_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel D: Removing conjectured data, adding campaign and laborer indicators}}\\\") ;			
	};
	
	if `T'==5 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(`"${PATH_OUT_TABLES}/table3_second_stage_est.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\multicolumn{8}{l}{\textit{Panel E: Removing conjectured data, adding campaign and laborer indic. and new data}}\\\")
				foot("\end{tabular}" "\end{center}" "\end{table}");
	};
	
};	
	
	
	
	
	
	
	
