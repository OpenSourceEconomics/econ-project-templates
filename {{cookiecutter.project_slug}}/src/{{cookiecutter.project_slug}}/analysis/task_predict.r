# ======================================================================================
# Get produces and depends_on from pytask
# ======================================================================================

args <- commandArgs(trailingOnly=TRUE)
path_to_json <- args[length(args)]
config <- yaml::yaml.load_file(path_to_json)

produces = config[["produces"]]
depends_on = config[["depends_on"]]
group = config[["group"]]
SRC = depends_on[["SRC"]]

# ======================================================================================
# Main
# ======================================================================================

source(file.path(SRC, "analysis", "predict.R"))

model = readRDS(depends_on[["model"]])
data = read.csv(depends_on[["data"]])
predicted_prob = predict_prob_by_age(data, model, group)
write.csv(predicted_prob, produces, row.names=FALSE)