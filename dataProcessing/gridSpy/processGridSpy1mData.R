### ----- About ---- 
# R code to process GREEN grid gridSpy data

# expects to be called from makeFile which will have set parameters used

# Local packages
library(data.table)
library(dplyr)
library(lubridate)
library(hms)
library(ggplot2)

# Local functions ----

# Code ----

# > Housekeeping ----

try(file.remove(gSpyParams$hhStatsByDate)) # otherwise the append within the get data function will keep adding
try(file.remove(gSpyParams$fLoadedStats)) # otherwise the append within the get data function will keep adding

# > Get file list ----
fListAllDT <- nzGREENGridDataR::getGridSpyFileList(gSpyParams$gSpyInPath, # where to look
                                                   gSpyParams$pattern, # what to look for
                                                   gSpyParams$gSpyFileThreshold # file size threshold
                                                   )

# > Fix ambiguous dates in meta data derived from file listing ----
fListAllDT <- nzGREENGridDataR::fixAmbiguousDates(fListAllDT)

# > Save the full list listing ----
ofile <- paste0(gSpyParams$fListAll) #  set in global
print(paste0("Saving 1 minute data files interim metadata to ", ofile))
data.table::fwrite(fListAllDT, ofile)

print(paste0("Overall we have ", nrow(fListAllDT), " files from ",
             uniqueN(fListAllDT$hhID), " households."))

# > Get data files where we think there is data ----
fListToLoadDT <- fListAllDT[!(dateColName %like% "ignore")] # based on fsize check

pcFiles <- round(100*(nrow(fListToLoadDT)/nrow(fListAllDT)))

print(paste0("Loading the ", nrow(fListToLoadDT), 
             " files (", pcFiles, " % of all ", 
             nrow(fListAllDT), " files) which we think have data (from ",
             uniqueN(fListToLoadDT$hhID), " of ",uniqueN(fListAllDT$hhID), " households)"))

hhIDs <- unique(fListToLoadDT$hhID) # list of household ids

for(hh in hhIDs){ # X >> start of per household loop ----
  # > set start time ----
  startTime <- proc.time()
  fileList <- fListToLoadDT[hhID == hh, fullPath] # files for this household
  dt <- processHhGridSpyData(hh, fileList) # returns final data table for testing if required
  t <- proc.time() - startTime
  print(paste0("Data for ", hh, " loaded in ", getDuration(t)))
  
  print(paste0("Running basic tests for: ", hh))
  dt <- dt[, month := lubridate::month(r_dateTime, label = TRUE)]
  dt <- dt[, year := lubridate::year(r_dateTime)]
  dt <- dt[, obsTime := hms::as.hms(r_dateTime)]
  
  plotDT <- dt[, .(meanW = mean(powerW)), keyby = .(circuitLabel, month, year, obsTime)
               ]
  vLineAlpha <- 0.4
  vLineCol <- "#0072B2" # http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette
  timeBreaks <- c(hms::as.hms("02:00:00"), hms::as.hms("04:00:00"), 
                  hms::as.hms("06:00:00"), hms::as.hms("08:00:00"),
                  hms::as.hms("10:00:00"), hms::as.hms("12:00:00"),
                  hms::as.hms("14:00:00"), hms::as.hms("16:00:00"),
                  hms::as.hms("18:00:00"), hms::as.hms("20:00:00"),
                  hms::as.hms("22:00:00")
  )
  myPlot <- ggplot2::ggplot(plotDT, aes(x = obsTime, y = meanW/1000, colour = circuitLabel)) +
    geom_line() + 
    facet_grid(month  ~ year) + 
    theme(strip.text.y = element_text(angle = 0, vjust = 0.5, hjust = 0.5)) + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
    theme(legend.position = "bottom") + 
    labs(title = paste0("Power plot: ", hh),
         y = "Mean kW", 
         caption = paste0("gridSpy data from ", min(dt$r_dateTime), 
                          " to ", max(dt$r_dateTime),
                          "\nobsTime = Pacific/Auckland"))
  
  myPlot + 
    scale_x_time(breaks = timeBreaks) +
    geom_vline(xintercept = timeBreaks, alpha = vLineAlpha, colour = vLineCol)
  
  
  ofile <- paste0(gSpyParams$gSpyOutPath, "checkPlots/", hh, "_powerPlot.png")
  ggsave(ofile, height = 10)
  
} # << X end per household loop ----


# End
