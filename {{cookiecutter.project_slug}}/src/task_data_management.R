library(yaml)

# ======================================================================================
# Tasks
# ======================================================================================

task_get_data = function(depends_on, produces) {
  data_info = yaml::yaml.load_file(depends_on[["data_info"]])
  data = read.csv(data_info[["url"]])
  write.csv(data, file=produces, col.names=TRUE)
}


task_clean_data = function(depends_on, produces) {
  data_info = yaml::yaml.load_file(depends_on[["data_info"]])
  data = read.csv(data_info[["data"]])
  data = clean_data(data, data_info)
  write.csv(data, file=produces, col.names=TRUE)
}

# ======================================================================================
# Main
# ======================================================================================

args <- commandArgs(trailingOnly=TRUE)
path_to_json <- args[length(args)]
config <- yaml::yaml.load_file(path_to_json)

produces = config[["produces"]]
depends_on = config[["depends_on"]]
task = config[["task"]]

if (task == "get_data") {

  task_get_data(produces, depends_on)

} else if (task == "clean_data") {

  source(file.path(config[["SRC"]], "data_management", "clean_data.R"))  
  task_clean_data(depends_on, produces)

} else {
  stop("task needs to be either 'get_data' or 'clean_data'.")
}