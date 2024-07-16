# ======================================================================================
# Functions
# ======================================================================================

predict_prob_by_age <- function(data, model, group) {
  age_min <- min(data[["age"]])
  age_max <- max(data[["age"]])
  age_grid <- seq(age_min, age_max)

  mode <- lapply(data, .mode)
  mode <- data.frame(mode)

  new_data <- data.frame(age = age_grid)
  cols_to_set <- setdiff(colnames(data), c(group, "age", "current_smoker"))
  new_data <- cbind(new_data, mode[cols_to_set])

  predicted <- list(age = age_grid)
  for (group_value in unique(data[[group]])) {
    .new_data <- data.frame(new_data) # create a copy
    .new_data[[group]] <- group_value
    predicted[[group_value]] <- predict(model, .new_data, type = "response")
  }

  predicted <- as.data.frame(predicted)
  return(predicted)
}

.mode <- function(x) {
  unique_values <- unique(x)
  mode <- unique_values[which.max(tabulate(match(x, unique_values)))]
  return(mode)
}

# ======================================================================================
# Get config from pytask
# ======================================================================================

args <- commandArgs(trailingOnly = TRUE)
path_to_yaml <- args[length(args)]
config <- yaml::yaml.load_file(path_to_yaml)

# ======================================================================================
# Main
# ======================================================================================

model <- readRDS(config[["model_path"]])
data <- readRDS(config[["data_path"]])
predicted_prob <- predict_prob_by_age(data, model, config[["group"]])
saveRDS(predicted_prob, config[["produces"]])
