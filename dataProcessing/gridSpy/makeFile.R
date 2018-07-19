### ----- About ---- 
# Master (make) file for gridSpy data processing. This file lets you:

# 1: Process the data and update (refresh) all the files. 
# Only run this if you have substantial new data as it takes a while.

# 2: Create a data processing report using the 'meta' data created by 1. 
# Obviously if you do not re-run 1 over new data then you will get a report based on the previous data processing run.
####

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

# Load nzGREENGrid package ----
library(nzGREENGridDataR) # local utilities

# Set global package parameters ----
nzGREENGridDataR::setup()

# Set gSpy parameters ----
gSpyParams <- list()
gSpyParams$fullFb <- 0 # give full feedback (1 = yes)?
gSpyParams$localTest <- 1 # local data test or not (1 = yes)?
gSpyParams$gSpyFileThreshold <- 3000 # assume any files smaller than this (bytes) = no data or some mangled xml/html. Really, we should check the contents of each file.

gSpyParams$pattern <- "*at1.csv$" # e.g. *at1.csv$ filters only 1 min data

# > Data paths  ----
if(gSpyParams$localTest){
  # Local test
  gSpyParams$gSpyInPath <- paste0("~/Data/NZGreenGrid/gridspy/1min_orig/") # location of data (BA laptop)
  gSpyParams$gSpyOutPath <- paste0("~/Data/NZGreenGrid/safe/gridSpy/1min/") # place to save them (BA laptop)
  msg1 <- paste0("Test run using reduced data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
} else {
  # full monty
  gSpyParams$gSpyInPath <- paste0("/Volumes/hum-csafe/Research Projects/GREEN Grid/_RAW DATA/GridSpyData/") # location of data
  gSpyParams$gSpyOutPath <- paste0("/Volumes/hum-csafe/Research Projects/GREEN Grid/Clean_data/safe/gridSpy/1min/") # place to save them
  msg1 <- paste0("Full run using full data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
}

print(msg1)


gSpyParams$fListAll <- paste0(gSpyParams$gSpyOutPath, "checkStats/fListAllDT.csv") # place to store the interim file list with initial meta-data
gSpyParams$fLoadedStats <- paste0(gSpyParams$gSpyOutPath, "checkStats/fLoadedStats.csv") # place to store the final loaded file list with all meta-data
gSpyParams$hhStatsByDate <- paste0(gSpyParams$gSpyOutPath, "checkStats/hhStatsByDate.csv") # place to store the final hh summary stats


# Set local (this script) parameters ----
refreshData <- 1 # 0 = No
buildReport <- 1 # 0 = No

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

# --- Refresh data ----
# do this by sourcing the R code

# > set start time ----
startTime <- proc.time()

if(refreshData){
  print(paste0("Refreshing all data using ", gSpyParams$gSpyInPath))
  source(paste0(ggrParams$projLoc, "/dataProcessing/gridSpy/processGridSpy1mData.R"))
}
t <- proc.time() - startTime

print(paste0("Data refresh completed in ", getDuration(t)))


# > set start time ----
startTime <- proc.time()

# --- Build report ----
if(buildReport){
  print("Rebuilding report")
  #source("buildGridSpy1mReport.Rmd")
  # Do some checks on DSTT change hours
}

t <- proc.time() - startTime

print(paste0("Report rebuild completed in ", getDuration(t)))
