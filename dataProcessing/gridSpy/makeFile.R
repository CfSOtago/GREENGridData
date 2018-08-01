### ----- About ---- 
# Master (make) file for gridSpy data processing. This file lets you:

# 1: Process the data and update (refresh) all the files. 
# Only run this if you have substantial new data as it takes a while.

# 2: Create a data processing report using the 'meta' data created by 1. 
# Obviously if you do not re-run 1 over new data then you will get a report 
# based on the previous data processing run.


# Best run using Rscript to avoid RStudio lock-up: http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/

####

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

print(paste0("#--------------- Processing NZ GREEN Grid Grid Spy Data ---------------#"))

# Load nzGREENGrid package ----

print(paste0("#-> Load nzGREENGridDataR package"))
library(nzGREENGridDataR) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up nzGREENGridDataR package "))
nzGREENGridDataR::setup()
print(paste0("#-> Done "))

# Load libraries needed in this .r file ----
localLibs <- c("rmarkdown")
nzGREENGridDataR::loadLibraries(localLibs)


# Set local (this script) parameters ----
refreshData <- 1 # 0 = No
buildReport <- 0 # 0 = No
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
  print(paste0("#-> Data refresh completed in ", nzGREENGridDataR::getDuration(t)))
  print(paste0("Non-fatal data processing warnings may follow"))
}


# --- Build report ----
library(rmarkdown)
# Via (parameterised) .Rmd
if(buildReport){
  startTime <- proc.time()
  print("#-- Rebuilding report")
  # run the report .Rmd and render to pdf
  rmdFile <- paste0(ggrParams$projLoc, "/dataProcessing/gridSpy/buildGridSpy1mReport.Rmd")
  rmarkdown::render(input = rmdFile,
                    output_format = "html_document",
                    params = list(localData = localData),
                    output_file = paste0(ggrParams$projLoc,"/docs/gridSpy1mProcessingReport.html")
  )
  t <- proc.time() - startTime
  print(paste0("Report rebuild completed in ", nzGREENGridDataR::getDuration(t)))
}


