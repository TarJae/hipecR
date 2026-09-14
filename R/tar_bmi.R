#' Calculating BMI (kg/m^2)
#'
#' @param weight Numeric, kg
#' @param height Numeric, cm
#'
#' @return A numeric vector containing the body mass index. Missing,
#'   non-finite, or physically invalid values produce NA at the corresponding
#'   position.
#' @export
#'
#' @examples
#' tar_bmi(weight = 100, height = 190)
#' tar_bmi(weight = c(80, NA), height = c(180, 175))

tar_bmi <- function(weight, height) {
  if (is.logical(weight) && all(is.na(weight))) {
    weight <- as.numeric(weight)
  }
  if (is.logical(height) && all(is.na(height))) {
    height <- as.numeric(height)
  }
  if (!is.numeric(weight) || !is.numeric(height)) {
    stop("weight and height must be numeric.")
  }
  weight <- replace(
    weight,
    !is.finite(weight) | weight < 0,
    NA_real_
  )
  height <- replace(
    height,
    !is.finite(height) | height <= 0,
    NA_real_
  )
  bmi <- weight / (height / 100) ^ 2
  return(bmi)
}
