ggrParams <<- list() # params holder

# Location of original data
ggrParams$repoLoc <- findParentDirectory("GREENGridData")
ggrParams$dataLoc <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/" # HCS by default

# Location of basic household data
ggrParams$gsHHMasterFile <- paste0(ggrParams$dataLoc, "Green Grid Project Management/Gridspy/Master list of Gridspy units.xlsx")


ggrParams$ApplianceData <- paste0(ggrParams$dataLoc, "_RAW DATA/householdAttributes/appliancesSummary.xlsx")
ggrParams$UnisonShortSurveyData <- paste0(ggrParams$dataLoc, "_RAW DATA/householdAttributes/Unison/householdSurveyData/EC2HouseholdSurvey__UnisonShortSurvey_with_house_label.csv")
ggrParams$UnisonLongSurveyData <- paste0(ggrParams$dataLoc, "_RAW DATA/householdAttributes/Unison/householdSurveyData/EC2HouseholdSurvey__UnisonLongSurvey.csv")
ggrParams$PowercoSurveyData <- paste0(ggrParams$dataLoc, "_RAW DATA/householdAttributes/PowerCo/Household survey results 16.7.14.csv")
ggrParams$ec2LongSurveyLabels <- paste0(ggrParams$dataLoc, "_RAW DATA/householdAttributes/Unison/householdSurveyData/ec2QuestionLabels.xlsx")

ggrParams$hhOutPath <- "/Volumes/hum-csafe/Research Projects/GREEN Grid/cleanData/safe/survey/"

# Location of misc data
ggrParams$dstNZDates <- paste0(ggrParams$repoLoc, "/data/dstNZDates.csv")

# Location of stats
ggrParams$statsLoc <- paste0(ggrParams$dataLoc, "cleanData/safe/gridSpy/1min/checkStats/")

# Location of safe data
ggrParams$gsSafe <- paste0(ggrParams$dataLoc, "cleanData/safe/gridSpy/1min/data/")
ggrParams$hhAttributes <- paste0(ggrParams$dataLoc, "cleanData/safe/survey/ggHouseholdAttributesSafe.csv")

# Vars for Rmd
ggrParams$pubLoc <- "[Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/), University of Otago: Dunedin"
ggrParams$otagoHCS <- "the University of Otago's High-Capacity Central File Storage [HCS](https://www.otago.ac.nz/its/services/hosting/otago068353.html)"
ggrParams$repo <- "[GREENGridData](https://github.com/CfSOtago/GREENGridData)"

ggrParams$Authors <- "Anderson, B., Eyers, D., Ford, R., Giraldo Ocampo, D., Peniamina, R.,  Stephenson, J., Suomalainen, K., Wilcocks, L. and Jack, M."

# Rmd includes
ggrParams$licenseCCBY <- paste0(ggrParams$repoLoc, "/includes/licenseCCBY.Rmd")
ggrParams$supportGeneric <- paste0(ggrParams$repoLoc, "/includes/supportGeneric.Rmd")
ggrParams$sampleGeneric <- paste0(ggrParams$repoLoc, "/includes/sampleGeneric.Rmd")
ggrParams$history <- paste0(ggrParams$repoLoc, "/includes/historyGeneric.Rmd")
ggrParams$citation <- paste0(ggrParams$repoLoc, "/includes/citationGeneric.Rmd")

# Misc
ggrParams$b2Kb <- 1024 #http://whatsabyte.com/P1/byteconverter.htm
ggrParams$b2Mb <- 1048576

# http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette
# with grey
ggrParams$cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# with black
ggrParams$cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# see also
# https://www.r-bloggers.com/palettes-in-r/
