# Function to handle unquoted inputs
#' Look-up function

#' @param mykeyvalue an unquoted key or value
#' @param df data frame with Name and azl number
#' @importFrom stringr str_detect
#' @importFrom stringr str_to_lower
#' @importFrom stringr fixed
#' @return a key or value, depending on what is wanted
#' @export
#'
#' @examples
#' # Example data
#' df <- data.frame(Name = c("Hans", "Maria", "Franz HUBER"), azl = c("1006341612", "1040405318", "1060707219"), stringsAsFactors = FALSE)
#'
#' tar_get_value(df, HUBER)       # Should return "1060707219"
#' tar_get_value(df, huber)       # Should also return "1060707219"
#' tar_get_value(df, Franz)       # Should return "1060707219"
#' tar_get_value(df, 1006341612)  # Should return "Hans"


# Function to handle inputs for data frame
tar_get_value <- function(df, mykeyvalue) {
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
    # Use case-insensitive and partial matching
    matches <- str_detect(str_to_lower(df$Name), fixed(str_to_lower(mykeyvalue_char)))
    if (any(matches)) {
      return(df$azl[matches])
    } else {
      stop("Name key not found in data frame")
    }
  }
}

