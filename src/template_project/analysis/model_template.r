# ======================================================================================
# Functions
# ======================================================================================

fit_logit_model <- function(data, formula, model_type) {
  if (model_type != "linear_index") {
    message <- "Only 'linear_index' model_type is supported right now."
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
formula <- (
  "current_smoker_numerical ~ gender + marital_status + age + highest_qualification"
)
model <- fit_logit_model(data, formula = formula, model_type = "linear_index")
saveRDS(model, file = config[["produces"]])
