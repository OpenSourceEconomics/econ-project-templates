library(dplyr)
library(yaml)

# ======================================================================================
# Tasks
# ======================================================================================


task_plot_regression = function(depends_on, group, produces) {
    
}


task_create_estimation_table = function(depends_on, produces) {

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


if (task == "plot_regression") {

  source(file.path(config[["SRC"]], "final", "plot.R"))  
  group = config[["group"]]
  task_plot_regression(depends_on, group, produces)

} else if (task == "create_estimation_table") {

  source(file.path(config[["SRC"]], "final", "plot.R"))
  task_create_estimation_table(depends_on, group, produces)

} else {
  stop("task needs to be either 'plot_regression' or 'create_estimation_table'.")
}