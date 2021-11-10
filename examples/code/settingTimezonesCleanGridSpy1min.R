#--- Shows how to set timezone if you are not in New Zealand ---#

# The r_dateTime variable in the power data is recorded in UTC
# If you load the data in New Zealand R will (probably) automatically
# set the timezone of r_dateTime to Pacific/Auckland.

# But if you load the data in a different timezone (such as the UK), R will 
# (probably) automatically set the timezone of r_dateTime to your local time zone.

# This will mean that any graphs that use the time part of r_dateTime will be 11, 12 or 13 hours
# out depending on the time difference (DST overlaps). This is most clearly visible
# if you try plotting circuits which monitor photovoltaic generation

# Packages we will need
library(data.table) # for loading data very fast. dplyr & readr would also do
library(hms) # for hour:min:sec time processing
library(lubridate) # for all other date & time processing
library(ggplot2) # for plots

# Local parameters ----

# use hhID parameter to change the household used (assumes you have access to the data from https://dx.doi.org/10.5255/UKDA-SN-853334)
hhID <- "rf_19" # this house had PV

# change this to suit your data location
dataPath <- path.expand("~/Dropbox/data/NZ_GREENGrid/ukds/data/powerData/")
# change this to suit your data location & to use a different household
demandFile <- paste0(dataPath,
                 hhID,
                 "_all_1min_data.csv.gz") # you may not have the .gz on your file if it is already uncompressed
# check
file.exists(demandFile)

powerData <- data.table::fread(demandFile)


head(powerData) # you will see that dateTime_orig and r_dateTime appear to be ~ 12 hours apart

# beware: dateTime_orig is a character variable - mostly so it can't easily be altered by accident!
summary(powerData)

# check:

lubridate::tz(powerData$r_dateTime) # should say "UTC"

# Plot the uncorrected time zone
# data.table version of powerData$hms_utc <- hms::as_hms(powerData$r_dateTime)
powerData[, hms_utc := hms::as_hms(r_dateTime)]
# convert to an hour to simplify the plots
powerData[, hourOfDay_utc := lubridate::hour(hms_utc)]

# calculate the mean power by time of day and month for all PV circuits
pv_utc <- powerData[circuit %like% "PV", .(meanW = mean(powerW)), 
                    keyby = .(hourOfDay_utc,
                               month = lubridate::month(r_dateTime, lab = TRUE))]

utc_pv_plot <- ggplot2::ggplot(pv_utc, aes(x = hourOfDay_utc, y = meanW, colour = month)) +
  geom_line() 
utc_pv_plot # you should see that the maximum -ve values (PV generation) are in the middle of the night
# Clearly wrong...
# Note also the maximum -ve values are in December - this is NZ's summer :-)

# Try again with corrected time zone
# NB: specify the timezone here
powerData[, hms_nz := lubridate::with_tz(hms::as_hms(r_dateTime), tz = "Pacific/Auckland")]
# convert to an hour to simplify the plots
powerData[, hourOfDay_nz := lubridate::hour(hms_nz)]

pv_nz <- powerData[circuit %like% "PV", .(meanW = mean(powerW)), 
                    keyby = .(month = lubridate::month(r_dateTime, label = TRUE), # month as a text label
                              hourOfDay_nz)]

nzt_pv_plot <- ggplot2::ggplot(pv_nz, aes(x = hourOfDay_nz, y = meanW, colour = month)) +
  geom_line()
nzt_pv_plot
# you should see that the maximum -ve values (PV generation) are at 12:00 (mid-day)
# Clearly right

