### About ----
# R code to process GREEN grid gridSpy data
#
# Can be run here without .Rmd output

# Set up packages & parameters ----
source("dataProcessing/gridSpy/setup.R")

# Local parameters ----

# Code ----

if(baTest){
  msg1 <- paste0("Test run using reduced data from ", fpath)
} else {
  msg1 <- paste0("Full run using all data from ", fpath)
}

print(msg1)


if(refreshData){
  msg2 <- paste0("\nrefreshData = ", refreshData, " so rebuilding entire fileset. May take a while.")
} else {
  msg2 <- paste0("\nrefreshData = ", refreshData, " so re-using previous output. Should be relatively quick.")
}

print(msg2)

# get file list ----

if(refreshData){
  print("Rebuilding filelist")
  fListCompleteDT <- nzGREENGridDataR::getGridSpyFileList(fpath, pattern, fListInterim)
} else {
  print("Re-using filelist")
  fListCompleteDT <- fread(paste0(outPath,fListInterim))
}
print(paste0("Overall we have ", nrow(fListCompleteDT), " files from ",
             uniqueN(fListCompleteDT$hhID), " households."))

# for use below
nFiles <- nrow(fListCompleteDT)
nFilesNotLoaded <- nrow(fListCompleteDT[dateColName %like% "unknown"])

# fix ambiguous dates in meta data derived from file listing ----
fListCompleteDT <- nzGREENGridDataR::fixAmbiguousDates(fListCompleteDT)

# load and save gridSpy data ----
# process the data & update the fListCompleteDT
# get a few rows of data as an example
# refresh the data depending on refreshData (set in ./setup.R)

if(refreshData){
  print(paste0("'refreshData' = ", refreshData, " so re-building filelist"))
  # returns the updated file list into fListCompleteDT
  # creates hhStatDT (used below)
  # puts top 6 rows of last file into lastOfHeadDT
  fListCompleteDT <- nzGREENGridDataR::processGridSpyDataFiles(fListCompleteDT, fListFinal)
} else {
  print(paste0("'refreshData' = ", refreshData, " so re-using filelist"))
  fListCompleteDT <- fread(paste0(outPath,fListFinal))

  # need to create hhStatDT
  ofile <- paste0(outPath, "hhDailyObservationsStats.csv")
  hhStatDT <- fread(ofile)

  # need to get lastOfHeadDT
  # do this by getting the first in the processed list
  dPath <- paste0(outPath,"data/")
  fList <- list.files(path = dPath, pattern = "csv.gz")
  print(paste0("Re-using saved data file..."))
  lastOfHeadDT <- head(read_csv(paste0(dPath, fList[1])))
}

# test
print("Example data rows")
print(lastOfHeadDT)

# load household data ----
hhInfoDT <- nzGREENGridDataR::getMetaData(gsMasterFile)

# add survey data ----
setkey(fListCompleteDT, hhID)
setkey(hhInfoDT, hhID)
fListCompleteDT <- fListCompleteDT[hhInfoDT]

# create data quality outputs ----
t <- table(fListCompleteDT$circuitLabels,fListCompleteDT$hhID)

ofile <- paste0(outPath, "circuitLabelbyHHCheckTable.csv")
write.csv(t, ofile)

t <- fListCompleteDT[, .(circuitLabelCounts = uniqueN(hhID)), keyby = .(circuitLabels)]
ofile <- paste0(outPath, "circuitLabelbyHHCheckTable.csv")
write.csv(t, ofile)

dt <- fListCompleteDT[!is.na(circuitLabels),
                      .(nFiles = .N,
                        minObsDate = min(obsStartDate), # helps locate issues in data
                        maxObsDate = max(obsEndDate),
                        minFileDate = min(fMDate), # helps locate issues in files
                        maxFileDate = max(fMDate),
                        nObs = sum(nObs)),
                      keyby = .(circuitLabels, hhID, sample)] # ignore NA - it is files not loaded due to size thresholds

ofile <- paste0(outPath, "circuitLabelMetaDataCheckTable.csv")
write.csv(dt, ofile)

print("Done!")

t <- proc.time() - startTime

elapsed <- t[[3]]

print(paste0("Processing completed in ",
             round(elapsed,2), ", seconds ( ", round(elapsed/60,2),
" minutes) using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com) with ", R.version.string," running on ", R.version$platform, "."))

