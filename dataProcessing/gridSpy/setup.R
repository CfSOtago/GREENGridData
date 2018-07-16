# set up for .R or .Rmd

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

# Load nzGREENGrid package ----
library(nzGREENGrid) # local utilities

# Set start time ----
startTime <- proc.time()

# Local parameters ----
fullFb <- 1 # switch on (1) or off (0) full feedback
baTest <- 1 # test (1) or full (0) run?
refreshData <- 1 # re-build entire fileset? 0 = no

b2Kb <- 1024 #http://whatsabyte.com/P1/byteconverter.htm
b2Mb <- 1048576

if(baTest == 1){
  # Local test
  dPath <- "~/Data/NZGreenGrid/gridspy/" # BA laptop test set
  fpath <- paste0(dPath,"1min_orig/") # location of data
  outPath <- paste0("~/Data/NZGreenGrid/safe/gridSpy/1min/") # place to save them
} else {
  # full monty
  dPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/" # HPS
  fpath <- paste0(dPath,"_RAW DATA/GridSpyData/") # location of data
  outPath <- paste0(dPath, "Clean_data/safe/gridSpy/1min/") # place to save them
}

pattern <- "*at1.csv$" # e.g. *at1.csv$ filters only 1 min data
fListInterim <- "fListCompleteDT_interim.csv" # place to store the interim file list with initial meta-data
fListFinal <- "fListCompleteDT_final.csv" # place to store the final complete file list with all meta-data
gsMasterFile <- path.expand("~/Syncplicity Folders/Green Grid Project Management Folder/Gridspy/Master list of Gridspy units.xlsx")

dataThreshold <- 3000 # assume any files smaller than this (bytes) = no data or some mangled xml/html. Really, we should check the contents of each file.

projLoc <- nzGREENGrid::findParentDirectory("nzGREENGrid")

# Packages needed in this .Rmd file ----
rmdLibs <- c("data.table" # data munching
)
# load them
nzGREENGrid::loadLibraries(rmdLibs)

# Local functions ----
