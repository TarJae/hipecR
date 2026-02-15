#' @title Short Installer
#' @description Helper that returns an `install.packages()` command for a package name.
#' @param x The name of the package you want to install.
#' @return A character string with the corresponding `install.packages()` command.
#' @details This function uses non-standard evaluation to allow you to specify
#' the package name unquoted.
#' @examples
#' \donttest{
#' tar_install(dplyr)
#' }
#' @rdname tar_install
#' @export
tar_install <- function(x) {
  x <- deparse(substitute(x))
  sprintf("install.packages('%s')", x)
}



