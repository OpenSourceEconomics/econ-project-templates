# ======================================================================================
# Functions
# ======================================================================================

fit_logit_model <- function(data, formula) {
  model <- glm(
    formula,
    family = "binomial",
    data = data,
    model = FALSE,
    y = FALSE
  )
  return(model)
}

# ======================================================================================
# Get config from pytask
# ======================================================================================

args <- commandArgs(trailingOnly = TRUE)
path_to_yaml <- args[length(args)]
config <- yaml::yaml.load_file(path_to_yaml)

produces <- config[["produces"]]
depends_on <- config[["depends_on"]]

# ======================================================================================
# Main
# ======================================================================================

data <- readRDS(config[["data"]])
model <- fit_logit_model(data, formula = config[["formula"]])
saveRDS(model, file = config[["produces"]])
