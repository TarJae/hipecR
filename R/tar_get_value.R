# Function to handle unquoted inputs
#' Look-up function
#'
<<<<<<< HEAD
#' @param mykeyvalue an unquoted key or value
=======
<<<<<<< HEAD
#' @param mykeyvalue an unquoted key or value
=======
#' @param mykey an unquoted key or value
>>>>>>> 90c08958b66a7344fa5f094c3eb3a64690cbc130
>>>>>>> 250d76c4c0265659faa6ef2ff45b6038dd20623c
#'
#' @return a key or value, depending on what is wanted
#' @export
#'
#' @examples
#' # Example data
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
#' lookup_vector <- c(Hans = "1006341612", Maria = "1040405318")
>>>>>>> 90c08958b66a7344fa5f094c3eb3a64690cbc130
>>>>>>> 250d76c4c0265659faa6ef2ff45b6038dd20623c
#' df <- data.frame(Name = c("Hans", "Maria"), azl = c("1006341612", "1040405318"), stringsAsFactors = FALSE)
#'
#' tar_get_value(Hans)       # Returns "1006341612"
#' tar_get_value(1006341612) # Returns "Hans"

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 250d76c4c0265659faa6ef2ff45b6038dd20623c

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
<<<<<<< HEAD
=======
=======
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

>>>>>>> 90c08958b66a7344fa5f094c3eb3a64690cbc130
>>>>>>> 250d76c4c0265659faa6ef2ff45b6038dd20623c
