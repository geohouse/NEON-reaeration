# Tabulate number of SF6 samples collected from Jan 2018 on that
# have values > 3 or are 0 or NA

library(lubridate)
library(dplyr)

dirs <- list.dirs(path = "/Users/housegl/GitHub/NEON-reaeration", recursive = FALSE)

# Exclude the 'reaRate' dir
dirs_2 <- dirs[which(!grepl(pattern = "reaRate", x = dirs))]

# Exclude the hidden '.git' dir
dirs_3 <- dirs_2[which(!grepl(pattern = "git", x = dirs_2))]

extractMeasures <- function(dir){

  try(inputData <- readr::read_csv(file.path(dir, "/filesToStack20190/stackedFiles/rea_externalLabDataGas.csv")))

  try(inputData$samplingYears <- lubridate::year(inputData$startDate))

  try(subsetData <- inputData %>% filter(samplingYears == 2018 & (gasTracerConcentration >= 3 | gasTracerConcentration == 0 | is.na(gasTracerConcentration))))

  if(exists("subsetData")){
    return(subsetData)
  } else{
    return(NULL)
  }
  #print(test)

}

outputHolder <- sapply(X = dirs_3, FUN = extractMeasures)

outputHolder_2 <- dplyr::bind_rows(outputHolder)

tabulatedOutput <- outputHolder_2 %>% group_by(siteID) %>% summarise(sumSamples = n())

readr::write_csv(outputHolder_2, path = "/Users/housegl/Documents/REA/SF6_outlierSampleTabulations/SF6_outlierSamplesCollLaterThan_Jan2018.csv")

readr::write_csv(tabulatedOutput, path = "/Users/housegl/Documents/REA/SF6_outlierSampleTabulations/SF6_outlierSamplesCollLaterThan_Jan2018_countsPerSite.csv")

print(paste("The total number of outlier samples is:", sum(tabulatedOutput$sumSamples)))
