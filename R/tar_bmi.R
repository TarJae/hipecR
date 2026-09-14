#' Calculating BMI (kg/m^2)
#'
#' @param weight Numeric, kg
#' @param height Numeric, cm
#'
#' @return A numeric vector containing the body mass index. If weight or
#'   height is missing, the corresponding result is NA.
#' @export
#'
#' @examples
#' tar_bmi(weight = 100, height = 190)
#' tar_bmi(weight = c(80, NA), height = c(180, 175))

tar_bmi <- function(weight, height) {
  if (!is.numeric(weight) || !is.numeric(height)) {
    stop("weight and height must be numeric.")
  }
  if (any(weight < 0, na.rm = TRUE)) {
    stop("weight must be non-negative.")
  }
  if (any(height <= 0, na.rm = TRUE)) {
    stop("height must be positive.")
  }
  bmi <- weight / (height / 100) ^ 2
  return(bmi)
}
