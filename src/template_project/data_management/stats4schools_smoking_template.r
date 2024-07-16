# ======================================================================================
# Functions
# ======================================================================================
clean_stats4schools_smoking <- function(data) {
  clean <- data.frame(matrix(nrow = nrow(data), ncol = 0))

  clean["gender"] <- clean_gender(data$gender)
  clean["marital_status"] <- clean_marital_status(data$marital_status)
  clean["current_smoker"] <- clean_current_smoker(data$smoke)
  clean["current_smoker_numerical"] <- convert_current_smoker_to_numerical(clean$current_smoker)
  clean["highest_qualification"] <- clean_highest_qualification(data$highest_qualification)
  clean["age"] <- as.integer(data$age)
  return(clean)
}

convert_current_smoker_to_numerical <- function(current_smoker) {
  return(as.integer(as.factor(current_smoker)) - 1)
}

clean_gender <- function(sr) {
  return(factor(sr, levels = c("Male", "Female"), ordered = FALSE))
}

clean_marital_status <- function(sr) {
  return(
    factor(
      sr,
      levels = c("Single", "Married", "Divorced", "Widowed", "Separated"),
      ordered = FALSE
    )
  )
}

clean_current_smoker <- function(sr) {
  return(factor(sr, levels = c("No", "Yes"), ordered = TRUE))
}

clean_highest_qualification <- function(sr) {
  replace_mapping <- c(
    "GCSE/CSE or GCSE/O Level" = "GCSE/CSE",
    "GCSE/CSE or GCSE/O Level" = "GCSE/O Level",
    "Other/Sub or Higher/Sub Degree" = "Other/Sub Degree",
    "Other/Sub or Higher/Sub Degree" = "Higher/Sub Degree"
  )
  ordered_qualifications <- c(
    "No Qualification",
    "GCSE/CSE or GCSE/O Level",
    "ONC/BTEC",
    "Other/Sub or Higher/Sub Degree",
    "A Levels",
    "Degree"
  )
  sr <- forcats::fct_recode(sr, !!!replace_mapping)
  return(factor(sr, levels = ordered_qualifications, ordered = TRUE))
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

data <- read.csv(config[["data"]])
data <- clean_stats4schools_smoking(data)
saveRDS(data, file = config[["produces"]])
