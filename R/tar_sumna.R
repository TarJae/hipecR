#' @title NA counter
#' @description Counts NA values across columns.
#' @param df A data frame or tibble.
#' @return A named numeric vector with NA counts per column.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  tar_count_na(mtcars)
#'  }
#' }
#' @rdname tar_count_na
#' @export

tar_count_na <- function(df){
  if (!is.data.frame(df)) {
    stop("df must be a data.frame or tibble.")
  }
  vapply(df, function(x) sum(is.na(x)), FUN.VALUE = numeric(1))
}

