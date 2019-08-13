### ----- About ----
# Master (make) file for GridSpy data processing. This file lets you:

# 1: Process the data and update (refresh) all the files.
# Only run this if you have substantial new data as it takes a while.

# Best run using Rscript to avoid RStudio lock-up: http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/
# -> Rscript makeFile.R

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
#households <- "all" # all the ones we have
households <- c("rf_46") # just the ones we specify here - NB this will over-write the summary stats

# > Set grid spy data paths etc from file ----
source(paste0(ggrParams$repoLoc, "/dataProcessing/gridSpy/gSpyParams.R"))

# > Get DST labels ----
dstDT <- data.table::fread(gSpyParams$dstNZDates)

# Load libraries needed in this .r file ----
localLibs <- c("drake", 
               "rmarkdown", 
               "bookdown")

GREENGridData::loadLibraries(localLibs)

# Local functions ----

getFileList <- function(path){
  fListAllDT <- GREENGridData::getGridSpyFileList(path, # where to look
                                                  gSpyParams$pattern, # what to look for
                                                  # can't be clever as hhID is not in the filenames
                                                  # so we have to list all files and _then_ filter
                                                  gSpyParams$gSpyFileThreshold # file size threshold
  )
  # > Fix ambiguous dates in meta data derived from file listing
  fListAllDT <- GREENGridData::fixAmbiguousDates(fListAllDT)
  # > Save the full list listing
  ofile <- gSpyParams$fListAll #  set in global
  print(paste0("#-> Saving full list of 1 minute data files with metadata to ", ofile))
  data.table::fwrite(fListAllDT, ofile)
  return(fListAllDT)
}

# --- Code ---

print(msg1)

allFiles <- getFileList(gSpyParams$gSpyInPath)
selectedFiles <- 
  
  # > set start time ----
  startTime <- proc.time()
  print(paste0("#-> Refreshing all data using ", gSpyParams$gSpyInPath))
  sourceF <- paste0(ggrParams$repoLoc, "/dataProcessing/gridSpy/processGridSpy1mData.R")
  print(paste0("#-> Running ", sourceF))
  source(sourceF)
  print("#-> Data refresh complete")
  t <- proc.time() - startTime
  print(paste0("#-> Data refresh completed in ", GREENGridData::getDuration(t)))
  print(paste0("Non-fatal data processing warnings may follow"))


