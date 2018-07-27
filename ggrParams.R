ggrParams <<- list() # params holder

# Location of original data
ggrParams$projLoc <- findParentDirectory("nzGREENGridDataR")
ggrParams$dataLoc <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/" # HPS by default

# Location of basic household data
ggrParams$gsHHMasterFile <- "~/Syncplicity Folders/Green Grid Project Management Folder/Gridspy/Master list of Gridspy units.xlsx"

# Vars for Rmd
ggrParams$pubLoc <- "[Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/), University of Otago: Dunedin"
ggrParams$otagoHCS <- "the University of Otago's High-Capacity Central File Storage [HCS](https://www.otago.ac.nz/its/services/hosting/otago068353.html)"
ggrParams$repo <- "[nzGREENGridDataR](https://github.com/dataknut/nzGREENGridDataR)"

# Rmd includes
ggrParams$licenseCCBY <- paste0(ggrParams$projLoc, "/includes/licenseCCBY.Rmd")
ggrParams$supportGeneric <- paste0(ggrParams$projLoc, "/includes/supportGeneric.Rmd")
ggrParams$sampleGeneric <- paste0(ggrParams$projLoc, "/includes/sampleGeneric.Rmd")

# Misc
ggrParams$b2Kb <- 1024 #http://whatsabyte.com/P1/byteconverter.htm
ggrParams$b2Mb <- 1048576

