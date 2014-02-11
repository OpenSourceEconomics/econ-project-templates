/*** This file creates table 2 taking as input the regression results and 
p-values from do-file "table2.do" 
It writes the results to Latex file "`"${PATH_OUT_TABLES}/table2.tex"'" ***/

set output error

# delimit ;
version 8.2 ;


forva K = 1(1)5 {;

use `"${PATH_OUT_DATA}/table2_temp_`K'"', clear ;

	if `K'==1 {;
		listtab colstring coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7 using `"${PATH_OUT_TABLES}/table2.tex"', replace type rstyle(tabular)
            head("\begin{table}" "\caption{Table 2 - First-Stage Estimates}" "\footnotesize" "\begin{center}" "\begin{tabular}{lccccccc}" 
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
		listtab colstring coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7, appendto(`"${PATH_OUT_TABLES}/table2.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Panel B}\\\") ;
	};
	
	if `K'==3 {;
		listtab colstring coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7, appendto(`"${PATH_OUT_TABLES}/table2.tex"') type rstyle(tabular)
				head(`"\vspace{0.1cm}\\"' `"\textit{Panel C}\\\\"') ;
	};
	
	if `K'==4 {;
		listtab colstring coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7, appendto(`"${PATH_OUT_TABLES}/table2.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Panel D}\\\") ;			
	};
	
	if `K'==5 {;
		listtab colstring coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7, appendto(`"${PATH_OUT_TABLES}/table2.tex"') type rstyle(tabular)
				head("\vspace{0.1cm}\\\" "\textit{Panel E}\\\")
				foot("\end{tabular}" "\end{center}" "\end{table}");
	};							
};


