# About ----
# Code to process raw 1minute NZ GREEN Grid electricity load (power) files as downloaded from gridSpy
# Purpose:
# - check file metadate e.g. size & date formats (if possible); flag files with (probably) no data
# -
# Produces:
# - a data.table called fListCompleteDT with all the files found + metadata
# - saves this to a local interim metadata file

# It won't work without the data so you will need access to it!

# Setup ----
#> Script parameters ----
pattern1Min <- "*at1.csv$" # e.g. *at1.csv$ filters only 1 min data
fListInterim <- "fListCompleteDT_interim.csv" # place to store the complete file list with interim meta-data

# > Script libraries ----
localLibs <- c("data.table", # for data munching
             "lubridate", # for date/time munching
             "readr", # for read/write_csv
             "dplyr", # for select columns
             "progress" # for a nice progress bar

)

nzGREENGrid::loadLibraries(localLibs)

#> Script functions ----

# Code ----

#> Check for 1 minute files using function ----

print(paste0("Looking for 1 minute data using pattern = ", pattern1Min, " in ", fpath, " - could take a while..."))
# get the file list as a data.table
fListCompleteDT <- nzGREENGrid::getFileList(fpath, pattern1Min)

nFiles <- nrow(fListCompleteDT)
print(paste0("Found ", tidyNum(nFiles), " files"))

#> Process file metadata ----

if(nrow(fListCompleteDT) == 0){
  # Then no files were found - should have been caught previously but...
  stop(paste0("No matching data files found, please check your path (", fpath, ") or your search pattern (", pattern1Min, "). If using /hum-csafe/ are you connected to it?!"))
} else {
  print(paste0("Processing file list and getting file meta-data. Please be patient)"))
  fListCompleteDT <- fListCompleteDT[, c("hhID","fileName") := data.table::tstrsplit(fList, "/")]
  fListCompleteDT <- fListCompleteDT[, fullPath := paste0(fpath, hhID,"/",fileName)]
  loopCount <- 1
  # now loop over the files and collect metadata
  pb <- progress::progress_bar$new(total = nrow(fListCompleteDT)) # set progress bar
  for(f in fListCompleteDT[,fullPath]){
    pb$tick()
    rf <- path.expand(f) # just in case of ~ etc
    fsize <- file.size(rf)
    fmtime <- lubridate::ymd_hms(file.mtime(rf), tz = "Pacific/Auckland") # requires lubridate
    fListCompleteDT <- fListCompleteDT[fullPath == f, fSize := fsize]
    fListCompleteDT <- fListCompleteDT[fullPath == f, fMTime := fmtime]
    fListCompleteDT <- fListCompleteDT[fullPath == f, fMDate := as.Date(fmtime)]
    fListCompleteDT <- fListCompleteDT[fullPath == f, dateColName := paste0("unknown - do not load (fsize = ", fsize, ")")]
    # only try to read files where we think there might be data
    loadThis <- ifelse(fsize > dataThreshold, "Loading (fsize > threshold)", "Skipping (fsize < threshold)")
    if(fullFb){print(paste0("Checking file ", loopCount, " of ", nFiles ,
                            " (", round(100*(loopCount/nFiles),2), "% checked): ", loadThis))}
    if(fsize > dataThreshold){
      if(fullFb){print(paste0("fSize (", fsize, ") > threshold (", dataThreshold, ") -> loading ", f))}
      row1DT <- fread(f, nrows = 1)
      # what is the date column called?
      fListCompleteDT <- fListCompleteDT[fullPath == f, dateColName := "unknown - can't tell"]
      if(nrow(dplyr::select(row1DT, dplyr::contains("NZ"))) > 0){ # requires dplyr
        setnames(row1DT, 'date NZ', "dateTime_char")
        row1DT <- row1DT[, dateColName := "date NZ"]
        fListCompleteDT <- fListCompleteDT[fullPath == f, dateColName := "date NZ"]
      }
      if(nrow(dplyr::select(row1DT, dplyr::contains("UTC"))) > 0){ # requires dplyr
        setnames(row1DT, 'date UTC', "dateTime_char")
        row1DT <- row1DT[, dateColName := "date UTC"]
        fListCompleteDT <- fListCompleteDT[fullPath == f, dateColName := "date UTC"]
      }
      # split dateTime
      row1DT <- row1DT[, c("date_char", "time_char") := data.table::tstrsplit(dateTime_char, " ")]
      # add example of date to metadata - presumably they are the same in each file?!
      fListCompleteDT <- fListCompleteDT[fullPath == f, dateExample := row1DT[1, date_char]]

      if(fullFb){print(paste0("Checking date formats in ", f))}
      dt <- nzGREENGrid::checkDates(row1DT)
      fListCompleteDT <- fListCompleteDT[fullPath == f, dateFormat := dt[1, dateFormat]]
      fListCompleteDT <- fListCompleteDT[fullPath == f, dateFormat := dt[1, dateFormat]]
      if(fullFb){print(paste0("Done ", f))}
    }
    loopCount <- loopCount + 1
  }
  print("All files checked")

  # any date formats are still ambiguous need a deeper inspection using the full file - could be slow
  fAmbig <- fListCompleteDT[dateFormat == "ambiguous", fullPath] # get ambiguous files as a list
  pbA <- progress::progress_bar$new(total = length(fAmbig))
  for(fa in fAmbig){
    if(baTest | fullFb){print(paste0("Checking ambiguous date formats in ", fa))}
    ambDT <- fread(fa)
    pbA$tick()
    if(nrow(dplyr::select(ambDT, dplyr::contains("NZ"))) > 0){ # requires dplyr
      setnames(ambDT, 'date NZ', "dateTime_char")
    }
    if(nrow(dplyr::select(ambDT, dplyr::contains("UTC"))) > 0){ # requires dplyr
      setnames(ambDT, 'date UTC', "dateTime_char")
    }
    ambDT <- ambDT[, c("date_char", "time_char") := data.table::tstrsplit(dateTime_char, " ")]
    ambDT <- nzGREENGrid::checkDates(ambDT)
    # set what we now know (or guess!)
    fListCompleteDT <- fListCompleteDT[fullPath == fa, dateFormat := ambDT[1,dateFormat]]
  }
  fListCompleteDT <- setnames(fListCompleteDT, "fList", "file")

  ofile <- paste0(outPath, fListInterim)
  print(paste0("Saving 1 minute data files interim metadata to ", ofile))
  write.csv(fListCompleteDT, ofile)
  print("Done")
}
