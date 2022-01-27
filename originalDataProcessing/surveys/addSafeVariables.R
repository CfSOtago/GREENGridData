# Code to produce an updated safe household attributes file with additional variables

# Uses the saved 'full' data
# adds new ones to the original safe file
# saves new safe file

library(data.table)

dp <- path.expand("~/Dropbox/data/NZ_GREENGrid/")

fullDT <- data.table::fread(paste0(dp, "ggHouseholdAttributesFull.csv.gz"))

safeOriginalDT <- data.table::fread(paste0(dp, "ukds/data/ggHouseholdAttributesSafe.csv"))
  
# checks
nrow(fullDT)

table(fullDT$hasLongSurvey)

version <- "_1.1" # version number
# incr version number when a new var is added

# note that some of the questions from the long survey may not have been asked of all households
# e.g. only 29 households were asked the long survey contaiing all the questions
# See https://cfsotago.github.io/GREENGridData/householdAttributeProcessingReport_v1.0.html#33_household_survey_data

# add new vars here
# we need a wildcard method
keepCols <- c("linkID", # for matching 
              "Q32_1", # Hot water
              "Q32_2", 
              "Q32_3",
              "Q32_4",
              "Q32_5",
              "Q32_6",
              "Q32_7",
              "Q32_8",
              "Q144", # PV attitudes
              "Q145", # PV in future
              "Q146" # PV if cost lower
              )

varsToAddDT <- fullDT[, ..keepCols]

setkey(varsToAddDT, linkID)
setkey(safeOriginalDT,linkID)

newSafeDT <- safeOriginalDT[varsToAddDT]
skimr::skim(newSafeDT)
# adds new vars to the end


# if you want to re-order the columns to be alphabetical do this:

library(dplyr)
newSafeDF <- as.data.frame(newSafeDT)
newSafeDF <- newSafeDF[,order(colnames(newSafeDT))]

of <- paste0(dp, "ggHouseholdAttributesSafe", version, ".csv")
data.table::fwrite(newSafeDT, file = of)

dkUtils::gzipIt(of)
