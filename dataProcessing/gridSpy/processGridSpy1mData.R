### ----- About ---- 
# R code to process GREEN grid gridSpy data

# expects to be called from makeFile which will have set parameters used

# Local functions ----

getHhGridSpyData <- function(hh, fileList){
  # Gets all files listed, loads, processes, cleans & merges, saves out in long form
  # Does not check that hh matches file name
  tempHhDT <- data.table::data.table() # (re)create new hh gridSpy data collector for each loop (hh)
  print(paste0("Loading: ", hh))
  pbF <- progress::progress_bar$new(total = length(fileList)) # set progress bar using n files to load
  # X > start of per-file loop ----
  for(f in fileList){ 
    print(paste0("Loading ", f))
    fDT <- data.table::fread(f)
    pbF$tick()
    
    # add hhid for ease of future loading etc
    fDT <- fDT[, hhID := hh]
    
    # >> set default dateTimes ----
    # what is the date column called?
    # Use this to work out which TZ is being applied
    if(nrow(dplyr::select(fDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
      # if we have > 1 row with col name containing 'NZ'
      setnames(fDT, 'date NZ', "dateTime_char")
      fDT <- fDT[, incomingTZ := "date NZ"]
    }
    if(nrow(dplyr::select(fDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
      # if we have > 1 row with col name containing 'UTC'
      setnames(fDT, 'date UTC', "dateTime_char")
      fDT <- fDT[, incomingTZ := "date UTC"]
    }
    
    # This will also have consequences for time - esp related to DST:
    # smb://storage.hcs-p01.otago.ac.nz/hum-csafe/Research Projects/GREEN Grid/_RAW DATA/GridSpyData/README.txt says:
    # "Note that the timestamps may well be problematic - the GridSpy source data used local time,
    # and thus there's instability of data around daylight savings time changes."
    
    # e.g. rf_01 file 1Jan2014-24May2014at1.csv at DST switch on April 6th 2014 simply repeats the 02:00 - 03:00 hour.
    # So this day has 25 hours in it. The date column is named 'date NZ'
    
    # Large files which seem to have been manually downloaded use 'date NZ' and this
    # appears to be local (lived) time with/without DST as appropriate
    
    # The small daily files which were set to auto-download have 'date UTC' as a column name
    # and do indeed appear to be UTC. Where this has DST change, no hours are repeated (as the time is UTC)
    # See e.g. rf_06 1Apr2018-2Apr2018at1.csv (DST @ 02:00 1st April 2018 Pacific/Auckland)
    
    # Using the pre-inferred dateFormat
    fDT <- fDT[, dateFormat := fListToLoadDT[fullPath == f, dateFormat]]
    # Sets timezone to default (UTC) - sort this out later
    fDT <- fDT[dateFormat %like% "mdy",
               r_dateTimeUTC := lubridate::mdy_hm(dateTime_char)] # requires lubridate
    fDT <- fDT[dateFormat %like% "dmy",
               r_dateTimeUTC := lubridate::dmy_hm(dateTime_char)] # requires lubridate
    fDT <- fDT[dateFormat %like% "ydm",
               r_dateTimeUTC := lubridate::ymd_hm(dateTime_char)] # requires lubridate
    fDT <- fDT[dateFormat %like% "ymd",
               r_dateTimeUTC := lubridate::ymd_hm(dateTime_char)] # requires lubridate
    fDT$dateFormat <- NULL # no longer needed
    # We will harmonise these to the correct (lived) 'time' later using the full household file
    
    # Fix labels
    if(hh == "rf_24"){
      # rf_24 has an additional circuit in some files but value is always NA
      fDT <- fixCircuitLabels_rf_24(fDT)
    }
    if(hh == "rf_46"){
      # rf_46 has 3 different versions of the circuit labels
      fDT <- fixCircuitLabels_rf_46(fDT)
    }
    # >> rbind data to hh data collector ----
    tempHhDT <- rbind(tempHhDT, fDT, fill = TRUE) # fill just in case there are different numbers of columns or columns with different names (quite likely - crcuit labels may vary!)
    print(paste0("Done ", f))
    
  } # X > end of per file loop ----
  
  # Switch to long format ----
  # this turns each circuit label (column) into a label within 'variable' and
  # sets value to be the power measurement
  # we then relabel them for clarity
  fLongDT <- reshape2::melt(tempHhDT, id=c("hhID","dateTime_char","r_dateTimeUTC", "incomingTZ"))
  data.table::setnames(fLongDT, "value", "power")
  data.table::setnames(fLongDT, "variable", "circuit")
  
  # force power to be numeric
  fLongDT <- fLongDT[, powerW := as.numeric(power)]
  
  # remove NA after conversion to numeric if present
  fLongDT <- fLongDT[!is.na(powerW)]
  fLongDT$power <- NULL # remove to save space/memory
  
  # >> set some file stats ----
  
  fileDT <- data.table::data.table() # (re)create new file stats data collector for each loop (hh)
  fileDT$fullPath <- f
  fileDT$nObs <- nrow(fDT) # could include duplicates
  # count the number of different circuits
  nCircuits <- fLongDT[, uniqueN(circuit)]
  # get circuit labels
  circuitList <- fLongDT[, toString(unique(circuit))]
  
  # check the names of circuits - all seem to contain "$"; sort them to make it easier to compare them - this is the only way we have to check if data from different households has been placed in the wrong folder.
  fileDT$circuitLabels <- circuitList
  # check for the number of circuits - all seem to contain "$"
  fileDT$nCircuits <- nCircuits
  
  # fix the time zones
  tempHhDT <- tempHhDT[, defaultTZ := lubridate::tz(r_dateTimeUTC)]
  min(tempHhDT$r_dateTimeUTC)
  table(tempHhDT$defaultTZ)
  # if the data was actually NZST then we need to force the tz to be Pacific/Auckland but keep the clock time the same
  tempHhDT <- tempHhDT[incomingTZ %like% "NZ",
                       r_dateTime := lubridate::force_tz(r_dateTimeUTC, 
                                                         tzone = "Pacific/Auckland", roll = TRUE)]
  # If the data was actually UTC then we just tell R to use local time when displaying
  tempHhDT <- tempHhDT[incomingTZ %like% "UTC",
                       r_dateTime := lubridate::with_tz(r_dateTimeUTC, tzone = "Pacific/Auckland")] # datetime stored as UTC
  
  #tempHhDT$r_dateTimeUTC <- NULL # remove
  tempHhDT <- tempHhDT[, finalTZ := lubridate::tz(r_dateTime)]
  min(tempHhDT$r_dateTime)
  table(tempHhDT$defaultTZ, tempHhDT$finalTZ, useNA = "always")
  
  # get rid of any duplicates by dateTime, circuit & power
  dupsBy <- c("r_dateTime", "circuit", "powerW")
  nDups <- anyDuplicated(tempHhDT, by=dupsBy)
  pcDups <- round(100*(nDups/nrow(tempHhDT)), 2)
  print(paste0("Removing ", nDups, " (", pcDups,"%) duplicates by ", toString(dupsBy)))
  tempHhDT <- unique(tempHhDT, by=dupsBy)
  
  # set household level stats by date
  statDT <- tempHhDT[, .(nObs = .N,
                         meanPower = mean(powerW),
                         sdPowerW = sd(powerW),
                         minPowerW = min(powerW),
                         maxPowerW = max(powerW),
                         nCircuits = uniqueN(circuit)), # the actual number of columns in the whole household file with "$" in them in case of rbind "errors" caused by files with different column names
                     keyby = .(hhID, date = lubridate::date(r_dateTime))] # can't do sensible summary stats on W as some circuits are sub-sets of others!
  # > Save hh file ----
  ofile <- paste0(gSpyParams$gSpyOutPath, "data/", hh,"_all_1min_data.csv")
  print(paste0("Saving ", ofile, "..."))
  
  data.table::fwrite(tempHhDT, ofile)
  
  print(paste0("Saved ", ofile, ", gzipping..."))
  cmd <- paste0("gzip -f ", "'", path.expand(ofile), "'") # gzip it - use quotes in case of spaces in file name, expand path if needed
  try(system(cmd)) # in case it fails - if it does there will just be .csv files (not gzipped) - e.g. under windows
  print(paste0("Gzipped ", ofile))
  
  # > Add fStats to end of stats file stats collector
  ofile <- paste0(gSpyParams$fListLoaded) # outPath set in global
  print(paste0("Adding file list stats to ", ofile))
  data.table::fwrite(tempFilesDT, ofile, append=TRUE) # this will only write out column names once when file is created see ?fwrite
  
  # > Add hh stats to end of hh stats collector
  ofile <- paste0(gSpyParams$hhStatsByDate) # outPath set in global
  print(paste0("Add hh stats by date to ", ofile))
  data.table::fwrite(statDT, ofile, , append=TRUE)
  
  # comment out for final
  return(tempHhDT)
}

fixCircuitLabels_rf_24 <- function(dt){
  # rf_24 has an additional circuit in some files but value is always NA so we ignore them
  return(dt)
}


fixCircuitLabels_rf_46 <- function(dt){
  # assumes this is wide (original) format data
  # rf_46 has 3 different versions of the circuit labels:
  # 1: Heat Pumps (2x) & Power$4232, Heat Pumps (2x) & Power$4399, Hot Water - Controlled$4231, Hot Water - Controlled$4400, Incomer - Uncontrolled$4230, Incomer - Uncontrolled$4401, Incomer Voltage$4405, Kitchen & Bedrooms$4229, Kitchen & Bedrooms$4402, Laundry & Bedrooms$4228, Laundry & Bedrooms$4403, Lighting$4233, Lighting$4404
  # 2: Heat Pumps (2x) & Power1$4232, Heat Pumps (2x) & Power2$4399, Hot Water - Controlled1$4231, Hot Water - Controlled2$4400, Incomer - Uncontrolled1$4230, Incomer - Uncontrolled2$4401, Incomer Voltage$4405, Kitchen & Bedrooms1$4229, Kitchen & Bedrooms2$4402, Laundry & Bedrooms1$4228, Laundry & Bedrooms2$4403, Lighting1$4233, Lighting2$4404
  # 3: Heat Pumps (2x) & Power_Imag$4399, Heat Pumps (2x) & Power$4232, Hot Water - Controlled_Imag$4400, Hot Water - Controlled$4231, Incomer - Uncontrolled_Imag$4401, Incomer - Uncontrolled$4230, Incomer Voltage$4405, Kitchen & Bedrooms_Imag$4402, Kitchen & Bedrooms$4229, Laundry & Bedrooms_Imag$4403, Laundry & Bedrooms$4228, Lighting_Imag$4404, Lighting$4233
  # Fix to just the first (might also fix duplication of observations)
  
  
    if(gSpyParams$fullFb){print("Checking circuit labels for rf_46")}
    # check if we have the second form of labels - they have 'Power1$4232' in one col label
    checkCols2 <- ncol(dplyr::select(dt,dplyr::contains("Power1$4232")))
    if(checkCols2 == 1){
      # we got label set 2
      if(gSpyParams$fullFb){print(paste0("Found circuit labels set 2 in ", f))}
      setnames(fDT, c("Heat Pumps (2x) & Power1$4232", "Heat Pumps (2x) & Power2$4399",
                      "Hot Water - Controlled1$4231", "Hot Water - Controlled2$4400",
                      "Incomer - Uncontrolled1$4230", "Incomer - Uncontrolled2$4401",
                      "Incomer Voltage$4405", "Kitchen & Bedrooms1$4229",
                      "Kitchen & Bedrooms2$4402","Laundry & Bedrooms1$4228",
                      "Laundry & Bedrooms2$4403", "Lighting1$4233", "Lighting2$4404"),
               c("Heat Pumps (2x) & Power$4232", "Heat Pumps (2x) & Power$4399", "Hot Water - Controlled$4231",
                 "Hot Water - Controlled$4400", "Incomer - Uncontrolled$4230", "Incomer - Uncontrolled$4401",
                 "Incomer Voltage$4405", "Kitchen & Bedrooms$4229", "Kitchen & Bedrooms$4402",
                 "Laundry & Bedrooms$4228", "Laundry & Bedrooms$4403", "Lighting$4233", "Lighting$4404"))
    }
    # check if we have the third form of labels - they have 'Power_Imag$4399' in one col label
    checkCols3 <- ncol(dplyr::select(dt,dplyr::contains("Power_Imag$4399")))
    if(checkCols3 == 1){
      # we got label set 3
      if(gSpyParams$fullFb){print(paste0("Found circuit labels set 3 in ", f))}
      # be careful to get this order correct so that it matches the label 1 order
      setnames(dt, c("Heat Pumps (2x) & Power$4232", "Heat Pumps (2x) & Power_Imag$4399",
                      "Hot Water - Controlled$4231", "Hot Water - Controlled_Imag$4400",
                      "Incomer - Uncontrolled$4230", "Incomer - Uncontrolled_Imag$4401", "Incomer Voltage$4405",
                      "Kitchen & Bedrooms$4229", "Kitchen & Bedrooms_Imag$4402",
                      "Laundry & Bedrooms$4228", "Laundry & Bedrooms_Imag$4403",
                      "Lighting$4233", "Lighting_Imag$4404"),
               c("Heat Pumps (2x) & Power$4232", "Heat Pumps (2x) & Power$4399",
                 "Hot Water - Controlled$4231", "Hot Water - Controlled$4400",
                 "Incomer - Uncontrolled$4230", "Incomer - Uncontrolled$4401", "Incomer Voltage$4405",
                 "Kitchen & Bedrooms$4229", "Kitchen & Bedrooms$4402",
                 "Laundry & Bedrooms$4228", "Laundry & Bedrooms$4403",
                 "Lighting$4233", "Lighting$4404"))
    }
  return(dt)
}

# Code ----

# > Housekeeping ----

try(file.remove(gSpyParams$hhStatsByDate)) # otherwise the append within the get data function will keep adding
try(file.remove(gSpyParams$fListLoaded)) # otherwise the append within the get data function will keep adding

# > Get file list ----
fListAllDT <- nzGREENGridDataR::getGridSpyFileList(gSpyParams$gSpyInPath, # where to look
                                                   gSpyParams$pattern, # what to look for
                                                   gSpyParams$gSpyFileThreshold # file size threshold
                                                   )

# > Fix ambiguous dates in meta data derived from file listing ----
fListAllDT <- nzGREENGridDataR::fixAmbiguousDates(fListAllDT)

# > Save the full list listing ----
ofile <- paste0(gSpyParams$fListAll) # outPath set in global
print(paste0("Saving 1 minute data files interim metadata to ", ofile))
data.table::fwrite(fListAllDT, ofile)

print(paste0("Overall we have ", nrow(fListAllDT), " files from ",
             uniqueN(fListAllDT$hhID), " households."))

fListToLoadDT <- fListAllDT[!(dateColName %like% "ignore")] # file stats data collector for files we intend to load
hhIDs <- unique(fListToLoadDT$hhID) # list of household ids



# for each hhID:

# hh <- "rf_06"
# fileList <- fListToLoadDT[hhID == hh, fullPath] # files for this household
# hhLongDT <- getHhGridSpyData(hh,fileList)

