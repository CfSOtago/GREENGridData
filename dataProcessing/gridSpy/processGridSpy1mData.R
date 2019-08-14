### ----- About ----
# R code to process GREEN grid GridSpy data

# expects to be called from makeFile which will have set parameters used

# Local packages (needed in this script) ----
libs <- c("ggplot2")

GREENGridData::loadLibraries(libs)

# Local parameters ----

# > set check plots location (github) ----
plotLoc <- paste0(ggrParams$repoLoc,"/checkPlots/") # where to save the check plots (github)

# Local functions ----
makeSummaryPlots <- function(hh,dt){
  # make 2 plots:
  # nObs by circuit label by date
  # mean value of whatever the circuits were measuring by circuit label by date
  # helps to debug
  plotDT <- dt[, .(nObs = .N, meanValue = mean(powerW)), 
               keyby = .(circuit, date = lubridate::date(r_dateTime))]
  
  myCaption <- paste0(hh, ": circuit labels (all data received)\n")
  
  p <- ggplot2::ggplot(plotDT, aes(x = date, y = circuit, alpha = nObs)) +
    geom_tile() +
    theme(legend.position="bottom") +
    labs(caption = paste0(myCaption, "Number of observations per day")) +
    scale_alpha_continuous(name = "N observations") +
    theme(legend.position="bottom")
  ofile <- paste0(gSpyParams$checkPlots, hh, "_circuitLabels_nObsByDate.png")
  ggplot2::ggsave(ofile, height = 10)
  
  p <- ggplot2::ggplot(plotDT, aes(x = date, y = circuit, fill = meanValue)) +
    geom_tile() +
    theme(legend.position="bottom") +
    labs(caption = paste0(myCaption, "Mean value (usually, but not always, power)")) +
    scale_fill_continuous(low = "green", high = "red", name = "Mean value") +
    theme(legend.position="bottom")
  ofile <- paste0(gSpyParams$checkPlots, hh, "_circuitLabels_meanValueByDate.png")
  ggplot2::ggsave(ofile, height = 10)

  # make plot of power by month, year & circuit
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
    labs(title = paste0("Monthly mean power profiles by circuit plot: ", hh),
         y = "Mean kW",
         caption = paste0("GridSpy data from ", min(dt$r_dateTime),
                          " to ", max(dt$r_dateTime),
                          "\nobsTime = Pacific/Auckland"))

  myPlot +
    scale_x_time(breaks = timeBreaks) +
    geom_vline(xintercept = timeBreaks, alpha = vLineAlpha, colour = vLineCol)

  ofile <- paste0(gSpyParams$checkPlots, hh, "_monthlyPowerPlot.png")
  ggplot2::ggsave(ofile, height = 10)

  # plots n obs per hour & date
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
         caption = paste0("GridSpy data from ", min(dt$r_dateTime),
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

  ofile <- paste0(gSpyParams$checkPlots, hh, "_observationsRatioPlot.png")
  ggplot2::ggsave(ofile, height = 10)
}

saveFinalDT <- function(hh,dt){
  # Keep only the vars we can't easily re-create
  keepVars <- c("hhID", "linkID", "dateTime_orig", "TZ_orig", "r_dateTime", "circuit", "powerW")
  saveDT <- dt[, ..keepVars] # just saves the keepVars
  ofile <- paste0(gSpyParams$gSpyOutPath, "data/", hh,"_all_1min_data.csv")
  print(paste0("#--> ", hh, ": Saving ", ofile, " (columns: ", toString(names(saveDT)), ")"))
  data.table::fwrite(saveDT, ofile)
  print(paste0("#--> ",hh, ": Saved ", ofile, ", gzipping..."))
  cmd <- paste0("gzip -f ", "'", path.expand(ofile), "'") # gzip it - use quotes in case of spaces in file name, expand path if needed
  try(system(cmd)) # in case it fails - if it does there will just be .csv files (not gzipped) - e.g. under windows
  print(paste0("#--> ",hh, ": Gzipped ", ofile))
  print(paste0("#--> ",hh, ": Done"))
}


# Code ----

# > Housekeeping ----

try(file.remove(gSpyParams$hhStatsByDate)) # otherwise the append within the get data function will keep adding
try(file.remove(gSpyParams$fLoadedStats)) # otherwise the append within the get data function will keep adding

# > set household id filter ----

if(households == "all"){ # set in makeFile.R
  hhIDs <- unique(fListAllDT$hhID) # list of all household ids we found
} else {
  hhIDs <- households # the selection we set as a filter
}

# > Set the files we really want ----
# data files where we think there is data 
fListToLoadDT <- fListAllDT[!(dateColName %like% "ignore")] # based on fsize check
# for the households we want
fListToLoadDT <- fListToLoadDT[hhID %in% hhIDs] # based on filter

# See what the date formats look like now
t <- fListToLoadDT[, .(nFiles = .N,
                       minDate = min(dateExample), # may not make much sense
                       maxDate = max(dateExample)),
                   keyby = .(dateColName, dateFormat)]

message("#-> Test inferred date formats for the selected households:")
message(list(hhIDs))
print(t)

pcFiles <- round(100*(nrow(fListToLoadDT)/nrow(fListAllDT)))

print(paste0("#-> Loading the ", nrow(fListToLoadDT),
             " files (", pcFiles, " % of all ",
             nrow(fListAllDT), " files) where we think have data for the ",
             uniqueN(fListToLoadDT$hhID), " selected households (out of ",
             uniqueN(fListAllDT$hhID), " found)"))

statDT <- data.table::data.table() # summary stats collector

# hhIDs
for(hh in hhIDs){ # X >> start of per household loop ----
  # > Set start time ----
  startTime <- proc.time()
  # > Process files ----
  fileList <- fListToLoadDT[hhID == hh, fullPath] # files for this household
  print(paste0("#---------------------------- Begin ",hh," ----------------------------#"))
  nFiles <- length(fileList)
  print(paste0("#--> ", hh, ": Loading ", nFiles, " files..."))
  dt <- processHhGridSpyData(hh, fileList) # returns final data table for testing if required
  t <- proc.time() - startTime
  print(paste0("#--> ",hh, ": ", nFiles ," data files loaded in ", getDuration(t)))

  # > Create clean circuit labels ----
  # dt <- dt[, c("circuitLabel", "circuitID") := tstrsplit(circuit, "$", fixed = TRUE)]
  # don't do this as it can lead to confusion due to re-use of labels with differing IDs

  # > Run basic tests ----
  print(paste0("#--> ",hh, ": deriving test vars"))
  # set some vars to aggregate by
  dt <- dt[, month := lubridate::month(r_dateTime, label = TRUE)]
  dt <- dt[, year := lubridate::year(r_dateTime)]
  dt <- dt[, obsHour := lubridate::hour(r_dateTime)]
  dt <- dt[, obsDate := lubridate::date(r_dateTime)]
  dt <- dt[, obsTime := hms::as.hms(r_dateTime)]

  print(paste0("#--> ",hh, ": running basic tests"))
  # > Fix the re-used rf_XX before we test or save anything ----
  # Can't do this in the processHhGridSpyData function as that assumes hhID is in filename
  # We need to split these files (here)
  if(hh == "rf_15"){
    print(paste0("#--> ",hh, ": Fixing rf_15 re-use"))
    # rf_15a up to 2015-01-15 then rf_15b to 2016-04-02 # see https://cfsotago.github.io/GREENGridData/
    hh <- "rf_15a"
    dt <- dt[, linkID := hh] # set default
    # GS master file notes disconnected 2015-01-15 but in fact there is no data before this date so
    # we assume the new household's data started on this date.
    dt <- dt[lubridate::date(r_dateTime) >= as.Date("2015-01-15"), linkID := "rf_15b"] # set to re-user
    # dt[, .(nObs = .N,
    #            minDate = min(as.Date(r_dateTime)),
    #            maxDate = max(as.Date(r_dateTime))), keyby = .(linkID)]
    dta <- dt[linkID == hh]
    if(nrow(dta) > 0){
      # there is data
      makeSummaryPlots(hh,dta)
      saveFinalDT(hh,dta)
    } else {
      print(paste0("#--> ",hh, ": no data rows for rf_15a - not saved"))
    }
    hh <- "rf_15b"
    dtb <- dt[linkID == hh]
    if(nrow(dtb) > 0){
      # there is data
      makeSummaryPlots(hh,dtb)
      saveFinalDT(hh,dtb)
    } else {
      print(paste0("#--> ",hh, ": no data rows for rf_15b - not saved"))
    }
  } else if(hh == "rf_17"){
    print(paste0("#--> ",hh, ": Fixing rf_17 re-use"))
    # rf_17a up to 2016-03-28 then rf_17b
    hh <- "rf_17a"
    dt <- dt[, linkID := hh] # set default
    dt <- dt[lubridate::date(r_dateTime) > as.Date("2016-03-28"), linkID := "rf_17b"]
    dta <- dt[linkID == hh]
    if(nrow(dta) > 0){
      # there is data
      makeSummaryPlots(hh,dta)
      saveFinalDT(hh,dta)
    } else {
      print(paste0("#--> ",hh, ": no data rows for rf_17a - not saved"))
    }
    hh <- "rf_17b"
    dtb <- dt[linkID == hh]
    if(nrow(dtb) > 0){
      # there is data
      makeSummaryPlots(hh,dtb)
      saveFinalDT(hh,dtb)
    } else {
      print(paste0("#--> ",hh, ": no data rows for rf_17b - not saved"))
    }
  } else {
    # no problems so set newID to hhID
    print(paste0("#--> ",hh, ": Not re-used so no re-use to fix"))
    dt <- dt[, linkID := hhID]
    makeSummaryPlots(hh,dt)
    saveFinalDT(hh,dt)
  }

  # > Set household level stats by date ----
  tdt <- dt[, .(nObs = .N,
                   meanPower = mean(powerW),
                   sdPowerW = sd(powerW),
                   minPowerW = min(powerW),
                   maxPowerW = max(powerW),
                   circuitLabels = toString(unique(circuit)),
                   nCircuits = uniqueN(circuit)), # the actual number of columns in the whole household file with "$" in them in case of rbind "errors" caused by files with different column names
               keyby = .(linkID, date = lubridate::date(r_dateTime))] # can't do sensible summary stats on W as some circuits are sub-sets of others!

  statDT <- rbind(statDT, tdt)
  
} # << X end per household loop ----

# > Add fStats to end of stats file stats collector
ofile <- gSpyParams$hhStatsByDate
print(paste0("#--> Writing hh stats by date list stats to ", ofile))
data.table::fwrite(statDT, ofile, append=TRUE) # this will only write out column names once when file is created see ?fwrite

# End
