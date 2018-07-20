#' Checks the dates of a date_char column in a data.table
#'
#' \code{checkDates} takes a data.table and splits the `date_char` column on either `/` or `-` (tries each).
#'
#' Expects `date_char` to have the format x-x-x or x/x/x
#'
#' Puts the results into 3 new columns () and returns the dt.
#'
#' @param dt the data.table
#'
#' @importFrom data.table tstrsplit
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
#'
checkDates <- function(dt) {
  # Check the date format as it could be y-m-d or d/m/y or m/d/y :-(
  dt <- dt[, c("date_char1","date_char2", "date_char3") := data.table::tstrsplit(date_char, "/")]
  # if this split failed then tstrsplit puts the dateVar in each one so we can check
  # this assumes we never have 9-9-9 10-10-10 or 11-11-11 or 12-12-12 !
  # would be better if data.table::tstrsplit returned an error if the split failed? We could then check for NA?
  dt <- dt[, splitFailed := ifelse(date_char1 == date_char2 & date_char1 == date_char3, TRUE, FALSE)]
  # and then split on / instead
  dt <- dt[splitFailed == TRUE, c("date_char1","date_char2", "date_char3") := data.table::tstrsplit(date_char, "-")] # requires data.table

  dt$dateFormat <- "ambiguous" # default
  # Days: 1-31
  # Months: 1 - 12
  # Years: could be 2 digit 15 - 18 or 4 digit 2015 - 2018 (+)
  max1 <- max(as.integer(dt$date_char1))
  #print(paste0("max1 = " , max1))
  max2 <- max(as.integer(dt$date_char2))
  #print(paste0("max2 = " , max2))
  max3 <- max(as.integer(dt$date_char3))
  #print(paste0("max3 = " , max3))

  if(max1 > 31){
    # char 1 = year so default is ymd
    dt$dateFormat <- "ymd - default (but day/month value <= 12)"
    if(max2 > 12){
      # char 2 = day - very unlikely
      dt$dateFormat <- "ydm"
    }
    if(max3 > 12){
      # char 3 = day
      dt$dateFormat <- "ymd - definite"
    }
  }
  if(max2 > 31){
    # char 2 is year - this is very unlikely
    if(max1 > 12){
      # char 1 = day
      dt$dateFormat <- "dym"
    }
    if(max3 > 12){
      # char 3 = day
      dt$dateFormat <- "myd"
    }
  }
  if(max3 > 31){
    # char 3 is year so default is dmy
    dt$dateFormat <- "dmy - default (but day/month value <= 12)"
    if(max1 > 12){
      # char 1 = day so char 2 = month
      dt$dateFormat <- "dmy - definite"
    }
    if(max2 > 12){
      # char 2 = day so char 1 = month
      dt$dateFormat <- "mdy - definite"
    }
  }
  return(dt)
}

#' Fixes ambiguous dates
#'
#' \code{fixAmbiguousDates} takes a data.table, fixes dates in dateFormat column and returns the dt.
#'
#' @param dt the data.table
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
fixAmbiguousDates <- function(dt){
  aList <- dt[dateFormat == "ambiguous",
              .(file, dateColName, dateExample, dateFormat)]
  # Setting to dmy seems OK
  dt <- dt[dateFormat == "ambiguous",
           dateFormat := "dmy - inferred"]

  print(paste0("Fixed ", nrow(aList), " files with an ambiguous dateFormat"))
  return(dt)
}

#' Gets a list of gridSpy data files matching a pattern
#'
#' \code{getGridSpyFileList} takes a file path, searches for files matching pattern and returns the filelist as a data.table with metadata.
#'
#'     Also saves out the metadata as an interim file
#'
#' @param fpath where to look (recursively)
#' @param pattern the pattern to match
#' @param dataThreshold the file size threshold (files smaller than this will be ignored as we assume they have no data)
#' @param mf name of file to save interim file list and meta data to
#'
#' @import dplyr
#' @import data.table
#' @import lubridate
#' @import progress
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
getGridSpyFileList <- function(fpath, pattern, dataThreshold){
  print(paste0("Looking for data using pattern = ", pattern, " in ", fpath, " - could take a while..."))
  # > Get the file list as a data.table ----
  fList <- list.files(path = fpath, pattern = pattern, # use to filter e.g. 1m from 30s files
                      recursive = TRUE)
  if(length(fList) == 0){ # if there are no files in the list...
    print(paste0("No matching data files found, please check your path (", fpath, 
                 ") or your search pattern (", pattern, ")"))
    dt <- data.table::as.data.table(NULL)
  } else {
    dt <- data.table::as.data.table(fList) # the column name will be fList
  }

  nFiles <- nrow(dt)
  print(paste0("Found ", tidyNum(nFiles), " files"))

  #> Process file metadata ----

  if(nrow(dt) == 0){
    # Then no files were found - should have been caught previously but...
    stop(paste0("No matching data files found, please check your path (", fpath,
                ") or your search pattern (", pattern1Min, "). If using /hum-csafe/ are you connected to it?!"))
  } else {
    print(paste0("Processing file list and getting file meta-data including checking date formats."))
    dt <- dt[, c("hhID","fileName") := data.table::tstrsplit(fList, "/")]
    dt <- dt[, fullPath := paste0(fpath, hhID,"/",fileName)]
    loopCount <- 1
    # now loop over the files and collect metadata
    pb <- progress::progress_bar$new(total = nrow(dt)) # set progress bar
    for(f in dt[,fullPath]){
      pb$tick()
      rf <- path.expand(f) # just in case of ~ etc
      fsize <- file.size(rf)
      fmtime <- lubridate::ymd_hms(file.mtime(rf), tz = "Pacific/Auckland") # requires lubridate
      dt <- dt[fullPath == f, fSize := fsize]
      dt <- dt[fullPath == f, fMTime := fmtime]
      dt <- dt[fullPath == f, fMDate := as.Date(fmtime)]
      dt <- dt[fullPath == f, dateColName := paste0("Unknown - ignore as fsize ( ", 
                                                    fsize, " ) < dataThreshold ( ", 
                                                    dataThreshold, " )")]
      # only try to read files where we think there might be data
      loadThis <- ifelse(fsize > dataThreshold, 
                         paste0("Loading (fsize (", fsize, ") > ", dataThreshold, ")"),
                         paste0("Skipping (fsize (", fsize, ") < ", dataThreshold, ")")
                         )
      if(gSpyParams$fullFb){print(paste0("Checking file ", loopCount, " of ", nFiles ,
                              " (", round(100*(loopCount/nFiles),2), "% checked): ", loadThis))}
      if(fsize > dataThreshold){
        if(gSpyParams$fullFb){print(paste0("fSize (", fsize, ") > ", 
                                           dataThreshold, ") -> loading ", f))}
        row1DT <- fread(f, nrows = 1)
        # what is the date column called?
        dt <- dt[fullPath == f, dateColName := "unknown - can't tell"]
        if(nrow(dplyr::select(row1DT, dplyr::contains("NZ"))) > 0){ # requires dplyr
          setnames(row1DT, 'date NZ', "dateTime_orig")
          row1DT <- row1DT[, dateColName := "date NZ"]
          dt <- dt[fullPath == f, dateColName := "date NZ"]
        }
        if(nrow(dplyr::select(row1DT, dplyr::contains("UTC"))) > 0){ # requires dplyr
          setnames(row1DT, 'date UTC', "dateTime_orig")
          row1DT <- row1DT[, dateColName := "date UTC"]
          dt <- dt[fullPath == f, dateColName := "date UTC"]
        }
        # split dateTime
        row1DT <- row1DT[, c("date_char", "time_char") := data.table::tstrsplit(dateTime_orig, " ")]
        # add example of date to metadata - presumably they are the same in each file?!
        dt <- dt[fullPath == f, dateExample := row1DT[1, date_char]]

        if(gSpyParams$fullFb){print(paste0("Checking date formats in ", f))}
        testDT <- checkDates(row1DT)
        dt <- dt[fullPath == f, dateFormat := testDT[1, dateFormat]]
        dt <- dt[fullPath == f, dateFormat := testDT[1, dateFormat]]
        if(gSpyParams$fullFb){print(paste0("Done ", f))}
      }
      loopCount <- loopCount + 1
    }
    print("All files checked")

    # any date formats are still ambiguous need a deeper inspection using the full file - could be slow
    fAmbig <- dt[dateFormat == "ambiguous", fullPath] # get ambiguous files as a list
    if(length(fAmbig) > 0){ # there were some
      pbA <- progress::progress_bar$new(total = length(fAmbig))
      for(fa in fAmbig){
        if(gSpyParams$fullFb){print(paste0("Checking ambiguous date formats in ", fa))}
        ambDT <- fread(fa)
        pbA$tick()
        if(nrow(dplyr::select(ambDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
          setnames(ambDT, 'date NZ', "dateTime_orig")
        }
        if(nrow(dplyr::select(ambDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
          setnames(ambDT, 'date UTC', "dateTime_orig")
        }
        ambDT <- ambDT[, c("date_char", "time_char") := data.table::tstrsplit(dateTime_orig, " ")]
        ambDT <- checkDates(ambDT)
        # set what we now know (or guess!)
        dt <- dt[fullPath == fa, dateFormat := ambDT[1,dateFormat]]
      }
    }
    dt <- setnames(dt, "fList", "file")
    print("Done")
  }
  return(dt)
}

#' Loads and processes a list of gridSpy data files for a given household
#'
#' \code{getHhGridSpyData} takes a file list and loads & processes data before returning the data.table for checks & saving. 
#'     
#'     What it does:
#'     
#'     - Updates the per input file metadata as it loops over each file
#'     
#'     - Fixes circuit labels for rf_46
#'     
#'     - Concatenates (rbinds) the files into a data.table and converts to long form for easier re-use
#'     
#'     - Splits original circuit name by $ into a label (first string) and an id (second string)
#'     
#'     - Attempts to create a correct r_dateTime in UTC but with tz set to "Pacific/Auckland"
#'     
#'     - Removes duplicates by r_dateTime <-> circuit <-> power caused by data from duplicate files. Note that this will retain the DST induced duplicate dateTimes if the power values are different (see below)
#'     
#'     - Removes any cases where power = NA
#'     
#'     - Returns the data.table
#' 
#'     Things to note...
#'    
#'      The function assumes all data in the fileList is for one household (can only be detected from input file path)
#'    
#'      The original data is sometimes stored as UTC (auto-downloads) & sometimes as NZ time (manual downloads). 
#'    
#'      If the original data was actually NZ time then we parse it with tz = Pacific/Auckland. It is not clear what will happen at the DST break.
#'      
#'      If the original data was actually UTC then we parse it with the default tz = UTC and then set to Pacific/Auckland. Note that this will create 
#'      duplicate r_dateTimes during the DST break when there is an extra hour and thus two moments of time with the same r_dateTime.
#'      
#'      Any true duplicates by r_dateTime <-> circuit <-> power are then removed (see above) to deal with duplicate data files. 
#'      However this will also remove observations around the DST break which are different moments of time but have the same 
#'      r_dateTime (as one of them is in the DST break hour) and by chance the same power values in the same circuits. Got that?
#'      
#'      Due to uncertainties over the timezones and dateTimes, we recommend that analysis should exclude the days on which DST changes occur.
#'      
#'      #YMMV
#'    
#'      Loading the resulting saved data from .csv will probably set the tz of r_dateTime to your local time. Be sure to set it to
#'      correctly using lubridate::with_tz(r_dateTime, tzone = "Pacific/Auckland")
#'      
#' @param hh the household id
#' @param fileList list of files to load (assumed to be all from hh)
#'
#' @import dplyr
#' @import data.table
#' @import lubridate
#' @import progress
#' @import reshape2
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
processHhGridSpyData <- function(hh, fileList){
  # Gets all files listed, loads, processes, cleans & merges, saves out in long form
  # Does not check that hh matches file path - XX TO DO XX
  tempHhDT <- data.table::data.table() # (re)create new hh gridSpy data collector for each loop (hh)
  nFiles <- length(fileList)
  print(paste0(hh, ": Loading ", nFiles, " files..."))
  pbF <- progress::progress_bar$new(total = length(fileList)) # set progress bar using n files to load
  # X > start of per-file loop ----
  for(f in fileList){ 
    if(gSpyParams$fullFb){print(paste0("Loading ", f))}
    fDT <- data.table::fread(f)
    pbF$tick()
    
    # add hhid for ease of future loading etc
    fDT <- fDT[, hhID := hh]
    
    # Fix labels in households where strange things seemed to have happened
    if(hh == "rf_24"){
      # rf_24 has an additional circuit in some files but value is always NA
      print(paste0(hh, ": Fixing rf_24 labels"))
      fDT <- fixCircuitLabels_rf_24(fDT)
    }
    if(hh == "rf_46"){
      # rf_46 has 3 different versions of the circuit labels
      print(paste0(hh, ": Fixing rf_46 labels"))
      fDT <- fixCircuitLabels_rf_46(fDT)
    }
    
    
    # >> set default dateTimes ----
    
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
    
    # what is the date column called?
    # Use this to work out which TZ is being applied
    if(nrow(dplyr::select(fDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
      # if we have > 1 row with col name containing 'NZ'
      # in fact this means all rows will have NZ time
      TZ_orig <- "date NZ"
      setnames(fDT, 'date NZ', "dateTime_orig")
      fDT <- fDT[, TZ_orig := "date NZ"]
      # Original data is NZ time - what this means for the DST break is unclear
      fDT <- fDT[dateFormat %like% "mdy",
                 r_dateTime := lubridate::mdy_hm(dateTime_orig, tz = "Pacific/Auckland")]
      fDT <- fDT[dateFormat %like% "dmy",
                 r_dateTime := lubridate::dmy_hm(dateTime_orig, tz = "Pacific/Auckland")]
      fDT <- fDT[dateFormat %like% "ydm",
                 r_dateTime := lubridate::ydm_hm(dateTime_orig, tz = "Pacific/Auckland")]
      fDT <- fDT[dateFormat %like% "ymd",
                 r_dateTime := lubridate::ymd_hm(dateTime_orig, tz = "Pacific/Auckland")]
    }
    if(nrow(dplyr::select(fDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
      # as above
      TZ_orig <- "date UTC"
      setnames(fDT, 'date UTC', "dateTime_orig")
      fDT <- fDT[, TZ_orig := "date UTC"]
      # Original data is UTC time
      fDT <- fDT[dateFormat %like% "mdy",
                 r_dateTimeUTC := lubridate::mdy_hm(dateTime_orig)] # UTC by default
      fDT <- fDT[dateFormat %like% "dmy",
                 r_dateTimeUTC := lubridate::dmy_hm(dateTime_orig)] # UTC by default
      fDT <- fDT[dateFormat %like% "ydm",
                 r_dateTimeUTC := lubridate::ydm_hm(dateTime_orig)] # UTC by default
      fDT <- fDT[dateFormat %like% "ymd",
                 r_dateTimeUTC := lubridate::ymd_hm(dateTime_orig)] # requires lubridate
      fDT <- fDT[, r_dateTime := lubridate::with_tz(r_dateTimeUTC, tzone = "Pacific/Auckland")] # set to NZ
      fDT$r_dateTimeUTC <- NULL # not needed, also messes up the reshape as it may/not be present
    }
    
    fDT$dateFormat <- NULL # no longer needed
    
    # >> set some file stats ----
    #print("Getting file stats")
    fileStat <- list()
    fileStat$hhID <- hh
    
    fileStat$fullPath <- f
    
    fileStat$nObs <- nrow(fDT) # could include duplicates
    fileStat$minDateTime <- min(fDT$r_dateTime)
    fileStat$maxDateTime <- max(fDT$r_dateTime)
    fileStat$TZ_orig <- toString(unique(fDT$TZ_orig))
    fileStat$dateFormat <- fListToLoadDT[fullPath == f, dateFormat]
    fileStat$mDateTime <- fListToLoadDT[fullPath == f, fMTime]
    fileStat$fSize <- fListToLoadDT[fullPath == f, fSize]
    
    # check for the number of circuits - all seem to contain "$"
    fileStat$nCircuits <- ncol(dplyr::select(fDT, dplyr::contains("$")))
    
    # check the names of circuits - all seem to contain "$"; sort them to make it easier to compare them 
    # - this is the only way we have to check if data from different households has been placed in the wrong folder.
    fileStat$circuitLabels <- toString(sort(colnames(dplyr::select(fDT, dplyr::contains("$")))))
    
    # >> save file stats ----
    #print("Saving file stats")
    ofile <- gSpyParams$fLoadedStats
    #print(paste0("Saving ", ofile, "..."))
    data.table::fwrite(data.table::as.data.table(fileStat), # convert to DT for writing out
                       ofile, 
                       append = TRUE) # will only write out col names on first pass
    
    # >> rbind data to the hh data collector ----
    tempHhDT <- rbind(tempHhDT, fDT, fill = TRUE) # fill just in case there are different numbers of columns or columns with different names (quite likely - crcuit labels may vary!)
  
  } # X > end of per file loop ----
  print(paste0(hh, ": Done, cleaning rbound files"))
  

  # Switch to long format ----
  # this turns each circuit label (column) into a label within 'variable' and
  # sets value to be the power measurement
  print(paste0(hh, ": wide form variables -> ", toString(names(tempHhDT))))
  # we then relabel them for clarity
  hhLongDT <- reshape2::melt(tempHhDT, id=c("hhID","dateTime_orig", "TZ_orig", "r_dateTime"))
  data.table::setnames(hhLongDT, "value", "power")
  data.table::setnames(hhLongDT, "variable", "circuit")
  
  print(paste0(hh, ": switched to long form"))
  
  # > Force power to be numeric ----
  hhLongDT <- hhLongDT[, powerW := as.numeric(power)]
  
  # remove NA after conversion to numeric if present
  hhLongDT <- hhLongDT[!is.na(powerW)]
  hhLongDT$power <- NULL # remove to save space/memory
  
  print(paste0(hh, ": removed powerW = NA"))
  
  # > Remove any duplicates by dateTime, circuit & power ----

  dupsBy <- c("r_dateTime", "circuit", "powerW")
  nDups <- anyDuplicated(hhLongDT, by=dupsBy)
  pcDups <- round(100*(nDups/nrow(hhLongDT)), 2)
  print(paste0(hh, ": removing ", nDups, " (", pcDups,"%) duplicates by ", toString(dupsBy)))
  hhLongDT <- unique(hhLongDT, by=dupsBy)
  
  # Create clean circuit labels
  hhLongDT <- hhLongDT[, c("circuitLabel", "circuitID") := tstrsplit(circuit, "$", fixed = TRUE)]
  
  hhLongDT$circuit <- NULL # no longer needed
  
  setkey(hhLongDT, r_dateTime, circuitLabel) # force dateTime & circuit order
  print(paste0(hh, ": final long form variables ->", toString(names(hhLongDT))))
  
  return(hhLongDT) # for saving etc
}

#' Fixes circuit labels in rf_24
#'    
#' \code{fixCircuitLabels_rf_24} is a stub that could be used to fix circuit labels.
#'     rf_24 has an additional circuit in some files but value is always NA so we ignore them (no fix).
#'    
#' @param dt wide-form (original) datat table to fix & return
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
#'
fixCircuitLabels_rf_24 <- function(dt){
  # rf_24 has an additional circuit in some files but value is always NA so we ignore them
  return(dt)
}

#' Fixes circuit labels in rf_46
#'
#' \code{fixCircuitLabels_rf_46} is a stub that could be used to fix circuit labels.
#'     rf_46 has 3 different versions of the circuit labels:
#'     1: Heat Pumps (2x) & Power$4232, Heat Pumps (2x) & Power$4399, Hot Water - Controlled$4231, Hot Water - Controlled$4400, Incomer - Uncontrolled$4230, Incomer - Uncontrolled$4401, Incomer Voltage$4405, Kitchen & Bedrooms$4229, Kitchen & Bedrooms$4402, Laundry & Bedrooms$4228, Laundry & Bedrooms$4403, Lighting$4233, Lighting$4404
#'     2: Heat Pumps (2x) & Power1$4232, Heat Pumps (2x) & Power2$4399, Hot Water - Controlled1$4231, Hot Water - Controlled2$4400, Incomer - Uncontrolled1$4230, Incomer - Uncontrolled2$4401, Incomer Voltage$4405, Kitchen & Bedrooms1$4229, Kitchen & Bedrooms2$4402, Laundry & Bedrooms1$4228, Laundry & Bedrooms2$4403, Lighting1$4233, Lighting2$4404
#'     3: Heat Pumps (2x) & Power_Imag$4399, Heat Pumps (2x) & Power$4232, Hot Water - Controlled_Imag$4400, Hot Water - Controlled$4231, Incomer - Uncontrolled_Imag$4401, Incomer - Uncontrolled$4230, Incomer Voltage$4405, Kitchen & Bedrooms_Imag$4402, Kitchen & Bedrooms$4229, Laundry & Bedrooms_Imag$4403, Laundry & Bedrooms$4228, Lighting_Imag$4404, Lighting$4233
#'     
#'     Was it re-used 3 times? Probably not as the labels are almost identical.
#'     
#'     This function fixes the labels to just the first (might also fix duplication of observations)
#'    
#' @param dt wide-form (original) datat table to fix & return
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
fixCircuitLabels_rf_46 <- function(dt){
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

