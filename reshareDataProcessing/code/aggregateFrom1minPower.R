#--- Shows how to aggregate to half-hours, hours or days ---#

# The raw data is 1 observation per minute
# Many people like to work with half-hours or hours instead
# This code shows how to calculate the mean & s.d. of power for each time-period for
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

# functions ---

# these are called from within aggregatePower

makeHalfHourly <- function(dt){
  # assumes dt is the powerData in 1 min intervals
  dt[, r_dateTimeHalfHour := lubridate::floor_date(r_dateTime, "30 mins")] # half-hour
  hhD <- dt[, .(meanPowerW = mean(powerW), # calculate mean power in W
                       sd = sd(powerW), # calculate standard deviation in W
                       nObs = .N), # count the number of observations - check you get what you expect!
                   keyby = .(r_dateTimeHalfHour, # per half-hour
                             circuit, # per circuit
                             linkID)] # keep as a column
  # file to save it in
  outF <- paste0(dataPath,"halfHourly/",hhID, "_halfHourlyPower.csv")
  if(!dir.exists(paste0(dataPath,"halfHourly/"))){
    dir.create(paste0(dataPath,"halfHourly/"))
  }
  data.table::fwrite(file = outF, # where to save it
                     hhD)  # we should probably compress it too
  message("Saved half-hourly to ", outF)
  
}

makeHourly <- function(dt){
  # assumes dt is the powerData in 1 min intervals
  dt[, r_dateTimeHour := lubridate::floor_date(r_dateTime, "60 mins")] # hour
  hD <- dt[, .(meanPowerW = mean(powerW), # calculate mean power in W
                      sd = sd(powerW), # calculate standard deviation in W
                      nObs = .N), # count the number of observations - check you get what you expect!
                  keyby = .(r_dateTimeHour, # per hour
                            circuit, # per circuit
                            linkID)] # keep as a column
  # file to save it in
  if(!dir.exists(paste0(dataPath,"hourly/"))){
    dir.create(paste0(dataPath,"hourly/"))
  }
  outF <- paste0(dataPath,"hourly/",hhID, "_hourlyPower.csv")
  data.table::fwrite(file = outF, # where to save it
                     hD) # we should probably compress it too
  message("Saved hourly to ", outF)
}

makeDaily <- function(dt){
  # assumes dt is the powerData in 1 min intervals
  dt[, r_date := lubridate::as_date(r_dateTime)] # hour
  dD <- dt[, .(meanPowerW = mean(powerW), # calculate mean power in W
                      sd = sd(powerW), # calculate standard deviation in W
                      nObs = .N), # count the number of observations - check you get what you expect!
                  keyby = .(r_date, # per day-hour
                            circuit, # per circuit
                            linkID)] # keep as a column
  # file to save it in
  if(!dir.exists(paste0(dataPath,"daily/"))){
    dir.create(paste0(dataPath,"daily/"))
  }
  outF <- paste0(dataPath,"daily/",hhID, "_dailyPower.csv")
  data.table::fwrite(file = outF, # where to save it
                     dD)
  message("Saved daily to ", outF)
}

aggregatePower <- function(f){
  # assumes f is the filename (without the path, we build the path below)
  # do all aggregations in the loop as the greatest time is the data loading
  hhID <- strsplit(f, "_")[[1]][2] # get the linkID/hhID from the filename
  
  # check for presence of 15 and 17 - these should not be there as
  # the data files have been split into 15a, 17a & 17b
  if(hhID == "15" | hhID == "17"){
    message("Skipping: ", hhID, " (invalid data file, shouldn't be here - see https://github.com/CfSOtago/GREENGridData/issues/19)")
  } else {
    df <- paste0(dataPath,
                 f) 

    message("Loading: ", df)
    powerData <- data.table::fread(df)
    
    # If you don't want any of these just comment them out
    
    # halfhourly
    makeHalfHourly(powerData)
    
    # hourly
    makeHourly(powerData)
    
    # daily
    makeDaily(powerData)
    
    # add new aggregation functions here
    
    message("Finished processing: ", hhID,"\n")
  }
}

# Single file example ----
demandFile <- paste0(hhID,
                 "_all_1min_data.csv.gz") # you may not have the .gz on your file if it is already uncompressed

aggregatePower(demandFile)

# Multi-file example using a loop ----

# we put the processing inside a function and then loop over the 
# known hh_ids

# run the function in a loop

# get the list of files to process
files <- list.files(dataPath, pattern = "csv") # get the list of data files

for(f in files){
  message("Processing: ", f)
  aggregatePower(f)
}

