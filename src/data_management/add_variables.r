' 
The file "add_new_data.r" adds the new data from AJR (2005) to the
dataset as described in Albouy (2012).

'

source("src/library/R/project_paths.r")

library(foreign, lib=PATH_OUT_LIBRARY_R)

data <- read.dta(paste(PATH_IN_DATA, "ajrcomment.dta", sep="/"))

'Initilize new variables'
data["logmort0_new"] = data$logmort0
data["campaign_new"] = data$campaign
data["source0_new"] = data$source0

'Adjust new variables'
data[grep("HKG", data$shortnam),]$logmort0_new = log(285)
data[grep("BHS", data$shortnam),]$logmort0_new = log(189)
data[grep("AUS", data$shortnam),]$logmort0_new = log(14.1)
data[grep("HND", data$shortnam),]$logmort0_new = log(95.2)
data[grep("GUY", data$shortnam),]$logmort0_new = log(84)
data[grep("SGP", data$shortnam),]$logmort0_new = log(20)
data[grep("TTO", data$shortnam),]$logmort0_new = log(106.3)
data[grep("SLE", data$shortnam),]$logmort0_new = log(350)

data_new[grep("HKG", data_new$shortnam),]$source0 = 1
data_new[grep("BHS", data_new$shortnam),]$source0 = 1
data_new[grep("AUS", data_new$shortnam),]$source0 = 1
data_new[grep("HND", data_new$shortnam),]$source0 = 1
data_new[grep("GUY", data_new$shortnam),]$source0 = 1
data_new[grep("SGP", data_new$shortnam),]$source0 = 1
data_new[grep("TTO", data_new$shortnam),]$source0 = 1
data_new[grep("SLE", data_new$shortnam),]$source0 = 1

data[grep("HND", data$shortnam),]$campaign_new = 0

write.table(data, file = paste(PATH_OUT_DATA, "ajrcomment_all.txt", sep="/"))