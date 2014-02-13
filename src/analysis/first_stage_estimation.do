/*** This file computes the first stage estimates for table 2 and stores the 
results in "table2_first_stage_est_temp_i.dta" ***/


// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'_`2'.log"', replace


// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list

set output error

# delimit ;
version 8.2 ;
/* FIRST STAGE ESTIMATES 
1 = No Controls
2 = Latitude
3 = No Neo-Europes
4 = Continent Controls
5 = Continent Controls & Latitude
6 = % European Descent
7 = Malaria
*/
 
local K=`2';

	/***DIFFERENT DATASET SPECIFICATIONS FOR FIRST STAGE AND IV ESTIMATION:
		1 = PANEL_A: Original mortality data (64 countries)
		2 = PANEL_B: Only countries with non-conjectured mortality rates (rest: 28 countries)
		3 = PANEL_C: Original data (64 countries) with campaign and laborer indicators
		4 = PANEL_D: Only countries with non-conjectured mortality rates and campaign and laborer indicators 
		5 = PANEL_E: As Panel D with new data provided by AJR
	***/

clear;

local depvar = " risk " ;
local logmort = "logmort0 ";

local v1 = " ";
local v2 = " lat" ;
local v3 = " ";    
local v4 = " asia africa other";
local v5 = " asia africa other lat";
local v6 = " edes1975 ";
local v7 = " malaria ";

local if3 = " if neoeuro==0 " ;

set graphics off;
set mat 800;
set mem 10m;
set more off;

/*** Define panel specific input ***/
	
	use `"${PATH_IN_DATASET_1}/ajrcomment"',replace; 
	
	replace `logmort' = . if source0==0 & inlist(`K',2,4,5);
	if inlist(`K',3,4,5) local dummies = "campaign slave" ;  

	replace `logmort' = log(285) if inlist(short,"HKG") & `K'==5 ;
	replace `logmort' = log(189) if inlist(short,"BHS") & `K'==5 ;
	replace `logmort' = log(14.1) if inlist(short,"AUS") & `K'==5 ;
	replace `logmort' = log(95.2) if inlist(short,"HND") & `K'==5 ;
	replace `logmort' = log(84) if inlist(short,"GUY") & `K'==5 ;
	replace `logmort' = log(20) if inlist(short,"SGP") & `K'==5 ;
	replace campaign = 0 if inlist(short,"HND") & `K'==5 ;

	replace `logmort' = log(106.3) if inlist(short,"TTO") & `K'==5 ;
	replace `logmort' = log(350) if inlist(short,"SLE") & `K'==5 ;
	

********************** FIRST STAGE STUFF *******************;

forva N = 1(1)7 {;


 qui reg `depvar' `logmort' `dummies'  `v`N'' `if`N'';
 est store F`N' ;
 qui reg `depvar' `logmort' `dummies'  `v`N''  `if`N'', robust cluster(`logmort')  ;
 est store F`N'C;
	scalar b`N' = _b[`logmort'] ;
	scalar se`N' = _se[`logmort'] ;
		
 if inlist(`N',2,4,5,6,7) { ;
    qui test `v`N'' ;
    scalar f`N' = r(p);
   

    *qui hausman F`N'C F1C ; 
    *scalar h`N' = r(p); 

  };
 if inlist(`N',1,3) { ;
    scalar f`N'=0;
    scalar h`N'=0;
  };

 if inlist("`dummies'","") { ; 
	qui test `logmort' ;
	scalar p`N' = r(p);
	disp "`N'" ; } ;
 else { ;
	qui test `logmort' ;
      scalar p`N' = r(p);
	qui test `dummies' ;
      scalar d`N' = r(p);
	scalar camp`N' = _b[campaign] ; 
	} ;


 };

*set output proc;
noi estimates table F1 F2 F3 F4 F5 F6 F7 , 
 b(%5.2f) se(%5.2f) keep(`logmort') ;
 
*CLUSTER;
noisily estimates table F1C F2C F3C F4C  F5C F6C F7C   , 
 b(%5.2f) se(%5.2f) stat(N N_clust);


if inlist("`dummies'","") { ; 
 mat F = [f1, f2, f3, f4, f5, f6, f7];
 mat rown F = Ftest_C ;
 mat coln F = 1 2 3 4 5 6 7 ;
 } ;
else { ;
 mat D = [camp1, camp2, camp3, camp4, camp5, camp6, camp7];
 noi mat list D, f(%5.3f) title("Campaign dummies"); 
 mat F = [d1, d2, d3, d4, d5, d6, d7 \
	    f1, f2, f3, f4, f5, f6, f7 ];
 mat rown F = Ftest_D Ftest_C ;
 mat coln F = 1 2 3 4 5 6 7 ;
} ;

*noisily mat list F, f(%5.3f) title("p-values of tests");

if inlist(`K',1,2) { ; //specification for panel A and B
	mat panel = [b1,b2,b3,b4,b5,b6,b7 \
				se1,se2,se3,se4,se5,se6,se7 \
				p1,p2,p3,p4,p5,p6,p7 \
				f1, f2, f3, f4, f5, f6, f7] ; 
	};
else { ; //specification for panel C,D,E
	mat panel = [b1,b2,b3,b4,b5,b6,b7 \
				se1,se2,se3,se4,se5,se6,se7 \
				p1,p2,p3,p4,p5,p6,p7 \
				d1, d2, d3, d4, d5, d6, d7 \
				f1, f2, f3, f4, f5, f6, f7]; 
	};
			
*noisily mat list panel,f(%5.2f) title("Panel A") ;


svmat panel, names(coef`K'_) ;
drop if coef`K'_1==. ;
format coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7 %5.2f ;
	gen id = _n ;
	sort id ;
	gen str colstring = "Log mortality" if id==1 ;
	replace colstring = "heteroscedastic SE" if id==2 ;
	replace colstring = "p-value log mortality" if id==3 ;
	replace colstring = "p-value of controls" if id==4 & inlist(`K',1,2);
	replace colstring = "p-value of indicators" if id==4 & inlist(`K',3,4,5);
	replace colstring = "p-value of controls" if id==5 & inlist(`K',3,4,5);
	
keep colstring coef`K'_1 coef`K'_2 coef`K'_3 coef`K'_4 coef`K'_5 coef`K'_6 coef`K'_7 ;

save `"${PATH_OUT_ANALYSIS}/first_stage_estimation_`K'"',replace ;
