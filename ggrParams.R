ggrParams <<- list() # params holder

# Location of original data
ggrParams$projLoc <- findParentDirectory("nzGREENGrid")
ggrParams$dataLoc <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/" # HPS by default

# Location of basic household data
ggrParams$gsHHMasterFile <- path.expand("~/Syncplicity Folders/Green Grid Project Management Folder/Gridspy/Master list of Gridspy units.xlsx")

# Rmd includes
ggrParams$historyGenericRmd <- paste0(ggParams$projLoc, "/includes/historyGeneric.Rmd")
ggrParams$supportGenericRmd <- paste0(ggParams$projLoc, "/includes/supportGeneric.Rmd")
ggrParams$circulationGenericRmd <- paste0(ggParams$projLoc, "/includes/circulationGeneric.Rmd")

# Vars for Rmd
ggrParams$pubLoc <- "[Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/), University of Otago: Dunedin"
ggrParams$otagoHCS <- "the University of Otago's High-Capacity Central File Storage [HCS](https://www.otago.ac.nz/its/services/hosting/otago068353.html)"

# Misc
ggrParams$b2Kb <- 1024 #http://whatsabyte.com/P1/byteconverter.htm
ggrParams$b2Mb <- 1048576

