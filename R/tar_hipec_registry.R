# https://gist.github.com/gluc/d39cea3d11f03542970b
# Get table metadata. For now, just the fields
# Further development: also define field types
# and create inputs generically

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param variable PARAM_DESCRIPTION, Default: fieldsAll
#' @param label PARAM_DESCRIPTION, Default: label_names
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname GetTableMetadata
#' @export

GetTableMetadata <- function(variable = fieldsAll, label = label_names){

    vector_str <- paste("c(", paste(paste0(variable, " = \"", label, "\""), collapse = ", "), ")")
    # Convert the string into an actual vector
    fields <- eval(parse(text = vector_str))
    result <- list(fields = fields)
    return(result)
  }

# Find the next ID of a new record
# (in mysql, this could be done by an incremental index)
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION

#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname GetNextId
#' @export

GetNextId <- function() {
  if (exists("responses") && nrow(responses) > 0) {
    max(as.integer(rownames(responses))) + 1
  } else {
    return (1)
  }
}

#C
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname CreateData
#' @export

CreateData <- function(data) {

  data <- CastData(data)
  rownames(data) <- GetNextId()
  if (exists("responses")) {
    responses <<- rbind(responses, data)
  } else {
    responses <<- data
  }
}

#R
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION

#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname ReadData
#' @export

ReadData <- function() {
  if (exists("responses")) {
    responses
  }
}

#U
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname UpdateData
#' @export

UpdateData <- function(data) {
  data <- CastData(data)
  responses[row.names(responses) == row.names(data), ] <<- data
}

#D
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname DeleteData
#' @export

DeleteData <- function(data) {
  #  browser()
  responses <<- responses[row.names(responses) != unname(data["id"]), ]
}




# Cast from Inputs to a one-row data.frame
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname CastData
#' @export

CastData <- function(data) {
  datar <- data.frame(Institut = data["Institut"],
                      Register_Nr = as.integer(data["Register_Nr"]),
                      Erstellt_am = as.character(data["Erstellt_am"]),
                      Chirurg_kodiert = as.character(data["Chirurg"]),
                      Interne_Nr = as.integer(data["Interne Nr"]),
                      Ueberprueft = as.character(data["Ueberprueft"]),
                      Datum_der_ueberpruefung = as.character(data["Datum_der_ueberpruefung"]),
                      Name_des_ueberpruefenden = as.character(data["Name_des_ueberpruefenden"]),
                      stringsAsFactors = FALSE)

  rownames(datar) <- data["id"]
  return (datar)
}


# Return an empty, new record
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION

#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname CreateDefaultRecord
#' @export

CreateDefaultRecord <- function() {
  mydefault <- CastData(list(id = "0",
                             Institut = "",
                             Register_Nr = 0,
                             Erstellt_am = as.character(Sys.Date()),
                             Chirurg_kodiert = "",
                             Interne_Nr = 0,
                             Ueberprueft = "",
                             Datum_der_ueberpruefung = as.character(Sys.Date()),
                             Name_des_ueberpruefenden = "")
                        )
  return (mydefault)
}

# Fill the input fields with the values of the selected record in the table
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @param session PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[shiny]{updateTextInput}}, \code{\link[shiny]{updateNumericInput}}, \code{\link[shiny]{updateDateInput}}, \code{\link[shiny]{session}}
#' @rdname UpdateInputs
#' @export
#' @importFrom shiny updateTextInput updateNumericInput updateDateInput session
UpdateInputs <- function(data, session) {
  shiny::updateTextInput(session, "id", value = unname(rownames(data)))
  shiny::updateTextInput(session, "Institut", value = unname(data["Institut"]))
  shiny::updateNumericInput(session, "Register_Nr", value = unname(data["Register_Nr"]))
  shiny::updateDateInput(shiny::session, "Erstellt_am", value = unname(data["Erstellt_am"]))
  shiny::updateTextInput(shiny::session, "Chirurg_kodiert", value = unname(data["Chirurg_kodiert"]))
  shiny::updateNumericInput(shiny::session, "Interne_Nr", value = unname(data["Interne_Nr"]))
  shiny::updateTextInput(shiny::session, "Ueberprueft", value = unname(data["Ueberprueft"]))
  shiny::updateDateInput(shiny::session, "Datum_der_ueberpruefung", value = unname(data["Datum_der_ueberpruefung"]))
  shiny::updateTextInput(shiny::session, "Name_des_ueberpruefenden", value = unname(data["Name_des_ueberpruefenden"]))
}
