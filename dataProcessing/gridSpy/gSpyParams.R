# Set gSpy parameters ----
gSpyParams <- list()
gSpyParams$fullFb <- 0 # give full feedback (1 = yes)?
gSpyParams$refreshFileList <- 1 # forces new file search & ignores any previously saved lists

gSpyParams$gSpyFileThreshold <- 3000 # assume any files smaller than this (bytes) = no data or some mangled xml/html. Really, we should check the contents of each file.

gSpyParams$pattern <- "*at1.csv$" # e.g. *at1.csv$ filters only 1 min data

gSpyParams$dstNZDates <- paste0(findParentDirectory("GREENGridData"),"/data/dstNZDates.csv")

# Must be run after localData is set

if(localData){
  # Local test
  gSpyParams$gSpyInPath <- "~/Data/NZGreenGrid/gridspy/1min_orig/" # location of data (BA laptop)
  gSpyParams$gSpyOutPath <- "~/Data/NZGreenGrid/safe/gridSpy/1min/" # place to save them (BA laptop)
  msg1 <- paste0("#--- Test run using reduced data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
} else {
  # full monty
  gSpyParams$gSpyInPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/_RAW DATA/GridSpyData/" # location of data
  gSpyParams$gSpyOutPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/cleanData/safe/gridSpy/1min/" # place to save them
  msg1 <- paste0("#--- Full run using full data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
}
if(Sys.info()[4] == "gridcrawler"){
  # we're on the CS RStudio server
  gSpyParams$gSpyInPath <- path.expand("~/greenGridData/_RAW DATA/GridSpyData/") # location of data
  gSpyParams$gSpyOutPath <- path.expand("~/greenGridData/cleanData/safe/gridSpy/1min/") # place to save them
  msg1 <- paste0("#--- Full run using full data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
  
}

# > set check plots location (not github - too large) ----
gSpyParams$checkPlots <- paste0(gSpyParams$gSpyOutPath,"checkPlots/") # place to store the final hh summary stats

# > set summary stats location (not github) ----
gSpyParams$fListAll <- paste0(gSpyParams$gSpyOutPath,"checkStats/fListAllDT.csv") # place to store the interim file list with initial meta-data
gSpyParams$fLoadedStats <- paste0(gSpyParams$gSpyOutPath,"checkStats/fLoadedStats.csv") # place to store the final loaded file list with all meta-data
gSpyParams$hhStatsByDate <- paste0(gSpyParams$gSpyOutPath,"checkStats/hhStatsByDate.csv") # place to store the final hh summary stats
