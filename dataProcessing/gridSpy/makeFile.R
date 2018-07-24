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

print(paste0("#--- Load nzGREENGridDataR package"))
library(nzGREENGridDataR) # local utilities
print(paste0("#--- Done "))

# Set global package parameters ----
print(paste0("#--- Set up nzGREENGridDataR package "))
nzGREENGridDataR::setup()
print(paste0("#--- Done "))

# Set gSpy parameters ----
gSpyParams <- list()
gSpyParams$fullFb <- 0 # give full feedback (1 = yes)?
gSpyParams$gSpyFileThreshold <- 3000 # assume any files smaller than this (bytes) = no data or some mangled xml/html. Really, we should check the contents of each file.

gSpyParams$pattern <- "*at1.csv$" # e.g. *at1.csv$ filters only 1 min data
gSpyParams$refreshFileList <- 1 # forces new file search & ignores any previously saved lists

# Set local (this script) parameters ----
refreshData <- 1 # 0 = No
buildReport <- 1 # 0 = No
localTest <- 1 # local data test or not (1 = yes)?

# > Set data paths  ----

# dst dates
gSpyParams$dstNZDates <- paste0(nzGREENGridDataR::findParentDirectory("nzGREENGridDataR"),"/data/dstNZDates.csv")

if(localTest){
  # Local test
  gSpyParams$gSpyInPath <- "~/Data/NZGreenGrid/gridspy/1min_orig/" # location of data (BA laptop)
  gSpyParams$gSpyOutPath <- "~/Data/NZGreenGrid/safe/gridSpy/1min/" # place to save them (BA laptop)
  msg1 <- paste0("#--- Test run using reduced data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
} else {
  # full monty
  gSpyParams$gSpyInPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/_RAW DATA/GridSpyData/" # location of data
  gSpyParams$gSpyOutPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/Clean_data/safe/gridSpy/1min/" # place to save them
  msg1 <- paste0("#--- Full run using full data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
}

gSpyParams$fListAll <- paste0(gSpyParams$gSpyOutPath, "checkStats/fListAllDT.csv") # place to store the interim file list with initial meta-data
gSpyParams$fLoadedStats <- paste0(gSpyParams$gSpyOutPath, "checkStats/fLoadedStats.csv") # place to store the final loaded file list with all meta-data
gSpyParams$hhStatsByDate <- paste0(gSpyParams$gSpyOutPath, "checkStats/hhStatsByDate.csv") # place to store the final hh summary stats

# Local functions ----
getDuration <- function(t){
  elapsed <- t[[3]]
  duration <- paste0(round(elapsed,2), 
               " seconds ( ", 
               round(elapsed/60,2),
               " minutes)"
  )
  return(duration)
}

# --- Code ---


print(msg1)

# --- Refresh data ----
# do this by sourcing the R code
if(refreshData){
  # > set start time ----
  startTime <- proc.time()
  print(paste0("#-- Refreshing all data using ", gSpyParams$gSpyInPath))
  sourceF <- paste0(ggrParams$projLoc, "/dataProcessing/gridSpy/processGridSpy1mData.R")
  print(paste0("#-- Running ", sourceF))
  source(sourceF)
  print("#-- Data refresh complete") 
  t <- proc.time() - startTime
  print(paste0("#-- Data refresh completed in ", getDuration(t)))
}


# --- Build report ----
# Via (parameterised) .Rmd
if(buildReport){
  startTime <- proc.time()
  print("#-- Rebuilding report")
  # run the report .Rmd and render to pdf
  rmarkdown::render(input = "buildGridSpy1mReport.Rmd",
                    output_format = "pdf_document",
                    output_file = paste0(gSpyParams$gSpyOutPath,"processingReports/gridSpy1mProcessingReport.pdf")
  )
  t <- proc.time() - startTime
  print(paste0("Report rebuild completed in ", getDuration(t)))
}


