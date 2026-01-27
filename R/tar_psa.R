#' Peritoneal Surface Area Calculation
#'
#' This function calculates 1% of the peritoneal surface area in cm^2 based on
#' the given height and weight. It's used as a factor for further calculations.
#'
#' @param height A numeric value representing the height in cm.
#' @param weight A numeric value representing the weight in kg.
#' @return A numeric value representing 1% of the peritoneal surface area in cm^2.
#' @export
#' @examples
#' tar_psa(180, 80) # Expected output: 199.6421 cm^2
tar_psa <- function(height, weight) {
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
  psa <- as.numeric((0.007184 * height^0.725 * weight^0.425) * 10000) / 100
  return(psa)
}
