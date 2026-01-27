
#' @title tar_WellPanel
#' @description Creates a shinydashboard box equivalent with shiny
#' @param n integer the gives the number of months in follow-up
#' @return returns a wellpanel a quasi shinydashboard box
#' (without ShinyDashboard)
#' @details Builds a wellPanel containing follow-up inputs for the given month.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_WellPanel
#' @export

tar_WellPanel <- function(n) {
  if (!is.numeric(n) || length(n) != 1 || is.na(n) || n < 0) {
    stop("n must be a single non-negative number.")
  }
  n_str <- as.character(n)

  shiny::wellPanel(
    htmltools::h3(paste(n_str, "Monate")),
    tar_dateInput(paste("FUp_", n_str, "Mo_Datum", sep = ""), "Datum"),
    shiny::selectInput(paste("FUp_", n_str, "Mo__Follow_Up_Status", sep = ""),
                "Status", c("", "A", "B", "C")),
    shiny::selectInput(paste("FUp_", n_str, "Mo_Art_des_Rezidivs", sep = ""),
                "Art des Rezidivs", c("", "A", "B", "C")),
    shiny::textInput(paste("FUp_", n_str, "Mo_Anmerkungen", sep = ""),
              "Anmerkungen","")
  )
}


#' @title tar_dateinput
#' @description Handles date format in Austrian HIPEC Registry(c)
#' @param inputId character
#' @param label character
#' @return A date input in dd-MM-yyyy format.
#' @details Wraps shinyWidgets::airDatepickerInput with fixed defaults.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[shinyWidgets]{airDatepicker}}
#' @rdname tar_dateInput
#' @export
#' @importFrom shinyWidgets airDatepickerInput
tar_dateInput <-  function(inputId, label) {
  if (!is.character(inputId) || length(inputId) != 1 || is.na(inputId) || nchar(inputId) == 0) {
    stop("inputId must be a non-empty character string.")
  }
  if (!is.character(label) || length(label) != 1 || is.na(label)) {
    stop("label must be a character string.")
  }
  shinyWidgets::airDatepickerInput(
    inputId = inputId,
    label = label,
    autoClose = TRUE,
    clearButton = TRUE,
    placeholder = "Select date",
    dateFormat = "dd-MM-yyyy",
    width = "150px"
  )
}
