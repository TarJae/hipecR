#' Set Pillar Print Minimum
#'
#' This function sets the `pillar.print_min` option in R.
#' This option controls globally the minimum number of data to print in tibbles.
#' In contrast to data frames, in tibbles only 10 lines are shown except you use print(n=...).
#' But you have to add it each time. tar_print can be use once globally and changed whenever necessayr!
#'
#' @param value A single non-negative integer for the minimum number of rows
#'   shown of a tibble in the console. Defaults to 50.
#' @return Invisible null. The function is called for its side effect of setting an option.
#' @export
#' @references
#' The formula is from here: https://stackoverflow.com/questions/77708674/is-there-a-global-option-to-adjust-the-default-setting-of-tibbles-that-displays
#' @examples
#' tar_print(100)  # Set the pillar.print_min option to 100
#' tar_print()     # Set the pillar.print_min option back to default (50)
tar_print <- function(value = 50) {
  if (!is.numeric(value) || length(value) != 1 || is.na(value) || value < 0) {
    stop("value must be a single non-negative number.")
  }
  options("pillar.print_min" = value)
  invisible(NULL)
}
