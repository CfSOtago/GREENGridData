print(paste0("#--------------- Processing NZ GREEN Grid Grid Survey Data ---------------#"))

# Load nzGREENGrid package ----

print(paste0("#-> Load GREENGridData package"))
library(GREENGridData) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up GREENGridData package "))
GREENGridData::setup()
print(paste0("#-> Done "))

# Load libraries needed in this .r file ----
rmdLibs <- c("data.table", # data munching
             "ggplot2", # for fancy graphs
             "lubridate", # date & time processing
             "readr", # reading/writing csv files
             "readxl", # reading xlsx
             "skimr", # for skim
             "knitr" # for kable & captions
)
# load them
GREENGridData::loadLibraries(rmdLibs)

# Local functions ----

# --- Code ---

# Set start time ----
startTime <- proc.time()

# Load data ----

hhMasterDT <- GREENGridData::getHouseholdData(ggrParams$gsHHMasterFile) # cleans it as it loads
setkey(hhMasterDT, linkID)
t <- with(hhMasterDT, table(Location, useNA = "always"))

t

# Appliance data ----

hhAppliancesDT <- data.table::as.data.table(readxl::read_xlsx(ggrParams$ApplianceData))

hhAppliancesDT$sample <- NULL # too detailed
setkey(hhAppliancesDT, linkID)

# Household survey data ----
hhEc2ShortDT <- data.table::as.data.table(readr::read_csv(ggrParams$UnisonShortSurveyData))
hhEc2LongDT <- data.table::as.data.table(readr::read_csv(ggrParams$UnisonLongSurveyData))
hhEc2DT <- data.table::as.data.table(readr::read_csv(ggrParams$PowercoSurveyData))

#> Hawkes Bay short ----

keepShortCols <- c("linkID","hasShortSurvey",
              "StartDate",
              "Q4",
              "Q7",
              "Q53_1",
              "Q53_2",
              "Q53_3",
              "Q53_4",
              "Q53_5",
              "Q53_6",
              "Q53_7",
              "Q54_1",
              "Q54_2",
              "Q54_3",
              "Q54_4",
              "Q54_5",
              "Q54_6",
              "Q54_7",
              "Q57",
              "Q55",
              "Q58#2_1")
keephhEc2ShortDT <- hhEc2ShortDT[!is.na(linkID), ..keepShortCols]

# > Hawkes Bay long ----
keepLongCols <- c("linkID", "hasLongSurvey",
              "StartDate",
              "Q4",
              "Q5",
              "Q7",
              "Q10#1_1_1_TEXT",
              "Q10#1_1_2_TEXT",
              "Q10#1_2_1_TEXT",
              "Q10#1_2_2_TEXT",
              "Q10#1_3_1_TEXT",
              "Q10#1_3_2_TEXT",
              "Q10#1_4_1_TEXT",
              "Q10#1_4_2_TEXT",
              "Q10#1_5_1_TEXT",
              "Q10#1_5_2_TEXT",
              "Q10#1_6_1_TEXT",
              "Q10#1_6_2_TEXT",
              "Q10#1_7_1_TEXT",
              "Q10#1_7_2_TEXT",
              "Q10#1_8_1_TEXT",
              "Q10#1_8_2_TEXT",
              "Q11_1",
              "Q14_1",
              "Q15_1",
              "Q17_1",
              "Q18_1",
              "Q19_1",
              "Q19_2",
              "Q19_3",
              "Q19_4",
              "Q19_5",
              "Q19_6",
              "Q19_7",
              "Q19_8",
              "Q19_9",
              "Q19_10",
              "Q19_10",
              "Q19_12",
              "Q19_13",
              "Q19_14",
              "Q19_15",
              "Q19_16",
              "Q19_17",
              "Q30_1",
              "Q33_1",
              "Q40_1",
              "Q40_2",
              "Q40_3",
              "Q40_4",
              "Q40_5",
              "Q40_6",
              "Q40_7",
              "Q40_9",
              "Q40_10",
              "Q40_11",
              "Q40_12",
              "Q40_13",
              "Q40_14",
              "Q40_15",
              "Q40_16",
              "Q40_17",
              "Q40_18",
              "Q40_19",
              "Q40_20",
              "Q40_21",
              "Q40_38",
              "Q53_1",
              "Q53_2",
              "Q53_3",
              "Q53_4",
              "Q53_5",
              "Q53_6",
              "Q53_7",
              "Q54_1",
              "Q54_2",
              "Q54_3",
              "Q54_4",
              "Q54_5",
              "Q54_6",
              "Q54_7",
              "Q57",
              "Q55",
              "Q58#2_1")
keephhEc2LongDT <- hhEc2LongDT[!is.na(linkID), ..keepLongCols] # no point keeping unknown IDs

# > New Plymouth sample ----
keephhEc2DT <- hhEc2DT[!is.na(linkID), ..keepLongCols]

# Combine them all using rbind ----
# As we think the linkIDs are unique - no-one did any survey twice (although there are possible duplicates flagged in linkID)

# full data
allHhEc2FullDT <- rbind(hhEc2ShortDT,hhEc2LongDT,hhEc2DT, fill=TRUE)

# > check for duplicates ----
nrow(allHhEc2FullDT)
data.table::uniqueN(allHhEc2FullDT$linkID)

# safe data ----
allHhEc2SafeDT <- rbind(keephhEc2LongDT,keephhEc2ShortDT,keephhEc2DT, fill=TRUE)

#> check for duplicates ----
nrow(allHhEc2SafeDT)
data.table::uniqueN(allHhEc2SafeDT$linkID)

# set date ----
allHhEc2FullDT <- allHhEc2FullDT[, surveyStartDate := lubridate::dmy_hm(StartDate)]
#allHhEc2FullDT$StartDate <- NULL
setkey(allHhEc2FullDT, linkID)

allHhEc2SafeDT <- allHhEc2SafeDT[, surveyStartDate := lubridate::dmy_hm(StartDate)]
#allHhEc2SafeDT$StartDate <- NULL
setkey(allHhEc2SafeDT, linkID)

# create combined DT ----
hhAttributesFullDT <- allHhEc2FullDT[hhMasterDT]
hhAttributesFullDT <- hhAppliancesDT[hhAttributesFullDT] # why do we need to do this in two steps?
# if we do it all in one step we get NAs in 'hasShortSurvey' if there is no appliance data?

hhAttributesSafeDT <- allHhEc2SafeDT[hhMasterDT]
hhAttributesSafeDT <- hhAppliancesDT[hhAttributesSafeDT] # why do we need to do this in two steps?
# if we do it all in one step we get NAs in 'hasShortSurvey' if there is no appliance data?

# Save data ----
# > full ----
ofile <- paste0(ggrParams$hhOutPath, "ggHouseholdAttributesFull.csv")
readr::write_csv(hhAttributesFullDT, ofile)

# > safe ----
ofile <- paste0(ggrParams$hhOutPath, "ggHouseholdAttributesSafe.csv")
readr::write_csv(hhAttributesSafeDT, ofile)


# Runtime ---

t <- proc.time() - startTime

elapsed <- t[[3]]

paste0("Analysis completed in ", round(elapsed,2), "seconds ( ", round(elapsed/60,2), " minutes)")
