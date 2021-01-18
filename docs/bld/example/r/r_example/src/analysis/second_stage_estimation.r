'

In the file "second_stage_estimation.r", we compute IV estimates for log GDP
per capita with expropriation risk as the first stage dependent variable.

We also compute confidence intervals for a usual Wald statistic and confidence
intervals for the Anderson-Rubin (1949) statistic.

The file requires to be called with a model specification as the argument,
a corresponding json-file must exist in PATH_IN_MODEL_SPECS. That file
needs to define a dictionary with keys:

    * INSTD - the dependent variable (in the first stage)
    * INSTS - the instrument
    * KEEP_CONDITION - any sampling restrictions
    * DUMMIES - additional dummy variables to be used as controls

The r-file loops over various specifications with geographic controls /
restrictions as defined in PATH_IN_MODEL_SPECS/geography.json. Finally,
it stores a dataframe with estimation results.

'


rm(list=ls())
options(digits=3)

args = commandArgs(trailingOnly=TRUE)

source(args[1])

# Load required libraries.
library(foreign)
library(zoo)
library(car)
library(rjson)
library(sandwich)
library(lmtest)
library(AER)

# Load model and geographic specification.
model <- fromJSON(file=args[2])
geography <- fromJSON(file=args[3])

# Initilize output dataframe for results.
results = data.frame(matrix(nrow = 5, ncol = 7))
row.names(results) <- c(
    "Expropriation risk $(\\alpha)$ ",
    "Wald 95\\% conf.",
    "region ",
    "AR \\textquotedblleft 95\\%\\textquotedblright conf.",
    "region"
)

# Loop over geographical specifications.
for (i in 1:7) {

    # Load data.
    data <- read.csv(file=args[4], header=TRUE)

    # Implement model-specific restrictions.
    if (model$KEEP_CONDITION != "") {
        data <- subset(data, eval(parse(text = model$KEEP_CONDITION)))
    }

    # Implement geographical constraints.
    GEO_COND <- paste("GEO_KEEP_CONDITION_", i, sep="")
    if (geography[[GEO_COND]] != "") {
        data <- subset(data, eval(parse(text = geography[[GEO_COND]])))
    }
    GEO_CONTROLS <- paste("GEO_CONTROLS_", i, sep="")

    # Set up variables for regression.
    y <- model$DEPVAR
    x <- model$INSTD
    instr <- model$INSTS
    dummies <- model$DUMMIES
    geo_controls <- geography[[GEO_CONTROLS]]

    # Set up regression formula.
    reg_formula <- as.formula(
      paste(y, " ~ ", x, dummies, geo_controls, " | ", instr, dummies, geo_controls, sep="")
    )
    reg <- ivreg(formula = reg_formula, data = data, x = TRUE)

    # Write regression results for iteration 'i' to output dataframe.
    if (is.na(anderson.rubin.ci(reg, conflevel=.95)[2])) {
        results[i] = c(
            round(reg$coef[[2]], 2),
            wald.ci(reg, 0.05, data[ ,instr]),
            "",
            paste("$", anderson.rubin.ci(reg, conflevel=.95)[1], "$", sep=""),
            ""
        )

    } else {
        results[i] = c(
            round(reg$coef[[2]], 2),
            wald.ci(reg, 0.05, data[ ,instr]),
            "",
            anderson.rubin.ci(reg, conflevel=.95)[1],
            anderson.rubin.ci(reg, conflevel=.95)[2]
        )
    }
}

# Save data to disk.
write.csv(results, file=args[5], col.names=TRUE)
