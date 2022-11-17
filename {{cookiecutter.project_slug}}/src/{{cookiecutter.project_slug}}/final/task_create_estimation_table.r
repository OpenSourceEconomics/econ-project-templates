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

model = readRDS(depends_on[["model"]])
table = xtable::xtable(model)
print(table, file=produces, compress=FALSE)