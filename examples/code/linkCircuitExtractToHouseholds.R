#--- Loads a circuit extract and links the household datausing linkID ---#

# Assumes that you have run extractCircuitFromCleanGridSpy1min.R first !!

# Load nzGREENGrid package ----
library(GREENGridData) # local utilities

# Packages needed in this .Rmd file ----
rmdLibs <- c("data.table", # data munching
             "lubridate" # date & time stuff
)
# load them
loadLibraries(rmdLibs)

# Local parameters ----

# change this to suit your data location - this is where extractCleanGridSpy1minCircuit.R saved your extract
dPath <- path.expand("~/SERG_data/NZ_GREENGrid/safe/")
                     
gsFile <- paste0(dPath, "gridSpy/1min/dataExtracts/Heat Pump_2015-04-01_2016-03-31_observations.csv.gz")
hhFile <- paste0(dPath, "survey/ggHouseholdAttributesSafe.csv.gz")

# test file exists
if(file.exists(gsFile)){
  message("Success! Found expected pre-extracted power data file: ", gsFile)
  message("Loading it...")
  powerDT <- data.table::fread(gsFile)
  powerDT[, rDateTime_NZ := lubridate::as_datetime(r_dateTime, # stored as UTC
                                                tz = "Pacific/Auckland")] # so we can extract within NZ dateTim
} else {
  message("Oops. Didn't find expected pre-extracted power data file: ", gsFile)
  stop("Please check you have set the paths and filename correctly...")
}

if(file.exists(hhFile)){
  message("Success! Found expected household survey file: ", hhFile)
  message("Loading it...")
  hhDT <- data.table::fread(hhFile)
} else {
  message("Oops. Didn't find expected household survey file: ", hhFile)
  stop("Please check you have set the paths and filename correctly...")
}


# --- Subset data ----
# take a subset of the power data just for speed
min(powerDT$rDateTime_NZ)
max(powerDT$rDateTime_NZ)

ssPowerDT <- powerDT[lubridate::date(rDateTime_NZ) == "2015-06-21"] # pick a day, any day

summary(ssPowerDT)
nrow(ssPowerDT) # how many rows?

# set the keys to match on
setkey(ssPowerDT, linkID)
setkey(hhDT, linkID)

# now they can be matched and merged
# note that we may have power data for fewer or more dwellings than we have household data
# e.g. rf_01 & rf_02 were test installs
# not all dwellings have heat pumps

uniqueN(ssPowerDT$linkID)
uniqueN(hhDT$linkID)

# merge them
# the order of this matters
nrow(ssPowerDT)
names(ssPowerDT)
ncol(ssPowerDT) # n columns bedfore
mergedDT <- hhDT[ssPowerDT] # data.table merge keeping only the hh data for those who are in the ssPowerDT
nrow(mergedDT)
# see? Same number of rows
ncol(mergedDT) # n columns after

# Now test
mergedDT[, .(meanW = mean(powerW), 
             nObs = .N, # data.table magic
             nDwellings = uniqueN(linkID)), 
         keyby = .(`Heat pump number`, Location)]

# so we have Heat Pump data from 4 households we didn't know had them
# most households claimed to have just 1 heat pump
# most of the Heat Pumps are in Hawke's Bay

# Suppose we now wanted to extract heat pump data for some spcific half hours...
times <- seq(lubridate::as_datetime("2015-06-21 17:00:00", tz = "Pacific/Auckland"), 
             lubridate::as_datetime("2015-06-21 20:30:00",tz = "Pacific/Auckland"), 
             by = 30*60)

timesDT <- as.data.table(times) # convert to a data.table 
timesDT[, rDateTime_NZ := x] # more sensible name
timesDT$x <- NULL # redundant
timesDT # which half-hours are they?

setkey(timesDT, rDateTime_NZ) # note the name of this column does not need to be 
# identical to the one in mergedDT as setkey just matches on the key you've set
# the clue's in the name...

# we need to create a half-hour column in ssPowerDT (since it is 1 minute level)
# which we can match our timeDT half hours to
mergedDT[, rDateTimeHalfHour_NZ := lubridate::floor_date(rDateTime_NZ, unit = "30 mins")] # we love lubridate
setkey(mergedDT, rDateTimeHalfHour_NZ)

ssDT <- mergedDT[timesDT] # this will select *only* the half hours in timesDT

# Now test
ssDT[, .(meanW = mean(powerW), 
             nObs = .N, # data.table magic
             nDwellings = uniqueN(linkID)), 
         keyby = .(rDateTimeHalfHour_NZ, # this is half-hours
                   `Heat pump number`)]


# So now you know how to:
# * load a power data extract
# * load the household data
# * link them
# * do some quick descriptives by sample Location & household attributes
# * extract according to some dates & times





