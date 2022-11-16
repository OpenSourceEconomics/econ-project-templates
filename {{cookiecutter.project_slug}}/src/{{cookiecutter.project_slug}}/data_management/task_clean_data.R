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

source(file.path(config[["SRC"]], "data_management", "clean_data.R"))  

data_info = yaml::yaml.load_file(depends_on[["data_info"]])
data = read.csv(data_info[["data"]])
data = clean_data(data, data_info)
write.csv(data, file=produces, col.names=TRUE)