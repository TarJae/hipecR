#' @title Short Installer
#' @description Function to facilitate the use of
#' install.packages("dplyr") as tar_install(dplyr).
#' @param x The name of the package you want to install.
#' @return Installs a package.
#' @details This function uses non-standard evaluation to allow you to specify
#' the package name unquoted.
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   tar_install(dplyr)
#' }
#' }
#' @rdname tar_install
#' @export
tar_install <- function(x) {
  x <- deparse(substitute(x))
  utils::install.packages(x)
}
