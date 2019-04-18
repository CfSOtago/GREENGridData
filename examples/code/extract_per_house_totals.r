print(paste0("#--------------- Processing NZ GREEN Grid Grid Power Data ---------------#"))

# -- Code to correctly sum household power demand to get an overall total -- #
# Required because some circuits are seperate from the 'Incomer' - e.g. seperately controlled hot water
# Code (c) 2018 Jason Mair - jkmair@cs.otago.ac.nz with amendments from ben.anderson@otago.ac.nz

# Nores:
#  This code uses a csv file 'circuits.csv' (in the package /data folder) which
# specifies the circuits to be used when calculating the total for each
# house. The code below calculates
# per-house totals, are saved in a single file for later use.
#
# Note that the code attempts to check which circuits contribute to the total, but this
# method allows for further checking by using the circuit names.

# NB: Houses which have negative values or PV are dropped

library(lubridate)
library(ggplot2)
library(data.table)
library(readr)
library(here)

# parameterise data path - edit for your set up
sysname <- Sys.info()[[1]]
user <- Sys.info()[[6]]
message("Running on ", sysname, " under user ", user)

if(user == "ben" & sysname == "Darwin"){
  # Ben's laptop
  DATA_PATH <- "~/Data/NZ_GREENGrid/reshare/v1.0/data/powerData"
  circuits_path <- paste0(here::here(), "/data/circuitsToSum.csv") # in the package data folder
  circuits_input <- read.csv(circuits_path, header = TRUE)
} else {
  DATA_PATH = "/Users/jkmair/GreenGrid/data/clean_raw" # <- Jason
  circuits_path <- sprintf("%s/circuitsToSum.csv", DATA_PATH) # <- Jason
  circuits_input <- read.csv(circuits_path, header = TRUE)
}
  
# Plot full numbers, not scientific
options(scipen=999)

# Set system timezone to UTC
Sys.setenv(TZ='UTC')


# Set the time period I want to get the per-house totals for
start_time <- as.POSIXct("2015-04-01 00:00", tz="Pacific/Auckland")
end_time <- as.POSIXct("2016-04-01 00:00", tz="Pacific/Auckland")

start_exec <- Sys.time()

for(house_id in colnames(circuits_input)){
  message("Running extraction for: ", house_id)
  message(" -> Loading data for ", house_id)
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
  inputDT <- fread(sprintf("%s/%s_all_1min_data.csv.gz", DATA_PATH, house_id))
  
  message(" -> Parsing dates ", house_id)
 # input$time_utc <- parse_date_time(input$r_dateTime, orders=c('ymdHMS'))
  inputDT <- inputDT[, time_utc := lubridate::as_datetime(r_dateTime)]
  inputDT <- inputDT[, time_nz := lubridate::with_tz(time_utc, tzone = "Pacific/Auckland")]

  # select dates we want
  inputDT <- inputDT[time_nz >= start_time & time_nz < end_time, ]

	# Read in the circuits and extract the circuit code number
	circuit_list <- circuits_input[, house_id]
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
	totDTl <- exDT[,.(sumkW = sum(powerW)), keyby = .(time_nz, time_utc,linkID)]

	if(is.data.table(dataL)){
	  # if exists add new hh to it
		dataL <- rbind(dataL, totDTl)
	}else{
	  # if not, create it
		dataL <- totDTl
	}
}

end_exec <- Sys.time()
end_exec - start_exec

# save out the files of all totals

#write.table(data, file=sprintf("%s/tot.csv", DATA_PATH), sep=",", row.names=FALSE, col.names=TRUE)
data.table::fwrite(dataL, file=sprintf("%s/allHouseholds_totalW_long.csv", DATA_PATH)) # way faster

# just for fun
plotDT <- dataL[, .(meanW = mean(sumW)), keyby = .(linkID, time = hms::as.hms(time_nz))]
ggplot2::ggplot(plotDT, aes(x = time, y = meanW/1000, colour = linkID)) + 
  geom_line() +
  labs(x = "Time of Day",
       y = "Mean kW")