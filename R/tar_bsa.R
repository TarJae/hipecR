#' Body surface area calculator (Dubois formula)
#' @description This function calculates the body surface area with the Dubois method. DuBois D. A formula to estimate the approximate surface area if height and body mass be known. Arch Intern Med 1916;17:863–71.
#'
#' @param height A numeric value in cm
#' @param weight A numeric value in kg
#'
#' @return A numeric value in (m²)
#' @export
#'
#' @examples
#' tar_bsa(180, 80)
#'
tar_bsa <- function(height, weight) {
  stopifnot("Input must be numeric" = is.numeric(c(height, weight)))
  bsa <- as.numeric((0.007184 * height^0.725 * weight^0.425))
  return(bsa)
}

