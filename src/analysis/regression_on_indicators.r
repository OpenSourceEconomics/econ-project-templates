'

The file "regression_on_indicators.r" computes the regression estimates 
of the main indicators (mortality, expropriation risk and GDP) on the 
indicators for campaigning soldiers and laborers, as well as
the correlations of the main indicators with log mortality.
The results are then plotted in the corresponding file in 
the final folder "table1_reg_on_indicators.r"

'

rm(list=ls())
options(digits=3)


source("project_paths.r")

library(foreign, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE, "functions.r", sep = "/"))

data <- read.table(
     file=paste(PATH_OUT_DATA, "ajrcomment_all.txt", sep = "/"),
     header = TRUE
)

## We run the regressions here of tabel 1

slave = data[,"slave"]
campaign = data[,"campaign"]
logmort = data[,"logmort0"]
risk = data[,"risk"]
loggdp = data[,"loggdp"]

fmmort = lm(logmort ~ slave + campaign)

fmrisk = lm(risk ~ slave + campaign)

fmgdp = lm(loggdp ~ slave + campaign)


## full correlation
cor_mo_gdp = cor(logmort, loggdp) 
cor_mo_ris = cor(logmort, risk) 

## partial correlation
cor_mo_gdp_par = cor(fmmort$resid, fmgdp$resid)
cor_mo_ris_par = cor(fmmort$resid, fmrisk$resid)

## write anything into a latex tabel


 mat = c( 
           ## first column 
                        
               "", 
               summary(fmmort)$coefficients["campaign","Estimate"],
               summaryw(fmmort)[[1]]["campaign",2], 
               summary(fmmort)$coefficients["slave","Estimate"],
               summaryw(fmmort)[[1]]["slave",2], 
               summary(fmmort)$r.squared,
               "",
               "",
               "1.00", 
               "1.00",
               
           ## second column                 
    
               "", 
               summary(fmrisk)$coefficients["campaign","Estimate"], 
               summaryw(fmrisk)[[1]]["campaign",2], 
               summary(fmrisk)$coefficients["slave","Estimate"],
               summaryw(fmrisk)[[1]]["slave",2],
               summary(fmrisk)$r.squared, 
               "", 
               "", 
               cor_mo_ris, 
               cor_mo_ris_par,
               
           ## third column 
                
               "", 
               summary(fmgdp)$coefficients["campaign","Estimate"], 
               summaryw(fmgdp)[[1]]["campaign",2], 
               summary(fmgdp)$coefficients["slave","Estimate"],
               summaryw(fmgdp)[[1]]["slave",2], 
               summary(fmgdp)$r.squared,
               "", 
               "", 
               cor_mo_gdp, 
               cor_mo_gdp_par 
)
   

## export the vector

dput( 
     mat, file=paste(PATH_OUT_ANALYSIS,"/","regression_on_indicators.txt",sep="")
)




