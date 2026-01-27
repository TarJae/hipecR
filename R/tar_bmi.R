#' Calculating BMI (kg/m^2)
#'
#' @param weight Numeric, kg
#' @param height Numeric, cm
#'
#' @return body mass index BMI
#' @export
#'
#' @examples
#' tar_bmi(weight = 100, height = 190)

tar_bmi <- function(weight, height){
  if (!is.numeric(weight) || !is.numeric(height)) {
    stop("weight and height must be numeric.")
  }
  if (any(is.na(weight)) || any(is.na(height))) {
    stop("weight and height must not be NA.")
  }
  if (any(weight < 0)) {
    stop("weight must be non-negative.")
  }
  if (any(height <= 0)) {
    stop("height must be positive.")
  }
  bmi <- weight / (height / 100) ^ 2
  return(bmi)
}
