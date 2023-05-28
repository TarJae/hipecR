#' Calculate person age
#' @description This function calculates the age of a person by given birthdate and the end date
#'
#' @param birth_date A date value for example "1974-11-23"
#' @param x_date A date value until the age lasts for example "2023-02-16"
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
  diff_years <- as.integer(x_date - birth_date) / 365.25
  truncated_diff_years <- trunc(diff_years)
  return(truncated_diff_years)
}
