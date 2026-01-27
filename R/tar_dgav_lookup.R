# Function to handle unquoted inputs
#' Look-up function for DGAV registry IDs/names
#' @description This function takes a data frame `df` and a vector of
#' key values `mykeyvalues`. It returns an unnamed vector of corresponding
#' results by performing lookups in the data frame.
#' @param mykeyvalues is a vector containing the key values to be looked up in the data frame.
#' These key values can be either numeric or character strings. The function processes each key
#' value individually to determine if it matches entries in the specified columns of the data frame
#' @param df data frame with Name and azl number
#' @importFrom stringr str_detect
#' @importFrom stringr str_to_lower
#' @importFrom stringr fixed
#' @return a key or value, depending on what is wanted
#' @export
#'
#' @examples
#' # Example data
#' df <- data.frame(
#'   Name = c("Hans", "Maria", "Franz HUBER"),
#'   azl = c("1006341612", "1040405318", "1060707219"),
#'   stringsAsFactors = FALSE
#' )
#'
#' tar_dgav_lookup(df, "HUBER")       # Should return "1060707219"
#' tar_dgav_lookup(df, "huber")       # Should also return "1060707219"
#' tar_dgav_lookup(df, "Franz")       # Should return "1060707219"
#' tar_dgav_lookup(df, 1006341612)  # Should return "Hans"
#' tar_dgav_lookup(df, c(1006341612, 1040405318)) # Should return "Hans"  "Maria"
#'
#' # Function to handle inputs for data frame
tar_dgav_lookup <- function(df, mykeyvalues) {
  results <- c()

  for (mykeyvalue in mykeyvalues) {
    if (is.numeric(mykeyvalue)) {
      mykeyvalue <- as.character(mykeyvalue)
      if (mykeyvalue %in% df$azl) {
        results <- c(results, df$Name[df$azl == mykeyvalue])
      } else {
        stop("Numeric key not found in data frame")
      }
    } else if (is.character(mykeyvalue)) {
      matches <- str_detect(str_to_lower(df$Name), fixed(str_to_lower(mykeyvalue)))
      if (any(matches)) {
        results <- c(results, df$azl[matches])
      } else {
        stop("Name key not found in data frame")
      }
    } else {
      stop("Key must be either numeric or character")
    }
  }

  return(results)
}
