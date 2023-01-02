#' 1% of Peritoneal surface area in centimeter
#'
#' @param height
#' @param weight
#'
#' @return
#' @export
#'
#' @examples
tar_psa <- function(height, weight) {
  stopifnot("Input must be numeric" = is.numeric(c(height, weight)))
  psa <- as.numeric((0.007184 * height^0.725 * weight^0.425) * 10000) / 100
  return(psa)
}
