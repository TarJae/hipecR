#' Peritoneal Surface Area Calculation
#'
#' This function calculates 1% of the peritoneal surface area in cm^2 based on
#' the given height and weight. It's used as a factor for further calculations.
#'
#' @param height A numeric vector representing height in cm.
#' @param weight A numeric vector representing weight in kg.
#' @return A numeric vector representing 1% of the peritoneal surface area in
#'   cm^2. Missing, non-finite, or non-positive values produce NA at the
#'   corresponding position.
#' @export
#' @examples
#' tar_psa(180, 80) # Expected output: 199.6421 cm^2
#' tar_psa(height = c(180, NA), weight = c(80, 75))
tar_psa <- function(height, weight) {
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
  psa <- as.numeric((0.007184 * height^0.725 * weight^0.425) * 10000) / 100
  return(psa)
}
