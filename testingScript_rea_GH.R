
library(devtools)
library(roxygen2)

setwd("~/GitHub/NEON-reaeration")
#setwd("C:/Users/Kaelin/Documents/GitHub/biogeochemistryIPT/reaeration/Science Only/rCodeForRelease")
#create("reaRate")
#install_github("NEONScience/NEON-utilities/neonUtilities", force = T)
install("reaRate")
library(reaRate)

dataDir <- "C:/Users/kcawley/Downloads/NEON_reaeration.zip"
#dataDir <- "C:/Users/Kaelin/Downloads/NEON_reaeration.zip"
#dataDir <- "C:/Users/Kcawley/Desktop/NEON_reaeration.zip"

#For use with the API functionality
dataDir <- "API"
site <- "POSE" # Curr has Reconcile duplicate external lab sample(s): POSE.15.20190617.TCR from def.format.Q
site <- "MCDI"
site <- "LEWI" # Curr runs with warning Warning messages:
# 1: In min(backgroundDataSalt$collectDate[backgroundDataSalt$siteID ==  :
#                         no non-missing arguments, returning NA
# 2: In min(backgroundDataSalt$collectDate[backgroundDataSalt$siteID ==  :
#                         no non-missing arguments, returning NA
site <- "GUIL" # Curr has Reconcile duplicate external lab sample(s): GUIL.08.20190807.TCR, GUIL.06.20191010.TCR from def.format.Q
#site <- "WALK"
site <- "BLDE" # Curr has Reconcile duplicate external lab sample(s): BLDE.15.20190606.TCR, BLDE.02.20190606.TCR, BLDE.15.20190820.TCR, BLDE.14.20190820.TCR, BLDE.16.20190820.TCR
site <- "SYCA" # Curr has Reconcile duplicate external lab sample(s): SYCA.20.20190430.TCR, SYCA.11.20190430.TCR
site <- "MART" # Curr has Error in grepl(repRegex, rea_externalLabDataSalt$saltSampleID) : invalid 'pattern' argument
site <- "OKSR" # Curr has Reconcile duplicate external lab sample(s): OKSR.20.20190712.TCR, OKSR.03.20190712.TCR
site <- "WALK" # Works well!
#site <- "all"

# The fieldQ also downloads the stream discharge data.
reaFormatted <- def.format.reaeration(dataDir = dataDir, site = site, fieldQ = TRUE)
#write.csv(reaFormatted, "C:/Users/kcawley/Documents/GitHub/biogeochemistryIPT/reaeration/Science Only/rCodeForRelease/reaRate/inst/extdata/reaTestData.csv", row.names = F)
#write.csv(condDataS1, "C:/Users/kcawley/Documents/GitHub/biogeochemistryIPT/reaeration/Science Only/rCodeForRelease/reaRate/inst/extdata/condDataS1.csv", row.names = F)

#reaRatesCalc <- def.calc.reaeration(inputFile = reaFormatted, loggerFile = , dataDir = dataDir, plot = TRUE)
# reaRatesCalc <- def.calc.reaeration(inputFile = reaFormatted,
#                                     dataDir = "C:/Users/kcawley/Documents/GitHub/NEON-reaeration/filesToStack20190/stackedFiles/",
#                                     loggerFile = "rea_conductivityFieldData.csv",
#                                     plot = TRUE,
#                                     savePlotPath = "H:/Operations Optimization/savedPlots")

reaRatesCalc <- def.calc.reaeration(inputFile = reaFormatted,
                                    dataDir = "~/GitHub/NEON-reaeration/filesToStack20190/stackedFiles/",
                                    loggerFile = "rea_conductivityFieldData.csv",
                                    plot = TRUE,
                                    savePlotPath = "/Users/housegl/Box/GH_reaeration")

outputDF <- reaRatesCalc$outputDF
inputFile <- reaRatesCalc$inputFile

plot(outputDF$meanQ,outputDF$travelTime, col = "blue", type = "p", pch = 16)
plot(outputDF$meanQ,outputDF$lossRateSF6, col = "blue", type = "p", pch = 16)
plot(outputDF$meanQ,outputDF$k600, col = "blue", type = "p", pch = 16)
plot(outputDF$meanQ,outputDF$velocity, col = "blue", type = "p", pch = 16)
plot(outputDF$meanQ,outputDF$meanDepth, col = "blue", type = "p", pch = 16)
plot(outputDF$meanQ,outputDF$meanWettedWidth, col = "blue", type = "p", pch = 16)

#Calculate travel time for BLUE for engineering design analysis
dataDir <- "API"
site <- "BLUE"
reaFormatted <- def.format.reaeration(dataDir = dataDir, site = site, fieldQ = TRUE)

setwd("C:/Users/kcawley/Documents/GitHub/NEON-reaeration/reaRate")
#setwd("C:/Users/Kaelin/Documents/GitHub/biogeochemistryIPT/reaeration/Science Only/rCodeForRelease/reaRate")
document()
#devtools::use_data(reaFormatted, reaFormatted)
#devtools::use_data(condDataS1, condDataS1)
devtools::check()
