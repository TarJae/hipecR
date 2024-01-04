#' Peritoneal Surface Area Calculation
#'
#' This function calculates 1% of the peritoneal surface area in cm² based on
#' the given height and weight. It's used as a factor for further calculations.
#'
#' @param height A numeric value representing the height in cm.
#' @param weight A numeric value representing the weight in kg.
#' @return A numeric value representing 1% of the peritoneal surface area in cm².
#' @export
#' @examples
#' tar_psa(180, 80) # Expected output: 199.6421 cm²
tar_psa <- function(height, weight) {
  stopifnot("Input must be numeric" = is.numeric(c(height, weight)))
  psa <- as.numeric((0.007184 * height^0.725 * weight^0.425) * 10000) / 100
  return(psa)
}
