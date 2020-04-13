##############################################################################################
#' @title Resolves duplicate lab analysis results - multiple results for the same sample name

#' @author
#' Geoffrey L. House \email{housegl@battelleecology.org} \cr

#' @description This includes multiple user-selectable options for resolving duplicate lab
#' samples: 1) keeping the most recent measurement for each duplicate sample.
#'
#' @importFrom utils read.csv

#' @param filepath The path to the directory containing the lab data to de-duplicate [string]
#' @param tableName The name of the table in the file path directory to de-duplicate [string]
#' @param fieldQ specifies whether or no field discharge data should be included [boolean]
#' @param filepath specifies the path to the downloaded and stacked rea data tables (DP1.20190.001) [string]
#' @param qFilepath specifies the path to the downloaded and stacked discharge data tables (DP1.20048.001) [string]

#' @return This function returns one data frame formatted for use with def.calc.reaeration.R

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
  tableName = ""
) {

  ## For testing only
  filepath = "~/GitHub/NEON-reaeration/filesToStack20190/stackedFiles"
  tableName = "externalLabDataSalt"

  if(filepath == ""){
    stop("No entry provided for 'filepath' within def.data.resolveDupes. Exiting.")
  }

  if(tableName == ""){
    stop("No entry provided for 'tableName' within def.data.resolveDupes. Exiting.")
  }

  if (dir.exists(filepath)) {
    allFiles <- list.files(filepath)

    if (sum(grepl(tableName, allFiles)) == 1){

      extFile <- allFiles[grepl(tableName, allFiles)]
      externalData <- read.csv(file.path(filepath, extFile), stringsAsFactors = F)

      dupSampleNames <- unique(externalData$saltSampleID[duplicated(externalData$saltSampleID)])

      # If there are duplicates, keep the most recent measurement (assumes it's a re-run with
      # an accurate measurement value)
      if(length(dupSampleNames) > 1){

        # Make a new column of the analysis date and sort the whole d.f. descending based on that.
        externalData$analysisDate_forSort <- as.POSIXct(externalData$analysisDate)
        externalData_dateSorted <- externalData[order(externalData$analysisDate_forSort, decreasing = TRUE),]
        # Now remove the duplicates this will remove all but the most recent measurement (because the d.f. is sorted by analysis date)
        externalData_noDupes <- externalData_dateSorted[!duplicated(externalData_dateSorted$saltSampleID),]

        # Overwrite the raw data with a version that doesn't have duplicate samples.
        write.csv(externalData_noDupes, file = file.path(filepath, extFile), append = FALSE)

        print(paste0(length(dupSampleNames), " duplicate sample names removed"))

      }
      print("Test")

    } else{
      stop(paste0("Error, the table named: ", tableName, " does not exist (or more than one matching file name) in file path: ", filepath, " (attempted access from function def.data.resolveDupes.R) Exiting."))
    }
  }
  else {
    stop(paste0("Error, the file path: ", filepath, " does not exist (attempted access from function def.data.resolveDupes.R) Exiting."))
  }
}

def.data.resolveDupes()
