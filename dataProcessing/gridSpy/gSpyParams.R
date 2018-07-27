# Set gSpy parameters ----
gSpyParams <- list()
gSpyParams$fullFb <- 0 # give full feedback (1 = yes)?
gSpyParams$refreshFileList <- 1 # forces new file search & ignores any previously saved lists

gSpyParams$gSpyFileThreshold <- 3000 # assume any files smaller than this (bytes) = no data or some mangled xml/html. Really, we should check the contents of each file.

gSpyParams$pattern <- "*at1.csv$" # e.g. *at1.csv$ filters only 1 min data

gSpyParams$dstNZDates <- paste0(nzGREENGridDataR::findParentDirectory("nzGREENGridDataR"),"/data/dstNZDates.csv")
gSpyParams$gSpyFileThreshold

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
  gSpyParams$gSpyOutPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/Clean_data/safe/gridSpy/1min/" # place to save them
  msg1 <- paste0("#--- Full run using full data from ", 
                 gSpyParams$gSpyInPath, " and saving to ",
                 gSpyParams$gSpyOutPath)
}

gSpyParams$fListAll <- paste0(ggrParams$projLoc,"/checkStats/fListAllDT.csv") # place to store the interim file list with initial meta-data
gSpyParams$fLoadedStats <- paste0(ggrParams$projLoc,"/checkStats/fLoadedStats.csv") # place to store the final loaded file list with all meta-data
gSpyParams$hhStatsByDate <- paste0(ggrParams$projLoc,"/checkStats/hhStatsByDate.csv") # place to store the final hh summary stats
