### ----- About ----
# Master (make) file for documentation
####

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

# Load nzGREENGrid package ----

print(paste0("#-> Load GREENGridData package"))
library(GREENGridData) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up GREENGridData package "))
GREENGridData::setup()
print(paste0("#-> Done "))

# Load libraries needed across all .Rmd files ----
localLibs <- c("rmarkdown",
               "bookdown",
               "data.table", # data munching
               "ggplot2", # for fancy graphs
               "readr", # data loading
               "lubridate", # fixing dates & times
               "kableExtra" # for fancier tables
               )
GREENGridData::loadLibraries(localLibs)

# Local functions ----

# Local parameters ----
version <- "1.0"

# --- Code ---

# --- Overview report ----
title <- paste0("NZ GREEN Grid Household Electricity Demand Study")
subtitle <- paste0("Research data overview (version ", version, ")")
rmdFile <- paste0(ggrParams$projLoc, "/makeDocs/buildOverviewReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title, subtitle = subtitle, version = version),
                  output_file = paste0(ggrParams$projLoc,"/docs/overviewReport_v", version, ".html")
)

# --- Survey data report ----
subtitle <- paste0("Household attributes (version ", version, ")")
rmdFile <- paste0(ggrParams$projLoc, "/makeDocs/buildHouseholdAttributesReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title, subtitle = subtitle, version = version),
                  output_file = paste0(ggrParams$projLoc,"/docs/surveyProcessingReport_v", version, ".html")
)

# --- Grid spy data report ----
localData <- 0 # 1 = yes
subtitle <- paste0("1 minute electricity power (version ", version, ")")
rmdFile <- paste0(ggrParams$projLoc, "/makeDocs/buildGridSpy1mReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(localData = localData, title = title, subtitle = subtitle, version = version),
                  output_file = paste0(ggrParams$projLoc,"/docs/gridSpy1mProcessingReport_v", version, ".html")
)

# --- TUD data report ----
