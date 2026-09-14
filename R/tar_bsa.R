#' Body surface area calculator in m^2 (DuBois and DuBois formula)
#' @description This function calculates the body surface area with the
#' DuBois method. DuBois D. A formula to estimate the approximate surface
#' area if height and body mass are known. Arch Intern Med 1916;17:863-71.
#'
#' @param height A numeric vector in cm
#' @param weight A numeric vector in kg
#'
#' @return A numeric vector in m^2. Missing, non-finite, or non-positive
#'   values produce NA at the corresponding position.
#' @export
#'
#' @examples
#' tar_bsa(height = 180, weight = 80) # ~1.996421 m^2
#' tar_bsa(height = c(180, NA), weight = c(80, 75))
#'
tar_bsa <- function(height, weight) {
  if (is.logical(height) && all(is.na(height))) {
    height <- as.numeric(height)
  }
  if (is.logical(weight) && all(is.na(weight))) {
    weight <- as.numeric(weight)
  }
  if (!is.numeric(height) || !is.numeric(weight)) {
    stop("height and weight must be numeric.")
  }
  height <- replace(
    height,
    !is.finite(height) | height <= 0,
    NA_real_
  )
  weight <- replace(
    weight,
    !is.finite(weight) | weight <= 0,
    NA_real_
  )
  bsa <- 0.007184 * height^0.725 * weight^0.425
  return(bsa)
}
