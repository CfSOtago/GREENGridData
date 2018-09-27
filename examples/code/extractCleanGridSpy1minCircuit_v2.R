####- R script to extract and save all observations whose circuit labels match a given pattern between two dates -####
# v2 - tries to extract multiple circuit labels into seperate files as it parses each household (quicker if more than 1 label)

# If the pattern/dateFrom/dateTo file already exists, it skips and ends

# Best run using: "> Rscript extractCleanGridSpy1minCircuit.R"

# Header ----

#> Set start time ----
startTime <- proc.time()

#> Load GREENGrid package ----
library(GREENGridData)

#> Packages needed in this .Rmd file ----
rmdLibs <- c("data.table", # data munching
             "dplyr", # data munching
             "readr"
)
# load them
GREENGridData::loadLibraries(rmdLibs)

#> Local parameters ----
circuitPattern <- c("Hot Water", "Heat Pump", "Lighting") # try to do them all in one go to save re-loading the data each time
dateFrom <- "2015-04-01"
dateTo <- "2016-03-31"

fullFb <- 0 # switch on (1) or off (0) full feedback
localData <- 1 # test using local (1) or Otago HCS (0) data?
refresh <- 1 # refresh data even if it seems to already exsit

b2Kb <- 1024 # http://whatsabyte.com/P1/byteconverter.htm
b2Mb <- 1048576

# >> Amend paths to suit your data storage location ----
if(localData == 1){
  # local
  iPath <- "~/Data/NZ_GREENGrid/reshare/v1.0/data/powerData/" # downloaded from https://dx.doi.org/10.5255/UKDA-SN-853334
  oPath <- "~/Data/NZ_GREENGrid/safe/gridSpy/1min/"
} else {
  # HCS
  dPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/cleanData/safe/gridSpy/1min/" # Otago HCS
  iPath <- paste0(dPath, "data/")
  oPath <- paste0(dPath, "dataExtracts/")
}
if(Sys.info()[4] == "gridcrawler"){
  # we're on the CS RStudio server
  dPath <- path.expand("~/greenGridData/cleanData/safe/gridSpy/1min/")
  iPath <- paste0(dPath, "data/")
  oPath <- paste0(dPath, "dataExtracts/")
}

# Code ----

if(localData){
  msg <- paste0("#-> Test run using reduced data from ", iPath)
} else {
  msg <- paste0("#-> Full run using all data from ", iPath)
}

print(msg)

#> Set output file name ----

oFile <- paste0(circuitPattern, "_", dateFrom, "_", dateTo, "_observations.csv")

exFile <- paste0(oPath, oFile) # place to save them
exFileTest <- paste0(exFile, ".gz")

#>  Run the extraction ----

if(file.exists(exFileTest) & refresh == 0){
  print(paste0(exFileTest, " exists and refresh = 0 so skipping.")) # prevents the file load in the function
  print(paste0("=> You may need to check your circuit label pattern (",
               circuitPattern ,") and date filter settings (",
               dateFrom, " - ", dateTo, ") if this is not what you expected."))


} else {
  print(paste0(exFileTest, " does not exist or refresh == 1 so running extraction.")) # prevents the file load in the function
  extractedDT <- GREENGridData::extractCleanGridSpyCircuitV2(iPath,
                                            exFile,
                                            circuitPattern,
                                            dateFrom,
                                            dateTo)
  print(paste0("Done - look for data in: ", exFileTest))
  t <- proc.time() - startTime
  elapsed <- t[[3]]
  print(paste0("Extraction of ", circuitPattern," circuit data completed in ",
               round(elapsed,2),
               " seconds ( ",
               round(elapsed/60,2), " minutes) using ",
               R.version.string , " running on ", R.version$platform , "."))
}


