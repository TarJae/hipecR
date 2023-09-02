#' @title Short Installer
#' @description Function to facilitate the use of
#' install.packages("dplyr") as tar_i(dplyr).
#' @param x The name of the package you want to install.
#' @return Installs a package.
#' @details This function uses non-standard evaluation to allow you to specify
#' the package name unquoted.
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   tar_i(dplyr)
#' }
#' }
#' @rdname tar_i
#' @export
tar_i <- function(x) {
  x <- deparse(substitute(x))
  install.packages(x)
}
