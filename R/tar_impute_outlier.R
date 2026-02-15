#' Imputates outliers and shows 4 different method plots
#'
#' @param df data frame or tibble where the numeric variable lives
#' @param variable Numeric variable column in the data frame
#'
#' @return 4 plots with mean, median, mode and capping imputation
#' @export
#'
#' @importFrom ggpubr ggarrange
#' @importFrom dlookr imputate_outlier
#' @examples
#' \donttest{
#' if (interactive()) {
#'   tar_impute_outlier(mtcars, mpg)
#' }
#' }

tar_impute_outlier <- function(df, variable) {
  # Generate plots
  img1 <- plot(dlookr::imputate_outlier(df, variable, method = "mean"))
  img2 <- plot(dlookr::imputate_outlier(df, variable, method = "median"))
  img3 <- plot(dlookr::imputate_outlier(df, variable, method = "mode"))
  img4 <- plot(dlookr::imputate_outlier(df, variable, method = "capping"))

  ggpubr::ggarrange(img1, img2, img3, img4, ncol = 2, nrow = 2)

}



