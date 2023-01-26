# ======================================================================================
# Functions
# ======================================================================================

clean_data <- function(data, data_info) {
  data[data_info[["columns_to_drop"]]] <- NULL
  data <- na.omit(data)
  for (cat_col in data_info[["categorical_columns"]]) {
    data[[cat_col]] <- as.factor(data[[cat_col]])
  }
  data <- plyr::rename(data, data_info[["column_rename_mapping"]])

  numerical_outcome <- ifelse(data[[data_info[["outcome"]]]] == "Yes", 1, 0)
  data[data_info[["outcome_numerical"]]] <- numerical_outcome

  return(data)
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
data <- clean_data(data, data_info)
write.csv(data, file = produces, row.names = FALSE)
