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
  unisonDT <- data.table::as.data.table(readxl::read_xlsx(f, sheet = "Unison"))

  # keep safe data only
  unisonDT <- unisonDT[, .(hhID, linkID,
                           Location, nAdults, nChildren0_12, nTeenagers13_18, notes, stopDate)]
  unisonDT <- unisonDT[, r_stopDate := lubridate::ymd(stopDate)]
  unisonDT$stopDate <- NULL
  #head(unisonDT)
  
  powercoDT <- data.table::as.data.table(readxl::read_xlsx(f, sheet = "Powerco"))
  powercoDT <- powercoDT[, .(hhID, linkID,
                             Location,nAdults,nChildren0_12,nTeenagers13_18,notes, stopDate)]
  powercoDT <- powercoDT[, r_stopDate := lubridate::ymd(stopDate)]
  powercoDT$stopDate <- NULL
  #head(powercoDT)

  # remove NA on rbind
  dt <- rbind(unisonDT[!is.na(hhID)], powercoDT[!is.na(hhID)])
  return(dt)
}
