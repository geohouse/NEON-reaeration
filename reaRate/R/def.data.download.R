##############################################################################################
#' @title Formats reaeration data for rate calculations

#' @author
#' Kaelin M. Cawley \email{kcawley@battelleecology.org} \cr

#' @description This function downloads and stacks the data by table in preparation
#' for other downstream functions
#' @importFrom neonUtilities stackByTable
#' @importFrom neonUtilities zipsByProduct
#' @importFrom utils read.csv

#' @param dataDir User identifies the directory that contains the zipped data or sets to
#' "API" to pull data from the NEON API [string]
#' @param site User identifies the site(s), defaults to "all" [string]
#' @param fieldQ specifies whether or not field discharge data should be included [boolean]

#' @return This function returns one data frame formatted for use with def.format.reaeration.R

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

#' @keywords surface water, streams, rivers, reaeration, gas transfer velocity, schmidt number

#' @examples
#' #where the data .zip file is in the working directory and has the default name,
#' #reaFormatted <- def.format.reaeration()
#' #where the data.zip file is in the downloads folder and has default name,
#' #reaFormatted <-
#' #def.format.reaeration(dataDir = path.expand("~/Downloads/NEON_reaeration.zip"))
#' #where the data.zip file is in the downloads folder and has a specified name,
#' #reaFormatted <- def.format.reaeration(dataDir = path.expand("~/Downloads/non-standard-name.zip"))
#' #Using the example data in this package
#' #dataDirectory <- paste(path.package("reaRate"),"inst\\extdata", sep = "\\")
#' #reaFormatted <- def.format.reaeration(dataDir = dataDirectory)

#' @seealso def.calc.tracerTime.R for calculating the stream travel time,
#' def.plot.reaQcurve.R for plotting reaeration rate versus stream flow

#' @export

# changelog and author contributions / copyrights
#   Kaelin M. Cawley (2017-10-30)
#     original creation
#   Kaelin M. Cawley (2018-05-03)
#     added the option of getting data from the API rather than a file download
#   Geoffrey L. House (2020-04-09)
#     created new def.data.download.R function and file from existing code. This splits
#     the data download and data processing tasks.
##############################################################################################
def.data.download <- function(
  dataDir = paste0(getwd(),"/NEON_reaeration.zip"),
  site = "all",
  fieldQ = TRUE
) {

  reaDPID <- "DP1.20190.001"
  qDPID <- "DP1.20048.001"
  folder <- FALSE
  #Pull files from the API to stack
  if(dataDir == "API"&&!dir.exists(paste(getwd(), "/filesToStack", substr(reaDPID, 5, 9), sep=""))){
    dataFromAPI <- zipsByProduct(reaDPID,site,package="expanded",check.size=TRUE)
    if(fieldQ){
      fieldQAPI <- zipsByProduct(qDPID,site,package="basic",check.size=TRUE)
    }
  }

  if(dataDir == "API"){
    filepath <- paste(getwd(), "/filesToStack", substr(reaDPID, 5, 9), sep="")
    qFilepath <- paste(getwd(), "/filesToStack", substr(qDPID, 5, 9), sep="")
    folder <- TRUE
  } else{
    filepath = dataDir
    qFilepath = dataDir
  }

  #Stack field and external lab data
  if(!dir.exists(paste(gsub("\\.zip","",filepath), "/stackedFiles", sep = "/"))&&
     file.exists(filepath)){
    stackByTable(dpID=reaDPID,filepath=filepath,folder=folder)
    filepath <- paste(gsub("\\.zip","",filepath), "stackedFiles", sep = "/")
  }

  #Stack discharge files if needed
  if(!dir.exists(paste(gsub("\\.zip","",qFilepath), "/stackedFiles", sep = "/"))&&
     file.exists(qFilepath)&&
     fieldQ){
    stackByTable(dpID=qDPID,filepath=qFilepath,folder=TRUE)
    qFilepath <- paste(gsub("\\.zip","",qFilepath), "stackedFiles", sep = "/")
  }else if(dir.exists(paste(gsub("\\.zip","",filepath), "/stackedFiles", sep = "/"))){
    filepath <- paste(gsub("\\.zip","",filepath), "stackedFiles", sep = "/")
    if(fieldQ){
      qFilepath <- paste(gsub("\\.zip","",qFilepath), "stackedFiles", sep = "/")
    }
  }

  return(c(filepath, qFilepath))
}

#   #Read in stacked files
#   if(dir.exists(filepath)){
#     #Read in stacked data
#     rea_backgroundFieldCondData <- read.csv(
#       paste(filepath,"rea_backgroundFieldCondData.csv", sep = "/"),
#       stringsAsFactors = F)
#
#     try(rea_backgroundFieldSaltData <- read.csv(
#       paste(filepath, "rea_backgroundFieldSaltData.csv", sep = "/"),
#       stringsAsFactors = F))
#
#     rea_fieldData <- read.csv(
#       paste(filepath,"rea_fieldData.csv", sep = "/"),
#       stringsAsFactors = F)
#
#     try(rea_plateauMeasurementFieldData <- read.csv(
#       paste(filepath,"rea_plateauMeasurementFieldData.csv", sep = "/"),
#       stringsAsFactors = F))
#
#     # #This isn't used anywhere else
#     # rea_plateauSampleFieldData <- read.csv(
#     #   paste(filepath,"rea_plateauSampleFieldData.csv", sep = "/"),
#     #   stringsAsFactors = F)
#
#     try(rea_externalLabDataSalt <- read.csv(
#       paste(filepath,"rea_externalLabDataSalt.csv", sep = "/"),
#       stringsAsFactors = F))
#
#     try(rea_externalLabDataGas <- read.csv(
#       paste(filepath,"rea_externalLabDataGas.csv", sep = "/"),
#       stringsAsFactors = F))
#
#     rea_widthFieldData <- read.csv(
#       paste(filepath,"rea_widthFieldData.csv", sep = "/"),
#       stringsAsFactors = F)
#
#     # #This isn't used anywhere else
#     # rea_conductivityFieldData <- read.csv(
#     #   paste(filepath,"rea_conductivityFieldData.csv", sep = "/"),
#     #   stringsAsFactors = F)
#   } else{
#     stop("Error, stacked files could not be read in reaeration data")
#   }
#
#   #Read in stacked field discharge data
#   if(fieldQ&&dir.exists(qFilepath)){
#     #Read in stacked data
#     dsc_fieldData <- read.csv(
#       paste(qFilepath,"dsc_fieldData.csv", sep = "/"),
#       stringsAsFactors = F)
#     dsc_fieldData$eventID <- paste(dsc_fieldData$siteID,gsub("-","",substr(dsc_fieldData$startDate,1,10)),sep = ".")
#   } else{
#     stop("Error, stacked discharge files could not be read in reaeration data")
#   }
#
#   rea_fieldData$namedLocation <- NULL #So that merge goes smoothly
#
#   #Merge the rea_backgroundFieldSaltData and rea_fieldData tables
#   if(exists("rea_backgroundFieldSaltData")){
#     loggerSiteData <- merge(rea_backgroundFieldSaltData,
#                             rea_fieldData,
#                             by = c('siteID', 'collectDate'),
#                             all = T)
#   }else{
#     loggerSiteData <- merge(rea_backgroundFieldCondData,
#                             rea_fieldData,
#                             by = c('siteID', 'collectDate'),
#                             all = T)
#   }
#
#   #Create input file for reaeration calculations
#   outputDFNames <- c(
#     'siteID',
#     'namedLocation', #Station at this point
#     'collectDate',
#     'stationToInjectionDistance',
#     'injectionType',
#     'slugTracerMass',
#     'slugPourTime',
#     'dripStartTime',
#     'backgroundSaltConc',
#     'plateauSaltConc',
#     'corrPlatSaltConc',
#     'plateauGasConc',
#     'wettedWidth',
#     'waterTemp',
#     'hoboSampleID',
#     'fieldDischarge',
#     'eventID'
#   )
#   outputDF <- data.frame(matrix(data=NA, ncol=length(outputDFNames), nrow=length(loggerSiteData$siteID)))
#   names(outputDF) <- outputDFNames
#
#   #Fill in the fields from the loggerSiteData table
#   for(i in seq(along = names(outputDF))){
#     if(names(outputDF)[i] %in% names(loggerSiteData)){
#       outputDF[,i] <- loggerSiteData[,which(names(loggerSiteData) == names(outputDF)[i])]
#     }
#   }
#
#   #Eliminated this so that the calc function can differentiate between NaBr and model
#   #Change to more generic injection types
#   #outputDF$injectionType[outputDF$injectionType == "NaCl"] <- "constant"
#   #outputDF$injectionType[outputDF$injectionType == "NaBr"|outputDF$injectionType == "model"] <- "slug"
#
#   outputDF$eventID <- paste0(outputDF$siteID, ".", substr(outputDF$collectDate,1,4), substr(outputDF$collectDate,6,7), substr(outputDF$collectDate,9,10))
#
#   #Remove data for model type injections
#   outputDF <- outputDF[outputDF$injectionType!="model"&!is.na(outputDF$injectionType),]
#
#   return(outputDF)
# }
