#' Add Footnote to Graph and Save as PNG
#'
#' This function takes a `grViz` graph object, adds a footnote with specified style and text,
#' and saves the graph along with the footnote as a PNG file. The PNG file is named based on the
#' graph object name.
#'
#' @param graph A `grViz` graph object.
#' @param style A character string specifying the CSS style for the footnote.
#' @param string A character string specifying the footnote text.
#' @param filename Optional output filename (without extension). Defaults to the
#'   variable name of `graph` if possible.
#' @param output_dir Output directory (default: current working directory).
#' @param overwrite Logical; overwrite an existing PNG (default: FALSE).
#' @param ask Logical; if TRUE, prompt when file exists (default: interactive()).
#'
#' @return None. The function saves a PNG file in the working directory.
#' @examples
#' \dontrun{
#' library(htmltools)
#' library(webshot2)
#'
#' graph <- grViz("
#' digraph {
#' graph [layout = dot]
#' node [shape = box]
#' a [label = 'A']
#' b [label = 'B']
#' a -> {b}
#' }
#' ")
#'
#' style <- "color: grey; font-family: Arial; text-align: left; font-size: 10px;"
#' string <- paste(
#'   "CNCT = Consolidation Chemotherapy,",
#'   "CRT = Chemoradiotherapy,",
#'   "CT = Chemotherapy,",
#'   "INCT = Induction Chemotherapy,",
#'   "SCRT = Short-course Radiotherapy,",
#'   "TME = Total Mesorectal Excision,",
#'   "WW = Watch and Wait,",
#'   sep = " "
#' )
#'
#' tar_footnote(graph, style, string)
#' }
#' @import htmltools webshot2
#' @export
tar_footnote <- function(graph,
                         style,
                         string,
                         filename = NULL,
                         output_dir = ".",
                         overwrite = FALSE,
                         ask = interactive()) {
  if (!is.character(style) || length(style) != 1 || is.na(style)) {
    stop("style must be a single character string.")
  }
  if (!is.character(string) || length(string) != 1 || is.na(string)) {
    stop("string must be a single character string.")
  }
  if (!is.character(output_dir) || length(output_dir) != 1 || is.na(output_dir) || nchar(output_dir) == 0) {
    stop("output_dir must be a non-empty character string.")
  }
  if (!is.logical(overwrite) || length(overwrite) != 1) {
    stop("overwrite must be a single logical value.")
  }
  if (!is.logical(ask) || length(ask) != 1) {
    stop("ask must be a single logical value.")
  }

  # Get the name of the graph variable
  graph_name <- deparse(substitute(graph))

  # Set the filename based on the graph name
  if (is.null(filename) || !is.character(filename) || length(filename) != 1 || is.na(filename) || nchar(filename) == 0) {
    filename <- if (nzchar(graph_name)) graph_name else "graph"
  }
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  png_file <- file.path(output_dir, paste0(filename, ".png"))
  if (file.exists(png_file)) {
    if (overwrite) {
      # Proceed to overwrite silently
    } else if (ask) {
      overwrite_answer <- readline(prompt = "File already exists. Overwrite? (yes/no): ")
      if (tolower(overwrite_answer) != "yes") {
        stop("Output file exists and overwrite is FALSE.")
      }
    } else {
      stop("Output file exists and overwrite is FALSE.")
    }
  }

  # 1. Create the output with the graph and the footnote
  output <- htmltools::div(
    graph,
    htmltools::HTML(
      sprintf("<p style='%s'>%s</p>", style, string)
    )
  )

  # 2. Save the HTML content to a file
  html_file <- file.path(output_dir, paste0(filename, ".html"))
  htmltools::save_html(output, html_file)
  on.exit(unlink(html_file), add = TRUE)

  # 3. Convert the HTML file to PNG with a delay to ensure content is loaded
  webshot2::webshot(html_file, file = png_file, delay = 2, zoom = 3)

  invisible(png_file)
}
