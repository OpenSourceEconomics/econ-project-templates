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

library(rjson, lib=PATH_OUT_LIBRARY_R)
library(zoo, lib=PATH_OUT_LIBRARY_R)
library(lmtest, lib=PATH_OUT_LIBRARY_R)
library(sandwich, lib=PATH_OUT_LIBRARY_R)
library(aod, lib=PATH_OUT_LIBRARY_R)
library(foreign, lib=PATH_OUT_LIBRARY_R)
library(xtable, lib=PATH_OUT_LIBRARY_R)
library(car, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE, "functions.r", sep="/"))

# Load model and geographic specification
model_name = commandArgs(trailingOnly = TRUE)
model <- fromJSON(paste(PATH_IN_MODEL_SPECS, paste(model_name, "json", sep="."), sep="/"))
panel_name = substring(model$TITLE, 1, 7)
geography <- fromJSON((PATH_IN_MODEL_SPECS, "geography.json", sep="/"))

# Access model via: data <- subset(data, eval(parse(text = model&KEEP_CONDITION)))

reg_names = c(
  "reg_no", 
  "reg_lat", 
  "reg_without_neo", 
  "reg_conti", 
  "reg_conti_lat", 
  "reg_per_euro",
  "reg_mal"
)

# define output dataframe. Store data in here. Set row names conditional on model...
out = data.frame()

# Loop over geographical constraints
for (i in 1:7) {
    
    # Load data
    data <- read.table(paste(PATH_OUT_DATA, "ajrcomment_all.txt", sep="/"))
    
    # Condition data on model
    data <- subset(data, eval(parse(text = model&KEEP_CONDITION)))

    # Condition data on geography
    GEO_COND <- paste("GEO_KEEP_CONDITIONS_", i, sep="")
    GEO_CONTROL <- paste("GEO_CONTROLS_", i, sep="")
    data <- subset(data, eval(parse(text = geography[[GEO_COND]])))

    # Set up variables for regression
    y <- model$INSTD
    x <- model$INSTS
    dummies <- model$DUMMIES
    geo_controls <- geography[[GEO_CONTROL]]

    # Set up regression formula
    reg_formula <- as.formula(paste(y, "~", x, dummies, geo_controls, sep=""))
    reg <- lm(reg_formula, data)
    
    temp = list()
    
    if (panel_name == "PANEL_A" | panel_name == "PANEL_B") {
    
        if (panel_name == "PANEL_A") {

            if (i == 1 | i == 3) { # No contols or No neo-europeans
                temp[[k]] = c(
                   reg[k][[1]]$coef[2], sqrt(diag(vcov(reg[k][[1]]))[2]), 
                   clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,2],
                   clx(fm = reg[k][[1]], dfcw = 1, cluster = logmort)[[1]][2,4],
                   ""
                  ) 
            } 

            else { # cases i = 2,4,5,6,7
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
            }
        }

        else { # panel_name == "PANEL_B"
                
            if (i == 1 | i == 3) { # No controls or No neo-europeans
                temp[[k]] = c(
                    reg[k][[1]]$coef[2], 
                    summaryw(reg[k][[1]])[[1]][2,2],
                    summaryw(reg[k][[1]])[[1]][2,4],
                    ""
                )
            } 

            else { # cases i = 2,4,5,6,7
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
    else { # panel_name == "PANEL_C" or "PANEL_D" or "PANEL_E"
            
        if (panel_name == "PANEL_C") {

            if (i == 1 | i == 3) { # No contols | No neo europeans
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
            } 
            
            else { # cases i = 2,4,5,6,7
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

        else { # panel_name == "PANEL_D" or "PANEL_E"

            if (i == 1 | i == 3) { # No contols | No neo europeans
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
            } 
            
            else { # cases i = 2,4,5,6,7
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
dput(out, file = paste(PATH_OUT_ANALYSIS, "first_stage_estimation.txt", sep="/"))
