#' Color Duplicate Cells in Specified Columns
#'
#' This function colors cells in specified columns (n=x) of a dataframe that are duplicates.
#' It is useful for visually identifying duplicates in a `gt` table format.
#'
#' @param df A data frame in which to look for duplicates.
#' @param vars A vector of column names in which to look for duplicates.
#'
#' @return A `gt` table with colored duplicate groups.
#' @export
#' @examples
#' tar_color_duplicates(mtcars, c("cyl", "mpg"))
#'
#' @importFrom dplyr mutate group_by ungroup
#' @importFrom rlang sym
#' @importFrom gt gt tab_style cells_body cell_fill
#' @importFrom scales hue_pal

tar_color_duplicates <- function(df, vars) {
  for (var in vars) {
    var_sym <- rlang::sym(var)
    dupe_group_var <- rlang::sym(paste0(var, "_dupe_group"))
    color_group_var <- rlang::sym(paste0(var, "_color_group"))

    df <- dplyr::mutate(df,
                        !!dupe_group_var := dplyr::if_else(duplicated(dplyr::pull(df, !!var_sym)) |
                                                             duplicated(dplyr::pull(df, !!var_sym), fromLast = TRUE),
                                                           as.character(dplyr::pull(df, !!var_sym)), NA)
    ) %>%
      dplyr::group_by(!!dupe_group_var) %>%
      dplyr::mutate(!!color_group_var := dplyr::if_else(is.na(!!dupe_group_var),
                                                        NA_integer_, dplyr::cur_group_id())) %>%
      dplyr::ungroup()
  }

  gt_table <- gt::gt(df)

  for (var in vars) {
    dupe_group_var <- paste0(var, "_dupe_group")
    color_group_var <- paste0(var, "_color_group")

    unique_groups <- unique(na.omit(df[[color_group_var]]))
    colors <- scales::hue_pal()(length(unique_groups))
    names(colors) <- unique_groups

    for (group in names(colors)) {
      gt_table <- gt::tab_style(gt_table,
                                style = gt::cell_fill(color = colors[group]),
                                locations = gt::cells_body(
                                  columns = var,
                                  rows = df[[color_group_var]] == as.numeric(group)
                                )
      )
    }
  }

  gt_table
}
