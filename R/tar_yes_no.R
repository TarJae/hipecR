#' Convert "yes" and "no" to 1 and 0
#'
#' This function takes a vector and converts all instances of "yes" to 1, "no" to 0,
#' and leaves other values as NA. It's useful for converting categorical "yes"/"no"
#' responses into a numeric format that can be used in statistical analysis.
#'
#' @param x A vector containing elements to be converted. Elements should be
#'   character strings potentially including "yes" and "no".
#'
#' @return A numeric vector where "yes" is replaced with 1, "no" with 0, and
#'   other values with NA.
#'
#' @export
#'
#' @examples
#' test_vector <- c("yes", "no", "maybe", "yes", "no")
#' tar_yes_no(test_vector)
tar_yes_no <- function(x) {
  if (is.factor(x)) {
    x <- as.character(x)
  }
  if (!is.character(x)) {
    stop("x must be a character vector.")
  }
  x <- trimws(tolower(x))
  ifelse(x == "yes", 1, ifelse(x == "no", 0, NA_integer_))
}
