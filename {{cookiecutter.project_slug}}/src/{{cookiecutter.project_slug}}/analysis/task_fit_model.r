# ======================================================================================
# Get produces and depends_on from pytask
# ======================================================================================

args <- commandArgs(trailingOnly=TRUE)
path_to_json <- args[length(args)]
config <- yaml::yaml.load_file(path_to_json)

produces = config[["produces"]]
depends_on = config[["depends_on"]]
SRC = depends_on[["SRC"]]

# ======================================================================================
# Main
# ======================================================================================

source(file.path(SRC, "analysis", "model.R"))  

data_info = yaml::yaml.load_file(depends_on[["data_info"]])
data = read.csv(depends_on[["data"]])
model = fit_logit_model(data, data_info, model_type="linear")
saveRDS(model, file=produces)