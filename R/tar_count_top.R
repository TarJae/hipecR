#' @title Count Top Categories in a Factor
#' @description This function transforms the specified factor variable within a dataframe to lump all but the top n most frequent levels into an 'Other' category and then computes the count of each level.
#' @param df A dataframe containing the variable to be manipulated.
#' @param var The name of the factor variable within the dataframe as a string.
#' @param n The number of top levels to keep before lumping others into 'Other'; default is 5.
#' @return A dataframe showing the count of each level including 'Other' for all lumped lesser categories.
#' @details This function leverages `dplyr` for data manipulation and `forcats` for managing factor levels. It is particularly useful in data summarization where the focus is on the most frequent categories.
#' @examples
#' \dontrun{
#' if(interactive()){
#'   data <- data.frame(color = c("red", "blue", "green", "blue", "blue", "red", "yellow", "red"))
#'   print(tar_count_top(data, color, n = 2))
#'  }
#' }
#' @rdname tar_count_top
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr group_by
#' @importFrom dplyr summarise
#' @importFrom forcats fct_lump
#' @importFrom forcats fct_infreq

tar_count_top <- function(df, var, n = 5) {
  require(dplyr)
  require(forcats)
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    count({{ var }})
}
