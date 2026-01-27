#' Display both the head and tail of a dataframe or tibble
#'
#' This function returns the first `nh` = n head and last `nt` = n tail rows of a dataframe or tibble.
#' Row numbers from the original data are preserved as row names in the result.
#'
#' @param data A data frame or tibble whose head and tail you wish to view.
#' @param nh An integer specifying the number of rows from the start of `data` to display. Default is 5.
#' @param nt An integer specifying the number of rows from the end of `data` to display. Default is 5.
#'
#' @return A dataframe composed of the first `nh` and last `nt` rows of the input data.
#' The row numbers from the original data are used as row names in the result.
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  # Generate example data
#'  df <- data.frame(A = 1:10, B = 11:20)
#'  tar_head_tail(df, nh = 3, nt = 2)
#'  }
#' }
#'
#' @seealso
#'  \code{\link[tibble]{rownames}}
#'
#' @rdname tar_head_tail
#'
#' @export
#'
#' @importFrom tibble rownames_to_column column_to_rownames
#' @importFrom dplyr %>%
#' @importFrom dplyr bind_rows
#' @importFrom utils head tail

tar_head_tail <- function(data, nh = 5, nt = 5) {
  if (!is.data.frame(data)) {
    stop("data must be a data.frame or tibble.")
  }
  if (!is.numeric(nh) || length(nh) != 1 || is.na(nh) || nh < 0) {
    stop("nh must be a single non-negative number.")
  }
  if (!is.numeric(nt) || length(nt) != 1 || is.na(nt) || nt < 0) {
    stop("nt must be a single non-negative number.")
  }

  x <- data %>%
    as.data.frame() %>%
    tibble::rownames_to_column("row_number") %>%
    head(n = nh)

  y <- data %>%
    as.data.frame() %>%
    tibble::rownames_to_column("row_number") %>%
    tail(n = nt)

  head_tail <- dplyr::bind_rows(x,y) %>%
    tibble::column_to_rownames("row_number")

  return(head_tail)
}

