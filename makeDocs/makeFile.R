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
localLibs <- c("rmarkdown",
               "bookdown",
               "kableExtra" # for fancier tables
               )
nzGREENGridDataR::loadLibraries(localLibs)

# Local functions ----

# Local parameters ----
version <- "1.0"

# --- Code ---

# --- Overview report ----
title <- paste0("NZ GREEN Grid Household Electricity Demand Study: Research data overview (version ", version, ")")
rmdFile <- paste0(ggrParams$projLoc, "/makeDocs/buildOverviewReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title),
                  output_file = paste0(ggrParams$projLoc,"/docs/overviewReport.html")
)

# --- Survey data report ----
title <- "GREEN Grid Data Processing:"
subtitle <- paste0("Household Attributes File (version ", version, ")")
rmdFile <- paste0(ggrParams$projLoc, "/makeDocs/buildHouseholdAttributesReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title, subtitle = subtitle),
                  output_file = paste0(ggrParams$projLoc,"/docs/surveyProcessingReport.html")
)

# --- Grid spy data report ----
localData <- 0 # 1 = yes
title <- "NZ GREEN Grid project data processing report"
subtitle <- paste0("1 minute electricity power (version ", version, ")")
rmdFile <- paste0(ggrParams$projLoc, "/makeDocs/buildGridSpy1mReport.Rmd")
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(localData = localData, title = title, subtitle = subtitle),
                  output_file = paste0(ggrParams$projLoc,"/docs/gridSpy1mProcessingReport.html")
)

# --- TUD data report ----
