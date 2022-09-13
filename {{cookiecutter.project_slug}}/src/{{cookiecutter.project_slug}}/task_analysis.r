library(dplyr)
library(yaml)

# ======================================================================================
# Tasks
# ======================================================================================

task_fit_model = function(depends_on, produces) {
    data_info = yaml::yaml.load_file(depends_on[["data_info"]])
    data = read.csv(depends_on[["data"]])
    model = fit_logit_model(data, data_info, model_type="linear")
    save(model, produces)
}

task_predict = function(depends_on, group, produces) {
    model = load_model(depends_on[["model"]])
    data = read.csv(depends_on[["data"]])
    predicted_prob = predict_prob_by_age(data, model, group)
    write.csv(predicted_prob, produces, row.names=FALSE)
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


if (task == "fit_model") {

  source(file.path(config[["SRC"]], "analysis", "model.R"))  
  task_fit_model(depends_on, produces)

} else if (task == "predict") {

  source(file.path(config[["SRC"]], "analysis", "predict.R"))
  group = config[["group"]]
  task_predict(depends_on, group, produces)

} else {
  stop("task needs to be either 'fit_model' or 'predict'.")
}