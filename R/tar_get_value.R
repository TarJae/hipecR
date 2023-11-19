# Function to handle unquoted inputs
#' Look-up function
#'

#' @param mykeyvalue an unquoted key or value

#'
#' @return a key or value, depending on what is wanted
#' @export
#'
#' @examples
#' # Example data
#' df <- data.frame(Name = c("Hans", "Maria"), azl = c("1006341612", "1040405318"), stringsAsFactors = FALSE)
#'
#' tar_get_value(Hans)       # Returns "1006341612"
#' tar_get_value(1006341612) # Returns "Hans"


# Function to handle inputs for data frame
tar_get_value <- function(mykeyvalue) {
  # Capture the unquoted input and convert to character
  mykeyvalue_char <- as.character(substitute(mykeyvalue))

  # Check if the input is numeric or character
  if (grepl("^[0-9]+$", mykeyvalue_char)) {
    # Input is numeric (azl)
    if (mykeyvalue_char %in% df$azl) {
      return(df$Name[df$azl == mykeyvalue_char])
    } else {
      stop("Numeric key not found in data frame")
    }
  } else {
    # Input is non-numeric (Name)
    if (mykeyvalue_char %in% df$Name) {
      return(df$azl[df$Name == mykeyvalue_char])
    } else {
      stop("Name key not found in data frame")
    }
  }
}
