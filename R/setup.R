#' Sets a range of parameters re-used throughout the repo by sourcing the <repo>/ggrParams.R file
#'
#' \code{setup} sources the <repo>/ggrParams.R file which sets a range of parameters as elements of the `ggrParams` list. These include default data sources and .Rmd include locations.
#'
#'   The parameters can be over-written in scipts if needed but do so wih care!
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk} (original)
#' @export
#'
setup <- function(){
  pLoc <- nzGREENGridDataR::findParentDirectory("nzGREENGridDataR") # R project location
  source(paste0(pLoc, "/ggrParams.R"))
}
