#' Calculate person age
#' @description This function calculates the age of a person by given birthdate and the end date
#'
#' @param birth_date A date value, e.g. "1974-11-23".
#' @param x_date A date value until the age lasts, e.g. "2023-02-16".
#'
#' @return A numeric value in (years)
#' @export
#'
#' @examples
#' tar_age("1974-11-23", "2023-02-16")
#'
tar_age <- function(birth_date, x_date) {
  birth_date <- as.Date(birth_date)
  x_date <- as.Date(x_date)
  if (length(birth_date) != 1 || length(x_date) != 1) {
    stop("birth_date and x_date must be single values.")
  }
  if (any(is.na(birth_date)) || any(is.na(x_date))) {
    stop("birth_date and x_date must be valid dates.")
  }
  if (any(birth_date > x_date)) {
    stop("birth_date must be on or before x_date.")
  }
  diff_years <- as.integer(x_date - birth_date) / 365.25
  trunc(diff_years)
}
