
library(devtools)
library(roxygen2)

setwd("~/GitHub/NEON-reaeration")
#setwd("C:/Users/Kaelin/Documents/GitHub/biogeochemistryIPT/reaeration/Science Only/rCodeForRelease")
#create("reaRate")
#install_github("NEONScience/NEON-utilities/neonUtilities", force = T)

# Updates the documentation/namespace
# devtools::document(pkg = "reaRate")

install("reaRate")
library(reaRate)

dataDir <- "C:/Users/kcawley/Downloads/NEON_reaeration.zip"
#dataDir <- "C:/Users/Kaelin/Downloads/NEON_reaeration.zip"
#dataDir <- "C:/Users/Kcawley/Desktop/NEON_reaeration.zip"

#For use with the API functionality
dataDir <- "API"
site <- "HOPB" # Curr has Reconcile duplicate external lab sample(s): HOPB.19.20191015.TCR, HOPB.14.20191015.TCR
site <- "POSE" # Curr has Reconcile duplicate external lab sample(s): POSE.15.20190617.TCR from def.format.Q
site <- "MCDI" # Curr runs with 18 warnings like for LEWI
site <- "LEWI" # Curr runs with warning Warning messages:
# 1: In min(backgroundDataSalt$collectDate[backgroundDataSalt$siteID ==  :
#                         no non-missing arguments, returning NA
# 2: In min(backgroundDataSalt$collectDate[backgroundDataSalt$siteID ==  :
#                         no non-missing arguments, returning NA
site <- "GUIL" # Curr has Reconcile duplicate external lab sample(s): GUIL.08.20190807.TCR, GUIL.06.20191010.TCR from def.format.Q
# site <- "FLNT"
site <- "BLDE" # Curr has Reconcile duplicate external lab sample(s): BLDE.15.20190606.TCR, BLDE.02.20190606.TCR, BLDE.15.20190820.TCR, BLDE.14.20190820.TCR, BLDE.16.20190820.TCR
site <- "SYCA" # Curr has Reconcile duplicate external lab sample(s): SYCA.20.20190430.TCR, SYCA.11.20190430.TCR
site <- "MART" # Curr has Error in grepl(repRegex, rea_externalLabDataSalt$saltSampleID) : invalid 'pattern' argument
site <- "OKSR" # Curr has Reconcile duplicate external lab sample(s): OKSR.20.20190712.TCR, OKSR.03.20190712.TCR
site <- "WALK" # Works well!
site <- "CUPE" # Curr has Reconcile duplicate external lab sample(s): CUPE.05.20190801.TCR
site <- "KING" # Works with 6 NA warnings; may have just salt slug drop.
site <- "LECO" # Curr has Reconcile duplicate external lab sample(s): LECO.10.20190718.TCR, LECO.00.20190718.TCR
site <- "MAYF" # Curr has Reconcile duplicate external lab sample(s): MAYF.18.20181204.TCR, MAYF.01.20181204.TCR, MAYF.14.20181204.TCR, MAYF.03.20181204.TCR, MAYF.04.20181204.TCR, MAYF.16.20181204.TCR, MAYF.13.20181204.TCR, MAYF.B4.20181204.TCR, MAYF.B3.20181204.TCR, MAYF.07.20181204.TCR, MAYF.10.20181204.TCR, MAYF.B2.20181204.TCR, MAYF.09.20181204.TCR, MAYF.00.20181204.TCR, MAYF.11.20181204.TCR, MAYF.15.20181204.TCR, MAYF.02.20181204.TCR, MAYF.12.20181204.TCR, MAYF.20.20181204.TCR, MAYF.08.20181204.TCR, MAYF.05.20181204.TCR, MAYF.17.20181204.TCR, MAYF.19.20181204.TCR, MAYF.B1.20181204.TCR
#site <- "TOMB"
# site <- "BLWA"
# site <- "ARIK"
site <- "PRIN" # Works well! May have jus salt slug drop.
site <- "BLUE" # Curr has Error in file(file, "rt") : cannot open the connection
site <- "COMO" # Curr has Reconcile duplicate external lab sample(s): COMO.B1.20190618.TCR, COMO.B3.20190618.TCR, COMO.B2.20190618.TCR, COMO.00.20190618.TCR, COMO.B4.20190618.TCR
site <- "WLOU" # Curr has Reconcile duplicate external lab sample(s): WLOU.15.20190619.TCR
site <- "REDB" # Curr has Reconcile duplicate external lab sample(s): REDB.14.20190703.TCR, REDB.16.20190703.TCR
site <- "MCRA" # Works with 2 NA warnings. Hard to pick points.
site <- "TECR" # Curr has Reconcile duplicate external lab sample(s): TECR.16.20181206.TCR
site <- "BIGC" # Curr has Reconcile duplicate external lab sample(s): BIGC.01.20190813.TCR, BIGC.09.20190813.TCR
site <- "CARI" # Works well! Looks like just has salt slug drop. Very steep peak at station 1, much smoother at station 4
#site <- "all"

# reaDownloaded is a 2-element character list that unpacks into the filepath and the qfilepath to
# use with def.format.reaeration to access the correct files after download.
reaDownloaded <- def.data.download(dataDir = dataDir, site = site, fieldQ = TRUE)

# The fieldQ also downloads the stream discharge data.
reaFormatted <- def.format.reaeration(dataDir = dataDir, site = site, fieldQ = TRUE, filepath = reaDownloaded[1], qFilepath = reaDownloaded[2])
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

par(mfrow=c(2,3))
plot(outputDF$meanQ,outputDF$travelTime, col = "blue", type = "p", pch = 16, cex = 4, cex.axis = 1.25)
plot(outputDF$meanQ,outputDF$lossRateSF6, col = "blue", type = "p", pch = 16, cex = 4, cex.axis = 1.25)
plot(outputDF$meanQ,outputDF$k600, col = "blue", type = "p", pch = 16, cex = 4, cex.axis = 1.25)
plot(outputDF$meanQ,outputDF$velocity, col = "blue", type = "p", pch = 16, cex = 4, cex.axis = 1.25)
plot(outputDF$meanQ,outputDF$meanDepth, col = "blue", type = "p", pch = 16, cex = 4, cex.axis = 1.25)
plot(outputDF$meanQ,outputDF$meanWettedWidth, col = "blue", type = "p", pch = 16, cex = 4, cex.axis = 1.25)

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
