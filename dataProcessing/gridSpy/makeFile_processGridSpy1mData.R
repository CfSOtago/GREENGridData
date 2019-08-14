### ----- About ----
# Master (make) file for GridSpy data processing. This file lets you:

# 1: Process the data and update (refresh) all the files.
# Only run this if you have substantial new data as it takes a while.

# Best run using Rscript to avoid RStudio lock-up: http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/
# -> Rscript makeFile_processGridSpy1mData.R

####

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

print(paste0("#--------------- Processing NZ GREEN Grid GridSpy Data ---------------#"))

# Load GREENGridData package ----

print(paste0("#-> Load GREENGridData package"))
library(GREENGridData) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up GREENGridData package "))
GREENGridData::setup()
print(paste0("#-> Done "))

# Set local (this script) parameters ----
refreshData <- 1 # 0 = No
localData <- 1 # local data test or not (1 = yes)?

# > Which households? ----
households <- "all" # all the ones we have
#households <- c("rf_01", "rf_46") # just the ones we specify here - NB this will over-write the summary stats

# > Set grid spy data paths etc from file ----
source(paste0(ggrParams$repoLoc, "/dataProcessing/gridSpy/gSpyParams.R"))

# > Get DST labels ----
dstDT <- data.table::fread(gSpyParams$dstNZDates)

# Load libraries needed in this .r file ----
localLibs <- c("data.table",
               "hms",
               "here",
               "lubridate",
               "readr")

GREENGridData::loadLibraries(localLibs)

haveDrake <- require(drake) # not on CS RStudio server (yet)

# Local functions ----

refreshFiles <- function(){
  # refresh the file list. This takes a while and is annoying if
  # you are iterating the code to test (for example) one or 2 households

    print(paste0("#-> Refreshing file list"))
    dt <- GREENGridData::getGridSpyFileList(gSpyParams$gSpyInPath, # where to look
                                                    gSpyParams$pattern, # what to look for
                                                    gSpyParams$gSpyFileThreshold # file size threshold
    )
    # > Fix ambiguous dates in meta data derived from file listing
    dt <- GREENGridData::fixAmbiguousDates(dt)
    print(paste0("#-> Overall we have ", nrow(dt), " files from ",
                 uniqueN(dt$hhID), " households."))
    return(dt)
}

processHouseholds <- function(){
  # > set start time ----
  startTime <- proc.time()
  print(paste0("#-> Refreshing all data using ", gSpyParams$gSpyInPath))
  # should put this in a function really
  sourceF <- paste0(here::here(), "/dataProcessing/gridSpy/processGridSpy1mData.R")
  print(paste0("#-> Running ", sourceF))
  source(sourceF)
  print("#-> Data refresh complete")
  t <- proc.time() - startTime
  print(paste0("#-> Data refresh completed in ", GREENGridData::getDuration(t)))
  print(paste0("Non-fatal data processing warnings may follow"))
}
  
# ---- Code ----

print(msg1)

#> do it ----
# if drake
if(haveDrake){
  message("#-> Have drake - refreshing file list if drake thinks we need to")
  #> drake plan ----
  plan <- drake::drake_plan(
    drakeFileList = refreshFiles()
  )
  
  #> test it ----
  plan
  
  config <- drake_config(plan)
  vis_drake_graph(config)
  make(plan)
  fListAllDT <- drake::readd(drakeFileList) # get filelist back
} else {
  # no drake
  message("#-> No drake - refreshing file list")
  fListAllDT <- refreshFiles()
}

# don't do this within drake as it is usually the thing you need to re-run with new data/code
processHouseholds()