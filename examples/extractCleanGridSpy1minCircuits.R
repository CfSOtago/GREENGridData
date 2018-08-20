####- R script to extract and save all observations whose circuit labels match a given pattern between two dates -####
# If the pattern/dateFrom/dateTo file already exists, it skips and ends

# Best run using: "> Rscript extractCleanGridSpy1minCircuits.R "

# Header ----

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

#> Set start time ----
startTime <- proc.time()

#> Load GREENGrid package ----
library(GREENGridData) # local utilities

#> Packages needed in this .Rmd file ----
rmdLibs <- c("data.table", # data munching
             "dplyr", # data munching
             "readr"
)
# load them
loadLibraries(rmdLibs)

#> Local parameters ----
circuitPattern <- "Heat Pump"
dateFrom <- "2015-04-01"
dateTo <- "2016-03-31"

fullFb <- 0 # switch on (1) or off (0) full feedback
localTest <- 0 # test using local (1) or full (0) data?
refresh <- 1 # refresh data even if it seems to already exsit

b2Kb <- 1024 # http://whatsabyte.com/P1/byteconverter.htm
b2Mb <- 1048576

# Amend these to suit your data storage location ----
if(localTest == 1){
  # Local test
  dPath <- "~/Data/NZGreenGrid/safe/gridSpy/1min/" # local test set
} else {
  # full clean data
  dPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/cleanData/safe/gridSpy/1min/" # Otago HCS
}
if(Sys.info()[4] == "gridcrawler"){
  # we're on the CS RStudio server
  dPath <- path.expand("~/greenGridData/cleanData/safe/gridSpy/1min/")
}

# Code ----

#> Set input path ----

iPath <- paste0(dPath, "data/")

if(localTest){
  msg <- paste0("#-> Test run using reduced data from ", iPath)
} else {
  msg <- paste0("#-> Full run using all data from ", iPath)
}

print(msg)

#> Set output file name ----

oFile <- paste0(circuitPattern, "_", dateFrom, "_", dateTo, "_observations.csv")

exFile <- paste0(dPath, "dataExtracts/", oFile) # place to save them
exFileTest <- paste0(exFile, ".gz")

if(file.exists(exFileTest) & refresh == 0){
  print(paste0(exFileTest, " exists and refresh = 0 so skipping.")) # prevents the file load in the function
  print(paste0("=> You may need to check your circuit label pattern (",
               circuitPattern ,") and date filter settings (",
               dateFrom, " - ", dateTo, ") if this is not what you expected."))
} else {
  print(paste0(exFileTest, " does not exist & refresh == 1 so running extraction.")) # prevents the file load in the function
  extractedDT <- extractCleanGridSpyCircuit(iPath, exFile,circuitPattern, dateFrom, dateTo)
  print(paste0("Done - look for data in: ", exFileTest))
}

t <- proc.time() - startTime

elapsed <- t[[3]]

print(paste0("Extraction of ", circuitPattern," circuit data completed in ",
             round(elapsed,2),
             " seconds ( ",
             round(elapsed/60,2), " minutes) using ",
             R.version.string , " running on ", R.version$platform , "."))
