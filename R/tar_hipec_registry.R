# https://gist.github.com/gluc/d39cea3d11f03542970b
# Get table metadata. For now, just the fields
# Further development: also define field types
# and create inputs generically

#' @title Registry field metadata
#' @description Create a named vector of fields and labels for the registry.
#' @param variable Character vector of field names. Default: fieldsAll.
#' @param label Character vector of labels. Default: label_names.
#' @return A list with element `fields`, a named character vector.
#' @details Expects `variable` and `label` to be the same length.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_get_table_metadata
#' @export
tar_get_table_metadata <- function(variable = fieldsAll, label = label_names){
  if (!is.character(variable) || !is.character(label)) {
    stop("variable and label must be character vectors.")
  }
  if (length(variable) != length(label)) {
    stop("variable and label must have the same length.")
  }
  fields <- stats::setNames(label, variable)
  result <- list(fields = fields)
  return(result)
}

# Find the next ID of a new record
# (in mysql, this could be done by an incremental index)
#' @title Get next registry ID
#' @description Get the next numeric ID based on the `responses` data frame.

#' @return Integer ID.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_get_next_id
#' @export
tar_get_next_id <- function() {
  if (exists("responses") && is.data.frame(responses) && nrow(responses) > 0) {
    ids <- suppressWarnings(as.integer(rownames(responses)))
    if (all(is.na(ids))) {
      return(nrow(responses) + 1L)
    }
    return(max(ids, na.rm = TRUE) + 1L)
  }
  return(1L)
}

#C
#' @title Create registry record
#' @description Add a new record to the in-memory `responses` data frame.
#' @param data A named list or data frame with registry fields.
#' @return Invisible NULL.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_create_data
#' @export
tar_create_data <- function(data) {
  if (missing(data)) {
    stop("data is required.")
  }
  data <- tar_cast_data(data)
  rownames(data) <- tar_get_next_id()
  if (exists("responses")) {
    responses <<- rbind(responses, data)
  } else {
    responses <<- data
  }
  invisible(NULL)
}

#R
#' @title Read registry data
#' @description Return the in-memory `responses` data frame, if present.

#' @return A data frame or NULL if not available.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_read_data
#' @export
tar_read_data <- function() {
  if (exists("responses")) {
    return(responses)
  }
  return(NULL)
}

#U
#' @title Update registry record
#' @description Update an existing record in `responses` by row name.
#' @param data A named list or data frame with registry fields.
#' @return Invisible NULL.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_update_data
#' @export
tar_update_data <- function(data) {
  if (!exists("responses") || !is.data.frame(responses)) {
    stop("responses data frame not found.")
  }
  data <- tar_cast_data(data)
  if (!all(row.names(data) %in% row.names(responses))) {
    stop("record id not found in responses.")
  }
  responses[row.names(responses) == row.names(data), ] <<- data
  invisible(NULL)
}

#D
#' @title Delete registry record
#' @description Delete a record from `responses` by id.
#' @param data A list or data frame containing an `id` field.
#' @return Invisible NULL.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_delete_data
#' @export
tar_delete_data <- function(data) {
  if (!exists("responses") || !is.data.frame(responses)) {
    stop("responses data frame not found.")
  }
  if (missing(data) || is.null(data["id"])) {
    stop("data must contain an 'id' field.")
  }
  responses <<- responses[row.names(responses) != unname(data["id"]), ]
  invisible(NULL)
}




# Cast from Inputs to a one-row data.frame
#' @title Cast registry data
#' @description Coerce raw input into a one-row data frame with registry fields.
#' @param data A list or data frame with registry fields.
#' @return A one-row data frame with standard column types.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_cast_data
#' @export
tar_cast_data <- function(data) {
  if (is.data.frame(data)) {
    data <- as.list(data[1, , drop = TRUE])
  }
  if (!is.list(data)) {
    stop("data must be a list or data frame.")
  }
  required <- c("id", "Institut", "Register_Nr", "Erstellt_am", "Chirurg_kodiert",
                "Interne_Nr", "Ueberprueft", "Datum_der_ueberpruefung",
                "Name_des_ueberpruefenden")
  missing_fields <- setdiff(required, names(data))
  if (length(missing_fields) > 0) {
    stop("Missing fields: ", paste(missing_fields, collapse = ", "))
  }
  datar <- data.frame(Institut = as.character(data["Institut"]),
                      Register_Nr = as.integer(data["Register_Nr"]),
                      Erstellt_am = as.character(data["Erstellt_am"]),
                      Chirurg_kodiert = as.character(data["Chirurg_kodiert"]),
                      Interne_Nr = as.integer(data["Interne_Nr"]),
                      Ueberprueft = as.character(data["Ueberprueft"]),
                      Datum_der_ueberpruefung = as.character(data["Datum_der_ueberpruefung"]),
                      Name_des_ueberpruefenden = as.character(data["Name_des_ueberpruefenden"]),
                      stringsAsFactors = FALSE)

  rownames(datar) <- data["id"]
  return (datar)
}


# Return an empty, new record
#' @title Create default registry record
#' @description Return an empty default registry record.

#' @return A one-row data frame with default values.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname tar_create_default_record
#' @export
tar_create_default_record <- function() {
  mydefault <- tar_cast_data(
    list(
      id = "0",
      Institut = "",
      Register_Nr = 0,
      Erstellt_am = as.character(Sys.Date()),
      Chirurg_kodiert = "",
      Interne_Nr = 0,
      Ueberprueft = "",
      Datum_der_ueberpruefung = as.character(Sys.Date()),
      Name_des_ueberpruefenden = ""
    )
  )
  return (mydefault)
}


#' @title Update Shiny inputs from record
#' @description Push a registry record into Shiny input controls.
#' @param data A one-row data frame with registry fields.
#' @param session Shiny session.
#' @return Invisible NULL.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[shiny]{updateTextInput}}, \code{\link[shiny]{updateNumericInput}}, \code{\link[shiny]{updateDateInput}}
#' @rdname tar_update_inputs
#' @export
#' @importFrom shiny updateTextInput updateNumericInput updateDateInput
tar_update_inputs <- function(data, session) {
  if (!is.data.frame(data) || nrow(data) != 1) {
    stop("data must be a one-row data frame.")
  }
  if (is.null(session)) {
    stop("session is required.")
  }
  shiny::updateTextInput(session, "id", value = unname(rownames(data)))
  shiny::updateTextInput(session, "Institut", value = unname(data["Institut"]))
  shiny::updateNumericInput(session, "Register_Nr", value = as.integer(data["Register_Nr"]))
  shiny::updateDateInput(session, "Erstellt_am", value = as.character(data["Erstellt_am"]))
  shiny::updateTextInput(session, "Chirurg_kodiert", value = as.character(data["Chirurg_kodiert"]))
  shiny::updateNumericInput(session, "Interne_Nr", value = as.integer(data["Interne_Nr"]))
  shiny::updateTextInput(session, "Ueberprueft", value = as.character(data["Ueberprueft"]))
  shiny::updateDateInput(session, "Datum_der_ueberpruefung", value = as.character(data["Datum_der_ueberpruefung"]))
  shiny::updateTextInput(session, "Name_des_ueberpruefenden", value = as.character(data["Name_des_ueberpruefenden"]))
  invisible(NULL)
}
