'

The file "figure1_mortality.r" creates two figures, plotting
expropriation risk and log GDP against settler mortality respectively.
It accounts for campaign/laborer indicators and distinguishes between
countries with original data and countries with conjectured mortality data.

'


rm(list=ls())

source("project_paths.r")

library(foreign)


data <- read.csv(paste(PATH_OUT_DATA, "ajrcomment_all.csv", sep = "/"))


## Rebuilding of Figures 2A and 2B

datacamp <- data[grep(1,data$campaign),] #mortality from campaign

data2 <- data[grep(0,data$campaign),]

databar <- data2[grep(0,data2$slave),] #mortality from barrack
datalab <- data2[grep(1,data2$slave),] #mortality from laborer

## Plot that data first against risk
datacamphome <- datacamp[grep(1,datacamp$source0),]
datacampcon <- datacamp[grep(0,datacamp$source0),]

databarhome <- databar[grep(1,databar$source0),]
databarcon <- databar[grep(0,databar$source0),]

datalabhome <- datalab[grep(1,datalab$source0),]
datalabcon <- datalab[grep(0,datalab$source0),]

png(filename=paste(PATH_OUT_FIGURES, "risk_mort.png", sep="/"))
plot(
     datacamphome$logmort0, datacamphome$risk, pch=15,
     xlab="Logarithm of settler mortality", ylab="Expropriation risk",
     ylim=c(3,10), xlim=c(2,8), bty="L"
)
lines(datacampcon$logmort0, datacampcon$risk, pch=22, type="p")

lines(databarhome$logmort0, databarhome$risk, pch=16, type="p")
lines(databarcon$logmort0, databarcon$risk, pch=21, type="p")

lines(datalabhome$logmort0, datalabhome$risk, pch=17, type="p")
lines(datalabcon$logmort0, datalabcon$risk, pch=2, type="p")

dev.off()


plot.new()
png(filename=paste(PATH_OUT_FIGURES, "gdp_mort.png", sep="/"))
## Plot that data against loggdp
plot(
     datacamphome$logmort0, datacamphome$loggdp, pch=15,
     xlab="Logarithm of settler mortality", ylab="Logarithm of GDP per capita",
     ylim=c(6,10.5), xlim=c(2,8), bty="L"
)
lines(datacampcon$logmort0, datacampcon$loggdp, pch=22, type="p")

lines(databarhome$logmort0, databarhome$loggdp, pch=16, type="p")
lines(databarcon$logmort0, databarcon$loggdp, pch=21, type="p")

lines(datalabhome$logmort0, datalabhome$loggdp, pch=17, type="p")
lines(datalabcon$logmort0, datalabcon$loggdp, pch=2, type="p")

# coordinates of legend box using plot units

dev.off()
