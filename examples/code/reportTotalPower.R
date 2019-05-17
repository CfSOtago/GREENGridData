print(paste0("#--------------- Reporting NZ GREEN Grid Grid Household Total Power Data ---------------#"))

# Reports the results of running the imputeTotalPower.r script.
# Uses the 'all households' file

# Libraries ----

library(lubridate)
library(data.table)
library(drake) # introduced to aid workflow - you'll see why
library(readr) # use fread instead where possible
library(here)

# parameterise data path - edit for your set up ----
source(paste0(here::here(), "ggrParams.R")) # has to be done here not within .Rmd. Why?

sysname <- Sys.info()[[1]]
user <- Sys.info()[[6]]
message("Running on ", sysname, " under user ", user)

#circuitsFile <- "circuitsToSum.csv"
circuitsFile <- "circuitsToSum_v1.0" # JKM original
#circuitsFile <- "circuitsToSum_v1.1" # all

# localise data paths
if(user == "ben" & sysname == "Darwin"){
  # Ben's laptop
  dPath <- "~/Data/NZ_GREENGrid/reshare/v1.0/data/powerData"
  dFile <- paste0(dPath, "/imputed/allHouseholds_totalW_long_", circuitsFile, ".csv")
} else {
  dPath <- "/Users/jkmair/GreenGrid/data/clean_raw" # <- Jason
  dFile <- paste0(dPath, "/imputed/allHouseholds_totalW_long_", circuitsFile, ".csv")
}

# set up ----

# hh attributes
hhFile <- "~/Data/NZ_GREENGrid/reshare/v1.0/data/ggHouseholdAttributesSafe.csv.zip"

start_exec <- Sys.time()

dataL <- data.table() # data bucket to collect data in

loadFile <- function(f){
  if(file.exists(f)){
     dt <- data.table::as.data.table(readr::read_csv(f)) # load hh data
     data.table::setkey(dt, linkID)
   } else {
     print(paste0("Failed to find ", f," - is the data source available?"))
   } 
  return(dt)
}

# set drake plan ----
rmdFile <- paste0(here::here(), "/examples/code/reportTotalPower.Rmd")
message("Checking Rmd file to run exists: ", file.exists(rmdFile))

htmlFile <- paste0(here::here(), "/examples/outputs/reportTotalPower_",circuitsFile,".html")
title <- "GREENGrid Household Electricity Demand Data Test"
subtitle <- paste0('Imputed total power demand using: ', circuitsFile)
knitParams <- list(
  circuitsFile = circuitsFile,
  title = title,
  subtitle = subtitle
)

plan <- drake::drake_plan(
  powerData = loadFile(dataFile),
  hhData = loadFile(hhFile),
  report = rmarkdown::render(
    knitr_in(rmdFile),
    params = knitParams,
    output_file = file_out(htmlFile),
    quiet = TRUE # change to TRUE for peace & quiet
  )
)


# test the plan ----
plan

config <- drake_config(plan)
vis_drake_graph(config)

# do the plan ----
make(plan)


end_exec <- Sys.time()
end_exec - start_exec


