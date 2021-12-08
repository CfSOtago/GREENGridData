#--- Shows how to aggregate to days ---#

# The raw data is 1 observation per minute
# Many people like to work with half-hours instead
# This code shows how to calculate the mean & s.d. of power for each half-hour for
# (some of) the households and save the data as a new file

# Packages we will need - you may need to install them

# Use require so the code fails if these can't be loaded
require(data.table) # for loading data very fast
require(lubridate) # for all other date & time processing

# NB: it would be possible to do this using
# readr <- to load the files
# dplyr <- to process the data using lubridate::floor_date() but it would probably be slower

# Local parameters ----

# use hhID parameter to change the household used (assumes you have access to the data from https://dx.doi.org/10.5255/UKDA-SN-853334)
hhID <- "rf_19" # for example

# change this to suit your data location
dataPath <- path.expand("~/Dropbox/data/NZ_GREENGrid/ukds/data/powerData/")

# Single file example ----
demandFile <- paste0(dataPath,
                 hhID,
                 "_all_1min_data.csv.gz") # you may not have the .gz on your file if it is already uncompressed
# check
file.exists(demandFile)

# load the data
powerData <- data.table::fread(demandFile)

# Note that this data contains observations from several different circuits. We
# want the mean power per circuit per half-hour.

head(powerData) # r_dateTime is in 1 minute intervals

# now use lubridate's floor_date() function to set the half-hour
# NB: this will set the start of the half-hour to represent all the 1 minute observations
# following. This is important when doing further analysis

powerData[, r_date := lubridate::as_date(r_dateTime)]

# check - is this what you expect?
head(powerData)

# now do the aggregation. data.table does this VERY fast
dailyPowerData <- powerData[, .(meanPowerW = mean(powerW), # calculate mean power in W
                                     sd = sd(powerW), # calculate standard deviation in W
                                     nObs = .N),
                                 keyby = .(r_date, # per half-hour
                                           circuit, # per circuit
                                           linkID)] # keep as a column

# check - is this what you expect?
head(dailyPowerData)

# now save it
# first check the folder we want to save the data in exists - if not create it
if(!dir.exists(paste0(dataPath,"daily/"))){
  dir.create(paste0(dataPath,"daily/"))
}

# file to save it in
outF <- paste0(dataPath,"daily/",hhID, "dailyPower.csv")
data.table::fwrite(file = outF, # where to save it
                   dailyPowerData)

# Multi-file example using a function ----

# we put the processing inside a function and then loop over the 
# known hh_ids

makeDailyPower <- function(f){
  hhID <- strsplit(f, "_")[[1]][2] # get the linkID/hhID from the filename

  # check for presence of 15 and 17 - these should not be there as
  # the data files have been split into 15a, 17a & 17b
  if(hhID == "15" | hhID == "17"){
    message("Skipping: ", hhID, " (invalid data file, shouldn't be here - see https://github.com/CfSOtago/GREENGridData/issues/19)")
  } else {
    df <- paste0(dataPath,
                 f) 
    # repeat above code
    message("Loading: ", hhID)
    powerData <- data.table::fread(df)
    powerData[, r_date := lubridate::as_date(r_dateTime)]
    dailyPowerData <- powerData[, .(meanPowerW = mean(powerW), # calculate mean power in W
                                         sd = sd(powerW), # calculate standard deviation in W
                                         nObs = .N),
                                     keyby = .(r_date, # per day
                                               circuit, # per circuit
                                               linkID)] # keep as a column
    # file to save it in
    outF <- paste0(dataPath,"daily/rf_",hhID, "_dailyPower.csv")
    data.table::fwrite(file = outF, # where to save it
                       dailyPowerData)
    message("Finished processing: ", hhID)
  }
}

# run the function in a loop
# first check the folder we want to save the data in exists - if not create it
# was probably created in our first example above but check
if(!dir.exists(paste0(dataPath,"daily/"))){
  dir.create(paste0(dataPath,"daily/"))
}

# get the list of files to process
files <- list.files(dataPath, pattern = "csv") # get the list of data files

for(f in files){
  message("Processing: ", f)
  makeDailyPower(f)
}

# check the last half hourly data file - does it look OK?

# Note especially any potential errors where there are less than or more
# than 30 observations per half-hour. You may need to examine these (there shold not be many)
summary(dailyPowerData)

# visual check
hist(dailyPowerData$nObs)

head(dailyPowerData[nObs < 30]) # where observations are missing

head(dailyPowerData[nObs > 30]) # where there are too many
