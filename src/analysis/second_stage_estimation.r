'
 
The file "second_stage_estimation.do" computes the IV estimates for log GDP 
per capita with expropriation risk as first stage dependent variable.
It also computes confidence intervals for a usual Wald statistic and 
the confidence intervals for the Anderson-Rubin (1949) statistic.

The results for the 5 data specifications are stored and later plotted 
to a Latex table in the corresponding file "table3_second_stage_est.do"
in the final directory.
  
'

rm(list=ls())
options(digits=3)

source("src/library/R/project_paths.r")

library(sandwich, lib=PATH_OUT_LIBRARY_R)
library(zoo, lib=PATH_OUT_LIBRARY_R)
library(lmtest, lib=PATH_OUT_LIBRARY_R)
library(car, lib=PATH_OUT_LIBRARY_R)
library(AER, lib=PATH_OUT_LIBRARY_R)
library(ivpack, lib=PATH_OUT_LIBRARY_R)
library(foreign, lib=PATH_OUT_LIBRARY_R)
library(xtable, lib=PATH_OUT_LIBRARY_R)
library(car, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE, "functions.r", sep="/"))


## define the needed data 
data <- read.dta(paste(PATH_IN_DATA,"/","ajrcomment.dta",sep=""))
data_mor_home = data[grep(1,data$source0),]

data_new <- data

data_new[grep("HKG", data_new$shortnam),]$logmort0 = log(285)
data_new[grep("BHS", data_new$shortnam),]$logmort0 = log(189)
data_new[grep("AUS", data_new$shortnam),]$logmort0 = log(14.1)
data_new[grep("HND", data_new$shortnam),]$logmort0 = log(95.2)
data_new[grep("GUY", data_new$shortnam),]$logmort0 = log(84)
data_new[grep("SGP", data_new$shortnam),]$logmort0 = log(20)
data_new[grep("TTO", data_new$shortnam),]$logmort0 = log(106.3)
data_new[grep("SLE", data_new$shortnam),]$logmort0 = log(350)

data_new[grep("HKG", data_new$shortnam),]$source0 = 1
data_new[grep("BHS", data_new$shortnam),]$source0 = 1
data_new[grep("AUS", data_new$shortnam),]$source0 = 1
data_new[grep("HND", data_new$shortnam),]$source0 = 1
data_new[grep("GUY", data_new$shortnam),]$source0 = 1
data_new[grep("SGP", data_new$shortnam),]$source0 = 1
data_new[grep("TTO", data_new$shortnam),]$source0 = 1
data_new[grep("SLE", data_new$shortnam),]$source0 = 1

data_new[grep("HND", data_new$shortnam),]$campaign = 0

data_mor_home_new = data_new[grep(1,data_new$source0),]

panel_name = list(
                  orig_data = "orig_data",re_conj_mor = "re_conj_mor", 
                  orig_data_con = "orig_data_con", re_conj_mor_con = "re_conj_mor_con", 
                  new_data_re_conj_mor_con = "new_data_re_conj_mor_con"
             )

panel_data_set = list(
                       "orig_data" = data,"re_conj_mor" = data_mor_home, 
                       "orig_data_con" = data, "re_conj_mor_con" = data_mor_home,
                       "new_data_re_conj_mor_con" = data_mor_home_new
                )

reg_name = list(
                reg_no = "reg_no",reg_lat = "reg_lat", 
                reg_without_neo = "reg_without_neo", reg_conti = "reg_conti",
                reg_conti_lat = "reg_conti_lat", reg_per_euro = "reg_per_euro",
                reg_mal = "reg_mal"
           )

##define the output list
out = list()

##run all regressions and store data in a list 
for(i in panel_name){
                     
             logmort = panel_data_set[i][[1]][,"logmort0"]
             risk = panel_data_set[i][[1]][,"risk"]
             lat = panel_data_set[i][[1]][,"latitude"]
             asia = panel_data_set[i][[1]][,"asia"]
             africa = panel_data_set[i][[1]][,"africa"]
             other = panel_data_set[i][[1]][,"other"]
             per_euro = panel_data_set[i][[1]][,"edes1975"]
             mal = panel_data_set[i][[1]][,"malaria"]
             slave = panel_data_set[i][[1]][,"slave"]
             campaign = panel_data_set[i][[1]][,"campaign"]
             loggdp = panel_data_set[i][[1]][,"loggdp"]
    
             data_without_neo = panel_data_set[i][[1]][grep(0,panel_data_set[i][[1]]$neoeuro),]
             
             risk_without_neo = data_without_neo[,"risk"]
             logmort_without_neo = data_without_neo[,"logmort0"]
             slave_without_neo = data_without_neo[,"slave"]
             campaign_without_neo = data_without_neo[,"campaign"]
             loggdp_without_neo = data_without_neo[,"loggdp"]
    
             data_mal = panel_data_set[i][[1]][which((regexpr("NA", panel_data_set[i][[1]]$malaria))!=1),]
        
             risk_m = data_mal$risk
             mal_m = data_mal$malaria
             logmort_m = data_mal$logmort0
             slave_m = data_mal$slave
             campaign_m = data_mal$campaign
             loggdp_m = data_mal$loggdp


             temp = list()
             if (i %in% c("orig_data", "re_conj_mor")){
            
             reg_no = ivreg(loggdp ~ risk  | logmort, x=TRUE )
             
             reg_lat = ivreg(loggdp ~ risk + lat | logmort + lat, x=TRUE )
             
             reg_without_neo = ivreg(
                                     loggdp_without_neo ~ risk_without_neo  
                                     | logmort_without_neo, 
                                     x=TRUE 
                                )
             
             reg_conti = ivreg(
                               loggdp ~ risk + asia + africa + other  
                               | logmort + asia + africa + other,
                                x=TRUE 
                        )
             
             reg_conti_lat = ivreg(
                                    loggdp ~ risk + asia + africa + other + lat 
                                    | logmort + asia + africa + other + lat, 
                                    x=TRUE 
                              )
             reg_per_euro = ivreg(loggdp ~ risk + per_euro  | logmort + per_euro, x=TRUE )
             
             reg_mal = ivreg(loggdp_m ~ risk_m + mal_m | logmort_m + mal_m, x=TRUE )


            reg = list(
                        "reg_no" = reg_no,"reg_lat" = reg_lat, 
                        "reg_without_neo" = reg_without_neo, "reg_conti" = reg_conti,
                        "reg_conti_lat" = reg_conti_lat, "reg_per_euro" = reg_per_euro,
                        "reg_mal" = reg_mal
                   )

            for(k in reg_name){
                               if (k == "reg_without_neo"){
                                                        
                                                temp[[k]] = c(
                                                              reg[k][[1]]$coef[2],  
                                                              waldki(reg[k][[1]], 0.05, logmort_without_neo),
                                                              "",
                                                              anderson.rubin.ci(reg[k][[1]], conflevel=.95)[1],
                                                              anderson.rubin.ci(reg[k][[1]], conflevel=.95)[2],
                                                              ""
                                                            )
                              }else{ 
                                    if (k == "reg_mal"){
                                                
                                                temp[[k]] = c(
                                                              reg[k][[1]]$coef[2],  
                                                              waldki(reg[k][[1]], 0.05, logmort_m),
                                                              "",
                                                              anderson.rubin.ci(reg[k][[1]], conflevel=.95)[1],
                                                              anderson.rubin.ci(reg[k][[1]], conflevel=.95)[2],
                                                              ""
                                                            )
                                    }else{
                                          
                                          temp[[k]] = c(
                                                        reg[k][[1]]$coef[2],  
                                                        waldki(reg[k][[1]], 0.05, logmort),
                                                        "",
                                                        anderson.rubin.ci(reg[k][[1]], conflevel=.95)[1],
                                                        anderson.rubin.ci(reg[k][[1]], conflevel=.95)[2],
                                                        ""
                                                       )
                                    }
                                }
            }
        }else{

            reg_no = ivreg(
                            loggdp ~ risk + slave + campaign 
                            | logmort + slave + campaign, 
                            x=TRUE 
                      )
              
            reg_lat = ivreg(
                             loggdp ~ risk + lat + slave + campaign 
                             | logmort + lat + slave + campaign, 
                             x=TRUE 
                        )
              
            reg_without_neo = ivreg(
                                     loggdp_without_neo ~ risk_without_neo + slave_without_neo + campaign_without_neo 
                                     |logmort_without_neo + slave_without_neo + campaign_without_neo, 
                                     x=TRUE 
                                )
              
            reg_conti = ivreg(
                               loggdp ~ risk + asia + africa + other + slave + campaign 
                               | logmort + asia + africa + other + slave + campaign,
                               x=TRUE 
                         )
              
            reg_conti_lat = ivreg(
                                   loggdp ~ risk + asia + africa + other + lat + slave + campaign 
                                   | logmort + asia + africa + other + lat + slave + campaign, 
                                   x=TRUE 
                             )
              
            reg_per_euro = ivreg(
                                  loggdp ~ risk + per_euro + slave + campaign 
                                  | logmort + per_euro + slave + campaign, 
                                  x=TRUE 
                            )
              
            reg_mal = ivreg(
                             loggdp_m ~ risk_m + mal_m + slave_m + campaign_m 
                             | logmort_m + mal_m + slave_m + campaign_m, 
                             x=TRUE 
                        )


            reg <- list(
                        "reg_no" = reg_no,"reg_lat" = reg_lat, 
                        "reg_without_neo" = reg_without_neo, "reg_conti" = reg_conti,
                        "reg_conti_lat" = reg_conti_lat, "reg_per_euro" = reg_per_euro,
                        "reg_mal" = reg_mal
                   )

            for(k in reg_name){
                        
                        if (k == "reg_without_neo"){
                                            
                                            temp[[k]] = c(
                                                          reg[k][[1]]$coef[2],  
                                                          waldki(reg[k][[1]], 0.05, logmort_without_neo),
                                                          "",
                                                          anderson.rubin.ci(reg[k][[1]], conflevel=.95)[1],
                                                          anderson.rubin.ci(reg[k][[1]], conflevel=.95)[2],
                                                          ""
                                                        )
                        }else{
                              if (k == "reg_mal"){
                                            
                                            temp[[k]] = c(
                                                          reg[k][[1]]$coef[2],  
                                                          waldki(reg[k][[1]], 0.05, logmort_m),
                                                          "",
                                                          anderson.rubin.ci(reg[k][[1]], conflevel=.95)[1],
                                                          anderson.rubin.ci(reg[k][[1]], conflevel=.95)[2],
                                                          ""
                                                        )
                             }else{
                                   
                                   temp[[k]] = c(
                                                 reg[k][[1]]$coef[2],  
                                                 waldki(reg[k][[1]], 0.05, logmort),
                                                 "",
                                                 anderson.rubin.ci(reg[k][[1]], conflevel=.95)[1],
                                                 anderson.rubin.ci(reg[k][[1]], conflevel=.95)[2],
                                                 ""
                                                )
                            }
                        }
                }
          }
      out[[i]] <- do.call(cbind,temp)
}


##export the data list 
dput(out, file = paste(PATH_OUT_ANALYSIS,"/","second_stage_estimation.pickle",sep=""))
