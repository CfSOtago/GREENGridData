# About ----
# Code to process raw 1minute NZ GREEN Grid electricity load (power) data as downloaded from gridSpy
# Purpose:
# - process & (slightly) clean  raw data
# - save data to 1 .csv.gz file per household
# - report data processing/file info
# Assumes:
# - a data.table called fListCompleteDT with all the files you want to process exists & has relevant metadata

# It won't work without the data so you will need access to it!

# Setup ----
#> Script parameters ----
fListFinal <- "fListCompleteDT_final.csv" # place to store the final complete file list with all meta-data

# > Script libraries ----
localLibs <- c("data.table", # for data munching
             "lubridate", # for date/time munching
             "readr", # for read/write_csv
             "dplyr", # for select columns
             "reshape2", # for making wide data long
             "progress" # for a nice progress bar

)

nzGREENGrid::loadLibraries(localLibs)

#> Script functions ----

# Code ----

#> Load, process & save the ones which probably have data ----
fListCompleteDT <- fListCompleteDT[, fileLoaded := "No"] # set default
# select those which we decided were large enough to probably have data
filesToLoadDT <- fListCompleteDT[!(dateColName %like% "do not load")]

hhIDs <- unique(filesToLoadDT$hhID) # list of household ids
hhStatDT <- data.table::data.table() # stats collector

for(hh in hhIDs){ #> start of household loop ----
  tempHhDT <- data.table::data.table() # hh data collector
  print(paste0("Loading: ", hh))
  filesToLoad <- filesToLoadDT[hhID == hh, fullPath]
  pbF <- progress::progress_bar$new(total = length(filesToLoad))
  for(f in filesToLoad){ # >> start of per-file loop ----
    if(fullFb){print(paste0("File size (", f, ") = ",
                            filesToLoadDT[fullPath == f, fSize],
                            " so probably OK"))} # files under 3kb are probably empty
    # attempt to load the file
    tempDT <- data.table::fread(f)
    pbF$tick()
    if(fullFb){print("File loaded")}
    # set some file stats
    fListCompleteDT <- fListCompleteDT[fullPath == f, fileLoaded := "Yes"]
    fListCompleteDT <- fListCompleteDT[fullPath == f, nObs := nrow(tempDT)] # could include duplicates

    # what is the date column called?
    if(nrow(dplyr::select(tempDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
      setnames(tempDT, 'date NZ', "dateTime_char")
      tempDT <- tempDT[, dateColName := "date NZ"]
    }
    if(nrow(dplyr::select(tempDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
      setnames(tempDT, 'date UTC', "dateTime_char")
      tempDT <- tempDT[, dateColName := "date UTC"]
    }

    # >> Fix dates ----
    # Using the pre-inferred dateFormat
    tempDT <- tempDT[, dateFormat := filesToLoadDT[fullPath == f, dateFormat]]
    tempDT <- tempDT[dateFormat %like% "mdy" & dateColName %like% "NZ", r_dateTime := lubridate::mdy_hm(dateTime_char, tz = "Pacific/Auckland")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "dmy" & dateColName %like% "NZ", r_dateTime := lubridate::dmy_hm(dateTime_char, tz = "Pacific/Auckland")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "ydm" & dateColName %like% "NZ", r_dateTime := lubridate::ymd_hm(dateTime_char, tz = "Pacific/Auckland")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "ymd" & dateColName %like% "NZ", r_dateTime := lubridate::ymd_hm(dateTime_char, tz = "Pacific/Auckland")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "mdy" & dateColName %like% "UTC", r_dateTime := lubridate::mdy_hm(dateTime_char, tz = "UTC")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "dmy" & dateColName %like% "UTC", r_dateTime := lubridate::dmy_hm(dateTime_char, tz = "UTC")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "ydm" & dateColName %like% "UTC", r_dateTime := lubridate::ymd_hm(dateTime_char, tz = "UTC")] # requires lubridate
    tempDT <- tempDT[dateFormat %like% "ymd" & dateColName %like% "UTC", r_dateTime := lubridate::ymd_hm(dateTime_char, tz = "UTC")] # requires lubridate
    if(fullFb){
      print(head(tempDT))
      print(summary(tempDT))
      #print(table(tempDT$dateFormat))
    }

    fListCompleteDT <- fListCompleteDT[fullPath == f, obsStartDate := min(as.Date(tempDT$r_dateTime))] # should be a sensible number and not NA
    fListCompleteDT <- fListCompleteDT[fullPath == f, obsEndDate := max(as.Date(tempDT$r_dateTime))] # should be a sensible number and not NA
    fListCompleteDT <- fListCompleteDT[fullPath == f, nObs := nrow(tempDT)]

    # >> Fix circuit labels where we have noticed errors ----
    # rf_24 has an additional circuit in some files but value is always NA
    # rf_46 has 3 different versions of the circuit labels:
    # 1: Heat Pumps (2x) & Power$4232, Heat Pumps (2x) & Power$4399, Hot Water - Controlled$4231, Hot Water - Controlled$4400, Incomer - Uncontrolled$4230, Incomer - Uncontrolled$4401, Incomer Voltage$4405, Kitchen & Bedrooms$4229, Kitchen & Bedrooms$4402, Laundry & Bedrooms$4228, Laundry & Bedrooms$4403, Lighting$4233, Lighting$4404
    # 2: Heat Pumps (2x) & Power1$4232, Heat Pumps (2x) & Power2$4399, Hot Water - Controlled1$4231, Hot Water - Controlled2$4400, Incomer - Uncontrolled1$4230, Incomer - Uncontrolled2$4401, Incomer Voltage$4405, Kitchen & Bedrooms1$4229, Kitchen & Bedrooms2$4402, Laundry & Bedrooms1$4228, Laundry & Bedrooms2$4403, Lighting1$4233, Lighting2$4404
    # 3: Heat Pumps (2x) & Power_Imag$4399, Heat Pumps (2x) & Power$4232, Hot Water - Controlled_Imag$4400, Hot Water - Controlled$4231, Incomer - Uncontrolled_Imag$4401, Incomer - Uncontrolled$4230, Incomer Voltage$4405, Kitchen & Bedrooms_Imag$4402, Kitchen & Bedrooms$4229, Laundry & Bedrooms_Imag$4403, Laundry & Bedrooms$4228, Lighting_Imag$4404, Lighting$4233
    # Fix to just the first (might also fix duplication of observations)
    if(hh == "rf_46"){
      if(fullFb){print("Checking circuit labels for rf_46")}
      # check if we have the second form of labels - they have 'Power1$4232' in one col label
      checkCols2 <- ncol(dplyr::select(tempDT,dplyr::contains("Power1$4232")))
      if(checkCols2 == 1){
        # we got label set 2
        if(fullFb){print(paste0("Found circuit labels set 2 in ", f))}
        setnames(tempDT, c("Heat Pumps (2x) & Power1$4232", "Heat Pumps (2x) & Power2$4399",
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
      checkCols3 <- ncol(dplyr::select(tempDT,dplyr::contains("Power_Imag$4399")))
      if(checkCols3 == 1){
        # we got label set 3
        if(fullFb){print(paste0("Found circuit labels set 3 in ", f))}
        # be careful to get this order correct so that it matches the label 1 order
        setnames(tempDT, c("Heat Pumps (2x) & Power$4232", "Heat Pumps (2x) & Power_Imag$4399",
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
    # >> Check circuit labels to see if any remaining errors ----
    # check the names of circuits - all seem to contain "$"; sort them to make it easier to compare them - this is the only way we have to check if data from different households has been placed in the wrong folder.
    fListCompleteDT <- fListCompleteDT[fullPath == f,
                                       circuitLabels := toString(sort(colnames(dplyr::select(tempDT,
                                                                                             dplyr::contains("$")))))]
    # check for the number of circuits - all seem to contain "$"
    fListCompleteDT <- fListCompleteDT[fullPath == f, nCircuits := ncol(dplyr::select(tempDT,
                                                                                      dplyr::contains("$")))]
    #tempDT <- tempDT[, sourceFile := f] # record for later checks - don't as it breaks de-duplication code

    # >> rbind file to hh data collector ----
    tempHhDT <- rbind(tempHhDT, tempDT, fill = TRUE) # fill just in case there are different numbers of columns or columns with different names (quite likely - crcuit labels may vary!)
  }

  # > Remove duplicates caused by over-lapping files and dates etc ----
  # Need to remove all uneccessary vars for this to work
  # Any remaining duplicates will probably be due to over-lapping files which have different circuit labels - see table below
  try(tempHhDT$dateColName <- NULL)
  try(tempHhDT$dateFormat <- NULL)
  try(tempHhDT$dateTime_char <- NULL) # if we leave this one in then we get duplicates where we have date NZ & date UTC for the same timestamp due to overlapping file downloads

  nObs <- nrow(tempHhDT)
  if(fullFb){print(paste0("N rows before removal of duplicates: ", nObs))}
  tempHhDT <- unique(tempHhDT)
  nObs <- nrow(tempHhDT)
  if(fullFb){print(paste0("N rows after removal of duplicates: ", nObs))}

  hhStatTempDT <- tempHhDT[, .(nObs = .N,
                               nDataColumns = ncol(select(tempDT, contains("$")))), # the actual number of columns in the whole household file with "$" in them in case of rbind "errors" caused by files with different column names
                           keyby = (date = as.Date(r_dateTime))] # can't do sensible summary stats on W as some circuits are sub-sets of others!
  # add hhID
  hhStatTempDT <- hhStatTempDT[, hhID := hh]

  hhStatDT <- rbind(hhStatDT,hhStatTempDT) # add to the collector
  # > add vars & switch to long form ----
  # add hhid for ease of future loading etc
  tempHhDT <- tempHhDT[, hhID := hh]
  # switch to long format for easy future loading
  # this turns each circuit label (column) into a label within 'variable' and
  # sets value to be the power measurement
  # we then relabel them for clarity
  tempHhLongDT <- reshape2::melt(tempHhDT, id=c("hhID","r_dateTime"))
  data.table::setnames(tempHhLongDT, "value", "power")
  data.table::setnames(tempHhLongDT, "variable", "circuit")
  # force numeric
  tempHhLongDT <- tempHhLongDT[, powerW := as.numeric(power)]

  # remove NA if present
  oldN <- nrow(tempHhLongDT)
  tempHhLongDT <- tempHhLongDT[!is.na(powerW)]
  tempHhLongDT$power <- NULL # remove to save space/memory
  newN <- nrow(tempHhLongDT)
  pcNA <- ((oldN - newN)/oldN)*100
  print(paste0("Removed ", oldN - newN, " (", round(pcNA, 2) , "% of observations) where powerW = NA"))

  # > Save hh file ----
  ofile <- paste0(outPath, "data/", hh,"_all_1min_data.csv")
  if(fullFb | baTest){
    print(paste0("Saving ", ofile, "..."))
    }
  write_csv(tempHhLongDT, ofile)
  if(fullFb | baTest){
    print(paste0("Saved ", ofile, ", gzipping..."))
    }
  cmd <- paste0("gzip -f ", "'", path.expand(ofile), "'") # gzip it - use quotes in case of spaces in file name, expand path if needed
  try(system(cmd)) # in case it fails - if it does there will just be .csv files (not gzipped) - e.g. under windows
  if(fullFb | baTest){
    print(paste0("Gzipped ", ofile))
    }
  if(fullFb){
    print("Col names: ")
    print(names(tempHhLongDT))
  }
  tempHhLongDT
  tempHhDT <- NULL # just in case
}

#> Save observed data stats for all files loaded ----
ofile <- paste0(outPath, "hhDailyObservationsStats.csv")
print(paste0("Saving daily observations stats by hhid to ", ofile)) # write out version with file stats
write.csv(hhStatDT, ofile)
print("Done")

ofile <- paste0(outPath, fListFinal)
print(paste0("Saving 1 minute data files final metadata to ", ofile))
write.csv(fListCompleteDT, ofile)
print("Done")
