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
    print(paste0("No matching data files found, please check your path (", fpath, ") or your search pattern (", pattern, ")"))
    dt <- data.table::as.data.table(NULL)
  } else {
    dt <- data.table::as.data.table(fList) # the column name will be fList
  }

  nFiles <- nrow(dt)
  print(paste0("Found ", tidyNum(nFiles), " files"))

  #> Process file metadata ----

  if(nrow(dt) == 0){
    # Then no files were found - should have been caught previously but...
    stop(paste0("No matching data files found, please check your path (", fpath, ") or your search pattern (", pattern1Min, "). If using /hum-csafe/ are you connected to it?!"))
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
                                                    fsize, " ) < dataThreshold ( ", dataThreshold, " )")]
      # only try to read files where we think there might be data
      loadThis <- ifelse(fsize > dataThreshold, "Loading (fsize > threshold)", "Skipping (fsize < threshold)")
      if(gSpyParams$fullFb){print(paste0("Checking file ", loopCount, " of ", nFiles ,
                              " (", round(100*(loopCount/nFiles),2), "% checked): ", loadThis))}
      if(fsize > dataThreshold){
        if(gSpyParams$fullFb){print(paste0("fSize (", fsize, ") > threshold (", dataThreshold, ") -> loading ", f))}
        row1DT <- fread(f, nrows = 1)
        # what is the date column called?
        dt <- dt[fullPath == f, dateColName := "unknown - can't tell"]
        if(nrow(dplyr::select(row1DT, dplyr::contains("NZ"))) > 0){ # requires dplyr
          setnames(row1DT, 'date NZ', "dateTime_char")
          row1DT <- row1DT[, dateColName := "date NZ"]
          dt <- dt[fullPath == f, dateColName := "date NZ"]
        }
        if(nrow(dplyr::select(row1DT, dplyr::contains("UTC"))) > 0){ # requires dplyr
          setnames(row1DT, 'date UTC', "dateTime_char")
          row1DT <- row1DT[, dateColName := "date UTC"]
          dt <- dt[fullPath == f, dateColName := "date UTC"]
        }
        # split dateTime
        row1DT <- row1DT[, c("date_char", "time_char") := data.table::tstrsplit(dateTime_char, " ")]
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
        if(gSpyParams$localTest | gSpyParams$fullFb){print(paste0("Checking ambiguous date formats in ", fa))}
        ambDT <- fread(fa)
        pbA$tick()
        if(nrow(dplyr::select(ambDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
          setnames(ambDT, 'date NZ', "dateTime_char")
        }
        if(nrow(dplyr::select(ambDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
          setnames(ambDT, 'date UTC', "dateTime_char")
        }
        ambDT <- ambDT[, c("date_char", "time_char") := data.table::tstrsplit(dateTime_char, " ")]
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
#' \code{getHhGridSpyData} takes a file list and loads & processes data before saving out 1 file. 
#'    It assumes all data is for one household (can only be detected from input file names)
#'
#'    Updates the per input file metadata and the per household per day summary stats file
#'    
#' @param hh the household id
#' @param fileList list of files to load
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
getHhGridSpyData <- function(hh, fileList){
  print(paste0("Running getHhGridSpyData from package functions to load files for ", hh))
}

#' Loads and processes a list of gridSpy data files
#'
#' \code{processGridSpyDataFiles} takes a file list (as a dt with attributes) and loads & processes data before saving out 1 file per household.
#'
#'    Updates the global file list and saves out the updated metadata
#'
#' @param dt list of files to load
#' @param mf name of file to save interim file list and meta data to
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
processGridSpyDataFiles <- function(dt, mf){
  #> Load, process & save the ones which probably have data ----
  dt <- dt[, fileLoaded := "No"] # set default
  # select those which we decided were large enough to probably have data
  filesToLoadDT <- dt[!(dateColName %like% "do not load")]
  hhIDs <- unique(dt$hhID) # list of household ids
  hhStatDT <- data.table::data.table() # stats collector

  for(hh in hhIDs){ # X > start of per household loop ----
    tempHhLongDT <- data.table::data.table() # hh data collector
    print(paste0("Loading: ", hh))
    filesToLoad <- filesToLoadDT[hhID == hh, fullPath]
    pbF <- progress::progress_bar$new(total = length(filesToLoad))
    for(f in filesToLoad){ # XX >> start of per-file loop ----
      if(gSpyParams$fullFb){print(paste0("File size (", f, ") = ",
                              dt[fullPath == f, fSize],
                              " so probably OK"))} # files under 3kb are probably empty
      # attempt to load the file
      fDT <- data.table::fread(f)
      pbF$tick()
      if(gSpyParams$fullFb){print("File loaded")}
      # set some file stats
      dt <- dt[fullPath == f, fileLoaded := "Yes"]
      dt <- dt[fullPath == f, nObs := nrow(fDT)] # could include duplicates

      # what is the date column called?
      # Use this to work out which TZ is being applied
      if(nrow(dplyr::select(fDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
        # if we have > 1 row with col name containing 'NZ'
        setnames(fDT, 'date NZ', "dateTime_char")
        fDT <- fDT[, dateColName := "date NZ"]
      }
      if(nrow(dplyr::select(fDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
        # if we have > 1 row with col name containing 'UTC'
        setnames(fDT, 'date UTC', "dateTime_char")
        fDT <- fDT[, dateColName := "date UTC"]
      }

      # >> Fix dates ----
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

      # We need to harmonise these to the correct (lived) 'time'. Somehow

      # Using the pre-inferred dateFormat
      # Sets timezone to default (UTC) - sort this out later
      fDT <- fDT[, dateFormat := dt[fullPath == f, dateFormat]]
      fDT <- fDT[dateFormat %like% "mdy",
                       r_dateTimeUTC := lubridate::mdy_hm(dateTime_char)] # requires lubridate
      fDT <- fDT[dateFormat %like% "dmy",
                       r_dateTimeUTC := lubridate::dmy_hm(dateTime_char)] # requires lubridate
      fDT <- fDT[dateFormat %like% "ydm",
                       r_dateTimeUTC := lubridate::ymd_hm(dateTime_char)] # requires lubridate
      fDT <- fDT[dateFormat %like% "ymd",
                       r_dateTimeUTC := lubridate::ymd_hm(dateTime_char)] # requires lubridate
      fDT$dateFormat <- NULL # no longer needed
      if(gSpyParams$fullFb){
        print(head(fDT))
        print(summary(fDT))
        #print(table(fDT$dateFormat))
      }

      dt <- dt[fullPath == f, obsStartDate := min(as.Date(fDT$r_dateTime))] # should be a sensible number and not NA
      dt <- dt[fullPath == f, obsEndDate := max(as.Date(fDT$r_dateTime))] # should be a sensible number and not NA
      dt <- dt[fullPath == f, nObs := nrow(fDT)]

      # >> Fix circuit labels where we have noticed errors ----
      # rf_24 has an additional circuit in some files but value is always NA
      # rf_46 has 3 different versions of the circuit labels:
      # 1: Heat Pumps (2x) & Power$4232, Heat Pumps (2x) & Power$4399, Hot Water - Controlled$4231, Hot Water - Controlled$4400, Incomer - Uncontrolled$4230, Incomer - Uncontrolled$4401, Incomer Voltage$4405, Kitchen & Bedrooms$4229, Kitchen & Bedrooms$4402, Laundry & Bedrooms$4228, Laundry & Bedrooms$4403, Lighting$4233, Lighting$4404
      # 2: Heat Pumps (2x) & Power1$4232, Heat Pumps (2x) & Power2$4399, Hot Water - Controlled1$4231, Hot Water - Controlled2$4400, Incomer - Uncontrolled1$4230, Incomer - Uncontrolled2$4401, Incomer Voltage$4405, Kitchen & Bedrooms1$4229, Kitchen & Bedrooms2$4402, Laundry & Bedrooms1$4228, Laundry & Bedrooms2$4403, Lighting1$4233, Lighting2$4404
      # 3: Heat Pumps (2x) & Power_Imag$4399, Heat Pumps (2x) & Power$4232, Hot Water - Controlled_Imag$4400, Hot Water - Controlled$4231, Incomer - Uncontrolled_Imag$4401, Incomer - Uncontrolled$4230, Incomer Voltage$4405, Kitchen & Bedrooms_Imag$4402, Kitchen & Bedrooms$4229, Laundry & Bedrooms_Imag$4403, Laundry & Bedrooms$4228, Lighting_Imag$4404, Lighting$4233
      # Fix to just the first (might also fix duplication of observations)
      if(hh == "rf_46"){
        if(gSpyParams$fullFb){print("Checking circuit labels for rf_46")}
        # check if we have the second form of labels - they have 'Power1$4232' in one col label
        checkCols2 <- ncol(dplyr::select(fDT,dplyr::contains("Power1$4232")))
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
        checkCols3 <- ncol(dplyr::select(fDT,dplyr::contains("Power_Imag$4399")))
        if(checkCols3 == 1){
          # we got label set 3
          if(gSpyParams$fullFb){print(paste0("Found circuit labels set 3 in ", f))}
          # be careful to get this order correct so that it matches the label 1 order
          setnames(fDT, c("Heat Pumps (2x) & Power$4232", "Heat Pumps (2x) & Power_Imag$4399",
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
      }
      # > add vars & switch to long form ----
      # add hhid for ease of future loading etc
      fDT <- fDT[, hhID := hh]
      # switch to long format for easy future loading
      # this turns each circuit label (column) into a label within 'variable' and
      # sets value to be the power measurement
      # we then relabel them for clarity
      fLongDT <- reshape2::melt(fDT, id=c("hhID","dateTime_char","r_dateTimeUTC", "dateColName"))
      data.table::setnames(fLongDT, "value", "power")
      data.table::setnames(fLongDT, "variable", "circuit")
      # force numeric
      fLongDT <- fLongDT[, powerW := as.numeric(power)]
      
      # remove NA after conversion to numeric if present
      fLongDT <- fLongDT[!is.na(powerW)]
      fLongDT$power <- NULL # remove to save space/memory
      
      # check the names of circuits - all seem to contain "$"; sort them to make it easier to compare them - this is the only way we have to check if data from different households has been placed in the wrong folder.
      dt <- dt[fullPath == f,
               circuitLabels := toString(sort(colnames(dplyr::select(tempDT,
                                                                     dplyr::contains("$")))))]
      # check for the number of circuits - all seem to contain "$"
      dt <- dt[fullPath == f, nCircuits := ncol(dplyr::select(tempDT,
                                                              dplyr::contains("$")))]
      #tempDT <- tempDT[, sourceFile := f] # record for later checks - don't as it breaks de-duplication code

      # >> rbind file to hh data collector ----
      tempHhLongDT <- rbind(tempHhLongDT, fLongDT, fill = TRUE) # fill just in case there are different numbers of columns or columns with different names (quite likely - crcuit labels may vary!)
      #fLongDT <- NULL # uncomment this if you don't need it for error checking (will be the last file loaded)
    } # XX >> end of per-file loop ----
    
    # Set correct time zone
    
    #tempHhLongDT <- tempHhLongDT[, defaultTZ := lubridate::tz(r_dateTimeUTC)]
    
    #table(tempHhLongDT$defaultTZ, useNA = "always")
    
    tempHhLongDT <- tempHhLongDT[dateColName %like% "UTC",
                     r_dateTime := lubridate::force_tz(r_dateTimeUTC, tzone = "Pacific/Auckland", roll = TRUE)] # requires lubridate
    tempHhLongDT <- tempHhLongDT[dateColName %like% "NZ",
                     r_dateTime := r_dateTimeUTC] # it wasn't actually UTC
    tempHhLongDT$r_dateTimeUTC <- NULL # remove
    
    #tempHhDT <- tempHhDT[, finalTZ := lubridate::tz(r_dateTime)]
    
    #table(tempHhDT$finalTZ, useNA = "always")
    
    # > Remove duplicates caused by over-lapping files and dates etc ----
    # Need to remove all uneccessary vars for this to work
    # Any remaining duplicates will probably be due to over-lapping files which have different circuit labels - see table below
    try(tempHhDT$dateColName <- NULL)
    try(tempHhDT$dateFormat <- NULL)
    try(tempHhDT$dateTime_char <- NULL) # if we leave this one in then we get duplicates where we have date NZ & date UTC for the same timestamp due to overlapping file downloads

    nObs <- nrow(tempHhDT)
    if(gSpyParams$fullFb){print(paste0("N rows before removal of duplicates: ", nObs))}
    tempHhDT <- unique(tempHhDT) # this will leave the duplicate DST readings alone provided at least 1 of the power readings differs
    nObs <- nrow(tempHhDT)
    if(gSpyParams$fullFb){print(paste0("N rows after removal of duplicates: ", nObs))}

    hhStatTempDT <- tempHhDT[, .(nObs = .N,
                                 nDataColumns = ncol(select(tempDT, contains("$")))), # the actual number of columns in the whole household file with "$" in them in case of rbind "errors" caused by files with different column names
                             keyby = (date = as.Date(r_dateTime))] # can't do sensible summary stats on W as some circuits are sub-sets of others!
    # add hhID
    hhStatTempDT <- hhStatTempDT[, hhID := hh]
    
    # make list of all circuits in this household's data
    circuitsDT <- tempHhLongDT[, .(nObs = .N), keyby = circuit]
    # split to remove the $
    circuitsDT <- circuitsDT[, c("circuitLabel", "circuitID") := tstrsplit(circuit, '$', fixed = TRUE)]
    circuitLabels <- circuitsDT[, circuitLabel]
    
    hhStatDT <- rbind(hhStatDT,hhStatTempDT) # add to the collector
    
    # > Save hh file ----
    ofile <- paste0(outPath, "data/", hh,"_all_1min_data.csv")
    if(gSpyParams$fullFb | gSpyParams$localTest){
      print(paste0("Saving ", ofile, "..."))
    }
    data.table::fwrite(tempHhLongDT, ofile)
    if(gSpyParams$fullFb | gSpyParams$localTest){
      print(paste0("Saved ", ofile, ", gzipping..."))
    }
    cmd <- paste0("gzip -f ", "'", path.expand(ofile), "'") # gzip it - use quotes in case of spaces in file name, expand path if needed
    try(system(cmd)) # in case it fails - if it does there will just be .csv files (not gzipped) - e.g. under windows
    if(gSpyParams$fullFb | gSpyParams$localTest){
      print(paste0("Gzipped ", ofile))
    }
    if(gSpyParams$fullFb){
      print("Col names: ")
      print(names(tempHhLongDT))
    }
    tempHhDT <- NULL # just in case
  } # X > end of per household loop ----

  #> Save observed data stats for all files loaded ----
  ofile <- paste0(outPath, "hhDailyObservationsStats.csv")
  print(paste0("Saving daily observations stats by hhid to ", ofile)) # write out version with file stats
  data.table::fwrite(hhStatDT, ofile)
  print("Done")

  ofile <- paste0(outPath, mf)
  print(paste0("Saving 1 minute data files final metadata to ", ofile))
  data.table::fwrite(dt, ofile)
  print("Done")
  lastOfHeadDT <<- head(tempHhLongDT) # for reporting
  hhStatDT <<- hhStatDT # for reporting
  tempHhLongDT <- NULL
  return(dt) # return the updated file list
}