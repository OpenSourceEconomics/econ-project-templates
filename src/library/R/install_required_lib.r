'
The file "install_required_lib.r" checks whether a library
can be found in "PATH_OUT_LIBRARY_R" and installs it if this
fails. In case of failure, we require an Internet connection.
'


source("src/library/R/project_paths.r")

cran <- "http://cran.rstudio.com/"


lib_name <- commandArgs(trailingOnly = TRUE)

.libPaths(PATH_OUT_LIBRARY_R)

tryCatch({
    library(lib_name, lib=PATH_OUT_LIBRARY_R, character.only=TRUE)
}, error = function(e) {
    install.packages(lib_name, lib=PATH_OUT_LIBRARY_R, repos=cran)
    library(lib_name, lib=PATH_OUT_LIBRARY_R, character.only=TRUE)
})
