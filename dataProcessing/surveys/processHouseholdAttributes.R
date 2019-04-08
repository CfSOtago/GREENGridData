print(paste0("#--------------- Processing NZ GREEN Grid Grid Survey Data ---------------#"))

# Load nzGREENGrid package ----

print(paste0("#-> Load GREENGridData package"))
library(GREENGridData) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up GREENGridData package "))
GREENGridData::setup()
print(paste0("#-> Done "))

# Load libraries needed in this .r file ----
rmdLibs <- c("data.table", # data munching
             "dplyr", # recode
             "ggplot2", # for fancy graphs
             "lubridate", # date & time processing
             "readr", # reading/writing csv files
             "readxl" # reading xlsx
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
hhEc2ShortDT <- data.table::as.data.table(readr::read_csv(ggrParams$HawkesBayShortSurveyData))
hhEc2LongDT <- data.table::as.data.table(readr::read_csv(ggrParams$HawkesBayLongSurveyData))
hhEc2DT <- data.table::as.data.table(readr::read_csv(ggrParams$TaranakiSurveyData))

#> Hawkes Bay short ----

keepShortCols <- c("linkID","hasShortSurvey",
                   "StartDate",
                   "Q4",
                   "Q7",
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
                   "Q20",
                   "Q49", # Light bulb types (majority)
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
                  "Q16", # can you apply a thermostat setting? (Yes = 1)
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
                  "Q20",
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
                  "Q49", # Light bulb types (majority)
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

# > Taranaki sample ----
keephhEc2DT <- hhEc2DT[!is.na(linkID), ..keepLongCols]

# Combine them all using rbind ----
# As we think the linkIDs are unique - no-one did any survey twice (although there are possible duplicates flagged in linkID)

# make full data ----
allHhEc2FullDT <- rbind(hhEc2ShortDT,hhEc2LongDT,hhEc2DT, fill=TRUE)
setkey(allHhEc2FullDT, linkID)
allHhEc2FullDT <- allHhEc2FullDT[hhMasterDT]

# > check for duplicates ----
message("N rows before duplicate check: ",nrow(allHhEc2FullDT))
data.table::uniqueN(allHhEc2FullDT$linkID)
message("N rows after duplicate check: ",nrow(allHhEc2FullDT))

recodeData <- function(dt){
  # expects a DT
  # > set date ----
  dt <- dt[, surveyStartDate := lubridate::dmy_hm(StartDate)]
  #dt$StartDate <- NULL

  dt <- dt[, surveyStartDate := lubridate::dmy_hm(StartDate)]
  #dt$StartDate <- NULL
  setkey(dt, linkID)
  
  # code useful variables ----
  # NB this relies extensively on https://ourarchive.otago.ac.nz/handle/10523/5634
  # and an original EC2 questionairre print-out provided by Ben Wooliscroft
  # As a result some coding may be suspect since a full code-book as implemented in GREEN Grid 
  # does not seem to exist. We have had to assume the category ordering is the same
  
  # Q19_x heat type available ----
  # see below or labels file
  
  # Q20 Main heat type ----
  # ques re-uses the Q19 coding frame
  dt <- dt[, Q20_coded := dplyr::recode(Q20, 
                                        "1" = "Heat pump", 
                                        "2" = "Electric night store", 
                                        "3" = "Portable electric heaters", 
                                        "4" = "Electric heaters fixed in place",
                                        "5" = "Enclosed coal burner",
                                        "6" = "Enclosed wood burner",
                                        "7" = "Portable gas heater",
                                        "8" = "Gas heaters fixed in place",
                                        "9" = "Central heating – gas (flued)",
                                        "10" = "Central heating – electric",
                                        "11" = "DVS or other heat transfer system",
                                        "12" = "HRV or other ventilation system",
                                        "13" = "Underfloor electric heating",
                                        "14" = "Underfloor gas heating",
                                        "15" = "Central heating pellet burner",
                                        "16" = "Open fire",
                                        "17" = "Other"
                                        )]
  table(dt$Q20_coded, dt$Q20, useNA = "always")
  
  # Q49 Majority of lighting ----
  # p88 table shows CFL, incandescent, halogen, LED (order of frequency)
  # if we assume the same frequency order (can we?)...
  table(dt$Q49)
  #
  dt <- dt[, Q49_coded := dplyr::recode(Q49, 
                                        "1" = "Halogen", 
                                        "2" = "LED", 
                                        "3" = "Energy saving - cfl", 
                                        "4" = "Incandescent")]
  table(dt$Q49_coded, dt$Q49, useNA = "always")
  return(dt)
}

# > recode full dt ----
allHhEc2FullDT <- recodeData(allHhEc2FullDT) # recode the full dt

# make safe data ----
allHhEc2SafeDT <- rbind(keephhEc2LongDT,keephhEc2ShortDT,keephhEc2DT, fill=TRUE)

setkey(allHhEc2SafeDT, linkID)
allHhEc2SafeDT <- allHhEc2SafeDT[hhMasterDT]

allHhEc2SafeDT <- recodeData(allHhEc2SafeDT) # recode the safe dt

# create final combined DTs ----
hhAttributesFullDT <- hhAppliancesDT[allHhEc2FullDT]

hhAttributesSafeDT <- hhAppliancesDT[allHhEc2SafeDT] 

# Save data ----
# > full ----
ofile <- paste0(ggrParams$hhOutPath, "ggHouseholdAttributesFull.csv")
data.table::fwrite(hhAttributesFullDT, ofile)

# > safe ----
ofile <- paste0(ggrParams$hhOutPath, "ggHouseholdAttributesSafe.csv")
data.table::fwrite(hhAttributesSafeDT, ofile)

# save locally for future use
tablesysName <- Sys.info()[[1]]
userName <- Sys.info()[[6]]
if(sysName == "Darwin" & userName == "ben"){
  ofile <-"~/Data/NZ_GREENGrid/safe/survey/ggHouseholdAttributesSafe.csv"
  data.table::fwrite(hhAttributesSafeDT, ofile)
}

# Runtime ---

t <- proc.time() - startTime

elapsed <- t[[3]]

paste0("Processing completed in ", round(elapsed,2), " seconds ( ", round(elapsed/60,2), " minutes)")
