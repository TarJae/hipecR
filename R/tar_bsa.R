#' Body surface area calculator (Dubois formula)
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
  bsa <- as.numeric((0.007184 * height^0.725 * weight^0.425))
  return(bsa)
}

