# --- Code to run the parameterised profile analysis ----

# Set parameters ----
# If no file is found that matches a new one will be created and saved
circuitPattern <- "Heat Pump"
dateFrom <- "2015-04-01"
dateTo <- "2016-03-31"

# Load packages ----
library(GREENGrid) # gg utilities
library(rmarkdown)

# Local parameters ----
fullFb <- 0 # switch on (1) or off (0) full feedback
localTest <- 0 # test on local data source (1) or full HPS (0) data?

b2Kb <- 1024 #http://whatsabyte.com/P1/byteconverter.htm
b2Mb <- 1048576

repoLoc <- findParentDirectory("GREENGrid")

# Local functions ----

if(localTest == 1){
  # Local test
  dPath <- "~/Data/NZGreenGrid/" # BA laptop test set
  fpath <- paste0(dPath,"gridspy/1min_orig/") # location of original data
  outPath <- paste0(dPath, "safe/gridSpy/1min/") # place to save them / load from
} else {
  # HPS data source
  dPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/" # HPS
  fpath <- paste0(dPath,"_RAW DATA/GridSpyData/") # location of data
  outPath <- paste0(dPath, "cleanData/safe/gridSpy/1min/") # place to save them
}

# test to see if the file we need exists
fName <- paste0(fName <- paste0(circuitPattern, "_", dateFrom, "_", dateTo, "_observations.csv"))
iFile <- paste0(outPath, "dataExtracts/", fName)

fileExists <- file.exists(paste0(iFile,".gz")) # don't forget .gz

if(fileExists){
  # iFile exists
  print(paste0(iFile, ".gz exists, loading & using."))
} else {
  print(paste0(iFile, " does not exist, running extraction..."))
  # iFile does not exist so need to create it
  fPath <- paste0(outPath, "data/")
  extractCleanGridSpyCircuit(fPath, iFile, circuitPattern, dateFrom, dateTo)
  print(paste0("Done - look for data in: ", iFile))
}

# run the extractor .Rmd and render to pdf
rmarkdown::render(input = "analysis/ggDemandProfiles/nzGGProfileAnalyserTemplate.Rmd",
                  output_format = "pdf_document",
                  params = list(circuitPattern = circuitPattern, dateFrom = dateFrom, dateTo = dateTo, iFile = iFile),
                  output_file = paste0(outPath,"profiles/nzGGHouseholdPowerDemandProfile_",
                                       circuitPattern, "_", dateFrom, "_", dateTo, ".pdf"))
