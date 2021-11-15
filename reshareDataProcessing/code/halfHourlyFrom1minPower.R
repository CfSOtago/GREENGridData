#--- Shows how to aggregate to half-hours ---#

# The raw data is 1 observation per minute
# Many people like to work with half-hours instead
# This code shows how to calculate the mean & s.d. of power for each half-hour for
# (some of) the households and save the data as a new file

# Packages we will need
# Use require so the code fails if these can't be loaded
require(data.table) # for loading data very fast
require(lubridate) # for all other date & time processing


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

powerData[, r_dateTimeHalfHour := lubridate::floor_date(r_dateTime, "30 mins")]

# check - is this what you expect?
head(powerData)

# now do the aggregation. data.table does this VERY fast
halfHourlyPowerData <- powerData[, .(meanPowerW = mean(powerW), # calculate mean power in W
                                     sd = sd(powerW), # calculate standard deviation in W
                                     nObs = .N),
                                 keyby = .(r_dateTimeHalfHour, # per half-hour
                                           circuit, # per circuit
                                           linkID)] # keep as a column

# check - is this what you expect?
head(halfHourlyPowerData)

# now save it
# first check the folder we want to save the data in exists - if not create it
if(!dir.exists(paste0(dataPath,"halfHourly/"))){
  dir.create(paste0(dataPath,"halfHourly/"))
}

# file to save it in
outF <- paste0(dataPath,"halfHourly/",hhID, "halfHourlyPower.csv")
data.table::fwrite(file = outF, # where to save it
                   halfHourlyPowerData)

# Multi-file example using a function ----

# we put the processing inside a function and then loop over the 
# known hh_ids

makeHalfHourlyPower <- function(f){
  hhID <- strsplit(f, "_")[[1]][2] # get the linkID/hhID from the filename
  df <- paste0(dataPath,
                       f) 
  # repeat above code
  message("Loading: ", hhID)
  powerData <- data.table::fread(df)
  powerData[, r_dateTimeHalfHour := lubridate::floor_date(r_dateTime, "30 mins")]
  halfHourlyPowerData <- powerData[, .(meanPowerW = mean(powerW), # calculate mean power in W
                                       sd = sd(powerW), # calculate standard deviation in W
                                       nObs = .N),
                                   keyby = .(r_dateTimeHalfHour, # per half-hour
                                             circuit, # per circuit
                                             linkID)] # keep as a column
  # file to save it in
  outF <- paste0(dataPath,"halfHourly/rf_",hhID, "_halfHourlyPower.csv")
  data.table::fwrite(file = outF, # where to save it
                     halfHourlyPowerData)
  message("Finished processing", hhID)
}

# run the function in a loop
# first check the folder we want to save the data in exists - if not create it
# was probably created in our first example above but check
if(!dir.exists(paste0(dataPath,"halfHourly/"))){
  dir.create(paste0(dataPath,"halfHourly/"))
}

# get the list of files to process
files <- list.files(dataPath, pattern = "csv") # get the list of data files

for(f in files){
  message("Processing: ", f)
  makeHalfHourlyPower(f)
}
