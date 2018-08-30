### ----- About ----
# Master (make) file for GridSpy data processing. This file lets you:

# 1: Process the data and update (refresh) all the files.
# Only run this if you have substantial new data as it takes a while.

# Best run using Rscript to avoid RStudio lock-up: http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/

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

# Load libraries needed in this .r file ----
localLibs <- c("rmarkdown", "bookdown")
GREENGridData::loadLibraries(localLibs)


# Set local (this script) parameters ----
refreshData <- 0 # 0 = No
localData <- 0 # local data test or not (1 = yes)?

# Set grid spy data paths etc from file ----
source(paste0(ggrParams$projLoc, "/dataProcessing/gridSpy/gSpyParams.R"))

# Local functions ----

# --- Code ---

print(msg1)

# --- Refresh data ----
# do this by sourcing the R code
if(refreshData){
  # > set start time ----
  startTime <- proc.time()
  print(paste0("#-> Refreshing all data using ", gSpyParams$gSpyInPath))
  sourceF <- paste0(ggrParams$projLoc, "/dataProcessing/gridSpy/processGridSpy1mData.R")
  print(paste0("#-> Running ", sourceF))
  source(sourceF)
  print("#-> Data refresh complete")
  t <- proc.time() - startTime
  print(paste0("#-> Data refresh completed in ", GREENGridData::getDuration(t)))
  print(paste0("Non-fatal data processing warnings may follow"))
}

