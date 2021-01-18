'
The file "add_new_data.r" adds the new data from AJR (2005) to the
dataset as described in Albouy (2012).

'

args = commandArgs(trailingOnly=TRUE)

library(foreign)

data <- read.dta(args[1])

# Initilize new variables
data["logmort0_new"] = data$logmort0
data["campaign_new"] = data$campaign
data["source0_new"] = data$source0

# Adjust new variables
data[grep("HKG", data$shortnam),]$logmort0_new = log(285)
data[grep("BHS", data$shortnam),]$logmort0_new = log(189)
data[grep("AUS", data$shortnam),]$logmort0_new = log(14.1)
data[grep("HND", data$shortnam),]$logmort0_new = log(95.2)
data[grep("GUY", data$shortnam),]$logmort0_new = log(84)
data[grep("SGP", data$shortnam),]$logmort0_new = log(20)
data[grep("TTO", data$shortnam),]$logmort0_new = log(106.3)
data[grep("SLE", data$shortnam),]$logmort0_new = log(350)

data[grep("HKG", data$shortnam),]$source0_new = 1
data[grep("BHS", data$shortnam),]$source0_new = 1
data[grep("AUS", data$shortnam),]$source0_new = 1
data[grep("HND", data$shortnam),]$source0_new = 1
data[grep("GUY", data$shortnam),]$source0_new = 1
data[grep("SGP", data$shortnam),]$source0_new = 1
data[grep("TTO", data$shortnam),]$source0_new = 1
data[grep("SLE", data$shortnam),]$source0_new = 1

data[grep("HND", data$shortnam),]$campaign_new = 0

write.csv(data, file=args[2])
