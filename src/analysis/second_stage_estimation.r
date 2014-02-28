# The file "first_stage_estimation.r" regresses in a first stage 
# the expropriation risk in the country on log mortality. 
# The results are stored and then plotted in the corresponding file 
# "table2_first_stage_est.r" in the final directory. 

# There are 5 different model specifications for the IV estimation 
# standing for different robustness checks. They are denoted as 
# Panels A-E in the second and third table.
  
# 1 = Panel A: Original mortality data (64 countries)
# 2 = Panel B: Only countries with non-conjectured mortality rates 
#       (rest: 28 countries)
# 3 = Panel C: Original data (64 countries)
#        with campaign and laborer indicators
# 4 = Panel D: Only countries with non-conjectured 
#       mortality rates and campaign and laborer indicators 
# 5 = Panel E: As Panel D with new data provided by Acemoglu et. al.



rm(list=ls())
options(digits=3)


source("src/library/R/project_paths.r")

library(rjson, lib=PATH_OUT_LIBRARY_R)
library(sandwich, lib=PATH_OUT_LIBRARY_R)
library(zoo, lib=PATH_OUT_LIBRARY_R)
library(lmtest, lib=PATH_OUT_LIBRARY_R)
library(car, lib=PATH_OUT_LIBRARY_R)
library(AER, lib=PATH_OUT_LIBRARY_R)
library(ivpack, lib=PATH_OUT_LIBRARY_R)
library(foreign, lib=PATH_OUT_LIBRARY_R)
library(xtable, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE, "functions.r", sep="/"))

# Load model and geographic specification
model_name <- commandArgs(trailingOnly = TRUE)
model_json <- paste(model_name, "json", sep=".")
model <- fromJSON(file=paste(PATH_IN_MODEL_SPECS, model_json, sep="/"))
panel_name = substring(model$TITLE, 1, 7)
geography <- fromJSON(file=paste(PATH_IN_MODEL_SPECS, "geography.json", sep="/"))

# Initilize output dataframe. Store data in here. Set row names conditional on panel
out = data.frame(matrix(nrow = 5, ncol = 7))
row.names(out) <- c(
    "Expropriation risk $(\\alpha)$ ", 
    "Wald 95\\% conf.",
    "region ",
    "AR \\textquotedblleft 95\\%\\textquotedblright conf.", 
    "region"
)


# Loop over geographical constraints
for (i in 1:7) {
    # Load data
    data <- read.table(
        file = paste(PATH_OUT_DATA, "ajrcomment_all.txt", sep="/"),
        header = TRUE
    )

    # Condition data on model
    if (model$KEEP_CONDITION != "") {
        data <- subset(data, eval(parse(text = model$KEEP_CONDITION)))    
    }

    # Condition data on geography
    GEO_COND <- paste("GEO_KEEP_CONDITION_", i, sep="")
    if (geography[[GEO_COND]] != "") {
        data <- subset(data, eval(parse(text = geography[[GEO_COND]])))
    }
    GEO_CONTROLS <- paste("GEO_CONTROLS_", i, sep="")

    # Set up variables for regression
    y <- model$DEPVAR
    x <- model$INSTD
    instr <- model$INSTS
    dummies <- model$DUMMIES
    geo_controls <- geography[[GEO_CONTROLS]]

    # Set up regression formula
    reg_formula <- as.formula(
      paste(y, " ~ ", x, dummies, geo_controls, " | ", instr, dummies, geo_controls, sep="")
    )
    reg <- ivreg(formula = reg_formula, data = data, x = TRUE)

    # Write temporary regression results for iteration 'i' to output dataframe
    if (is.na(anderson.rubin.ci(reg, conflevel=.95)[2])) {
        out[i] = c(
            round(reg$coef[[2]], 2),  
            wald.ci(reg, 0.05, data[ ,instr]),
            "",
            paste("$", anderson.rubin.ci(reg, conflevel=.95)[1], "$", sep=""),
            ""
        )

    } else {
        out[i] = c(
            round(reg$coef[[2]], 2),  
            wald.ci(reg, 0.05, data[ ,instr]),
            "",
            anderson.rubin.ci(reg, conflevel=.95)[1],
            anderson.rubin.ci(reg, conflevel=.95)[2]
        )
    }
}

# export data
write.table(
    out, 
    file = paste(
        PATH_OUT_ANALYSIS, 
        paste("second_stage_estimation_", model_name, ".txt", sep=""),
        sep = "/"
    )
)