#' Color duplicate cells within specific column.
#'
#' To visually identify this function will color duplicates in a column.
#'
#' @param df The input data frame.
#' @param var The column to be used for coloring duplicates.
#'
#' @return A gt table with colored duplicate groups.
#' @export
#' @examples
#' # Example usage:
#' tar_color_duplicates(mtcars, cyl)
#'
#' @importFrom dplyr mutate group_by ungroup cur_group_id
#' @importFrom scales hue_pal
#' @importFrom gt gt tab_style cell_fill cells_body
#'
#' @author tarjae
#'
tar_color_duplicates <- function(df, var){
  df <- df %>%
    dplyr::mutate(
      dupe_group = ifelse(duplicated({{var}}) |
                            duplicated({{var}}, fromLast = TRUE),
                          as.character({{var}}), NA)
    ) %>%
    dplyr::group_by(dupe_group) %>%
    dplyr::mutate(color_group = ifelse(is.na(dupe_group), NA, dplyr::cur_group_id())) %>%
    ungroup()

  # Assign a color duplicate groups
  unique_groups <- unique(na.omit(df$color_group))
  colors <- scales::hue_pal()(length(unique_groups))
  names(colors) <- unique_groups


  gt_table <- df %>%
    gt::gt()

  for (group in names(colors)) {
    gt_table <- gt_table %>%
      gt::tab_style(
        style = gt::cell_fill(color = colors[group]),
        locations = gt::cells_body(
          columns = {{var}},
          rows = df$color_group == as.numeric(group)
        )
      )
  }

  print(gt_table)
}
