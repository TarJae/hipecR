# Function to handle unquoted inputs
#' Look-up function
#'
#' @param mykey an unquoted key or value
#'
#' @return a key or value, depending on what is wanted
#' @export
#'
#' @examples
#' # Example data
#' lookup_vector <- c(Hans = "1006341612", Maria = "1040405318")
#' df <- data.frame(Name = c("Hans", "Maria"), azl = c("1006341612", "1040405318"), stringsAsFactors = FALSE)
#'
#' tar_get_value(Hans)       # Returns "1006341612"
#' tar_get_value(1006341612) # Returns "Hans"

tar_get_value <- function(mykey) {
  # Capture the unquoted input
  mykey <- substitute(mykey)

  # Convert symbol/numeric input to character
  if (is.symbol(mykey) || is.numeric(mykey)) {
    mykey <- as.character(mykey)
  }

  # Check in named vector (keys)
  if (mykey %in% names(lookup_vector)) {
    return(unname(lookup_vector[mykey]))
  }

  # Convert numeric key to character for df lookup
  mykey_char <- as.character(mykey)

  # Check in data frame (values)
  if (mykey_char %in% df$azl) {
    return(unname(df$Name[df$azl == mykey_char]))
  }

  # If key not found in both
  stop("Key not found in any lookup source")
}

