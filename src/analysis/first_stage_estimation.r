' 

The file "first_stage_estimation.r" regresses in a first stage 
the expropriation risk in the country on log mortality. 
The results are stored and then plotted in the corresponding file 
"table2_first_stage_est.r" in the final directory. 

There are 5 different model specifications for the IV estimation 
standing for different robustness checks. They are denoted as 
Panels A-E in the second and third table.
  
1 = PANEL_A: Original mortality data (64 countries)
2 = PANEL_B: Only countries with non-conjectured mortality rates 
			(rest: 28 countries)
3 = PANEL_C: Original data (64 countries)
			 with campaign and laborer indicators
4 = PANEL_D: Only countries with non-conjectured 
			mortality rates and campaign and laborer indicators 
5 = PANEL_E: As Panel D with new data provided by Acemoglu et. al.

'


rm(list=ls())
options(digits=3)


source("src/library/R/project_paths.r")

library(zoo, lib=PATH_OUT_LIBRARY_R)
library(lmtest, lib=PATH_OUT_LIBRARY_R)
library(sandwich, lib=PATH_OUT_LIBRARY_R)
library(aod, lib=PATH_OUT_LIBRARY_R)
library(foreign, lib=PATH_OUT_LIBRARY_R)
library(xtable, lib=PATH_OUT_LIBRARY_R)
library(car, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE,"/","functions.r",sep=""))

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
                reg_no = "reg_no",
                reg_lat = "reg_lat", 
                reg_without_neo = "reg_without_neo",
                reg_conti = "reg_conti",
                reg_conti_lat = "reg_conti_lat",
                reg_per_euro = "reg_per_euro",
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
    
                    data_without_neo = panel_data_set[i][[1]][grep(0,panel_data_set[i][[1]]$neoeuro),]
                    risk_without_neo = data_without_neo[,"risk"]
                    logmort_without_neo = data_without_neo[,"logmort0"]
                    slave_without_neo = data_without_neo[,"slave"]
                    campaign_without_neo = data_without_neo[,"campaign"]
                    
                    data_mal = panel_data_set[i][[1]][which((regexpr("NA", panel_data_set[i][[1]]$malaria))!=1),]
                
                    risk_m = data_mal$risk
                    mal_m = data_mal$malaria
                    logmort_m = data_mal$logmort0
                    slave_m = data_mal$slave
                    campaign_m = data_mal$campaign
    

    
    temp = list()
    
    if (i %in% c("orig_data", "re_conj_mor")){
    
            reg_no = lm(risk ~ logmort)
            reg_lat = lm(risk ~ logmort + lat)
            reg_without_neo = lm(risk_without_neo ~ logmort_without_neo)
            reg_conti = lm(risk ~ logmort + asia + africa + other)
            reg_conti_lat = lm(risk ~ logmort + asia + africa + other + lat)
            reg_per_euro = lm(risk ~ logmort + per_euro)
            reg_mal = lm(risk_m ~ logmort_m + mal_m)
    
            reg <- list(
                        "reg_no" = reg_no,"reg_lat" = reg_lat, 
                        "reg_without_neo" = reg_without_neo, "reg_conti" = reg_conti,
                        "reg_conti_lat" = reg_conti_lat, "reg_per_euro" = reg_per_euro,
                        "reg_mal" = reg_mal
                   )
           if (i == "orig_data"){
    
                for(k in reg_name){
                                   
                    if (k == "reg_no"){
                               temp[[k]] = c(
                                              reg[k][[1]]$coef[2], sqrt(diag(vcov(reg[k][[1]]))[2]), 
                                              clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,2],
                                              clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,4],
                                              ""
                                             ) 
                    } else{
                           
                        if (k == "reg_mal"){ 
                                temp[[k]] = c(
                                               reg[k][[1]]$coef[2], sqrt(diag(vcov(reg[k][[1]]))[2]), 
                                               clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[1]][2,2],
                                               clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[1]][2,4],
                                               wald.test(
                                                         b = reg[k][[1]]$coef,
                                                         Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[2]], 
                                                         Terms = 3:length(reg[k][[1]]$coef), df = reg[k][[1]]$df
                                               )[[6]][[2]][4]
                                             )
                       } else {
                               
                             if (k == "reg_without_neo"){ 
                                    temp[[k]] = c(
                                                   reg[k][[1]]$coef[2], sqrt(diag(vcov(reg[k][[1]]))[2]), 
                                                   clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_without_neo)[[1]][2,2],
                                                   clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_without_neo)[[1]][2,4],
                                                   ""
                                                 )
                             }else{
                                    temp[[k]] = c(
                                                   reg[k][[1]]$coef[2], sqrt(diag(vcov(reg[k][[1]]))[2]), 
                                                   clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,2],
                                                   clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,4],
                                                   wald.test(
                                                             b = reg[k][[1]]$coef,
                                                             Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[2]], 
                                                             Terms = 3:length(reg[k][[1]]$coef), df = reg[k][[1]]$df
                                                   )[[6]][[2]][4]
                                                 )
                            }
                      }                
                   }
                }                   
           } else {
                for(k in reg_name){
                    if (k %in% c("reg_no", "reg_without_neo")){
                                        temp[[k]] = c(
                                                       reg[k][[1]]$coef[2], 
                                                       summaryw(reg[k][[1]])[[1]][2,2],
                                                       summaryw(reg[k][[1]])[[1]][2,4],
                                                       ""
                                                     )
                   } else{ 
                          temp[[k]] = c(
                                         reg[k][[1]]$coef[2],  
                                         summaryw(reg[k][[1]])[[1]][2,2],
                                         summaryw(reg[k][[1]])[[1]][2,4],
                                         wald.test(
                                                   b = reg[k][[1]]$coef,
                                                   Sigma = summaryw(reg[k][[1]])[[2]], 
                                                   Terms = 3:length(reg[k][[1]]$coef), df = reg[k][[1]]$df
                                         )[[6]][[2]][4]
                                       )
                  }
             }
    } 
  }else {

        reg_no = lm(risk ~ logmort + slave + campaign)
        reg_lat = lm(risk ~ logmort + lat + slave + campaign)
        reg_without_neo = lm(risk_without_neo ~ logmort_without_neo + slave_without_neo + campaign_without_neo)
        reg_conti = lm(risk ~ logmort + asia + africa + other + slave + campaign)
        reg_conti_lat = lm(risk ~ logmort + asia + africa + other + lat + slave + campaign)
        reg_per_euro = lm(risk ~ logmort + per_euro + slave + campaign)
        reg_mal = lm(risk_m ~ logmort_m + mal_m + slave_m + campaign_m)
        
        reg = list(
                   "reg_no" = reg_no,"reg_lat" = reg_lat, 
                   "reg_without_neo" = reg_without_neo, "reg_conti" = reg_conti,
                   "reg_conti_lat" = reg_conti_lat, "reg_per_euro" = reg_per_euro,
                   "reg_mal" = reg_mal
              )
            
        if (i == "orig_data_con"){    
              for(k in reg_name){
                                 
                    if (k == "reg_no"){
                           temp[[k]] = c(
                                          reg[k][[1]]$coef[2],  
                                          clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,2],
                                          clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,4],
                                          wald.test(
                                                    b = reg[k][[1]]$coef,
                                                    Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[2]], 
                                                    Terms = 3:length(reg[k][[1]]$coef), df = reg[k][[1]]$df
                                          )[[6]][[2]][4],
                                          ""
                                        ) 
                    } else{
                         if (k == "reg_mal"){ 
                                temp[[k]] = c(
                                              reg[k][[1]]$coef[2],  
                                              clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[1]][2,2],
                                              clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[1]][2,4],
                                              wald.test(
                                                        b = reg[k][[1]]$coef,
                                                        Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[2]], 
                                                        Terms = 3:(length(reg[k][[1]]$coef) - 2) , df = reg[k][[1]]$df
                                              )[[6]][[2]][4],
                                              wald.test(
                                                        b = reg[k][[1]]$coef,
                                                        Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_m)[[2]], 
                                                        Terms = (length(reg[k][[1]]$coef) - 1):length(reg[k][[1]]$coef) , 
                                                        df = reg[k][[1]]$df
                                              )[[6]][[2]][4]
                                             )
                                     
                   }else{
                         if (k == "reg_without_neo"){ 
                                temp[[k]] = c(
                                              reg[k][[1]]$coef[2], 
                                              clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_without_neo)[[1]][2,2],
                                              clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort_without_neo)[[1]][2,4],
                                              wald.test(
                                                        b = reg[k][[1]]$coef,
                                                        Sigma = clx(fm = reg[k][[1]], dfcw = 1, 
                                                        cluster = logmort_without_neo)[[2]], 
                                                        Terms = 3:(length(reg[k][[1]]$coef) - 2) , df = reg[k][[1]]$df
                                              )[[6]][[2]][4],
                                              wald.test(
                                                        b = reg[k][[1]]$coef,
                                                        Sigma = clx(fm = reg[k][[1]], dfcw = 1, 
                                                        cluster = logmort_without_neo)[[2]], 
                                                        Terms = (length(reg[k][[1]]$coef) - 1):length(reg[k][[1]]$coef), 
                                                        df = reg[k][[1]]$df
                                              )[[6]][[2]][4]
                                            )
                         }else{
                             temp[[k]] = c(
                                          reg[k][[1]]$coef[2],  
                                          clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,2],
                                          clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,4],
                                          wald.test(
                                                    b = reg[k][[1]]$coef,
                                                    Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[2]], 
                                                    Terms = 3:(length(reg[k][[1]]$coef) - 2) , df = reg[k][[1]]$df
                                          )[[6]][[2]][4],
                                          wald.test(
                                                    b = reg[k][[1]]$coef,
                                                    Sigma = clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[2]], 
                                                    Terms = (length(reg[k][[1]]$coef) - 1):length(reg[k][[1]]$coef) , 
                                                    df = reg[k][[1]]$df
                                          )[[6]][[2]][4]
                                         )
                          }
                    }
                }
            }
       }else{
                for(k in reg_name){
                                   
                    if (k %in% c("reg_no", "reg_without_neo")){
                                        temp[[k]] = c(
                                                       reg[k][[1]]$coef[2], 
                                                       summaryw(reg[k][[1]])[[1]][2,2],
                                                       summaryw(reg[k][[1]])[[1]][2,4],
                                                       wald.test(
                                                                 b = reg[k][[1]]$coef,
                                                                 Sigma = summaryw(reg[k][[1]])[[2]], 
                                                                 Terms = 3:(length(reg[k][[1]]$coef) - 2), 
                                                                 df = reg[k][[1]]$df
                                                       )[[6]][[2]][4],
                                                       ""
                                                     )
                   } else{ 
    
                    temp[[k]] = c(
                                   reg[k][[1]]$coef[2],  
                                   summaryw(reg[k][[1]])[[1]][2,2],
                                   summaryw(reg[k][[1]])[[1]][2,4],
                                   wald.test(
                                             b = reg[k][[1]]$coef,
                                             Sigma = summaryw(reg[k][[1]])[[2]], 
                                             Terms = 3:(length(reg[k][[1]]$coef) - 2), df = reg[k][[1]]$df
                                   )[[6]][[2]][4],
                                   wald.test(
                                             b = reg[k][[1]]$coef,
                                             Sigma = summaryw(reg[k][[1]])[[2]], 
                                             Terms = (length(reg[k][[1]]$coef) - 1):length(reg[k][[1]]$coef), 
                                             df = reg[k][[1]]$df
                                   )[[6]][[2]][4]   
                                 )
                  }
             }    
        }                 
    }
    out[[i]] <- do.call(cbind,temp)
}

##export the data list 
dput(out, file = paste(PATH_OUT_ANALYSIS,"/","first_stage_estimation.txt",sep=""))
