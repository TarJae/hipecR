#' @title tar_oneline
#' @description Creates a one-liner from a multiline code example in the clipboard.

#' @return A character vector with the reformatted one-line code.
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # Your multiline string
#'   # copy this code
#'   numericInput(
#'     "Register_Nr",
#'     "Nr.",
#'     min = 0,
#'     max = 20,
#'     step = 1,
#'     value = 0
#'   )
#' }
#'
#' # then apply
#' tar_oneline()
#' }
#' @seealso
#'  \code{\link[formatR]{tidy_source}}
#' @rdname tar_oneline
#' @export
#' @importFrom formatR tidy_source

tar_oneline <- function() {
  if (.Platform$OS.type != "windows") {
    stop("tar_oneline is only supported on Windows (clipboard access).")
  }
  my_code <- utils::readClipboard()
  if (!length(my_code) || all(nchar(my_code) == 0)) {
    stop("Clipboard is empty.")
  }
  out <- formatR::tidy_source(text = my_code, width.cutoff = Inf)
  out$text.tidy
}
