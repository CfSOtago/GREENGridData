#--- Runs the circuit extract analysis ---#

# Load nzGREENGrid package ----
library(GREENGridData) # local utilities

GREENGridData::setup()

# Packages needed in this .Rmd file ----
rmdLibs <- c("data.table", # data munching
             "lubridate", # date & time stuff
             "ggplot2", # for fancy graphs
             "readr", # for reading & parsing .csv files
             "rmarkdown", # for render
             "bookdown", # for html2
             "kableExtra" # for pretty kable
)
# load them
loadLibraries(rmdLibs)

# Local parameters ----

# use circuit parameter to change the circuit used (assumes you have already extracted it)
circuit <- "Hot Water"

# change this to suit your data location

gsFile <- paste0(ggrParams$dataLoc, "cleanData/safe/gridSpy/1min/dataExtracts/",
                circuit, # change the circuit and you change the data used :-)
                 "_2015-04-01_2016-03-31_observations.csv.gz")
hhFile <- ggrParams$hhAttributes

# --- Build report ----

# NB this will fail if you do not have access to the data and/or an extract that matches 'Heat Pump' from https://dx.doi.org/10.5255/UKDA-SN-853334

rmdFile <- paste0(ggrParams$repoLoc, "/examples/code/testCircuitExtract.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(circuit = circuit, gsFile = gsFile, hhFile = hhFile),
                  output_file = paste0(ggrParams$repoLoc,"/examples/outputs/testCircuitExtract_", circuit, ".html")
)
