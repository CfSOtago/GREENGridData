# Code to produce an updated safe household attributes file with additional variables

# Uses the saved 'full' data
# adds new ones to the original safe file
# saves new safe file

library(data.table)
library(dplyr)


# data path
dp <- path.expand("~/Dropbox/data/NZ_GREENGrid/")

# Full original saved household attributes file - archived to Otago secure HCS server
# at HCS:: /hum-csafe/Research Projects/GREEN Grid/cleanData/safe/survey/ggHouseholdAttributesFull.csv.gz)
fullDT <- data.table::fread(paste0(dp, "ggHouseholdAttributesFull.csv.gz"))

# dataset from UKDS reshare archive
safeOriginalDT <- data.table::fread(paste0(dp, "ukds/data/ggHouseholdAttributesSafe.csv"))
  
# checks
nrow(fullDT)

table(fullDT$hasLongSurvey)

version <- "_1.1" # version number
# incr version number when a new var is added

my_log <- paste0(dp, "ggHouseholdAttributesSafe", version, "_skim.txt")
sink(my_log, append = FALSE, # new one each time
     type = "output") # Writing console output to log file

# note that some of the questions from the long survey may not have been asked of all households
# e.g. only 29 households were asked the long survey contaiing all the questions
# See https://cfsotago.github.io/GREENGridData/householdAttributeProcessingReport_v1.0.html#33_household_survey_data

# add new vars here
# matching
patterns <- names(dplyr::select(fullDT,starts_with("Q3") |
                                   starts_with("Q75"))) # hot water

# single vars
singles <- c("linkID", # for matching 
              "Q57", # hot water
              "Q73_9", # hot water
              "Q76_x11", # hot water
              "Q96_5", # hot water
              "Q97", # hot water
              "Q144", # PV attitudes
              "Q145", # PV in future
              "Q146" # PV if cost lower
              )

varsToKeep <- c(patterns, singles)

varsToAddDT <- fullDT[, ..varsToKeep] # keep the columns we specified
# remove accidental duplicates
varsToAddDT$Q30_1 <- NULL
varsToAddDT$Q33_1 <- NULL
varsToAddDT$Q57 <- NULL

setkey(varsToAddDT, linkID) # set keys for matching
setkey(safeOriginalDT,linkID)

newSafeDT <- safeOriginalDT[varsToAddDT] # merge/match by linkID to add the variables to the correct household
# adds new vars to the end


# if you want to re-order the columns to be alphabetical do this:

library(dplyr)
newSafeDF <- as.data.frame(newSafeDT)
newSafeDF <- newSafeDF[,order(colnames(newSafeDT))]

of <- paste0(dp, "ggHouseholdAttributesSafe", version, ".csv")
data.table::fwrite(newSafeDT, file = of) # save the new file

dkUtils::gzipIt(of) # gzip it

skimr::skim(newSafeDT) # check

closeAllConnections() # Close connection to log file