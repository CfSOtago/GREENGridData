#' Loads GridSpy household data from .xlsx
#'
#' \code{getHouseholdData} does what it says. Expects an .xlsx with two sheets, one for each sample.
#'
#' Combines & returns the results as a data.table which records:
#' 
#'    - power company
#'    - location
#'    - n adults
#'    - n children aged 0-12
#'    - n chidlren aged 13-18
#'    - any recruitment or sampling notes
#'    - date GridSpy monitor disconnected and (potentially) re-used
#'    
#'    Will be extended to include other survey data when available.
#'
#' @param f the .xlsx file
#'
#' @import data.table
#' @import lubridate
#' @import readxl
#'
#' @author Ben Anderson, \email{b.anderson@@soton.ac.uk}
#' @export
#'
#'
getHouseholdData <- function(f) {
  #f <- ggrParams$gsHHMasterFile
  hbDT <- data.table::as.data.table(readxl::read_xlsx(f, sheet = "HawkesBay"))

  # keep safe data only
  hbDT <- hbDT[, .(hhID, linkID,
                           Location, nAdults, nChildren0_12, nTeenagers13_18, notes, stopDate)]
  hbDT <- hbDT[, r_stopDate := lubridate::ymd(stopDate)]
  hbDT$stopDate <- NULL
  #head(hbDT)
  
  tDT <- data.table::as.data.table(readxl::read_xlsx(f, sheet = "Taranaki"))
  tDT <- tDT[, .(hhID, linkID,
                             Location,nAdults,nChildren0_12,nTeenagers13_18,notes, stopDate)]
  tDT <- tDT[, r_stopDate := lubridate::ymd(stopDate)]
  tDT$stopDate <- NULL
  #head(tDT)

  # remove NA on rbind
  dt <- rbind(hbDT[!is.na(hhID)], tDT[!is.na(hhID)])
  return(dt)
}
