#' Body surface area calculator in m^2 (DuBois and DuBois formula)
#' @description This function calculates the body surface area with the
#' DuBois method. DuBois D. A formula to estimate the approximate surface
#' area if height and body mass are known. Arch Intern Med 1916;17:863-71.
#'
#' @param height A numeric value in cm
#' @param weight A numeric value in kg
#'
#' @return A numeric value in m^2
#' @export
#'
#' @examples
#' tar_bsa(height = 180, weight = 80) # ~1.996421 m^2
#'
tar_bsa <- function(height, weight) {
  if (!is.numeric(height) || !is.numeric(weight)) {
    stop("height and weight must be numeric.")
  }
  if (any(is.na(height)) || any(is.na(weight))) {
    stop("height and weight must not be NA.")
  }
  if (any(height <= 0)) {
    stop("height must be positive.")
  }
  if (any(weight <= 0)) {
    stop("weight must be positive.")
  }
  bsa <- 0.007184 * height^0.725 * weight^0.425
  return(bsa)
}
