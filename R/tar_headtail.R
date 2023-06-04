
#' @title Show head and tail of data frame
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @param nh PARAM_DESCRIPTION, Default: 5
#' @param nt PARAM_DESCRIPTION, Default: 5
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[tibble]{rownames}}
#' @rdname tar_head_tail
#' @export
#' @importFrom tibble rownames_to_column column_to_rownames
#' @importFrom dplyr %>%
#' @importFrom dplyr bind_rows
#' @importFrom utils head tail

tar_head_tail <- function(data, nh = 5, nt = 5) {

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

