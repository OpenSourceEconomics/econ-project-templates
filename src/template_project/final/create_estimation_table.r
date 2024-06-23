# ======================================================================================
# Get config from pytask
# ======================================================================================

args <- commandArgs(trailingOnly = TRUE)
path_to_yaml <- args[length(args)]
config <- yaml::yaml.load_file(path_to_yaml)

# ======================================================================================
# Main
# ======================================================================================

model <- readRDS(config[["model"]])
table <- xtable::xtable(model)
print(table, file = config[["produces"]], compress = FALSE)
