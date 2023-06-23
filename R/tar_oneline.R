#' @title tar_oneline
#' @description creates a one liner from a multiline code example

#' @return re-formats the multiline code to one line code
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  # Your multiline string
#'  # copy this code
#'  numericInput(
#'  'Register_Nr',
#'  'Nr.',
#'  min = 0,
#'  max = 20,
#'  step = 1,
#'  value = 0
#'  )
#'  }
#'  }
#'  # then apply
#'  tar_oneline
#' @seealso
#'  \code{\link[formatR]{tidy_source}}
#' @rdname tar_oneline
#' @export
#' @importFrom formatR tidy_source

tar_oneline <- function() {
  my_code <- readClipboard() # This will read what is in your clipboard
  formatR::tidy_source(text = my_code, width.cutoff = Inf)
}
