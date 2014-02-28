# The file "first_stage_estimation.r" regresses in a first stage 
# the expropriation risk in the country on log mortality. 
# The results are stored and then plotted in the corresponding file 
# "table2_first_stage_est.r" in the final directory. 

# There are 5 different model specifications for the IV estimation 
# standing for different robustness checks. They are denoted as 
# Panels A-E in the second and third table.
  
# 1 = Panel A: Original mortality data (64 countries)
# 2 = Panel B: Only countries with non-conjectured mortality rates 
# 			(rest: 28 countries)
# 3 = Panel C: Original data (64 countries)
# 			 with campaign and laborer indicators
# 4 = Panel D: Only countries with non-conjectured 
# 			mortality rates and campaign and laborer indicators 
# 5 = Panel E: As Panel D with new data provided by Acemoglu et. al.



rm(list=ls())
options(digits=3)

source("src/library/R/project_paths.r")
source(paste(PATH_IN_MODEL_CODE, "functions.r", sep="/"))

# Load required libraries
library(rjson, lib=PATH_OUT_LIBRARY_R)
library(zoo, lib=PATH_OUT_LIBRARY_R)
library(lmtest, lib=PATH_OUT_LIBRARY_R)
library(sandwich, lib=PATH_OUT_LIBRARY_R)
library(aod, lib=PATH_OUT_LIBRARY_R)
library(foreign, lib=PATH_OUT_LIBRARY_R)
library(xtable, lib=PATH_OUT_LIBRARY_R)
library(car, lib=PATH_OUT_LIBRARY_R)

# Load model and geographic specification
model_name <- commandArgs(trailingOnly = TRUE)
model_json <- paste(model_name, "json", sep=".")
model <- fromJSON(file=paste(PATH_IN_MODEL_SPECS, model_json, sep="/"))
panel_name = substring(model$TITLE, 1, 7)
geography <- fromJSON(file=paste(PATH_IN_MODEL_SPECS, "geography.json", sep="/"))

# Initilize output dataframe. Store data in here.
results = data.frame(matrix(nrow = 7, ncol = 7))
row.names(results) <- c(
    "logmort_coef", 
    "homoscedastic_se",
    "heteroscedastic_se",
    "hetero_clustered_se",
    "p_val_logmort",
    "p_val_indicators",
    "p_val_controls"
)

# Loop over geographical constraints
for (j in 1:7) {

    # Load data
    data <- read.table(
        file = paste(PATH_OUT_DATA, "ajrcomment_all.txt", sep="/"),
        header = TRUE
    )

    # Condition data on model
    if (model$KEEP_CONDITION != "") {
        data <- subset(data, eval(parse(text = model$KEEP_CONDITION)))    
    }

    # Condition data on geographical constraints
    GEO_COND <- paste("GEO_KEEP_CONDITION_", j, sep="")
    if (geography[[GEO_COND]] != "") {
        data <- subset(data, eval(parse(text = geography[[GEO_COND]])))
    }
    GEO_CONTROLS <- paste("GEO_CONTROLS_", j, sep="")

    # Set up variables for regression
    y <- model$INSTD
    x <- model$INSTS
    dummies <- model$DUMMIES
    geo_controls <- geography[[GEO_CONTROLS]]

    # Set up regression formula
    reg_formula <- as.formula(paste(y, " ~ ", x, dummies, geo_controls, sep=""))
    reg <- lm(reg_formula, data)

    # Write regression output conditional on model/panel
    results[j, 1] = reg$coef[[2]] 
    results[j, 2] = sqrt(diag(vcov(reg))[2])
    results[j, 3] = summaryw(reg)[[1]][2,2]
    results[j, 4] = clx(fm = reg, dfcw = 1, cluster = data[ ,x])[[1]][2,2]
    
    # p-value for log mortality conditional on standard errors
    if (panel_name == "Panel A" | panel_name == "Panel C") {
        results[j, 5] = clx(fm = reg, dfcw = 1, cluster = data[ ,x])[[1]][2,4]
    } else {
        results[j, 5] = summaryw(reg)[[1]][2,4]
    }
    # p-value of indicators conditional on panel
    if (panel_name == "Panel C" | panel_name == "Panel D" | panel_name == "Panel E") {
        results[j, 6] = wald.test(
            b = reg$coef,
            Sigma = clx(fm = reg, dfcw = 1, cluster = data[ ,x])[[2]], 
            Terms = 3:length(reg$coef), 
            df = reg$df
        )[[6]][[2]][4]        
    }
    # p-value of controls conditional on geographical constraints
    if (j != 1 & j != 3) {
        results[j, 7] = wald.test(
            b = reg$coef,
            Sigma = summaryw(reg)[[2]], 
            Terms = (length(reg$coef) - 1):length(reg$coef), 
            df = reg$df
        )[[6]][[2]][4]
    }
}

# export data
write.table(
    results, 
    file = paste(
        PATH_OUT_ANALYSIS, 
        paste("first_stage_estimation_", model_name, ".txt", sep=""),
        sep = "/"
    ),
    col.names = FALSE
)