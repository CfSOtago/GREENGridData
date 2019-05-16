print(paste0("#--------------- Processing NZ GREEN Grid Grid Power Data ---------------#"))

# -- Code to correctly sum household power demand to get an overall total -- #
# Required because some circuits are seperate from the 'Incomer' - e.g. seperately controlled hot water
# Code (c) 2018 Jason Mair - jkmair@cs.otago.ac.nz 
# with amendments from ben.anderson@otago.ac.nz
# edit history:

# Notes:
# This code uses a csv file in the package /data folder which
# specifies the circuits to be used when calculating the total for each
# house. The code below calculates per-house totals, and saves them to a single file for later use.
#
# The code assumes that the circuits in the circuits file are actually the ones to sum to get overall
# power demand. We have checked as best we can. If you notice errors please add an issue at:
#
# https://github.com/CfSOtago/GREENGridData/issues?q=is%3Aissue+is%3Aopen+label%3AdataIssue
#
# Note that the code attempts to check which circuits contribute to the total, but this
# method allows for further checking by using the circuit names.

# Run rarely - takes time

# Libraries ----

library(lubridate)
library(data.table)
library(readr) # use fread instead where possible
library(here)

# parameterise data path - edit for your set up ----

sysname <- Sys.info()[[1]]
user <- Sys.info()[[6]]
message("Running on ", sysname, " under user ", user)

#circuitsFile <- "circuitsToSum.csv"
circuitsFile <- "circuitsToSum_v1.0" # JKM original
#circuitsFile <- "circuitsToSum_v1.1" # all

# localise data paths
if(user == "ben" & sysname == "Darwin"){
  # Ben's laptop
  DATA_PATH <- "~/Data/NZ_GREENGrid/safe/gridSpy/1min/data"
  circuits_path <- paste0(here::here(), "/data/", circuitsFile, ".csv") # in the package data folder
} else {
  DATA_PATH = "/Users/jkmair/GreenGrid/data/clean_raw" # <- Jason
  circuits_path <- paste0(DATA_PATH, "/", circuitsFile, ".csv") # <- Jason
  #circuits_path <- sprintf("%s/circuitsToSum.csv", DATA_PATH) # <- Jason
}

# set up ----

# Plot full numbers, not scientific
options(scipen=999)

# Set system timezone to UTC
Sys.setenv(TZ='UTC')

# Set the time period I want to get the per-house totals for ----
start_time <- as.POSIXct("2015-04-01 00:00", tz="Pacific/Auckland")
end_time <- as.POSIXct("2016-04-01 00:00", tz="Pacific/Auckland")

start_exec <- Sys.time()

dataL <- data.table() # data bucket to collect data in

# process household files ----
processPowerFiles <- function(df){
  message("Using data from: ", DATA_PATH)
  for(house_id in colnames(df)){
    #house_id <- "rf_44" # for testing
    
    # input <- data.table::as.data.table(readr::read_csv(sprintf("%s/%s_all_1min_data.csv.gz", DATA_PATH, house_id), 
    #                                                    col_types=cols(hhID=col_character(), 
    #                                                                   linkID=col_character(), 
    #                                                                   dateTime_orig=col_character(), 
    #                                                                   TZ_orig=col_character(), 
    #                                                                   r_dateTime=col_character(), 
    #                                                                   circuit = col_character(), 
    #                                                                   powerW=col_double())
    #                                                    )
    #                                    )
    iF <- sprintf("%s/%s_all_1min_data.csv.gz", DATA_PATH, house_id)
    message(" -> Loading data for ", house_id, " from ", iF)
    inputDT <- data.table::fread(iF) # load the household data
    
    message(" -> Parsing dates ", house_id)
    # input$time_utc <- parse_date_time(input$r_dateTime, orders=c('ymdHMS'))
    inputDT <- inputDT[, time_utc := lubridate::as_datetime(r_dateTime)]
    inputDT <- inputDT[, time_nz := lubridate::with_tz(time_utc, tzone = "Pacific/Auckland")]
    
    # select dates we want
    inputDT <- inputDT[time_nz >= start_time & time_nz < end_time, ]
    
    # Read in the circuits and extract the circuit code number
    circuit_list <- df[, house_id]
    circuit_list <- sub(".*\\$", "", circuit_list)
    circuit_list <- circuit_list[circuit_list != ""]
    
    
    # Create a boolean array of rows/circuits to be extracted
    cond <- rep(FALSE, length(inputDT$circuit))
    
    for(circuit in circuit_list){
      message(" -> Checking circuit: ", circuit)
      cond <- cond | grepl(circuit, inputDT$circuit)
    }
    
    exDT <- inputDT[cond, c("linkID", "time_nz","time_utc", "powerW")]
      
    # make long verion (easier for data analysis)
    totDTl <- exDT[,.(powerW = sum(powerW)), keyby = .(time_nz, time_utc,linkID)]
    totDTl$circuit <- paste0("imputedTotalDemand_", circuitsFile)
    # add the total back to the input DT and save as new file
    outDT <- rbind(inputDT[, .(linkID, circuit, time_utc, powerW, time_nz)])
    oF <- paste0(DATA_PATH, "/imputed/",house_id, "_all_1min_data_withImputedTotal_",
                 circuitsFile, ".csv")
    message("Saving and gzipping: ", oF)
    data.table::fwrite(outDT, oF) # save the household data
    # gzip it
    cmd <- paste0("gzip -f ", oF)
    try(system(cmd))
    message("Done")
    dataL <- rbind(dataL, totDTl) # the big data bucket of totals
  }
  message("All households processed using: ", circuitsFile)
  return(dataL)
}

message("Loading circuits from: ", circuits_path)
df <- read.csv(circuits_path, header = TRUE) # if we switch to readr::read_csv the processing code breaks

message("Processing")
dataL <- processPowerFiles(df)

# save out the files of all totals ----

#write.table(data, file=sprintf("%s/tot.csv", DATA_PATH), sep=",", row.names=FALSE, col.names=TRUE)
gsFile <- paste0(DATA_PATH, "/imputed/allHouseholds_totalW_long_", circuitsFile, ".csv")
data.table::fwrite(dataL, gsFile) # way faster

# gzip it
cmd <- paste0("gzip -f ", gsFile)
try(system(cmd))

message("Done")

end_exec <- Sys.time()
end_exec - start_exec


