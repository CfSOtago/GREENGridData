### ----- About ---- 
# R code to process GREEN grid gridSpy data

# expects to be called from makeFile which will have set parameters used

# Local packages (needed in this script) ----
localLibs <- c("data.table",
               "lubridate",
               "hms",
               "ggplot2")

nzGREENGridDataR::loadLibraries(localLibs)

# Local functions ----

# Local parameters ----
plotLoc <- paste0(ggrParams$projLoc,"/checkPlots/") # where to save the check plots

# Code ----

# > Housekeeping ----

try(file.remove(gSpyParams$hhStatsByDate)) # otherwise the append within the get data function will keep adding
try(file.remove(gSpyParams$fLoadedStats)) # otherwise the append within the get data function will keep adding

# > Get DST labels ----
dstDT <- data.table::fread(gSpyParams$dstNZDates)

# > Get file list ----
testFile <- file.exists(gSpyParams$fListAll) # does it exist?
  
if(testFile){
  mTime <- file.mtime(gSpyParams$fListAll)
  mDate <- as.Date(file.mtime(gSpyParams$fListAll))
  if(mDate == today() & !gSpyParams$refreshFileList){
    # Already ran today but 
    print(paste0("#-> Re-using saved file list"))
    fListAllDT <- data.table::fread(gSpyParams$fListAll)
  } 
}
if(!testFile | gSpyParams$refreshFileList) {
      print(paste0("#-> Refreshing file list"))
      fListAllDT <- nzGREENGridDataR::getGridSpyFileList(gSpyParams$gSpyInPath, # where to look
                                                     gSpyParams$pattern, # what to look for
                                                     gSpyParams$gSpyFileThreshold # file size threshold
      )
      # > Fix ambiguous dates in meta data derived from file listing 
      fListAllDT <- nzGREENGridDataR::fixAmbiguousDates(fListAllDT)
      # > Save the full list listing 
      ofile <- gSpyParams$fListAll #  set in global
      print(paste0("#-> Saving full list of 1 minute data files with metadata to ", ofile))
      data.table::fwrite(fListAllDT, ofile)
  }

print(paste0("#-> Overall we have ", nrow(fListAllDT), " files from ",
             uniqueN(fListAllDT$hhID), " households."))

# > Get data files where we think there is data ----
fListToLoadDT <- fListAllDT[!(dateColName %like% "ignore")] # based on fsize check


# See what the date formats look like now
t <- fListToLoadDT[, .(nFiles = .N, 
                         minDate = min(dateExample), # may not make much sense
                         maxDate = max(dateExample)), 
                     keyby = .(dateColName, dateFormat)]

print("#-> Test inferred date formats")
t

pcFiles <- round(100*(nrow(fListToLoadDT)/nrow(fListAllDT)))

print(paste0("#-> Loading the ", nrow(fListToLoadDT), 
             " files (", pcFiles, " % of all ", 
             nrow(fListAllDT), " files) which we think have data (from ",
             uniqueN(fListToLoadDT$hhID), " of ",uniqueN(fListAllDT$hhID), " households)"))

hhIDs <- unique(fListToLoadDT$hhID) # list of household ids

for(hh in hhIDs){ # X >> start of per household loop ----
  # > Set start time ----
  startTime <- proc.time()
  # > Process files ----
  fileList <- fListToLoadDT[hhID == hh, fullPath] # files for this household
  print(paste0("#---------------------------- Begin ",hh,"----------------------------#"))
  nFiles <- length(fileList)
  print(paste0("#--> ", hh, ": Loading ", nFiles, " files..."))
  dt <- processHhGridSpyData(hh, fileList) # returns final data table for testing if required
  t <- proc.time() - startTime
  print(paste0("#--> ",hh, ": ", nFiles ," data files loaded in ", getDuration(t)))
  
  # > Create clean circuit labels ----
  # dt <- dt[, c("circuitLabel", "circuitID") := tstrsplit(circuit, "$", fixed = TRUE)]
  # don't do this as it can lead to confusion due to re-use of labels with differing IDs
  
  # > Run basic tests ----
  print(paste0("#--> ",hh, ": running basic tests"))
  # set some vars to aggregate by
  dt <- dt[, month := lubridate::month(r_dateTime, label = TRUE)]
  dt <- dt[, year := lubridate::year(r_dateTime)]
  dt <- dt[, obsHour := lubridate::hour(r_dateTime)]
  dt <- dt[, obsDate := lubridate::date(r_dateTime)]
  dt <- dt[, obsTime := hms::as.hms(r_dateTime)]
  
  # >> power checks ----
  # These will show us when the household was consuming electricity 
  # - do they look OK?
  # - can you spot the households with PV?
  
  plotDT <- dt[, .(meanW = mean(powerW)), keyby = .(circuit, month, year, obsTime)
               ] # aggregate by circuit to preserve unique circuit labels in households 
                 # (e.g. rf_46) where names are re-used but with different ids. see ?fixCircuitLabels_rf_46
  vLineAlpha <- 0.4
  vLineCol <- "#0072B2" # http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette
  timeBreaks <- c(hms::as.hms("02:00:00"), hms::as.hms("04:00:00"), 
                  hms::as.hms("06:00:00"), hms::as.hms("08:00:00"),
                  hms::as.hms("10:00:00"), hms::as.hms("12:00:00"),
                  hms::as.hms("14:00:00"), hms::as.hms("16:00:00"),
                  hms::as.hms("18:00:00"), hms::as.hms("20:00:00"),
                  hms::as.hms("22:00:00")
  )
  myPlot <- ggplot2::ggplot(plotDT, aes(x = obsTime, y = meanW/1000, colour = circuit)) +
    geom_line() + 
    facet_grid(month  ~ year) + 
    theme(strip.text.y = element_text(angle = 0, vjust = 0.5, hjust = 0.5)) + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
    theme(legend.position = "bottom") + 
    labs(title = paste0("Montly mean power profiles by circuit plot: ", hh),
         y = "Mean kW", 
         caption = paste0("gridSpy data from ", min(dt$r_dateTime), 
                          " to ", max(dt$r_dateTime),
                          "\nobsTime = Pacific/Auckland"))
    
  myPlot + 
    scale_x_time(breaks = timeBreaks) +
    geom_vline(xintercept = timeBreaks, alpha = vLineAlpha, colour = vLineCol)
  
  ofile <- paste0(plotLoc, hh, "_monthlyPowerPlot.png")
  ggsave(ofile, height = 10)
  
  # >> date time checks ----
  # This will tell us when we have too few or too many observations
  # We should have too many once a year when the DST change occurs and we 'gain' an hour (we have 02:00 - 03:00 twice)
  # and the reverse once a year when we lose 02:00 - 03:00
  # This will not be visible in UTC time, only local time
  nCircuits <- uniqueN(dt$circuit)
  nExpectedObs <- nCircuits * 60
  t <- dt[, .(nObs = .N), keyby = .(obsDate, obsHour)]
  t$ratio <- t$nObs/nExpectedObs
  myPlot <- ggplot2::ggplot(t, aes(x = obsDate, y = obsHour, fill = ratio)) + 
    geom_tile() +
    # https://ggplot2.tidyverse.org/reference/scale_brewer.html
    # http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
    #scale_fill_distiller(palette = "Spectral", direction = -1) +
    scale_fill_gradient2(midpoint = 1) +
    scale_x_date(date_breaks = "2 months") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) +
    labs(title = paste0("Expected observations ratio by date & hour plot: ", hh),
         y = "Hour", 
         caption = paste0("gridSpy data from ", min(dt$r_dateTime), 
                          " to ", max(dt$r_dateTime),
                          "\nobsDate = Pacific/Auckland",
                          "\nWe expect ", nExpectedObs, " per hour given ", nCircuits, " circuits",
                          "\nRatio = nObs/nExpectedObs so a value of 2 means we have duplicate hours (usualy at DST changes)"))
  
  # Add DST labels. We add all labels as it helps to show which households have ongoing data collection
  for(d in unique(dstDT$date)){
    obsDate <- lubridate::dmy(d)
    label <- dstDT[date == d, label]
    myPlot <- myPlot +
      annotate("text", x = obsDate,
               y = 7,size = 3, angle = 90,
               label = label)
  }
  myPlot 
  
  ofile <- paste0(plotLoc, hh, "_observationsRatioPlot.png")
  ggsave(ofile, height = 10)

  # > Set household level stats by date ----
  statDT <- dt[, .(nObs = .N,
                        meanPower = mean(powerW),
                        sdPowerW = sd(powerW),
                        minPowerW = min(powerW),
                        maxPowerW = max(powerW),
                        circuitLabels = toString(unique(circuit)),
                        nCircuits = uniqueN(circuit)), # the actual number of columns in the whole household file with "$" in them in case of rbind "errors" caused by files with different column names
                    keyby = .(hhID, date = lubridate::date(r_dateTime))] # can't do sensible summary stats on W as some circuits are sub-sets of others!
  
  # > Add fStats to end of stats file stats collector
  ofile <- gSpyParams$hhStatsByDate 
  print(paste0("#--> ",hh, ": Adding hh stats by date list stats to ", ofile))
  data.table::fwrite(statDT, ofile, append=TRUE) # this will only write out column names once when file is created see ?fwrite

  
  # > Save hh file ----
  # Keep only the vars we can't easily re-create
  keepVars <- c("hhID", "dateTime_orig", "TZ_orig", "r_dateTime", "circuit", "powerW")
  saveDT <- dt[, ..keepVars] # just saves the keepVars
  ofile <- paste0(gSpyParams$gSpyOutPath, "data/", hh,"_all_1min_data.csv")
  print(paste0("#--> ", hh, ": Saving ", ofile, " (columns: ", toString(names(saveDT)), ")"))
  data.table::fwrite(saveDT, ofile)
  print(paste0("#--> ",hh, ": Saved ", ofile, ", gzipping..."))
  cmd <- paste0("gzip -f ", "'", path.expand(ofile), "'") # gzip it - use quotes in case of spaces in file name, expand path if needed
  try(system(cmd)) # in case it fails - if it does there will just be .csv files (not gzipped) - e.g. under windows
  print(paste0("#--> ",hh, ": Gzipped ", ofile))
  print(paste0("#--> ",hh, ": Done"))
} # << X end per household loop ----

# End
