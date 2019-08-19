### ----- About ----
# Master (make) file for documentation
####

# Load nzGREENGrid package ----

print(paste0("#-> Load GREENGridData package"))
library(GREENGridData) # local utilities
print(paste0("#-> Done "))

# Set global package parameters ----
print(paste0("#-> Set up GREENGridData package "))
GREENGridData::setup()
print(paste0("#-> Done "))

# Load libraries needed across all .Rmd files ----
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

title <- paste0("NZ GREEN Grid Household Electricity Demand Study")

# --- Code ---

# --- Overview report ----
doOverviewReport < function(){
  subtitle <- paste0("Research data overview (version ", version, ")")
  rmdFile <- paste0(ggrParams$repoLoc, "/makeDocs/buildOverviewReport.Rmd")
  rmarkdown::render(input = rmdFile,
                    output_format = "html_document2",
                    params = list(title = title, subtitle = subtitle, version = version),
                    output_file = paste0(ggrParams$repoLoc,"/docs/overviewReport_v", version, ".html")
  )
}


# --- Survey data report ----
doSurveyReport <- function(){
  subtitle <- paste0("Household attributes (version ", version, ")")
  rmdFile <- paste0(ggrParams$repoLoc, "/makeDocs/buildHouseholdAttributesReport.Rmd")
  rmarkdown::render(input = rmdFile,
                    params = list(title = title, subtitle = subtitle, version = version),
                    output_file = paste0(ggrParams$repoLoc,"/docs/householdAttributeProcessingReport_v", version, ".html")
  )
}


# --- Grid spy data report ----
# only run this if you have to - takes a while
localData <- 0 # 1 = yes for testing
doGridSpyreport <- function(){
  subtitle <- paste0("1 minute electricity power (version ", version, ")")
  rmdFile <- paste0(ggrParams$repoLoc, "/makeDocs/buildGridSpy1mReport.Rmd")
  rmarkdown::render(input = rmdFile,
                    output_format = "html_document2",
                    params = list(localData = localData, title = title, subtitle = subtitle, version = version),
                    output_file = paste0(ggrParams$repoLoc,"/docs/gridSpy1mProcessingReport_v", version, ".html")
  )
}


# --- Grid spy circuit level outliers report ----
localData <- 0 # 1 = yes
doGridSpyOutliersReport <- function(){
  subtitle <- paste0("1 minute circuit level electricity power outlier report (version ", version, ")")
  rmdFile <- paste0(ggrParams$repoLoc, "/makeDocs/buildGridSpyOutliers.Rmd")
  rmarkdown::render(input = rmdFile,
                    output_format = "html_document2",
                    params = list(localData = localData, title = title, subtitle = subtitle, version = version),
                    output_file = paste0(ggrParams$repoLoc,"/docs/gridSpy1mOutliersReport_v", version, ".html")
  )
}

# --- Grid spy imputed whole household demand report ----
localData <- 0 # 1 = yes
doGridSpyHouseholdLoadReport <- function(){
  source(paste0(ggrParams$repoLoc,"/makeDocs/reportTotalPower.R")) # <- requires drake. Will FAIL on CS RStudio Server 
}

# --- TUD data report ----

doSurveyReport()
#doGridSpyreport()
#doGridSpyOutliersReport()
#doGridSpyHouseholdLoadReport()

