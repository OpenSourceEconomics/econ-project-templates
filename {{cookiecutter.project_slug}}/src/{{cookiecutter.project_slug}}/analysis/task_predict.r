# ======================================================================================
# Get produces and depends_on from pytask
# ======================================================================================

args <- commandArgs(trailingOnly=TRUE)
path_to_json <- args[length(args)]
config <- yaml::yaml.load_file(path_to_json)

produces = config[["produces"]]
depends_on = config[["depends_on"]]

# ======================================================================================
# Main
# ======================================================================================

source(file.path(config[["SRC"]], "analysis", "predict.R"))
group = config[["group"]]

model = load_model(depends_on[["model"]])
data = read.csv(depends_on[["data"]])
predicted_prob = predict_prob_by_age(data, model, group)
write.csv(predicted_prob, produces, row.names=FALSE)