#' Sets a range of parameters re-used throughout the repo by sourcing the <repo>/ggParams.R file
#'
#' \code{setup} sources the <repo>/ggParams.R file which sets a range of parameters as elements of the `ggParams` list. These include data sources and .Rmd include locations.
#'
#'   The parameters can be over-written in scipts if needed but do so wih care!
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk} (original)
#' @export
#'
setup <- function(){
  pLoc <- nzGREENGridr::findParentDirectory("nzGREENGridr") # R project location
  source(paste0(pLoc, "/ggrParams.R"))
}
