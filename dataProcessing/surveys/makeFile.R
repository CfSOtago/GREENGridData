### ----- About ---- 
# Master (make) file for survey data processing. This file lets you:

# 1: Create a data processing report & save out a safe data file.


# Best run using Rscript to avoid RStudio lock-up: http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/

####

# Housekeeping ----
rm(list=ls(all=TRUE)) # remove all objects from workspace

print(paste0("#--------------- Processing NZ GREEN Grid Grid Survey Data ---------------#"))

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

# --- Build report ----
buildReport <- 1

# Via (parameterised) .Rmd
title <- "GREEN Grid Data Processing:"
subtitle <- "Household Attributes File"

if(buildReport){
  startTime <- proc.time()
  print("#-- Rebuilding report")
  # run the report .Rmd and render to pdf
  rmdFile <- paste0(ggrParams$projLoc, "/dataProcessing/surveys/createHouseholdAttributes.Rmd")
  rmarkdown::render(input = rmdFile,
                    output_format = "html_document",
                    params = list(title = title, subtitle = subtitle),
                    output_file = paste0(ggrParams$projLoc,"/docs/surveyProcessingReport.html")
  )
  t <- proc.time() - startTime
  print(paste0("Report rebuild completed in ", nzGREENGridDataR::getDuration(t)))
}


