print(paste0("#--------------- Processing NZ GREEN Grid Grid Power Data ---------------#"))

# -- Code to correctly sum household power demand to get an overall total -- #
# Required because some circuits are seperate from the 'Incomer' - e.g. seperately controlled hot water
# Code (c) 2018 Jason Mair - jkmair@cs.otago.ac.nz

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


DATA_PATH = "/Users/jkmair/GreenGrid/data/clean_raw" # <- edit for your set up


# Plot full numbers, not scientific
options(scipen=999)

# Set system timezone to UTC
Sys.setenv(TZ='UTC')


# Set the time period I want to get the per-house totals for
start_time <- as.POSIXct("2015-04-01 00:00", tz="Pacific/Auckland")
end_time <- as.POSIXct("2016-04-01 00:00", tz="Pacific/Auckland")


circuits_input <- read.csv(sprintf("%s/circuits.csv", DATA_PATH), header = TRUE);

start_exec <- Sys.time()

for(house_id in colnames(circuits_input)){
  input <- data.table::as.data.table(readr::read_csv(sprintf("%s/%s_all_1min_data.csv.gz", DATA_PATH, house_id), col_types=cols(hhID=col_character(), linkID=col_character(), dateTime_orig=col_character(), TZ_orig=col_character(), r_dateTime=col_character(), circuit = col_character(), powerW=col_double())))

	input$time_utc <- parse_date_time(input$r_dateTime, orders=c('ymdHMS'))
	input$time_nz <- with_tz(input$time, "Pacific/Auckland")

	input <- input[input$time_nz >= start_time & input$time_nz < end_time, ]

	# Read in the circuits and extract the circuit code number
	circuit_list <- circuits_input[, house_id]
	circuit_list <- sub(".*\\$", "", circuit_list)
	circuit_list <- circuit_list[circuit_list != ""]


	# Create a boolean array of rows/circuits to be extracted
	cond <- rep(FALSE, length(input$circuit))

	for(circuit in circuit_list){
		cond <- cond | grepl(circuit, input$circuit)
	}

	input <- input[cond, c("time_utc", "time_nz", "powerW")]

	input <- input[,sum(powerW), by="time_nz"]

	colnames(input)[2] <- house_id

	if(is.data.table(data)){
		data <- merge(data, input, by="time_nz", all=TRUE)
	}else{
		data <- input
	}
}

end_exec <- Sys.time()
end_exec - start_exec


write.table(data, file=sprintf("%s/tot.csv", DATA_PATH), sep=",", row.names=FALSE, col.names=TRUE)


