// Header do-file with path definitions, those end up in global macros.
include src/library/stata/project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace


// Delete these lines -- just to check whether everything caught correctly.
adopath
macro list


set output error
set more off 

# delimit ;
version 8.2 ;
 
set graphics on ;

clear;

use `"${PATH_IN_DATASET_1}/ajrcomment"',replace;
	
g logmort = logmort0 ;
drop logmort0 ;

g logmort0 = logmort if source0==0 ;
g logmort1 = logmort if source0==1 ;


g smallnam = lower(shortnam) ;


foreach V in logmort risk loggdp { ;


	g `V'_c = `V' if campaign==1  ;
	g `V'_s = `V' if slave==1  ;
	g `V'_b = `V' if campaign==0 & slave==0  ;
	g `V'_nc = `V' if campaign==0 | slave==1  ;
	
foreach W of numlist 0 1  { ;
	
	g `V'_c`W' = `V' if campaign==1  & source0==`W';
	g `V'_s`W' = `V' if slave==1  & source0==`W';
	g `V'_b`W' = `V' if campaign==0 & slave==0  & source0==`W';
	g `V'_nc`W' = `V' if (campaign==0 | slave==1)  & source0==`W';
	
	
} ;
	la var `V'_c "Campaign" ;
	la var `V'_s "Laborer" ;
	la var `V'_b "Barracks" ;
	la var `V'_nc "Not Barracks" ;

	la var `V'_c0 "Campaign" ;
	la var `V'_s0 "Laborer" ;
	la var `V'_b0 "Barracks" ;
	la var `V'_nc0 "Not Barracks" ;
	
	la var `V'_c1 "Campaign" ;
	la var `V'_s1 "Laborer" ;
	la var `V'_b1 "Barracks" ;
	la var `V'_nc1 "Not Barracks" ;
	
} ;


/*** GRAPH OF RISK AGAINST SETTLER MORTALITY ***/


for V in var logmort risk loggdp :
	reg V campaign slave \
	predict V_r, resid ;
	
noi corr logmort risk  ;
	local corra = round(r(rho),.01) ;
noi corr logmort loggdp  ;
	local corrb = round(r(rho),.01) ;	
noi corr logmort risk if source0==1 ;
	local corra0 = round(r(rho),.01) ;
noi corr logmort loggdp  if source0==1;
	local corrb0 = round(r(rho),.01) ;	

	
noi corr logmort_r risk_r  ;
	local corra_r = round(r(rho),.01) ;
noi corr logmort_r loggdp_r  ;
	local corrb_r = round(r(rho),.01) ;	
noi corr logmort_r risk_r  if source0==1;
	local corra0_r = round(r(rho),.01) ;
noi corr logmort_r loggdp_r  if source0==1;
	local corrb0_r = round(r(rho),.01) ;	

	
/*** FIGURE 2A REDUCED FORM ***/

noi reg risk logmort, cluster(logmort) ;
	predict riskmortfit  ;
	la var riskmortfit "Original sample (64 obs.): slope = -0.61 (clustered s.e. = 0.17)" ;

noi reg risk logmort  if source0==1 & (campaign==1 | slave==1), cluster(logmort) ;
	g riskmortfit2 = _b[_cons] + _b[logmort]*logmort ;
	la var riskmortfit2 "Rates from country, excl. barracks (17 obs.): slope = -0.14 (robust s.e. = 0.26)" ;
	
twoway
	
	scatter risk_b0 risk_c0 risk_s0 risk_b1 risk_c1 risk_s1 logmort,
	msymbol(Oh Sh Th O S T)
	mcolor(black black black black black black )
	msize(medsmall small small medsmall small small  )
	mlwidth(thin thin thin thin thin thin) 
/*	mlab(smallnam smallnam smallnam shortnam shortnam shortnam)  
	mlabcol(black black black black black black )
	mlabsize(2.0 2.0 2.0 2.0 2.0 2.0)
	mlabpos(3 3 3 3 3 3) 
*/	xaxis(1) 
	yaxis(1)
	yscale( axis(1)) 
	
	||
	,
	ti("FIGURE 2A: EXPROPRIATION RISK AND SETTLER MORTALITY"
	"ACCORDING TO MORTALITY RATE CHARACTERISTICS", size(3) ) 	
	graphregion(fcolor(white) icolor(white) color(white))
	
	saving(riskmort, replace)  
	xsize(7) ysize(7) 
	
	xtitle("Logarithm of Settler Mortality", size(2.5) axis(1) )
	xlabel(2(2)8, nogrid labsize(2.5) format(%5.0f))
	xmtick(2(1)8,  axis(1) )
	
	
	ytitle("Expropriation Risk", size(2.5) axis(1) )
	
	ymtick(3(1)10, axis(1) ) 
	ylabel(4(2)10, nogrid labsize(2.5) format(%5.0f) axis(1) )
	
	
	
	legend(order(- "From Country:" 4 5 6 - "Conjectured:" 1 2 3)
	symplacement(right) 
	cols(4) colgap(1) textwidth(18)  symxsize(5)
	 nobox bmargin(zero) region(lcolor(none)) size(2.5)  span) 	
			

	;
	
	graph export `"${PATH_OUT_FIGURES}/figure2a_risk_mort.png"', replace ;



/*** FIGURE 2B REDUCED FORMS **/
	
noi reg loggdp logmort, cluster(logmort) ;
	predict gdpmortfit  ;
	la var gdpmortfit "Original sample (64 obs.): slope = -0.57 (clustered s.e. = 0.07)" ;

noi reg loggdp logmort  if  source0==1 & (campaign==1 | slave==1), cluster(logmort) ;
	g gdpmortfit2 = _b[_cons] + _b[logmort]*logmort ;
	la var gdpmortfit2 "Rates from country, excl. barracks (17 obs.): slope = -0.21 (robust s.e. = 0.15)" ;
	

/*** GRAPH OF LOG GDP AGAINST SETTLER MORTALITY ***/
	
twoway 
	
	scatter loggdp_b0 loggdp_c0 loggdp_s0 loggdp_b1 loggdp_c1 loggdp_s1 logmort,
	msymbol(Oh Sh Th O S T)
	mcolor(black black black black black black )
	msize(medsmall small small medsmall small small  )
	mlwidth(thin thin thin thin thin thin) 
/*	mlab(smallnam smallnam smallnam shortnam shortnam shortnam)  
	mlabcol(black black black black black black )
	mlabsize(2.0 2.0 2.0 2.0 2.0 2.0)
	mlabpos(3 3 3 3 3 3) 
	*/ xaxis(1) 
	yaxis(1)
	yscale( axis(1)) 
	||
	,
	ti("FIGURE 2B: INCOME PER CAPITA AND SETTLER MORTALITY"
	"ACCORDING TO MORTALITY RATE CHARACTERISTICS", size(3) ) 	
	graphregion(fcolor(white) icolor(white) color(white))
	
	saving(loggdpmort, replace)  
	xsize(7) ysize(7) 
	
	
	xtitle("Logarithm of Settler Mortality", size(2.5) axis(1) bex )

	xlabel(2(2)8, nogrid labsize(2.5) format(%5.0f))
	xmtick(2(1)8,  axis(1) )
	
	
	ytitle("Logarithm of GDP per Capita", size(2.5) axis(1) bex )

	ymtick(6(1)10, axis(1) ) 
	ylabel(6(2)10, nogrid labsize(2.5) format(%5.0f) axis(1) )
	
	legend(order(- "From Country:" 4 5 6 - "Conjectured:" 1 2 3)
	symplacement(right) 
	cols(4) colgap(1) textwidth(18)  symxsize(5)
	 nobox bmargin(zero) region(lcolor(none)) size(2.5)  span) 	
	 
		
	;


	graph export `"${PATH_OUT_FIGURES}/figure2b_gdp_mort.png"', replace ;
	
