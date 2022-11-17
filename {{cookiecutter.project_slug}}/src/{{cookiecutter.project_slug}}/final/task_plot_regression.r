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

source(file.path(SRC, "final", "plot.R"))  

data = read.csv(depends_on[["data"]])
data_info = yaml::yaml.load_file(depends_on[["data_info"]])
predictions = read.csv(depends_on[["predictions"]])

fig = plot_regression_by_age(data, data_info, predictions, group)
plotly::export(fig, produces)
