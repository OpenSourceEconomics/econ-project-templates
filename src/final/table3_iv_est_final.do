/*** This file creates table 3 taking as input the regression results and confidence
intervals from the temporary do-files "table3_iv_est_temp1_i.do"
It writes the results to Latex file "table3_iv_est.tex" ***/



set output error


# delimit ;
version 8.2 ;
	local PATH C:\Dropbox\PhD_Bonn\WS_2013_14\Effective_Programming\stata_project\AER20041216_data\ ;
	
	local IN_DATA = "src\original_data\" ;
	local IN_MODEL_CODE = "src\model_code\" ;
	local IN_MODEL_SPECS = "src\model_specs\" ;
	local OUT_DATA = "bld\out\data\" ;
	local OUT_ANALYSIS = "bld\out\analysis\" ;
	local OUT_FINAL = "bld\out\final\" ;
	local OUT_FIGURES = "bld\out\figures\" ;
	local OUT_TABLES = "bld\out\tables\" ;

forva K = 1(1)5 {; 

use table3_iv_est_temp1_`K',clear;

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

save table3_iv_est_temp2_`K',replace ;

};
	
	
	
/***Write to Latex file ***/	
	
forva K = 1(1)5 {;
	use table3_iv_est_temp2_`K',clear ;
	
	if `K'==1 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7 using example3.tex, replace type rstyle(tabular)
            head("\begin{table}" "\caption{Table 3 - Instrumental Variable Estimates and Confidence Regions}" "\footnotesize" "\begin{center}" "\begin{tabular}{lccccccc}" 
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
			"\textit{Panel A}\\\") ;
	};
	

	if `K'==2 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(example3.tex) type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Panel B}\\\") ;
	};
	
	if `K'==3 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(example3.tex) type rstyle(tabular)
				head(`"\vspace{0.1cm}\\"' `"\textit{Panel C}\\\\"') ;
	};
	
	if `K'==4 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(example3.tex) type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Panel D}\\\") ;			
	};
	
	if `K'==5 {;
		listtab colstring aux1 aux2 aux3 aux4 aux5 aux6 aux7, appendto(example3.tex) type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Panel E}\\\")
				foot("\end{tabular}" "\end{center}" "\end{table}");
	};
	
};
	
	
	
	
	
	
	
	
