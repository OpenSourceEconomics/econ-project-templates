# ======================================================================================
# Functions
# ======================================================================================
clean_data <- function(data) {
  clean <- data.frame(
    gender = clean_gender(data$gender),
    marital_status = clean_marital_status(data$marital_status),
    smoke = clean_smoke(data$smoke),
    smoke_numerical = convert_smoke_to_numerical(data$smoke),
    highest_qualification = clean_highest_qualification(data$highest_qualification),
    age = as.integer(data$age)
  )

  return(clean)
}

convert_smoke_to_numerical <- function(smoke) {
  return(as.integer(as.factor(smoke)) - 1)
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

clean_smoke <- function(sr) {
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
data <- clean_data(data)
saveRDS(data, file = config[["produces"]])
