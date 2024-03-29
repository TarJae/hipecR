
#' @title tar_WellPanel
#' @description Creates a shinydashboard box equivalent with shiny
#' @param n integer the gives the number of months in follow-up
#' @return returns a wellpanel a quasi shinydashboard box
#' (without ShinyDashboard)
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_WellPanel
#' @export

tar_WellPanel <- function(n) {
  n_str <- as.character(n)

  wellPanel(
    h3(paste(n_str, "Monate")),
    tar_dateInput(paste("FUp_", n_str, "Mo_Datum", sep = ""), "Datum"),
    selectInput(paste("FUp_", n_str, "Mo__Follow_Up_Status", sep = ""),
                "Status", c("", "A", "B", "C")),
    selectInput(paste("FUp_", n_str, "Mo_Art_des_Rezidivs", sep = ""),
                "Art des Rezidivs", c("", "A", "B", "C")),
    textInput(paste("FUp_", n_str, "Mo_Anmerkungen", sep = ""),
              "Anmerkungen","")
  )
}


#' @title tar_dateinput
#' @description Handles date format in Austrian HIPEC Registry(c)
#' @param inputId character
#' @param label character
#' @return returns a date in dd-MM-yyyy format
#' @details DETAILS
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
