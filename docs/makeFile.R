### ----- About ---- 
# Master (make) file for documentation
####

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

# Load nzGREENGrid package ----

print(paste0("#-> Load nzGREENGridDataR package"))
library(nzGREENGridDataR) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up nzGREENGridDataR package "))
nzGREENGridDataR::setup()
print(paste0("#-> Done "))

# Load libraries needed in this .r file ----
localLibs <- c("rmarkdown", "bookdown")
nzGREENGridDataR::loadLibraries(localLibs)

# Local functions ----

# --- Code ---

# --- Overview report ----
title <- "NZ GREEN Grid project: Research data overview"
# run the report .Rmd and render to pdf
rmdFile <- paste0(ggrParams$projLoc, "/docs/ggOverviewReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title),
                  output_file = paste0(ggrParams$projLoc,"/docs/ggOverviewReport.html")
)

# --- Survey data report ----
title <- "GREEN Grid Data Processing:"
subtitle <- "Household Attributes File"
rmdFile <- paste0(ggrParams$projLoc, "/dataProcessing/surveys/createHouseholdAttributes.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title, subtitle = subtitle),
                  output_file = paste0(ggrParams$projLoc,"/docs/surveyProcessingReport.html")
)

# --- Grid spy data report ----
localData <- 1
rmdFile <- paste0(ggrParams$projLoc, "/dataProcessing/gridSpy/buildGridSpy1mReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(localData = localData),
                  output_file = paste0(ggrParams$projLoc,"/docs/gridSpy1mProcessingReport.html")
)

# --- TUD data report ----
