
library(readr)
library(devtools)
library(roxygen2)
library(dplyr)

# Install the neonOSbase package that contains the removeDups() function.
install("/Users/housegl/GitHub/NEON-OS-data-processing/neonOSbase")
library(neonOSbase)


# Download the MAYF data if needed and stack
# zipsByProduct(dpID = "DP1.20190.001", site = "MAYF", startdate = "2018-11", enddate = "2019-09", package = "expanded", savepath = "~/Downloads")
#stackByTable(filepath = "~/Downloads/filesToStack20190/")
inputData <- readr::read_csv(file = "/Users/housegl/Downloads/filesToStack20190/stackedFiles/rea_externalLabDataSalt.csv")


# Download the pub notebook
pubNotebook <- restR::get.pub.workbook(DPID = "DP1.20190.001", stack = "prod", table = "rea_externalLabDataSalt_pub")


missingFields <- setdiff(pubNotebook$fieldName, names(inputData))

print("the missing fields are:")
print(missingFields)

# Fails initially with
# Error in neonOSbase::removeDups(data = inputData, variables = pubNotebook,  :
# Field names in data do not match variables file.
# test <- neonOSbase::removeDups(data = inputData, variables = pubNotebook, table = "rea_externalLabDataSalt_pub")

# remove the columns in the missingFields
pubNotebook_dropMissingInData <- dplyr::filter(pubNotebook, fieldName %!in% missingFields)

# Need to remove the publication date column from the inputData so that all the fields match with the pub notebook.
inputData_v2 <- select(inputData, -publicationDate)

!all(names(inputData_v2) %in% pubNotebook_dropMissingInData$fieldName[which(pubNotebook_dropMissingInData$table == "rea_externalLabDataSalt_pub")])

!all(pubNotebook_dropMissingInData$fieldName[which(pubNotebook_dropMissingInData$table == "rea_externalLabDataSalt_pub")] %in% names(inputData_v2))

missingFields_v2<- pubNotebook_dropMissingInData$fieldName[pubNotebook_dropMissingInData$fieldName %!in% names(inputData)]

test2 <- neonOSbase::removeDups(data = inputData_v2, variables = pubNotebook_dropMissingInData, table = "rea_externalLabDataSalt_pub")
