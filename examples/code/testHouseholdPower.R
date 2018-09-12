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

# use hhID parameter to change the household used (assumes you have access to the data from https://dx.doi.org/10.5255/UKDA-SN-853334)
hhID <- "rf_38"

# change this to suit your data location

# change this to suit your data location & to use a different household
gsFile <- paste0(ggrParams$dataLoc, "cleanData/safe/gridSpy/1min/data/",
                 hhID,
                 "_all_1min_data.csv.gz")
hhFile <- ggrParams$hhAttributes

# --- Build report ----

# NB this will fail if you do not have access to the data and/or an extract that matches 'Heat Pump'

rmdFile <- paste0(ggrParams$repoLoc, "/examples/code/testHouseholdPower.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(hhID = hhID, gsFile = gsFile, hhFile = hhFile),
                  output_file = paste0(ggrParams$repoLoc,"/examples/outputs/testHouseholdPower_", hhID, ".html")
)
