#' Calculating BMI (kg/m²)
#'
#' @param weight Numeric, kg
#' @param height Numeric, meter
#'
#' @return body mass index BMI
#' @export
#'
#' @examples
#' weight = 100
#' height = 1.90
#' tar_bmi(weight, height)

tar_bmi <- function(weight, height){
  BMI <- (weight/(height/100)^2) #weight in kilgram, height in m
  return(BMI)
}
