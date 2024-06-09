#' Plot Median Survival Curves with Custom Font Sizes
#'
#' This function generates survival plots with risk tables for different levels
#' of a specified variable. It allows customization of font sizes for both the
#' plot and the risk table.
#'
#' @param df A data frame containing the survival data.
#' @param var A variable name (as an unquoted variable or character string) that defines the groups for the survival curves.
#' @param time_col A string specifying the name of the column containing the survival times. Default is "time".
#' @param status_col A string specifying the name of the column containing the event status (1 = event, 0 = censored). Default is "status".
#' @param palette A string specifying the color palette for the plots. Default is "jco".
#' @param font_size A numeric value specifying the font size for the plot text. Default is 7.
#' @param risk_table_font_size A numeric value specifying the font size for the risk table text. Default is 5.
#' @return A list of ggplot objects representing the survival curves for each level of the specified variable.
#' @importFrom survival Surv
#' @importFrom survminer ggsurvplot surv_fit
#' @importFrom dplyr mutate filter %>%
#' @importFrom ggplot2 theme_minimal element_text
#' @importFrom gridExtra grid.arrange
#' @export
#' @examples
#' # Example dataset
#' df_survival <- structure(list(
#'   status = c(1, 0, 1, 1, 1, 1, 0, 1, 1, 0),
#'   primorgan = structure(c(1L, 1L, 1L, 2L, 1L, 1L, 1L, 2L, 2L, 2L), levels = c("Colon", "Rectum"), class = "factor"),
#'   sex = structure(c("male", "female", "male", "male", "male", "male", "male", "male", "male", "female"), label = "Gender"),
#'   time = c(4.26, 49.52, 18.05, 11.04, 47.67, 8.03, 76.2, 15.44, 22.74, 50.64),
#'   subtype = structure(c(2L, 1L, 2L, 3L, 2L, 3L, 1L, 1L, 1L, 2L), levels = c("adenocarcinoma", "mucinous", "signet ring cell"), label = "Histological subtype", class = "factor")
#' ), row.names = c(NA, -10L), class = c("tbl_df", "tbl", "data.frame"))
#'
#' library(hipecR)
#' library(gridExtra)
#' plots <- tar_median_survival(df_survival, primorgan, font_size = 10, risk_table_font_size = 8)
#' do.call(grid.arrange, c(plots, ncol = 2))
tar_median_survival <- function(df, var, time_col = "time", status_col = "status", palette = "jco", font_size = 7, risk_table_font_size = 5) {
  # Convert var to a string if it's not already
  var <- as.character(substitute(var))

  # Create the formula dynamically
  formula <- as.formula(paste("Surv(", time_col, ",", status_col, ") ~", var))

  # Fit the survival curves using the variable
  fit <- try(surv_fit(formula, data = df), silent = TRUE)

  if (inherits(fit, "try-error")) {
    warning("The survival model could not be fitted. Please check the input data.")
    return(NULL)
  }

  # Define a custom theme for the risk table
  risk_table_theme <- theme(
    text = element_text(size = risk_table_font_size)
  )

  # Plotting the survival curves with risk table and median survival annotations
  surv_plot <- ggsurvplot(
    fit,
    data = df,
    palette = palette,
    ggtheme = theme_minimal() + tar_ggplot_font_size(font_size),  # Integrate custom font size for plot
    legend.title = var,
    risk.table = TRUE,            # Add risk table
    risk.table.height = 0.25,     # Adjust the height of the risk table
    risk.table.col = "strata",    # Color the risk table by strata
    surv.median.line = "hv",      # Add median survival lines
    pval = TRUE,                  # Add p-value for log-rank test
    conf.int = TRUE,              # Add confidence intervals for survival curves
    tables.theme = risk_table_theme  # Apply custom risk table theme
  )

  print(surv_plot)

  # Alternatively, to plot individual curves separately with risk tables and median survival annotations:
  var_levels <- levels(as.factor(df[[var]]))  # Ensure levels are correctly interpreted
  plots <- list()

  for (level in var_levels) {
    df_filtered <- df %>% filter(df[[var]] == level)
    fit_filtered <- try(surv_fit(Surv(df_filtered[[time_col]], df_filtered[[status_col]]) ~ 1, data = df_filtered), silent = TRUE)

    if (inherits(fit_filtered, "try-error")) {
      warning(paste("The survival model could not be fitted for", level, "."))
      next
    }

    plot <- ggsurvplot(
      fit_filtered,
      data = df_filtered,
      palette = "#2E9FDF",
      ggtheme = theme_minimal() + tar_ggplot_font_size(font_size),  # Integrate custom font size for plot
      title = paste("Survival Curve for", level),
      risk.table = TRUE,            # Add risk table
      risk.table.height = 0.25,     # Adjust the height of the risk table
      risk.table.col = "strata",    # Color the risk table by strata
      legend.labs = level,
      legend.title = var,
      surv.median.line = "hv",      # Add median survival lines
      pval = TRUE,                  # Add p-value for log-rank test
      conf.int = TRUE,              # Add confidence intervals for survival curves
      tables.theme = risk_table_theme  # Apply custom risk table theme
    )
    # Add median survival annotation
    median_surv <- summary(fit_filtered)$table["median"]
    plot$plot <- plot$plot + ggplot2::annotate("text", x = median_surv, y = 0.6, label = paste("    ", round(median_surv, 0)), size = font_size, color = "red")
    plots[[level]] <- plot$plot
  }

  return(plots)
}
