##############################################################################################
#' @title Resolves duplicate lab analysis results - multiple results for the same sample name

#' @author
#' Geoffrey L. House \email{housegl@battelleecology.org} \cr

#' @description This first runs the removeDups function in the neonOSbase package to remove duplicates
#' when possible, and to flag those that are not exactly identical. Then for any remaining, flagged
#' duplicates, this includes multiple user-selectable options for resolving duplicate lab
#' samples: 1) keeping the most recent measurement for each duplicate sample, 2) NEEDS DEVELOPMENT -
#' keeping samples only most similar to other measured values for the same location and sampling time.
#'
#' @importFrom utils read.csv
#' @importFrom neonOSbase removeDups

#' @param filepath The path to the directory containing the lab data to de-duplicate [string]
#' @param tableName The name of the table in the file path directory to de-duplicate [string]
#' @param pubTableName The name of the publication table to use to define the pub. table to use to define the primary keys used for de-duping [string]
#' @param variablesFile a pub notebook read-in - temporary [data.frame]

#' @return This function returns the de-duplicated version of the tableName as a data.frame, and also
#' overwrites the original version of the file with this de-duplicated version for downstream processing.

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

#' @keywords surface water, streams, rivers, reaeration, gas transfer velocity, schmidt number

#' @examples
#' def.data.resolveDupes(filepath = "GitHub/NEON-reaeration/filesToStack20190/stackedFiles", tableName = "externalLabDataSalt")

# changelog and author contributions / copyrights
#   Geoffrey L. House (2020-04-10)
#     original creation
##############################################################################################
def.data.resolveDupes <- function(
  filepath = "",
  tableName = "",
  pubTableName = "",
  variablesFile = ""
) {

  # ## For testing only
  # filepath = "~/GitHub/NEON-reaeration/filesToStack20190/stackedFiles"
  # tableName = "externalLabDataSalt"
  # # Download the pub notebook
  # variablesFile <- restR::get.pub.workbook(DPID = "DP1.20190.001", stack = "prod", table = "rea_externalLabDataSalt_pub")


  if(filepath == ""){
    stop("No entry provided for 'filepath' within def.data.resolveDupes. Exiting.")
  }

  if(tableName == ""){
    stop("No entry provided for 'tableName' within def.data.resolveDupes. Exiting.")
  }

  if(pubTableName == ""){
    stop("No entry provided for 'pubTableName' within def.data.resolveDupes. Exiting.")
  }

  if(class(variablesFile) == "character"){
    stop("No entry provided for 'variablesFile' within def.data.resolveDupes. Exiting.")
  }

  if (dir.exists(filepath)) {
    allFiles <- list.files(filepath)

    if (sum(grepl(tableName, allFiles)) == 1){

      extFile <- allFiles[grepl(tableName, allFiles)]
      externalData <- read.csv(file.path(filepath, extFile), stringsAsFactors = F)

      ## Re-try after re-transitions - fields that are missing in the inputData compared to the pub notebook.
      missingFields <- setdiff(variablesFile$fieldName, names(externalData))

      #print("the missing fields are:")
      #print(missingFields)

      # Fails initially with
      # Error in neonOSbase::removeDups(data = inputData, variables = pubNotebook,  :
      # Field names in data do not match variables file.
      # test <- neonOSbase::removeDups(data = inputData, variables = pubNotebook, table = "rea_externalLabDataSalt_pub")

      # remove the rows in the pub notebook that contain the field names missing from the inputData.
      variablesFile_dropMissingInData <- variablesFile[!(variablesFile$fieldName %in% missingFields),]

      # Need to remove the publication date column from the inputData so that all the fields match with the pub notebook.
      externalData_v2 <- externalData[,names(externalData) != "publicationDate"]

      dataAfterDupeFlag <- neonOSbase::removeDups(data = externalData_v2, variables = variablesFile_dropMissingInData, table = pubTableName)

      numDupesRemaining <- sum(dataAfterDupeFlag$duplicateRecordQF == 2)

      # If there are duplicates still, decide how to handle them.
      if(numDupesRemaining > 1){

        # Keep the most recent measurement (assumes it's a re-run with
        # an accurate measurement value)
        ## ============
        # Make a new column of the analysis date and sort the whole d.f. descending based on that.
        dataAfterDupeFlag$analysisDate_forSort <- as.POSIXct(dataAfterDupeFlag$analysisDate)
        dataAfterDupeFlag_dateSorted <- dataAfterDupeFlag[order(dataAfterDupeFlag$analysisDate_forSort, decreasing = TRUE),]
        # Now remove the duplicates this will remove all but the most recent measurement (because the d.f. is sorted by analysis date)
        externalData_noDupes <- dataAfterDupeFlag_dateSorted[!duplicated(dataAfterDupeFlag_dateSorted$saltSampleID),]
        ## =============


        # Overwrite the raw data with a version that doesn't have duplicate samples.
        write.csv(externalData_noDupes, file = file.path(filepath, extFile))

        print(paste0((numDupesRemaining / 2), " additional duplicate sample names removed by analysis date sorting"))

        return(externalData_noDupes)

      } else{
        write.csv(dataAfterDupeFlag, file = file.path(filepath, extFile))

        return(dataAfterDupeFlag)
      }

    } else{
      stop(paste0("Error, the table named: ", tableName, " does not exist (or more than one matching file name) in file path: ", filepath, " (attempted access from function def.data.resolveDupes.R) Exiting."))
    }
  }
  else {
    stop(paste0("Error, the file path: ", filepath, " does not exist (attempted access from function def.data.resolveDupes.R) Exiting."))
  }
}
