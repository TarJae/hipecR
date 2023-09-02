#' @title NA counter
#' @description Counts NA's across columns
#' @param df a data frame
#' @return returns
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  tar_count_na(mtcars)
#'  }
#' }
#' @rdname tar_count_na
#' @export

tar_count_na <- function(df){
  vapply(df, function(x) sum(is.na(x)), FUN.VALUE = numeric(1))
}

