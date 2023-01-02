#' Peritoneal surface area in centimeter
#' @description This function calculates the pERITONEAL sURFACE aREA in cm²
#'
#'
#' @param height A numeric value in cm
#' @param weight A numeric value in cm
#'
#' @return A numeric value in (cm²) (factor for further calculations)
#'
#' @export
#' tar_psa(180, 80)
#'
#' @examples
tar_psa <- function(height, weight) {
  stopifnot("Input must be numeric" = is.numeric(c(height, weight)))
  psa <- as.numeric((0.007184 * height^0.725 * weight^0.425) * 10000) / 100
  return(psa)
}
