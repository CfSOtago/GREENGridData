# Local packages (needed in this script) ----
library(GREENGridData)
localLibs <- c("data.table",
               "ggplot2",
               "here",
               "lubridate")

GREENGridData::loadLibraries(localLibs)


gSpyParams$gSpyInPath <- path.expand("~/Data/NZ_GREENGrid/gridspy/1min_orig/") # location of original raw data (BA laptop)

print(paste0("#-> Refreshing file list"))
fListAllDT <- GREENGridData::getGridSpyFileList(gSpyParams$gSpyInPath, # where to look
                                                gSpyParams$pattern, # what to look for
                                                gSpyParams$gSpyFileThreshold # file size threshold
)
# > Fix ambiguous dates in meta data derived from file listing
fListAllDT <- GREENGridData::fixAmbiguousDates(fListAllDT)

# > Set start time ----
startTime <- proc.time()
# > Process files rf_46 files ----

hh <- "rf_46" # <- choose your household

fileList <- fListToLoadDT[hhID == hh, fullPath] # files for this household
print(paste0("#---------------------------- Begin ",hh,"----------------------------#"))
nFiles <- length(fileList)
print(paste0("#--> ", hh, ": Loading ", nFiles, " files..."))
dt <- processHhGridSpyData(hh, fileList) # returns final data table for testing if required
t <- proc.time() - startTime
print(paste0("#--> ",hh, ": ", nFiles ," data files loaded in ", getDuration(t)))

t <- dt[, .(min = min(r_dateTime), 
            max = max(r_dateTime), 
            minValue = min(powerW), 
            meanValue = mean(powerW), 
            maxValue = max(powerW)), 
        keyby = .(circuit)][order(min)]

t

plotDT <- dt[, .(nObs = .N, meanValue = mean(powerW)), keyby = .(circuit, date = lubridate::date(r_dateTime))]

p <- ggplot2::ggplot(plotDT, aes(x = date, y = circuit, fill = nObs)) +
  geom_tile() +
  theme(legend.position="bottom") +
  labs(caption = "rf_46 circuit labels (all data received)\n",
       "_Imag = reactive/imaginary power",
       "Incomer Voltage = voltage")

pFile <- paste0(here::here(), "/plots/rf_46_circuitLabels.png")
ggplot2::ggsave(pFile, p)
