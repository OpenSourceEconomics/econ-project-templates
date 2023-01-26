# ======================================================================================
# Functions
# ======================================================================================

fit_logit_model <- function(data, data_info, model_type) {
  outcome_name <- data_info[["outcome"]]
  outcome_name_numerical <- data_info[["outcome_numerical"]]
  feature_names <- setdiff(colnames(data), c(outcome_name, outcome_name_numerical))

  if (model_type == "linear") {
    formula <- paste(
      outcome_name_numerical,
      "~",
      paste(feature_names, collapse = "+")
    )
    formula <- as.formula(formula)
  } else {
    message <- "Only 'linear' model_type is supported right now."
    stop(message)
  }

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
# Get produces and depends_on from pytask
# ======================================================================================

args <- commandArgs(trailingOnly = TRUE)
path_to_yaml <- args[length(args)]
config <- yaml::yaml.load_file(path_to_yaml)

produces <- config[["produces"]]
depends_on <- config[["depends_on"]]

# ======================================================================================
# Main
# ======================================================================================

data_info <- yaml::yaml.load_file(depends_on[["data_info"]])
data <- read.csv(depends_on[["data"]])
model <- fit_logit_model(data, data_info, model_type = "linear")
saveRDS(model, file = produces)
