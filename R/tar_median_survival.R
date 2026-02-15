#' Plot Survival Curves and Save with Median Annotations
#'
#' This function fits a survival model, plots the survival curves, and
#' annotates median survival times. The plot can optionally be saved to file.
#'
#' @param df A data frame containing the survival data.
#' @param var A variable used for grouping the survival curves.
#' @param time_col A string specifying the name of the column representing time.
#' @param status_col A string specifying the name of the column representing status.
#' @param output_file Optional output path for saving the plot. If `NULL`
#'   (default), the function does not write a file.
#'
#' @return A `ggsurvplot` object (invisibly). Optionally writes a PNG file.
#' @export
#' @importFrom survival Surv
#' @importFrom survminer ggsurvplot surv_fit
#' @importFrom ggplot2 annotate scale_x_continuous ggsave theme_bw element_text
#' @importFrom dplyr tibble
#' @importFrom labelled get_variable_labels
#' @examples
#' \donttest{
#' # Example dataset
#' df_survival <- structure(
#'   list(
#'     status = c(1, 0, 1, 1, 1, 1, 0, 1, 1, 0),
#'     primorgan = structure(
#'       c(1L, 1L, 1L, 2L, 1L, 1L, 1L, 2L, 2L, 2L),
#'       levels = c("Colon", "Rectum"),
#'       class = "factor"
#'     ),
#'     sex = structure(
#'       c("male", "female", "male", "male", "male",
#'         "male", "male", "male", "male", "female"),
#'       label = "Gender"
#'     ),
#'     time = c(4.26, 49.52, 18.05, 11.04, 47.67, 8.03, 76.2, 15.44, 22.74, 50.64),
#'     subtype = structure(
#'       c(2L, 1L, 2L, 3L, 2L, 3L, 1L, 1L, 1L, 2L),
#'       levels = c("adenocarcinoma", "mucinous", "signet ring cell"),
#'       label = "Histological subtype",
#'       class = "factor"
#'     )
#'   ),
#'   row.names = c(NA, -10L),
#'   class = c("tbl_df", "tbl", "data.frame")
#' )
#'
#' tar_median_survival(
#'   df = df_survival,
#'   var = sex,
#'   time_col = "time",
#'   status_col = "status",
#'   output_file = file.path(tempdir(), "survival_sex.png")
#' )
#' }

tar_median_survival <- function(df, var, time_col = "time", status_col = "status", output_file = NULL) {
  # Convert the variable to a string
  var <- as.character(substitute(var))

  # Create the formula
  formula <- stats::as.formula(paste("Surv(", time_col, ",", status_col, ") ~", var))

  # Fit the survival model
  fit <- try(surv_fit(formula, data = df), silent = TRUE)
  if (inherits(fit, "try-error")) {
    warning("The survival model could not be fitted. Please check the input data.")
    return(NULL)
  }

  # Get the median survival times
  medians <- summary(fit)$table[, "median"]

  # Draw the survival curves
  plot <- ggsurvplot(
    fit,
    data = df,
    size = 1,                 # Change line size
    palette = "jco",
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,
    pval.coord = c(55, 0.95), # Position p-value in the right upper corner
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    risk.table.y.text = FALSE,
    legend.labs = unique(df[[var]]),
    legend.title = get_variable_labels(df[[var]]),
    surv.median.line = "hv",      # Add median survival lines
    ggtheme = theme_bw() + tar_ggplot_font_size(5),
    xlim = c(0, 60),          # Limit x-axis to 60 months
    break.time.by = 12        # Break x-axis at 0, 12, 24, 36, 48, 60
  )

  # Create annotation data frame
  annotation_df <- tibble(
    x = medians,
    y = rep(0.5, length(medians)),
    label = ifelse(is.na(medians), "", "X"),
    size = 7,
    color = "red"
  )

  # Create annotation data frame for median values
  median_annotation_df <- tibble(
    x = medians + 1,
    y = rep(0, length(medians)),
    label = ifelse(is.na(medians), "", as.character(medians)),
    size = 5,
    color = "red"
  )

  # Add annotations to the plot
  plot$plot <- plot$plot +
    annotate("text", x = annotation_df$x, y = annotation_df$y, label = annotation_df$label, size = 7, color = "red") +
    annotate("text", x = median_annotation_df$x, y = median_annotation_df$y, label = median_annotation_df$label, size = 5, color = "red") +
    scale_x_continuous(breaks = seq(0, 60, by = 12)) # Set x-axis breaks

  # Print the plot
  print(plot)

  if (!is.null(output_file)) {
    if (!is.character(output_file) || length(output_file) != 1 || is.na(output_file) || nchar(output_file) == 0) {
      stop("output_file must be NULL or a non-empty character string.")
    }
    output_dir <- dirname(output_file)
    if (!dir.exists(output_dir)) {
      dir.create(output_dir, recursive = TRUE)
    }
    ggplot2::ggsave(output_file, plot$plot, width = 10, height = 7, units = "in", dpi = 300, bg = "white")
    message("Plot saved to: ", output_file)
  }
  invisible(plot)
}




